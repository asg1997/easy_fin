import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/drift/mappers/renter_mapper.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rentersStorageProvider = Provider<RentersStorage>(
  RentersStorageImpl.new,
);

sealed class RentersStorageError implements Exception {
  const RentersStorageError();
}

class DuplicateRenterAccountNumbersError extends RentersStorageError {
  const DuplicateRenterAccountNumbersError();
}

class AccountBelongsToAnotherRenterError extends RentersStorageError {
  const AccountBelongsToAnotherRenterError(this.accountNumber);

  final AccountNumber accountNumber;
}

abstract class RentersStorage {
  Future<void> save(Renter renter);
  Future<Renter?> findById(RenterId id);
  Future<Renter?> findByAccount(AccountNumber accountNumber);
  Future<List<Renter>> getAll();
}

class RentersStorageImpl implements RentersStorage {
  const RentersStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<Renter?> findById(RenterId id) async {
    final db = ref.read(appDatabaseProvider);

    final renterRow = await (db.select(
      db.renters,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    if (renterRow == null) return null;

    final accountRows = await (db.select(
      db.renterAccountNumbers,
    )..where((table) => table.renterId.equals(id))).get();

    return renterRow.toDomain(
      accountNumbers: accountRows.map((row) => row.accountNumber).toList(),
    );
  }

  @override
  Future<Renter?> findByAccount(AccountNumber accountNumber) async {
    final db = ref.read(appDatabaseProvider);

    final accountRow =
        await (db.select(db.renterAccountNumbers)
              ..where((table) => table.accountNumber.equals(accountNumber)))
            .getSingleOrNull();
    if (accountRow == null) return null;

    return findById(accountRow.renterId);
  }

  @override
  Future<List<Renter>> getAll() async {
    final db = ref.read(appDatabaseProvider);

    final renterRows = await db.select(db.renters).get();
    if (renterRows.isEmpty) return [];

    final accountRows = await db.select(db.renterAccountNumbers).get();
    final accountNumbersByRenterId = <RenterId, List<AccountNumber>>{};
    for (final row in accountRows) {
      accountNumbersByRenterId
          .putIfAbsent(row.renterId, () => [])
          .add(row.accountNumber);
    }

    return renterRows
        .map(
          (row) => row.toDomain(
            accountNumbers: accountNumbersByRenterId[row.id] ?? [],
          ),
        )
        .toList();
  }

  @override
  Future<void> save(Renter renter) async {
    final uniqueAccountNumbers = renter.accountNumbers.toSet().toList();
    if (uniqueAccountNumbers.length != renter.accountNumbers.length) {
      throw const DuplicateRenterAccountNumbersError();
    }

    for (final accountNumber in uniqueAccountNumbers) {
      final existingRenter = await findByAccount(accountNumber);
      if (existingRenter != null && existingRenter.id != renter.id) {
        throw AccountBelongsToAnotherRenterError(accountNumber);
      }
    }

    final db = ref.read(appDatabaseProvider);

    await db.transaction(() async {
      await db.into(db.renters).insertOnConflictUpdate(renter.toCompanion());

      await (db.delete(
        db.renterAccountNumbers,
      )..where((table) => table.renterId.equals(renter.id))).go();

      if (uniqueAccountNumbers.isEmpty) return;

      await db.batch((batch) {
        batch.insertAll(
          db.renterAccountNumbers,
          uniqueAccountNumbers
              .map(
                (accountNumber) => RenterAccountNumbersCompanion(
                  renterId: Value(renter.id),
                  accountNumber: Value(accountNumber),
                ),
              )
              .toList(),
        );
      });
    });
  }
}
