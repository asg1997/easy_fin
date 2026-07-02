import 'package:drift/native.dart';
import 'package:easy_fin/data/income_categories_storage/income_categories_storage.dart';
import 'package:easy_fin/data/incomes_storage/incomes_storage.dart';
import 'package:easy_fin/data/models/get_statements_filters.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/models/account_filter_type.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:easy_fin/models/income.dart';
import 'package:easy_fin/models/income_document.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

IncomeDocument _sampleDocument({
  required String id,
  required String baseId,
  required int categoryId,
  IncomeDocumentAccount account = const IncomeDocumentCashAccount(),
}) {
  return IncomeDocument(
    id: id,
    createdAt: DateTime(2026, 6, 15),
    baseId: baseId,
    date: DateTime(2026, 6, 15),
    account: account,
    lines: [
      Income(
        id: '${id}_0',
        sum: 1500,
        incomeSource: IncomeSourceFromOther(categoryId: categoryId),
        note: 'тест',
      ),
    ],
  );
}

void main() {
  group('IncomeCategoriesStorage', () {
    late AppDatabase db;
    late ProviderContainer container;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    test('seeds default categories on fresh database', () async {
      final categories = await container
          .read(incomeCategoriesStorageProvider)
          .getActive();

      expect(categories, hasLength(4));
      expect(categories.map((item) => item.name), [
        'Кредит',
        'Возврат',
        'Перевод',
        'Прочее',
      ]);
    });

    test('delete fails when category is used', () async {
      await db.into(db.bases).insert(
        BasesCompanion.insert(id: 'base1', name: 'База 1'),
      );

      final categories = await container
          .read(incomeCategoriesStorageProvider)
          .getActive();
      final categoryId = categories.first.id;

      await container.read(incomesStorageProvider).saveDocument(
        _sampleDocument(
          id: 'doc1',
          baseId: 'base1',
          categoryId: categoryId,
        ),
      );

      expect(
        () => container
            .read(incomeCategoriesStorageProvider)
            .delete(categoryId),
        throwsA(isA<IncomeCategoryInUseError>()),
      );
    });

    test('archive hides category from active list', () async {
      final storage = container.read(incomeCategoriesStorageProvider);
      final category = await storage.save('Бонус');

      await storage.archive(category.id);

      final active = await storage.getActive();
      expect(active.any((item) => item.id == category.id), isFalse);

      final all = await storage.getAll();
      expect(all.any((item) => item.id == category.id), isTrue);
    });
  });

  group('IncomesStorage', () {
    late AppDatabase db;
    late ProviderContainer container;
    late int categoryId;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );

      await db.into(db.bases).insert(
        BasesCompanion.insert(id: 'base1', name: 'База 1'),
      );
      await db.into(db.renters).insert(
        RentersCompanion.insert(id: 'renter1', baseId: 'base1', name: 'Иванов'),
      );

      final categories = await container
          .read(incomeCategoriesStorageProvider)
          .getActive();
      categoryId = categories.first.id;
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    test('saveDocument and getById roundtrip', () async {
      final storage = container.read(incomesStorageProvider);
      final document = _sampleDocument(
        id: 'doc1',
        baseId: 'base1',
        categoryId: categoryId,
      );

      await storage.saveDocument(document);
      final loaded = await storage.getById('doc1');

      expect(loaded, isNotNull);
      expect(loaded!.totalSum, 1500);
      expect(loaded.lines, hasLength(1));
      expect(loaded.lines.first.note, 'тест');
    });

    test('getByFilters respects document type and account filters', () async {
      final storage = container.read(incomesStorageProvider);

      await storage.saveDocument(
        _sampleDocument(
          id: 'cash_doc',
          baseId: 'base1',
          categoryId: categoryId,
        ),
      );
      await storage.saveDocument(
        _sampleDocument(
          id: 'bank_doc',
          baseId: 'base1',
          categoryId: categoryId,
          account: const IncomeDocumentBankAccount(
            accountNumber: '40702810123456789012',
          ),
        ),
      );

      final onlyCash = await storage.getByFilters(
        const GetStatementsFilters(
          documentTypes: [DocumentType.income],
          accountFilterTypes: [AccountFilterType.cash],
        ),
      );
      expect(onlyCash, hasLength(1));
      expect(onlyCash.first.id, 'cash_doc');

      final onlyBank = await storage.getByFilters(
        const GetStatementsFilters(
          documentTypes: [DocumentType.income],
          accountFilterTypes: [AccountFilterType.bank],
        ),
      );
      expect(onlyBank, hasLength(1));
      expect(onlyBank.first.id, 'bank_doc');
    });

    test('updateDocument replaces header and lines', () async {
      final storage = container.read(incomesStorageProvider);
      await storage.saveDocument(
        _sampleDocument(
          id: 'doc1',
          baseId: 'base1',
          categoryId: categoryId,
        ),
      );

      await storage.updateDocument(
        IncomeDocument(
          id: 'doc1',
          createdAt: DateTime(2026, 6, 15),
          baseId: 'base1',
          date: DateTime(2026, 6, 20),
          account: const IncomeDocumentCashAccount(),
          lines: [
            Income(
              id: 'line1',
              sum: 2000,
              incomeSource: IncomeSourceFromRenter(
                renterId: 'renter1',
                accountNumber: '',
              ),
            ),
            Income(
              id: 'line2',
              sum: 500,
              incomeSource: IncomeSourceFromOther(categoryId: categoryId),
            ),
          ],
        ),
      );

      final loaded = await storage.getById('doc1');
      expect(loaded!.date, DateTime(2026, 6, 20));
      expect(loaded.totalSum, 2500);
      expect(loaded.lines, hasLength(2));
    });

    test('deleteDocument removes document', () async {
      final storage = container.read(incomesStorageProvider);
      await storage.saveDocument(
        _sampleDocument(
          id: 'doc1',
          baseId: 'base1',
          categoryId: categoryId,
        ),
      );

      await storage.deleteDocument('doc1');

      final loaded = await storage.getById('doc1');
      expect(loaded, isNull);
    });

    test('rejects duplicate renter lines', () async {
      final storage = container.read(incomesStorageProvider);

      expect(
        () => storage.saveDocument(
          IncomeDocument(
            id: 'doc1',
            createdAt: DateTime(2026, 6, 15),
            baseId: 'base1',
            date: DateTime(2026, 6, 15),
            account: const IncomeDocumentCashAccount(),
            lines: [
              Income(
                id: 'line1',
                sum: 100,
                incomeSource: const IncomeSourceFromRenter(
                  renterId: 'renter1',
                  accountNumber: '40702810123456789012',
                ),
              ),
              Income(
                id: 'line2',
                sum: 200,
                incomeSource: const IncomeSourceFromRenter(
                  renterId: 'renter1',
                  accountNumber: '40702810123456789012',
                ),
              ),
            ],
          ),
        ),
        throwsA(isA<DuplicateIncomeRenterLineError>()),
      );
    });
  });
}
