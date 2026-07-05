import 'package:drift/drift.dart';
import 'package:easy_fin/data/models/get_statements_filters.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/drift/mappers/expense_document_mapper.dart';
import 'package:easy_fin/models/account_filter_type.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:easy_fin/models/expense_document.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expensesStorageProvider = Provider<ExpensesStorage>(
  ExpensesStorageImpl.new,
);

sealed class ExpensesStorageError implements Exception {
  const ExpensesStorageError();
}

class EmptyExpenseDocumentError extends ExpensesStorageError {
  const EmptyExpenseDocumentError();
}

class InvalidExpenseAmountError extends ExpensesStorageError {
  const InvalidExpenseAmountError();
}

class ExpenseDocumentNotFoundError extends ExpensesStorageError {
  const ExpenseDocumentNotFoundError();
}

abstract class ExpensesStorage {
  Future<ExpenseDocument?> getById(ExpenseDocumentId id);

  Future<List<ExpenseDocument>> getByFilters(GetStatementsFilters filters);

  Future<void> saveDocument(ExpenseDocument document);

  Future<void> updateDocument(ExpenseDocument document);

  Future<void> deleteDocument(ExpenseDocumentId id);
}

class ExpensesStorageImpl implements ExpensesStorage {
  const ExpensesStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<ExpenseDocument?> getById(ExpenseDocumentId id) async {
    final db = ref.read(appDatabaseProvider);

    final header = await (db.select(db.expenseDocuments)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    if (header == null) return null;

    final lines = await (db.select(db.expenseLines)
          ..where((table) => table.documentId.equals(id)))
        .get();

    return header.toDomain(lines);
  }

  @override
  Future<List<ExpenseDocument>> getByFilters(
    GetStatementsFilters filters,
  ) async {
    if (!_includesOutcomeFilter(filters)) {
      return [];
    }

    final db = ref.read(appDatabaseProvider);
    final headers = await (db.select(db.expenseDocuments)
          ..where((table) => _buildWhere(table, filters))
          ..orderBy([(table) => OrderingTerm.desc(table.date)]))
        .get();

    if (headers.isEmpty) return [];

    final documentIds = headers.map((header) => header.id).toList();
    final allLines = await (db.select(db.expenseLines)
          ..where((table) => table.documentId.isIn(documentIds)))
        .get();

    final linesByDocument = <String, List<ExpenseLineRow>>{};
    for (final line in allLines) {
      linesByDocument.putIfAbsent(line.documentId, () => []).add(line);
    }

    return headers
        .map((header) => header.toDomain(linesByDocument[header.id] ?? []))
        .toList();
  }

  bool _includesOutcomeFilter(GetStatementsFilters filters) {
    final documentTypes = filters.documentTypes;
    if (documentTypes != null &&
        documentTypes.isNotEmpty &&
        !documentTypes.contains(DocumentType.outcome)) {
      return false;
    }
    return true;
  }

  Expression<bool> _buildWhere(
    $ExpenseDocumentsTable table,
    GetStatementsFilters filters,
  ) {
    Expression<bool> condition = const Constant<bool>(true);

    final baseIds = filters.baseIds;
    if (baseIds != null && baseIds.isNotEmpty) {
      condition = condition & table.baseId.isIn(baseIds);
    }

    final startDate = filters.startDate;
    if (startDate != null) {
      condition = condition & table.date.isBiggerOrEqualValue(startDate);
    }

    final endDate = filters.endDate;
    if (endDate != null) {
      condition = condition & table.date.isSmallerOrEqualValue(endDate);
    }

    final accountFilterTypes = filters.accountFilterTypes;
    if (accountFilterTypes != null && accountFilterTypes.isNotEmpty) {
      final accountTypes = accountFilterTypes.map((type) {
        return type == AccountFilterType.cash ? 'cash' : 'bank';
      }).toList();
      condition = condition & table.accountType.isIn(accountTypes);
    }

    return condition;
  }

  @override
  Future<void> saveDocument(ExpenseDocument document) async {
    _validateDocument(document);

    final db = ref.read(appDatabaseProvider);
    await db.transaction(() async {
      await db.into(db.expenseDocuments).insert(document.toHeaderCompanion());
      await db.batch((batch) {
        batch.insertAll(db.expenseLines, document.toLineCompanions());
      });
    });
  }

  @override
  Future<void> updateDocument(ExpenseDocument document) async {
    _validateDocument(document);

    final db = ref.read(appDatabaseProvider);
    final existing = await (db.select(db.expenseDocuments)
          ..where((table) => table.id.equals(document.id)))
        .getSingleOrNull();
    if (existing == null) {
      throw const ExpenseDocumentNotFoundError();
    }

    await db.transaction(() async {
      await (db.delete(db.expenseLines)
            ..where((table) => table.documentId.equals(document.id)))
          .go();

      await (db.update(db.expenseDocuments)
            ..where((table) => table.id.equals(document.id)))
          .write(document.toHeaderCompanion());

      await db.batch((batch) {
        batch.insertAll(db.expenseLines, document.toLineCompanions());
      });
    });
  }

  @override
  Future<void> deleteDocument(ExpenseDocumentId id) async {
    final db = ref.read(appDatabaseProvider);
    final deleted = await (db.delete(db.expenseDocuments)
          ..where((table) => table.id.equals(id)))
        .go();

    if (deleted == 0) {
      throw const ExpenseDocumentNotFoundError();
    }
  }

  void _validateDocument(ExpenseDocument document) {
    if (document.lines.isEmpty) {
      throw const EmptyExpenseDocumentError();
    }

    for (final line in document.lines) {
      if (line.sum <= 0) {
        throw const InvalidExpenseAmountError();
      }
    }
  }
}
