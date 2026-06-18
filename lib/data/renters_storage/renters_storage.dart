import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/drift/mappers/renter_mapper.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:easy_fin/utils/account_number_validator.dart';
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

class InvalidRenterAccountNumberError extends RentersStorageError {
  const InvalidRenterAccountNumberError(this.accountNumber);

  final AccountNumber accountNumber;
}

abstract class RentersStorage {
  Future<void> save(Renter renter);
  Future<void> archive(RenterId id);
  Future<void> unarchive(RenterId id);
  Future<Renter?> findById(RenterId id);
  Future<Renter?> findByAccount(AccountNumber accountNumber);
  Future<List<Renter>> getAll();
  Future<List<Renter>> getByBase(BaseId baseId);
  Future<List<Renter>> getArchivedByBase(BaseId baseId);
  Future<Map<RenterId, String>> getNamesByIds(Iterable<RenterId> ids);
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
    return _mapRenterRows(
      await (db.select(db.renters)..where((table) => table.baseId.isNotNull()))
          .get(),
    );
  }

  @override
  Future<List<Renter>> getByBase(BaseId baseId) async {
    final db = ref.read(appDatabaseProvider);

    final renterRows = await (db.select(db.renters)..where(
      (table) =>
          table.baseId.equals(baseId) & table.isArchived.equals(false),
    )).get();

    return _sortByName(await _mapRenterRows(renterRows));
  }

  @override
  Future<List<Renter>> getArchivedByBase(BaseId baseId) async {
    final db = ref.read(appDatabaseProvider);

    final renterRows = await (db.select(db.renters)..where(
      (table) => table.baseId.equals(baseId) & table.isArchived.equals(true),
    )).get();

    return _sortByName(await _mapRenterRows(renterRows));
  }

  @override
  Future<Map<RenterId, String>> getNamesByIds(Iterable<RenterId> ids) async {
    final uniqueIds = ids.where((id) => id.isNotEmpty).toSet();
    if (uniqueIds.isEmpty) return {};

    final db = ref.read(appDatabaseProvider);
    final rows =
        await (db.selectOnly(db.renters)
              ..addColumns([db.renters.id, db.renters.name])
              ..where(db.renters.id.isIn(uniqueIds.toList())))
            .get();

    return {
      for (final row in rows)
        row.read(db.renters.id)!: row.read(db.renters.name)!,
    };
  }

  List<Renter> _sortByName(List<Renter> renters) {
    final sorted = List<Renter>.from(renters);
    sorted.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return sorted;
  }

  Future<List<Renter>> _mapRenterRows(List<RenterRow> renterRows) async {
    if (renterRows.isEmpty) return [];

    final db = ref.read(appDatabaseProvider);
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
  Future<void> archive(RenterId id) async {
    final db = ref.read(appDatabaseProvider);

    await (db.update(db.renters)..where((table) => table.id.equals(id))).write(
      const RentersCompanion(isArchived: Value(true)),
    );
  }

  @override
  Future<void> unarchive(RenterId id) async {
    final db = ref.read(appDatabaseProvider);

    await (db.update(db.renters)..where((table) => table.id.equals(id))).write(
      const RentersCompanion(isArchived: Value(false)),
    );
  }

  @override
  Future<void> save(Renter renter) async {
    final uniqueAccountNumbers = renter.accountNumbers.toSet().toList();
    if (uniqueAccountNumbers.length != renter.accountNumbers.length) {
      throw const DuplicateRenterAccountNumbersError();
    }

    for (final accountNumber in uniqueAccountNumbers) {
      if (!isValidAccountNumber(accountNumber)) {
        throw InvalidRenterAccountNumberError(accountNumber);
      }
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
