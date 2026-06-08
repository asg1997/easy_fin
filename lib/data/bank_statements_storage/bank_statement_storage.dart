import 'package:drift/drift.dart';
import 'package:easy_fin/data/bank_statements_storage/bank_statement_saver/bank_statement_saver.dart';
import 'package:easy_fin/data/bases_storage/bases_storage.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/drift/bank_statement_database/bank_statement_mapper.dart';
import 'package:easy_fin/drift/bank_statement_database/db/bank_statement_database.dart'
    hide BankStatement;
import 'package:easy_fin/drift/bank_statement_database/db/bank_statement_database_provider.dart';
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
    final base = await ref.read(basesStorageProvider).findById(baseId);
    if (base == null || base.accountNumbers.isEmpty) return [];

    final db = ref.read(bankStatementDatabaseProvider);

    final statementsQuery = db.select(db.bankStatements)
      ..where((table) => table.accountNumber.isIn(base.accountNumbers))
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
              ..where((table) => table.statementId.isIn(statementIds)))
            .get();

    final operationsByStatementId = <int, List<BankStatementOperation>>{};
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
