import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/drift/mappers/base_mapper.dart';
import 'package:easy_fin/models/base.dart';
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
  Future<Base?> findById(BaseId id);
  Future<Base?> findByAccount(AccountNumber accountNumber);
  Future<List<Base>> getAll();
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
      accountNumbers: accountRows.map((row) => row.accountNumber).toList(),
    );
  }

  @override
  Future<Base?> findByAccount(AccountNumber accountNumber) async {
    final db = ref.read(appDatabaseProvider);

    final accountRow =
        await (db.select(db.baseAccountNumbers)
              ..where((table) => table.accountNumber.equals(accountNumber)))
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
    final accountNumbersByBaseId = <BaseId, List<AccountNumber>>{};
    for (final row in accountRows) {
      accountNumbersByBaseId
          .putIfAbsent(row.baseId, () => [])
          .add(row.accountNumber);
    }

    return baseRows
        .map(
          (row) => row.toDomain(
            accountNumbers: accountNumbersByBaseId[row.id] ?? [],
          ),
        )
        .toList();
  }

  @override
  Future<void> save(Base base) async {
    final uniqueAccountNumbers = base.accountNumbers.toSet().toList();
    if (uniqueAccountNumbers.length != base.accountNumbers.length) {
      throw const DuplicateAccountNumbersError();
    }

    for (final accountNumber in uniqueAccountNumbers) {
      final existingBase = await findByAccount(accountNumber);
      if (existingBase != null && existingBase.id != base.id) {
        throw AccountBelongsToAnotherBaseError(accountNumber);
      }
    }

    final db = ref.read(appDatabaseProvider);
    final currentBase = await findById(base.id);
    if (currentBase != null) {
      final newAccounts = uniqueAccountNumbers.toSet();
      for (final accountNumber in currentBase.accountNumbers) {
        if (newAccounts.contains(accountNumber)) continue;

        final hasStatements =
            await (db.select(db.bankStatements)
                  ..where((table) => table.accountNumber.equals(accountNumber)))
                .getSingleOrNull();
        if (hasStatements != null) {
          throw AccountHasStatementsError(accountNumber);
        }
      }
    }

    await db.transaction(() async {
      await db.into(db.bases).insertOnConflictUpdate(base.toCompanion());

      await (db.delete(
        db.baseAccountNumbers,
      )..where((table) => table.baseId.equals(base.id))).go();

      if (uniqueAccountNumbers.isEmpty) return;

      await db.batch((batch) {
        batch.insertAll(
          db.baseAccountNumbers,
          uniqueAccountNumbers
              .map(
                (accountNumber) => BaseAccountNumbersCompanion(
                  baseId: Value(base.id),
                  accountNumber: Value(accountNumber),
                ),
              )
              .toList(),
        );
      });
    });
  }
}
