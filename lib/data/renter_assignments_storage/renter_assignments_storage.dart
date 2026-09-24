import 'package:drift/drift.dart';
import 'package:easy_fin/data/models/get_statements_filters.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/drift/mappers/renter_assignment_mapper.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:easy_fin/models/renter_assignment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final renterAssignmentsStorageProvider = Provider<RenterAssignmentsStorage>(
  RenterAssignmentsStorageImpl.new,
);

sealed class RenterAssignmentsStorageError implements Exception {
  const RenterAssignmentsStorageError();
}

class EmptyRenterAssignmentsError extends RenterAssignmentsStorageError {
  const EmptyRenterAssignmentsError();
}

class InvalidRenterAssignmentAmountError extends RenterAssignmentsStorageError {
  const InvalidRenterAssignmentAmountError();
}

class RenterAssignmentDocumentNotFoundError
    extends RenterAssignmentsStorageError {
  const RenterAssignmentDocumentNotFoundError();
}

abstract class RenterAssignmentsStorage {
  Future<RenterAssignmentDocument?> getById(RenterAssignmentDocumentId id);

  Future<List<RenterAssignmentDocument>> getByFilters(
    GetStatementsFilters filters,
  );

  Future<List<RenterAssignmentDocument>> getByBaseAndMonth(
    BaseId baseId,
    DateTime month,
  );

  Future<void> saveDocument(RenterAssignmentDocument document);

  Future<void> updateDocument(RenterAssignmentDocument document);

  Future<void> deleteDocument(RenterAssignmentDocumentId id);
}

class RenterAssignmentsStorageImpl implements RenterAssignmentsStorage {
  const RenterAssignmentsStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<RenterAssignmentDocument?> getById(
    RenterAssignmentDocumentId id,
  ) async {
    final db = ref.read(appDatabaseProvider);

    final header = await (db.select(db.renterAssignmentDocuments)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    if (header == null) return null;

    final lines = await (db.select(db.renterAssignments)
          ..where((table) => table.documentId.equals(id)))
        .get();

    return header.toDomain(lines);
  }

  @override
  Future<List<RenterAssignmentDocument>> getByFilters(
    GetStatementsFilters filters,
  ) async {
    if (!_includesRenterAssignmentFilter(filters)) {
      return [];
    }

    final db = ref.read(appDatabaseProvider);
    final headers = await (db.select(db.renterAssignmentDocuments)
          ..where((table) => _buildWhere(table, filters))
          ..orderBy([(table) => OrderingTerm.desc(table.date)]))
        .get();

    return _documentsWithLines(db, headers);
  }

  @override
  Future<List<RenterAssignmentDocument>> getByBaseAndMonth(
    BaseId baseId,
    DateTime month,
  ) async {
    final db = ref.read(appDatabaseProvider);
    final start = normalizeRenterAssignmentMonth(month);
    final endExclusive = renterAssignmentMonthEndExclusive(month);

    final headers = await (db.select(db.renterAssignmentDocuments)
          ..where(
            (table) =>
                table.baseId.equals(baseId) &
                table.date.isBiggerOrEqualValue(start) &
                table.date.isSmallerThanValue(endExclusive),
          )
          ..orderBy([(table) => OrderingTerm.desc(table.date)]))
        .get();

    return _documentsWithLines(db, headers);
  }

  Future<List<RenterAssignmentDocument>> _documentsWithLines(
    AppDatabase db,
    List<RenterAssignmentDocumentRow> headers,
  ) async {
    if (headers.isEmpty) return [];

    final documentIds = headers.map((header) => header.id).toList();
    final allLines = await (db.select(db.renterAssignments)
          ..where((table) => table.documentId.isIn(documentIds)))
        .get();

    final linesByDocument = <String, List<RenterAssignmentRow>>{};
    for (final line in allLines) {
      linesByDocument.putIfAbsent(line.documentId, () => []).add(line);
    }

    return headers
        .map((header) => header.toDomain(linesByDocument[header.id] ?? []))
        .toList();
  }

  bool _includesRenterAssignmentFilter(GetStatementsFilters filters) {
    final documentTypes = filters.documentTypes;
    if (documentTypes != null &&
        documentTypes.isNotEmpty &&
        !documentTypes.contains(DocumentType.renterAssignment)) {
      return false;
    }

    // Начисления по аренде не относятся к кассе/банку — фильтр счёта на них
    // не распространяется.
    return true;
  }

  Expression<bool> _buildWhere(
    $RenterAssignmentDocumentsTable table,
    GetStatementsFilters filters,
  ) {
    Expression<bool> condition = const Constant<bool>(true);

    final baseIds = filters.baseIds;
    if (baseIds != null && baseIds.isNotEmpty) {
      condition = condition & table.baseId.isIn(baseIds);
    }

    final startDate = filters.startDate;
    if (startDate != null) {
      condition = condition & table.date.isBiggerOrEqualValue(
        normalizeRenterAssignmentDate(startDate),
      );
    }

    final endDate = filters.endDate;
    if (endDate != null) {
      condition = condition & table.date.isSmallerOrEqualValue(
        normalizeRenterAssignmentDate(endDate),
      );
    }

    return condition;
  }

  @override
  Future<void> saveDocument(RenterAssignmentDocument document) async {
    _validateDocument(document);

    final db = ref.read(appDatabaseProvider);
    await db.transaction(() async {
      await db
          .into(db.renterAssignmentDocuments)
          .insert(document.toHeaderCompanion());
      await db.batch((batch) {
        batch.insertAll(db.renterAssignments, document.toLineCompanions());
      });
    });
  }

  @override
  Future<void> updateDocument(RenterAssignmentDocument document) async {
    _validateDocument(document);

    final db = ref.read(appDatabaseProvider);
    final existing = await (db.select(db.renterAssignmentDocuments)
          ..where((table) => table.id.equals(document.id)))
        .getSingleOrNull();
    if (existing == null) {
      throw const RenterAssignmentDocumentNotFoundError();
    }

    await db.transaction(() async {
      await (db.delete(db.renterAssignments)
            ..where((table) => table.documentId.equals(document.id)))
          .go();

      await (db.update(db.renterAssignmentDocuments)
            ..where((table) => table.id.equals(document.id)))
          .write(document.toHeaderCompanion());

      await db.batch((batch) {
        batch.insertAll(db.renterAssignments, document.toLineCompanions());
      });
    });
  }

  @override
  Future<void> deleteDocument(RenterAssignmentDocumentId id) async {
    final db = ref.read(appDatabaseProvider);
    final deleted = await (db.delete(db.renterAssignmentDocuments)
          ..where((table) => table.id.equals(id)))
        .go();

    if (deleted == 0) {
      throw const RenterAssignmentDocumentNotFoundError();
    }
  }

  void _validateDocument(RenterAssignmentDocument document) {
    if (document.lines.isEmpty) {
      throw const EmptyRenterAssignmentsError();
    }

    for (final line in document.lines) {
      if (line.sum <= 0) {
        throw const InvalidRenterAssignmentAmountError();
      }
    }
  }
}
