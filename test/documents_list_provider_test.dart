import 'package:drift/native.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/view/providers/documents_filters_provider.dart';
import 'package:easy_fin/view/providers/documents_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('documentsListProvider loads renter assignments', () async {
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

    final items = await container.read(documentsListProvider.future);

    expect(items, hasLength(1));
    await db.close();
  });
}
