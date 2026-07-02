import 'package:drift/native.dart';
import 'package:easy_fin/data/bank_statements_importing/statement_income_review_analyzer.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/data/models/bank_statement_operation.dart';
import 'package:easy_fin/data/renters_storage/renters_storage.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/models/import_income_review.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StatementIncomeReviewAnalyzer', () {
    late AppDatabase db;
    late ProviderContainer container;
    late StatementIncomeReviewAnalyzer analyzer;

    const baseAccount = '40702810111111111111';
    const renterAccount = '40702810222222222222';
    const unknownAccount = '40702810333333333333';

    BankStatement buildStatement({
      required List<BankStatementOperation> operations,
    }) {
      return BankStatement(
        startDate: DateTime(2026, 3, 1),
        endDate: DateTime(2026, 3, 31),
        accountNumber: baseAccount,
        bankName: '',
        initialBalance: 0,
        finalBalance: 1000,
        operations: operations,
      );
    }

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      await db.into(db.bases).insert(
        BasesCompanion.insert(id: 'base1', name: 'База 1'),
      );
      await db.into(db.bases).insert(
        BasesCompanion.insert(id: 'base2', name: 'База 2'),
      );
      await db.into(db.renters).insert(
        RentersCompanion.insert(id: 'renter1', baseId: 'base1', name: 'Иванов'),
      );
      await db.into(db.renterAccountNumbers).insert(
        RenterAccountNumbersCompanion.insert(
          renterId: 'renter1',
          accountNumber: renterAccount,
        ),
      );
      await db.into(db.renters).insert(
        RentersCompanion.insert(id: 'renter2', baseId: 'base2', name: 'Петров'),
      );
      await db.into(db.renterAccountNumbers).insert(
        RenterAccountNumbersCompanion.insert(
          renterId: 'renter2',
          accountNumber: '40702810444444444444',
        ),
      );

      container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );
      addTearDown(container.dispose);
      analyzer = StatementIncomeReviewAnalyzer(
        container.read(rentersStorageProvider),
      );
    });

    test('auto-matches renter from current base', () async {
      final statement = buildStatement(
        operations: [
          BankStatementOperation(
            date: DateTime(2026, 3, 10),
            debitInn: '',
            debitBankAccount: renterAccount,
            creditInn: '',
            creditBankAccount: baseAccount,
            debit: null,
            credit: 1500,
            note: 'Аренда',
          ),
        ],
      );

      final result = await analyzer.analyze(statement, baseId: 'base1');

      expect(result.reviewItems, isEmpty);
      expect(result.autoMatchedRenterIds, {0: 'renter1'});
    });

    test('groups unknown account operations into counterparty item', () async {
      final statement = buildStatement(
        operations: [
          BankStatementOperation(
            date: DateTime(2026, 3, 10),
            debitInn: '',
            debitBankAccount: unknownAccount,
            creditInn: '',
            creditBankAccount: baseAccount,
            debit: null,
            credit: 1500,
            note: 'Аренда',
            debitCounterpartyName: 'ООО Ромашка',
          ),
          BankStatementOperation(
            date: DateTime(2026, 3, 15),
            debitInn: '',
            debitBankAccount: unknownAccount,
            creditInn: '',
            creditBankAccount: baseAccount,
            debit: null,
            credit: 2000,
            note: 'Аренда 2',
            debitCounterpartyName: 'ООО Ромашка длинное',
          ),
        ],
      );

      final result = await analyzer.analyze(statement, baseId: 'base1');

      expect(result.autoMatchedRenterIds, isEmpty);
      expect(result.reviewItems, hasLength(1));
      final item = result.reviewItems.single as ImportIncomeCounterpartyItem;
      expect(item.originalAccountNumber, unknownAccount);
      expect(item.suggestedName, 'ООО Ромашка длинное');
      expect(item.operations, hasLength(2));
    });

    test('creates standalone item for income without account', () async {
      final statement = buildStatement(
        operations: [
          BankStatementOperation(
            date: DateTime(2026, 3, 5),
            debitInn: '',
            debitBankAccount: '',
            creditInn: '',
            creditBankAccount: baseAccount,
            debit: null,
            credit: 1250,
            note: 'Проценты',
          ),
        ],
      );

      final result = await analyzer.analyze(statement, baseId: 'base1');

      expect(result.reviewItems, hasLength(1));
      expect(result.reviewItems.single, isA<ImportIncomeStandaloneItem>());
    });

    test('filters internal transfer to own account', () async {
      final statement = buildStatement(
        operations: [
          BankStatementOperation(
            date: DateTime(2026, 3, 5),
            debitInn: '',
            debitBankAccount: baseAccount,
            creditInn: '',
            creditBankAccount: baseAccount,
            debit: null,
            credit: 5000,
            note: 'Перевод',
          ),
        ],
      );

      final result = await analyzer.analyze(statement, baseId: 'base1');

      expect(result.reviewItems, isEmpty);
      expect(result.autoMatchedRenterIds, isEmpty);
    });

    test('shows warning for renter from another base', () async {
      final statement = buildStatement(
        operations: [
          BankStatementOperation(
            date: DateTime(2026, 3, 10),
            debitInn: '',
            debitBankAccount: '40702810444444444444',
            creditInn: '',
            creditBankAccount: baseAccount,
            debit: null,
            credit: 1000,
            note: 'Платёж',
          ),
        ],
      );

      final result = await analyzer.analyze(statement, baseId: 'base1');

      expect(result.autoMatchedRenterIds, isEmpty);
      final item = result.reviewItems.single as ImportIncomeCounterpartyItem;
      expect(item.otherBaseRenterName, 'Петров');
    });
  });

  test('applyIncomeClassification sets renter and category fields', () {
    final statement = BankStatement(
      startDate: DateTime(2026, 3, 1),
      endDate: DateTime(2026, 3, 31),
      accountNumber: '40702810111111111111',
      bankName: '',
      initialBalance: 0,
      finalBalance: 1000,
      operations: [
        BankStatementOperation(
          date: DateTime(2026, 3, 1),
          debitInn: '',
          debitBankAccount: '40702810222222222222',
          creditInn: '',
          creditBankAccount: '40702810111111111111',
          debit: null,
          credit: 100,
          note: 'Аренда',
        ),
        BankStatementOperation(
          date: DateTime(2026, 3, 2),
          debitInn: '',
          debitBankAccount: '',
          creditInn: '',
          creditBankAccount: '40702810111111111111',
          debit: null,
          credit: 50,
          note: 'Проценты',
        ),
      ],
    );

    final updated = applyIncomeClassification(
      statement,
      autoMatchedRenterIds: {0: 'renter1'},
      resolutions: [
        const ImportIncomeResolution(
          operationIndices: [1],
          classification: ImportIncomeClassification.other,
          incomeCategoryId: 3,
        ),
      ],
    );

    expect(updated.operations[0].renterId, 'renter1');
    expect(updated.operations[0].incomeCategoryId, isNull);
    expect(updated.operations[1].incomeCategoryId, 3);
    expect(updated.operations[1].renterId, isNull);
  });
}
