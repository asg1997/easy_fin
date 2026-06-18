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

abstract class RenterAssignmentsStorage {
  Future<List<RenterAssignment>> getByBaseAndMonth(
    BaseId baseId,
    DateTime month,
  );

  Future<List<RenterAssignment>> getByFilters(
    GetStatementsFilters filters,
  );

  Future<void> saveAll({
    required BaseId baseId,
    required DateTime month,
    required List<RenterAssignment> assignments,
  });
}

class RenterAssignmentsStorageImpl implements RenterAssignmentsStorage {
  const RenterAssignmentsStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<List<RenterAssignment>> getByBaseAndMonth(
    BaseId baseId,
    DateTime month,
  ) async {
    final db = ref.read(appDatabaseProvider);
    final normalizedMonth = normalizeRenterAssignmentMonth(month);

    final rows =
        await (db.select(db.renterAssignments)..where(
          (table) =>
              table.baseId.equals(baseId) &
              table.date.equals(normalizedMonth),
        )).get();

    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<List<RenterAssignment>> getByFilters(
    GetStatementsFilters filters,
  ) async {
    if (!_includesRenterAssignmentFilter(filters)) {
      return [];
    }

    final db = ref.read(appDatabaseProvider);

    final rows = await (db.select(db.renterAssignments)
          ..where((table) => _buildWhere(table, filters))
          ..orderBy([(table) => OrderingTerm.desc(table.date)]))
        .get();

    return rows.map((row) => row.toDomain()).toList();
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
    $RenterAssignmentsTable table,
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
        normalizeRenterAssignmentMonth(startDate),
      );
    }

    final endDate = filters.endDate;
    if (endDate != null) {
      condition = condition & table.date.isSmallerOrEqualValue(
        normalizeRenterAssignmentMonth(endDate),
      );
    }

    return condition;
  }

  @override
  Future<void> saveAll({
    required BaseId baseId,
    required DateTime month,
    required List<RenterAssignment> assignments,
  }) async {
    if (assignments.isEmpty) {
      throw const EmptyRenterAssignmentsError();
    }

    for (final assignment in assignments) {
      if (assignment.sum <= 0) {
        throw const InvalidRenterAssignmentAmountError();
      }
    }

    final db = ref.read(appDatabaseProvider);
    final normalizedMonth = normalizeRenterAssignmentMonth(month);

    await db.transaction(() async {
      await (db.delete(db.renterAssignments)..where(
        (table) =>
            table.baseId.equals(baseId) & table.date.equals(normalizedMonth),
      )).go();

      await db.batch((batch) {
        batch.insertAll(
          db.renterAssignments,
          assignments
              .map(
                (assignment) => assignment
                    .copyWith(
                      baseId: baseId,
                      date: normalizedMonth,
                    )
                    .toCompanion(),
              )
              .toList(),
        );
      });
    });
  }
}

extension on RenterAssignment {
  RenterAssignment copyWith({
    BaseId? baseId,
    DateTime? date,
  }) {
    return RenterAssignment(
      id: id,
      createdAt: createdAt,
      baseId: baseId ?? this.baseId,
      date: date ?? this.date,
      sum: sum,
      renterId: renterId,
      accountNumber: accountNumber,
    );
  }
}
