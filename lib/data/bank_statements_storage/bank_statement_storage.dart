import 'package:drift/drift.dart';
import 'package:easy_fin/data/bank_statements_storage/bank_statement_saver/bank_statement_saver.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/drift/mappers/bank_statement_mapper.dart';
import 'package:easy_fin/models/base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bankStatementStorageProvider = Provider<BankStatementStorage>(
  BankStatementStorageImpl.new,
);

/// Хранилище выписок по банковскому счету
abstract class BankStatementStorage {
  Future<void> save(BankStatement bankStatement);
  Future<List<BankStatement>> getForBase(
    BaseId baseId, {
    bool dateDesc = true,
  });
}

class BankStatementStorageImpl implements BankStatementStorage {
  const BankStatementStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<void> save(BankStatement bankStatement) async {
    await ref.read(bankStatementSaverProvider).save(bankStatement);
  }

  @override
  Future<List<BankStatement>> getForBase(
    BaseId baseId, {
    bool dateDesc = true,
  }) async {
    final db = ref.read(appDatabaseProvider);

    final statementsQuery = db.select(db.bankStatements)
      ..where((table) => table.baseId.equals(baseId))
      ..orderBy([
        (table) => dateDesc
            ? OrderingTerm.desc(table.startDate)
            : OrderingTerm.asc(table.startDate),
      ]);

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
        .map(
          (row) => row.toDomain(
            operations: (operationsByStatementId[row.id] ?? [])
                .map((operation) => operation.toDomain())
                .toList(),
          ),
        )
        .toList();
  }
}
