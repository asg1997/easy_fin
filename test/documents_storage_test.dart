import 'package:drift/native.dart';
import 'package:easy_fin/data/documents_storage/documents_storage.dart';
import 'package:easy_fin/data/models/get_statements_filters.dart';
import 'package:easy_fin/models/account_filter_type.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('documents storage includes renter assignments', () async {
    final db = AppDatabase(NativeDatabase.memory());

    await db.into(db.bases).insert(
      BasesCompanion.insert(id: 'base1', name: 'База 1'),
    );
    await db.into(db.renters).insert(
      RentersCompanion.insert(id: 'renter1', baseId: 'base1', name: 'Иванов'),
    );
    await db.into(db.renterAssignments).insert(
      RenterAssignmentsCompanion.insert(
        id: '1_0',
        baseId: 'base1',
        renterId: 'renter1',
        accountNumber: '40702810123456789012',
        date: DateTime(2026, 6),
        amountMinor: 500000,
        createdAt: DateTime(2026, 6, 11),
      ),
    );

    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final items = await container
        .read(documentsStorageProvider)
        .getDocuments(const GetStatementsFilters());

    expect(items, hasLength(1));
    expect(items.first.baseName, 'База 1');
    expect(items.first.amount, 5000);
    expect(items.first.note, isEmpty);
    expect(items.first.baseId, 'base1');
  });

  test('documents storage groups renter assignments by base and month', () async {
    final db = AppDatabase(NativeDatabase.memory());

    await db.into(db.bases).insert(
      BasesCompanion.insert(id: 'base1', name: 'База 1'),
    );
    await db.into(db.renters).insert(
      RentersCompanion.insert(id: 'renter1', baseId: 'base1', name: 'Иванов'),
    );
    await db.into(db.renters).insert(
      RentersCompanion.insert(id: 'renter2', baseId: 'base1', name: 'Петров'),
    );
    await db.into(db.renterAssignments).insert(
      RenterAssignmentsCompanion.insert(
        id: '1_0',
        baseId: 'base1',
        renterId: 'renter1',
        accountNumber: '40702810123456789012',
        date: DateTime(2026, 6),
        amountMinor: 500000,
        createdAt: DateTime(2026, 6, 11),
      ),
    );
    await db.into(db.renterAssignments).insert(
      RenterAssignmentsCompanion.insert(
        id: '1_1',
        baseId: 'base1',
        renterId: 'renter2',
        accountNumber: '40702810987654321098',
        date: DateTime(2026, 6),
        amountMinor: 300000,
        createdAt: DateTime(2026, 6, 11),
      ),
    );

    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final items = await container
        .read(documentsStorageProvider)
        .getDocuments(const GetStatementsFilters());

    expect(items, hasLength(1));
    expect(items.first.amount, 8000);
    expect(items.first.note, isEmpty);
  });

  test('documents storage loads assignments with bank account filter', () async {
    final db = AppDatabase(NativeDatabase.memory());

    await db.into(db.bases).insert(
      BasesCompanion.insert(id: 'base1', name: 'База 1'),
    );
    await db.into(db.renters).insert(
      RentersCompanion.insert(id: 'renter1', baseId: 'base1', name: 'Иванов'),
    );
    await db.into(db.renterAssignments).insert(
      RenterAssignmentsCompanion.insert(
        id: '1_0',
        baseId: 'base1',
        renterId: 'renter1',
        accountNumber: '40702810123456789012',
        date: DateTime(2026, 6),
        amountMinor: 500000,
        createdAt: DateTime(2026, 6, 11),
      ),
    );

    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final items = await container.read(documentsStorageProvider).getDocuments(
      const GetStatementsFilters(
        accountFilterTypes: [AccountFilterType.bank],
      ),
    );

    expect(items, hasLength(1));
  });
}
