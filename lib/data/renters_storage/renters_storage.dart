import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/drift/mappers/renter_mapper.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:easy_fin/utils/account_number_validator.dart';
import 'package:easy_fin/utils/money.dart';
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

class RenterInUseError extends RentersStorageError {
  const RenterInUseError({
    this.bankOperationsCount = 0,
    this.incomeLinesCount = 0,
    this.assignmentsCount = 0,
    this.documents = const [],
  });

  final int bankOperationsCount;
  final int incomeLinesCount;
  final int assignmentsCount;
  final List<RenterUsageDocument> documents;

  String get message {
    final parts = <String>[];
    if (bankOperationsCount > 0) {
      parts.add('операций выписки: $bankOperationsCount');
    }
    if (incomeLinesCount > 0) {
      parts.add('строк прихода: $incomeLinesCount');
    }
    if (assignmentsCount > 0) {
      parts.add('начислений: $assignmentsCount');
    }

    final details = parts.isEmpty ? 'связанные документы' : parts.join(', ');
    return 'Арендатор используется ($details). '
        'Архивируйте его вместо удаления или удалите связанные записи '
        'в разделе «Документы». '
        'Сбросьте фильтры даты и «Касса/Банк», либо выберите этого '
        'арендатора в фильтре документов.';
  }
}

class RenterUsageDocument {
  const RenterUsageDocument({
    required this.date,
    required this.kindLabel,
    required this.accountLabel,
    required this.amount,
  });

  final DateTime date;
  final String kindLabel;
  final String accountLabel;
  final double amount;
}

class RenterNotFoundError extends RentersStorageError {
  const RenterNotFoundError();
}

abstract class RentersStorage {
  Future<void> save(Renter renter);
  Future<void> archive(RenterId id);
  Future<void> unarchive(RenterId id);
  Future<void> delete(RenterId id);
  Future<bool> isUsed(RenterId id);
  Future<Renter?> findById(RenterId id);
  Future<Renter?> findByAccount(
    AccountNumber accountNumber, {
    BaseId? baseId,
  });
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
  Future<Renter?> findByAccount(
    AccountNumber accountNumber, {
    BaseId? baseId,
  }) async {
    final db = ref.read(appDatabaseProvider);

    final accountRows =
        await (db.select(db.renterAccountNumbers)
              ..where((table) => table.accountNumber.equals(accountNumber)))
            .get();

    for (final accountRow in accountRows) {
      final renter = await findById(accountRow.renterId);
      if (renter == null) continue;
      if (baseId == null || renter.baseId == baseId) {
        return renter;
      }
    }

    return null;
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
  Future<void> delete(RenterId id) async {
    final usage = await _usageCounts(id);
    if (usage.isUsed) {
      throw RenterInUseError(
        bankOperationsCount: usage.bankOperationsCount,
        incomeLinesCount: usage.incomeLinesCount,
        assignmentsCount: usage.assignmentsCount,
        documents: usage.documents,
      );
    }

    final db = ref.read(appDatabaseProvider);
    final deleted = await (db.delete(db.renters)
          ..where((table) => table.id.equals(id)))
        .go();

    if (deleted == 0) {
      throw const RenterNotFoundError();
    }
  }

  @override
  Future<bool> isUsed(RenterId id) async {
    return (await _usageCounts(id)).isUsed;
  }

  Future<
      ({
        bool isUsed,
        int bankOperationsCount,
        int incomeLinesCount,
        int assignmentsCount,
        List<RenterUsageDocument> documents,
      })> _usageCounts(RenterId id) async {
    final db = ref.read(appDatabaseProvider);
    final documents = <RenterUsageDocument>[];

    final incomeRows = await (db.select(db.incomeLines).join([
          innerJoin(
            db.incomeDocuments,
            db.incomeDocuments.id.equalsExp(db.incomeLines.documentId),
          ),
        ])
          ..where(db.incomeLines.renterId.equals(id)))
        .get();
    for (final row in incomeRows) {
      final line = row.readTable(db.incomeLines);
      final header = row.readTable(db.incomeDocuments);
      documents.add(
        RenterUsageDocument(
          date: header.date,
          kindLabel: 'Приход',
          accountLabel: header.accountType == 'cash'
              ? 'Касса'
              : header.accountRef,
          amount: moneyFromMinor(line.amountMinor),
        ),
      );
    }

    final operationRows = await (db.select(db.bankStatementOperations).join([
          innerJoin(
            db.bankStatements,
            db.bankStatements.id.equalsExp(
              db.bankStatementOperations.statementId,
            ),
          ),
        ])
          ..where(db.bankStatementOperations.renterId.equals(id)))
        .get();
    for (final row in operationRows) {
      final operation = row.readTable(db.bankStatementOperations);
      final statement = row.readTable(db.bankStatements);
      final isIncome = operation.creditMinor != null;
      documents.add(
        RenterUsageDocument(
          date: operation.date,
          kindLabel: isIncome ? 'Приход (выписка)' : 'Расход (выписка)',
          accountLabel: statement.accountNumber,
          amount: moneyFromMinor(
            operation.creditMinor ?? operation.debitMinor ?? 0,
          ),
        ),
      );
    }

    final assignmentRows = await (db.select(db.renterAssignments)
          ..where((table) => table.renterId.equals(id)))
        .get();
    for (final row in assignmentRows) {
      documents.add(
        RenterUsageDocument(
          date: row.date,
          kindLabel: 'Начисление',
          accountLabel: 'Аренда',
          amount: moneyFromMinor(row.amountMinor),
        ),
      );
    }

    documents.sort((a, b) => b.date.compareTo(a.date));

    return (
      isUsed: documents.isNotEmpty,
      bankOperationsCount: operationRows.length,
      incomeLinesCount: incomeRows.length,
      assignmentsCount: assignmentRows.length,
      documents: documents,
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
      final existingRenter = await findByAccount(
        accountNumber,
        baseId: renter.baseId,
      );
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
