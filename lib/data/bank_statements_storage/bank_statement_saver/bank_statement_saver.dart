import 'package:drift/drift.dart';
import 'package:easy_fin/data/bases_storage/bases_storage.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/drift/mappers/bank_statement_mapper.dart';
import 'package:easy_fin/utils/account_number_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bankStatementSaverProvider = Provider<BankStatementSaver>(
  BankStatementSaverImpl.new,
);

/// Ошибки при сохранении выписки по банковскому счету
sealed class BankStatementSaveError implements Exception {
  BankStatementSaveError();
}

/// Банковский счет не найден в базе
class BankAccountNotFoundError extends BankStatementSaveError {
  BankAccountNotFoundError();
}

/// Счёт выписки не принадлежит указанной базе
class BankAccountBaseMismatchError extends BankStatementSaveError {
  BankAccountBaseMismatchError();
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
    final accountNumber = normalizeAccountNumber(bankStatement.accountNumber);
    final statement = bankStatement.accountNumber == accountNumber
        ? bankStatement
        : bankStatement.copyWith(accountNumber: accountNumber);

    final base = await ref
        .read(basesStorageProvider)
        .findByAccount(accountNumber);
    if (base == null) throw BankAccountNotFoundError();

    if (!base.accountNumbers.contains(accountNumber)) {
      throw BankAccountBaseMismatchError();
    }

    await _saveToDatabase(statement, baseId: base.id);
    await ref
        .read(basesStorageProvider)
        .updateAccountBankName(
          accountNumber,
          statement.bankName,
        );
  }

  Future<void> _saveToDatabase(
    BankStatement bankStatement, {
    required String baseId,
  }) async {
    final db = ref.read(appDatabaseProvider);

    await db.transaction(() async {
      final existingStatement =
          await (db.select(db.bankStatements)..where(
                (table) =>
                    table.accountNumber.equals(bankStatement.accountNumber) &
                    table.startDate.equals(bankStatement.startDate) &
                    table.endDate.equals(bankStatement.endDate),
              ))
              .getSingleOrNull();

      final statementId =
          existingStatement?.id ??
          await db
              .into(db.bankStatements)
              .insert(bankStatement.toCompanion(baseId: baseId));

      if (existingStatement != null) {
        await (db.update(db.bankStatements)..where(
              (table) => table.id.equals(existingStatement.id),
            ))
            .write(
              bankStatement
                  .toCompanion(baseId: baseId)
                  .copyWith(id: Value(existingStatement.id)),
            );
      }

      await (db.delete(
        db.bankStatementOperations,
      )..where((table) => table.statementId.equals(statementId))).go();

      if (bankStatement.operations.isEmpty) return;

      await db.batch((batch) {
        batch.insertAll(
          db.bankStatementOperations,
          bankStatement.operations
              .map(
                (operation) => operation.toCompanion(statementId: statementId),
              )
              .toList(),
        );
      });
    });
  }
}
