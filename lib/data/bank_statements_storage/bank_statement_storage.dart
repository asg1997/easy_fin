import 'package:drift/drift.dart';
import 'package:easy_fin/data/bank_statements_storage/bank_statement_saver/bank_statement_saver.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/data/models/bank_statement_operation.dart';
import 'package:easy_fin/data/models/get_statements_filters.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/drift/mappers/bank_statement_mapper.dart';
import 'package:easy_fin/models/account_filter_type.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bankStatementStorageProvider = Provider<BankStatementStorage>(
  BankStatementStorageImpl.new,
);

/// Хранилище выписок по банковскому счету
abstract class BankStatementStorage {
  Future<void> save(BankStatement bankStatement);
  Future<List<BankStatement>> getStatements(
    GetStatementsFilters filters,
  );
  Future<BankStatement?> findPreviousStatement(
    String accountNumber,
    DateTime startDate,
  );
  Future<BankStatement?> findNextStatement(
    String accountNumber,
    DateTime endDate,
  );
  Future<BankStatement?> findOverlappingStatement(
    String accountNumber,
    DateTime startDate,
    DateTime endDate,
  );
  Future<void> deleteOperation(int operationId);
}

class BankStatementStorageImpl implements BankStatementStorage {
  const BankStatementStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<void> save(BankStatement bankStatement) async {
    await ref.read(bankStatementSaverProvider).save(bankStatement);
  }

  @override
  Future<List<BankStatement>> getStatements(
    GetStatementsFilters filters,
  ) async {
    if (!_includesBankAccountFilter(filters.accountFilterTypes)) {
      return [];
    }

    final db = ref.read(appDatabaseProvider);

    final statementsQuery = db.select(db.bankStatements)
      ..where((table) => _buildStatementsWhere(table, filters))
      ..orderBy([(table) => OrderingTerm.desc(table.startDate)]);

    final statementRows = await statementsQuery.get();
    if (statementRows.isEmpty) return [];

    final statementIds = statementRows.map((row) => row.id).toList();
    final operationRows =
        await (db.select(db.bankStatementOperations)
              ..where((table) => table.statementId.isIn(statementIds))
              ..orderBy([(table) => OrderingTerm.asc(table.date)]))
            .get();

    final operationsByStatementId = <int, List<BankStatementOperationRow>>{};
    for (final operation in operationRows) {
      operationsByStatementId
          .putIfAbsent(operation.statementId, () => [])
          .add(operation);
    }

    return statementRows
        .map((row) {
          final operations = (operationsByStatementId[row.id] ?? [])
              .map((operation) => operation.toDomain())
              .where(
                (operation) => _matchesOperationFilters(operation, filters),
              )
              .toList();

          return row.toDomain(operations: operations);
        })
        .where((statement) => statement.operations.isNotEmpty)
        .toList();
  }

  bool _includesBankAccountFilter(List<AccountFilterType>? accountFilterTypes) {
    if (accountFilterTypes == null || accountFilterTypes.isEmpty) {
      return true;
    }

    return accountFilterTypes.contains(AccountFilterType.bank);
  }

  Expression<bool> _buildStatementsWhere(
    $BankStatementsTable table,
    GetStatementsFilters filters,
  ) {
    Expression<bool> condition = const Constant<bool>(true);

    final baseIds = filters.baseIds;
    if (baseIds != null && baseIds.isNotEmpty) {
      condition = condition & table.baseId.isIn(baseIds);
    }

    final startDate = filters.startDate;
    if (startDate != null) {
      condition = condition & table.endDate.isBiggerOrEqualValue(startDate);
    }

    final endDate = filters.endDate;
    if (endDate != null) {
      condition = condition & table.startDate.isSmallerOrEqualValue(endDate);
    }

    return condition;
  }

  bool _matchesOperationFilters(
    BankStatementOperation operation,
    GetStatementsFilters filters,
  ) {
    final startDate = filters.startDate;
    if (startDate != null && operation.date.isBefore(startDate)) {
      return false;
    }

    final endDate = filters.endDate;
    if (endDate != null && operation.date.isAfter(endDate)) {
      return false;
    }

    final documentTypes = filters.documentTypes;
    if (documentTypes == null || documentTypes.isEmpty) {
      return true;
    }

    if (operation.isCredit && documentTypes.contains(DocumentType.income)) {
      return true;
    }

    return operation.isDebit && documentTypes.contains(DocumentType.outcome);
  }

  @override
  Future<BankStatement?> findPreviousStatement(
    String accountNumber,
    DateTime startDate,
  ) async {
    final db = ref.read(appDatabaseProvider);

    final row =
        await (db.select(db.bankStatements)
              ..where(
                (table) =>
                    table.accountNumber.equals(accountNumber) &
                    table.endDate.isSmallerThanValue(startDate),
              )
              ..orderBy([(table) => OrderingTerm.desc(table.endDate)])
              ..limit(1))
            .getSingleOrNull();

    return row?.toDomain(operations: []);
  }

  @override
  Future<BankStatement?> findNextStatement(
    String accountNumber,
    DateTime endDate,
  ) async {
    final db = ref.read(appDatabaseProvider);

    final row =
        await (db.select(db.bankStatements)
              ..where(
                (table) =>
                    table.accountNumber.equals(accountNumber) &
                    table.startDate.isBiggerThanValue(endDate),
              )
              ..orderBy([(table) => OrderingTerm.asc(table.startDate)])
              ..limit(1))
            .getSingleOrNull();

    return row?.toDomain(operations: []);
  }

  @override
  Future<BankStatement?> findOverlappingStatement(
    String accountNumber,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = ref.read(appDatabaseProvider);

    final row =
        await (db.select(db.bankStatements)
              ..where(
                (table) =>
                    table.accountNumber.equals(accountNumber) &
                    table.startDate.isSmallerOrEqualValue(endDate) &
                    table.endDate.isBiggerOrEqualValue(startDate) &
                    (table.startDate.equals(startDate).not() |
                        table.endDate.equals(endDate).not()),
              )
              ..limit(1))
            .getSingleOrNull();

    return row?.toDomain(operations: []);
  }

  @override
  Future<void> deleteOperation(int operationId) async {
    final db = ref.read(appDatabaseProvider);

    await db.transaction(() async {
      final operation =
          await (db.select(db.bankStatementOperations)
                ..where((table) => table.id.equals(operationId)))
              .getSingleOrNull();
      if (operation == null) return;

      final statementId = operation.statementId;

      await (db.delete(db.bankStatementOperations)
            ..where((table) => table.id.equals(operationId)))
          .go();

      final remainingOperations =
          await (db.select(db.bankStatementOperations)
                ..where((table) => table.statementId.equals(statementId)))
              .get();
      if (remainingOperations.isEmpty) {
        await (db.delete(db.bankStatements)
              ..where((table) => table.id.equals(statementId)))
            .go();
      }
    });
  }
}
