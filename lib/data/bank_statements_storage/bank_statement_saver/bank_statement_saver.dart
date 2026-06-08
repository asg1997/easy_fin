import 'package:easy_fin/data/bases_storage/bases_storage.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/drift/bank_statement_database/bank_statement_mapper.dart';
import 'package:easy_fin/drift/bank_statement_database/db/bank_statement_database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bankStatementSaverProvider = Provider<BankStatementSaver>(
  BankStatementSaverImpl.new,
);

/// Ошибки при сохранении выписки по банковскому счету
sealed class BankStatementSaveError implements Exception {
  BankStatementSaveError();
}

///  Банковский счет не найден в базе
class BankAccountNotFoundError extends BankStatementSaveError {
  BankAccountNotFoundError();
}

abstract class BankStatementSaver {
  /// Сохраняет выписку по банковскому счету.
  ///
  /// Выбрасывает ошибку [BankStatementSaveError].
  ///
  /// Если банковский счет не найден, выбрасывает ошибку [BankAccountNotFoundError]
  Future<void> save(BankStatement bankStatement);
}

class BankStatementSaverImpl implements BankStatementSaver {
  const BankStatementSaverImpl(this.ref);
  final Ref ref;

  @override
  Future<void> save(BankStatement bankStatement) async {
    /// по номеру счета находим к какой базе относится выписка
    final base = await ref
        .read(basesStorageProvider)
        .findByAccount(bankStatement.accountNumber);
    if (base == null) throw BankAccountNotFoundError();

    /// Сохраняем выписку в базу данных
    await _saveToDatabase(bankStatement);
  }

  Future<void> _saveToDatabase(BankStatement bankStatement) async {
    final db = ref.read(bankStatementDatabaseProvider);

    await db.transaction(() async {
      final statementId = await db
          .into(db.bankStatements)
          .insert(bankStatement.toCompanion());

      if (bankStatement.operations.isEmpty) return;

      await db.batch((batch) {
        batch.insertAll(
          db.bankStatementOperations,
          bankStatement.operations
              .map((operation) => operation.toCompanion(statementId: statementId))
              .toList(),
        );
      });
    });
  }
}
