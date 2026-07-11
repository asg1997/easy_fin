import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/drift/mappers/base_mapper.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/base_account.dart';
import 'package:easy_fin/utils/account_number_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final basesStorageProvider = Provider<BasesStorage>(
  BasesStorageImpl.new,
);

sealed class BasesStorageError implements Exception {
  const BasesStorageError();
}

class DuplicateAccountNumbersError extends BasesStorageError {
  const DuplicateAccountNumbersError();
}

class AccountBelongsToAnotherBaseError extends BasesStorageError {
  const AccountBelongsToAnotherBaseError(this.accountNumber);

  final AccountNumber accountNumber;
}

class AccountHasStatementsError extends BasesStorageError {
  const AccountHasStatementsError(this.accountNumber);

  final AccountNumber accountNumber;
}

abstract class BasesStorage {
  Future<void> save(Base base);
  Future<void> delete(BaseId id);
  Future<Base?> findById(BaseId id);
  Future<Base?> findByAccount(AccountNumber accountNumber);
  Future<List<Base>> getAll();
  Future<void> updateAccountBankName(
    AccountNumber accountNumber,
    String bankName,
  );
}

class BasesStorageImpl implements BasesStorage {
  const BasesStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<Base?> findById(BaseId id) async {
    final db = ref.read(appDatabaseProvider);

    final baseRow = await (db.select(
      db.bases,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    if (baseRow == null) return null;

    final accountRows = await (db.select(
      db.baseAccountNumbers,
    )..where((table) => table.baseId.equals(id))).get();

    return baseRow.toDomain(
      accounts: accountRows.map((row) => row.toAccountDomain()).toList(),
    );
  }

  @override
  Future<Base?> findByAccount(AccountNumber accountNumber) async {
    final db = ref.read(appDatabaseProvider);
    final normalized = normalizeAccountNumber(accountNumber);

    final accountRow =
        await (db.select(db.baseAccountNumbers)
              ..where((table) => table.accountNumber.equals(normalized)))
            .getSingleOrNull();
    if (accountRow == null) return null;

    return findById(accountRow.baseId);
  }

  @override
  Future<List<Base>> getAll() async {
    final db = ref.read(appDatabaseProvider);

    final baseRows = await db.select(db.bases).get();
    if (baseRows.isEmpty) return [];

    final accountRows = await db.select(db.baseAccountNumbers).get();
    final accountsByBaseId = <BaseId, List<BaseAccount>>{};
    for (final row in accountRows) {
      accountsByBaseId
          .putIfAbsent(row.baseId, () => [])
          .add(row.toAccountDomain());
    }

    return baseRows
        .map(
          (row) => row.toDomain(
            accounts: accountsByBaseId[row.id] ?? [],
          ),
        )
        .toList();
  }

  @override
  Future<void> delete(BaseId id) async {
    final db = ref.read(appDatabaseProvider);

    await db.transaction(() async {
      final statementIds = await (db.select(db.bankStatements)
            ..where((table) => table.baseId.equals(id)))
          .map((row) => row.id)
          .get();

      if (statementIds.isNotEmpty) {
        await (db.delete(db.bankStatementOperations)
              ..where((table) => table.statementId.isIn(statementIds)))
            .go();
        await (db.delete(db.bankStatements)
              ..where((table) => table.baseId.equals(id)))
            .go();
      }

      await (db.delete(db.renters)..where((table) => table.baseId.equals(id)))
          .go();
      await (db.delete(db.baseAccountNumbers)
            ..where((table) => table.baseId.equals(id)))
          .go();
      await (db.delete(db.bases)..where((table) => table.id.equals(id))).go();
    });
  }

  @override
  Future<void> save(Base base) async {
    final uniqueAccounts = _uniqueAccounts(base.accounts);
    if (uniqueAccounts.length != base.accounts.length) {
      throw const DuplicateAccountNumbersError();
    }

    for (final account in uniqueAccounts) {
      final existingBase = await findByAccount(account.accountNumber);
      if (existingBase != null && existingBase.id != base.id) {
        throw AccountBelongsToAnotherBaseError(account.accountNumber);
      }
    }

    final db = ref.read(appDatabaseProvider);
    final currentBase = await findById(base.id);
    if (currentBase != null) {
      final newAccountNumbers = uniqueAccounts
          .map((account) => account.accountNumber)
          .toSet();
      for (final account in currentBase.accounts) {
        if (newAccountNumbers.contains(account.accountNumber)) continue;

        final hasStatements =
            await (db.select(db.bankStatements)
                  ..where(
                    (table) => table.accountNumber.equals(account.accountNumber),
                  ))
                .getSingleOrNull();
        if (hasStatements != null) {
          throw AccountHasStatementsError(account.accountNumber);
        }
      }
    }

    await db.transaction(() async {
      await db.into(db.bases).insertOnConflictUpdate(base.toCompanion());

      await (db.delete(
        db.baseAccountNumbers,
      )..where((table) => table.baseId.equals(base.id))).go();

      if (uniqueAccounts.isEmpty) return;

      await db.batch((batch) {
        batch.insertAll(
          db.baseAccountNumbers,
          uniqueAccounts
              .map(
                (account) => BaseAccountNumbersCompanion(
                  baseId: Value(base.id),
                  accountNumber: Value(account.accountNumber),
                  bankName: Value(account.bankName),
                ),
              )
              .toList(),
        );
      });
    });
  }

  @override
  Future<void> updateAccountBankName(
    AccountNumber accountNumber,
    String bankName,
  ) async {
    if (bankName.isEmpty) return;

    final db = ref.read(appDatabaseProvider);
    await (db.update(db.baseAccountNumbers)
          ..where((table) => table.accountNumber.equals(accountNumber)))
        .write(BaseAccountNumbersCompanion(bankName: Value(bankName)));
  }

  List<BaseAccount> _uniqueAccounts(List<BaseAccount> accounts) {
    final uniqueAccounts = <BaseAccount>[];
    final seenAccountNumbers = <AccountNumber>{};

    for (final account in accounts) {
      final accountNumber = normalizeAccountNumber(account.accountNumber);
      if (seenAccountNumbers.add(accountNumber)) {
        uniqueAccounts.add(
          BaseAccount(
            accountNumber: accountNumber,
            bankName: account.bankName,
          ),
        );
      }
    }

    return uniqueAccounts;
  }
}
