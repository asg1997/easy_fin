import 'package:drift/drift.dart';
import 'package:easy_fin/data/models/get_statements_filters.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/drift/mappers/income_document_mapper.dart';
import 'package:easy_fin/models/account_filter_type.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:easy_fin/models/income.dart';
import 'package:easy_fin/models/income_document.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final incomesStorageProvider = Provider<IncomesStorage>(
  IncomesStorageImpl.new,
);

sealed class IncomesStorageError implements Exception {
  const IncomesStorageError();
}

class EmptyIncomeDocumentError extends IncomesStorageError {
  const EmptyIncomeDocumentError();
}

class InvalidIncomeAmountError extends IncomesStorageError {
  const InvalidIncomeAmountError();
}

class DuplicateIncomeRenterLineError extends IncomesStorageError {
  const DuplicateIncomeRenterLineError();
}

class IncomeDocumentNotFoundError extends IncomesStorageError {
  const IncomeDocumentNotFoundError();
}

abstract class IncomesStorage {
  Future<IncomeDocument?> getById(IncomeDocumentId id);

  Future<List<IncomeDocument>> getByFilters(GetStatementsFilters filters);

  Future<void> saveDocument(IncomeDocument document);

  Future<void> updateDocument(IncomeDocument document);

  Future<void> deleteDocument(IncomeDocumentId id);
}

class IncomesStorageImpl implements IncomesStorage {
  const IncomesStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<IncomeDocument?> getById(IncomeDocumentId id) async {
    final db = ref.read(appDatabaseProvider);

    final header = await (db.select(db.incomeDocuments)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    if (header == null) return null;

    final lines = await (db.select(db.incomeLines)
          ..where((table) => table.documentId.equals(id)))
        .get();

    return header.toDomain(lines);
  }

  @override
  Future<List<IncomeDocument>> getByFilters(
    GetStatementsFilters filters,
  ) async {
    if (!_includesIncomeFilter(filters)) {
      return [];
    }

    final db = ref.read(appDatabaseProvider);
    final headers = await (db.select(db.incomeDocuments)
          ..where((table) => _buildWhere(table, filters))
          ..orderBy([(table) => OrderingTerm.desc(table.date)]))
        .get();

    if (headers.isEmpty) return [];

    final documentIds = headers.map((header) => header.id).toList();
    final allLines = await (db.select(db.incomeLines)
          ..where((table) => table.documentId.isIn(documentIds)))
        .get();

    final linesByDocument = <String, List<IncomeLineRow>>{};
    for (final line in allLines) {
      linesByDocument.putIfAbsent(line.documentId, () => []).add(line);
    }

    return headers
        .map((header) => header.toDomain(linesByDocument[header.id] ?? []))
        .toList();
  }

  bool _includesIncomeFilter(GetStatementsFilters filters) {
    final documentTypes = filters.documentTypes;
    if (documentTypes != null &&
        documentTypes.isNotEmpty &&
        !documentTypes.contains(DocumentType.income)) {
      return false;
    }
    return true;
  }

  Expression<bool> _buildWhere(
    $IncomeDocumentsTable table,
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
  Future<void> saveDocument(IncomeDocument document) async {
    _validateDocument(document);

    final db = ref.read(appDatabaseProvider);
    await db.transaction(() async {
      await db.into(db.incomeDocuments).insert(document.toHeaderCompanion());
      await db.batch((batch) {
        batch.insertAll(db.incomeLines, document.toLineCompanions());
      });
    });
  }

  @override
  Future<void> updateDocument(IncomeDocument document) async {
    _validateDocument(document);

    final db = ref.read(appDatabaseProvider);
    final existing = await (db.select(db.incomeDocuments)
          ..where((table) => table.id.equals(document.id)))
        .getSingleOrNull();
    if (existing == null) {
      throw const IncomeDocumentNotFoundError();
    }

    await db.transaction(() async {
      await (db.delete(db.incomeLines)
            ..where((table) => table.documentId.equals(document.id)))
          .go();

      await (db.update(db.incomeDocuments)
            ..where((table) => table.id.equals(document.id)))
          .write(document.toHeaderCompanion());

      await db.batch((batch) {
        batch.insertAll(db.incomeLines, document.toLineCompanions());
      });
    });
  }

  @override
  Future<void> deleteDocument(IncomeDocumentId id) async {
    final db = ref.read(appDatabaseProvider);
    final deleted = await (db.delete(db.incomeDocuments)
          ..where((table) => table.id.equals(id)))
        .go();

    if (deleted == 0) {
      throw const IncomeDocumentNotFoundError();
    }
  }

  void _validateDocument(IncomeDocument document) {
    if (document.lines.isEmpty) {
      throw const EmptyIncomeDocumentError();
    }

    final seenRenterKeys = <String>{};
    for (final line in document.lines) {
      if (line.sum <= 0) {
        throw const InvalidIncomeAmountError();
      }

      final source = line.incomeSource;
      if (source is IncomeSourceFromRenter) {
        final key = '${source.renterId}:${source.accountNumber}';
        if (seenRenterKeys.contains(key)) {
          throw const DuplicateIncomeRenterLineError();
        }
        seenRenterKeys.add(key);
      }
    }
  }
}
