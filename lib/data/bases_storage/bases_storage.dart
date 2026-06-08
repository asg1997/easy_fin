import 'package:drift/drift.dart';
import 'package:easy_fin/drift/bases_database/base_mapper.dart';
import 'package:easy_fin/drift/bases_database/db/bases_database.dart';
import 'package:easy_fin/drift/bases_database/db/bases_database_provider.dart';
import 'package:easy_fin/models/base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final basesStorageProvider = Provider<BasesStorage>(
  BasesStorageImpl.new,
);

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
    final db = ref.read(basesDatabaseProvider);

    final baseRow = await (db.select(db.bases)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    if (baseRow == null) return null;

    final accountRows = await (db.select(db.baseAccountNumbers)
          ..where((table) => table.baseId.equals(id)))
        .get();

    return baseRow.toDomain(
      accountNumbers: accountRows.map((row) => row.accountNumber).toList(),
    );
  }

  @override
  Future<Base?> findByAccount(AccountNumber accountNumber) async {
    final db = ref.read(basesDatabaseProvider);

    final accountRow = await (db.select(db.baseAccountNumbers)
          ..where((table) => table.accountNumber.equals(accountNumber)))
        .getSingleOrNull();
    if (accountRow == null) return null;

    return findById(accountRow.baseId);
  }

  @override
  Future<List<Base>> getAll() async {
    final db = ref.read(basesDatabaseProvider);

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
    final db = ref.read(basesDatabaseProvider);

    await db.transaction(() async {
      await db.into(db.bases).insertOnConflictUpdate(base.toCompanion());

      await (db.delete(db.baseAccountNumbers)
            ..where((table) => table.baseId.equals(base.id)))
          .go();

      if (base.accountNumbers.isEmpty) return;

      await db.batch((batch) {
        batch.insertAll(
          db.baseAccountNumbers,
          base.accountNumbers
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
