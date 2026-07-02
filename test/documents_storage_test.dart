import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:easy_fin/data/documents_storage/documents_storage.dart';
import 'package:easy_fin/data/income_categories_storage/income_categories_storage.dart';
import 'package:easy_fin/data/incomes_storage/incomes_storage.dart';
import 'package:easy_fin/data/models/get_statements_filters.dart';
import 'package:easy_fin/models/account_filter_type.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:easy_fin/models/income.dart';
import 'package:easy_fin/models/income_document.dart';
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

  test('documents storage includes manual income documents', () async {
    final db = AppDatabase(NativeDatabase.memory());

    await db.into(db.bases).insert(
      BasesCompanion.insert(id: 'base1', name: 'База 1'),
    );

    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final categories = await container
        .read(incomeCategoriesStorageProvider)
        .getActive();

    await container.read(incomesStorageProvider).saveDocument(
      IncomeDocument(
        id: 'income1',
        createdAt: DateTime(2026, 6, 12),
        baseId: 'base1',
        date: DateTime(2026, 6, 12),
        account: const IncomeDocumentCashAccount(),
        lines: [
          Income(
            id: 'line1',
            sum: 1200,
            incomeSource: IncomeSourceFromOther(
              categoryId: categories.first.id,
            ),
          ),
        ],
      ),
    );

    final items = await container
        .read(documentsStorageProvider)
        .getDocuments(const GetStatementsFilters());

    expect(items, hasLength(1));
    expect(items.first.amount, 1200);
    expect(items.first.documentType, DocumentType.income);
    expect(items.first.incomeDocumentId, 'income1');
    expect(items.first.accountType, AccountFilterType.cash.label);
  });

  test('documents storage prefixes classified bank operations', () async {
    final db = AppDatabase(NativeDatabase.memory());

    await db.into(db.bases).insert(
      BasesCompanion.insert(id: 'base1', name: 'База 1'),
    );
    await db.into(db.baseAccountNumbers).insert(
      BaseAccountNumbersCompanion(
        baseId: const Value('base1'),
        accountNumber: const Value('40702810111111111111'),
        bankName: const Value('Сбер'),
      ),
    );
    await db.into(db.renters).insert(
      RentersCompanion.insert(id: 'renter1', baseId: 'base1', name: 'Иванов'),
    );

    final categoryId = await (db.select(db.incomeCategories)
          ..where((table) => table.name.equals('Прочее')))
        .getSingle()
        .then((row) => row.id);

    final statementId = await db.into(db.bankStatements).insert(
      BankStatementsCompanion.insert(
        baseId: 'base1',
        accountNumber: '40702810111111111111',
        startDate: DateTime(2026, 3, 1),
        endDate: DateTime(2026, 3, 31),
        initialBalanceMinor: 0,
        finalBalanceMinor: 200000,
      ),
    );

    await db.into(db.bankStatementOperations).insert(
      BankStatementOperationsCompanion.insert(
        statementId: statementId,
        date: DateTime(2026, 3, 10),
        debitInn: '',
        debitBankAccount: '40702810222222222222',
        creditInn: '',
        creditBankAccount: '40702810111111111111',
        creditMinor: const Value(150000),
        note: 'Оплата аренды',
        renterId: const Value('renter1'),
      ),
    );
    await db.into(db.bankStatementOperations).insert(
      BankStatementOperationsCompanion.insert(
        statementId: statementId,
        date: DateTime(2026, 3, 12),
        debitInn: '',
        debitBankAccount: '',
        creditInn: '',
        creditBankAccount: '40702810111111111111',
        creditMinor: const Value(50000),
        note: 'Вознаграждение за остаток',
        incomeCategoryId: Value(categoryId),
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

    expect(items, hasLength(2));
    expect(
      items.map((item) => item.note).toSet(),
      containsAll([
        'Иванов: Оплата аренды',
        'Прочее: Вознаграждение за остаток',
      ]),
    );
  });
}
