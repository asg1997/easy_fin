import 'package:drift/native.dart';
import 'package:easy_fin/data/bank_statements_importing/statement_expense_review_analyzer.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/data/models/bank_statement_operation.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/models/import_expense_review.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StatementExpenseReviewAnalyzer', () {
    late AppDatabase db;
    late ProviderContainer container;
    late StatementExpenseReviewAnalyzer analyzer;

    const baseAccount = '40702810111111111111';
    const otherOwnAccount = '40702810999999999999';
    const recipientAccount = '40702810333333333333';
    const treasuryAccount = '40702810555555555555';

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
      await db.into(db.baseAccountNumbers).insert(
        BaseAccountNumbersCompanion.insert(
          baseId: 'base1',
          accountNumber: baseAccount,
        ),
      );
      await db.into(db.baseAccountNumbers).insert(
        BaseAccountNumbersCompanion.insert(
          baseId: 'base1',
          accountNumber: otherOwnAccount,
        ),
      );

      container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );
      addTearDown(container.dispose);
      analyzer = container.read(statementExpenseReviewAnalyzerProvider);
    });

    test('groups unknown account operations into counterparty item', () async {
      final statement = buildStatement(
        operations: [
          BankStatementOperation(
            date: DateTime(2026, 3, 10),
            debitInn: '',
            debitBankAccount: baseAccount,
            creditInn: '',
            creditBankAccount: recipientAccount,
            debit: 1500,
            credit: null,
            note: 'Коммунальные',
            creditCounterpartyName: 'ООО ЖКХ',
          ),
          BankStatementOperation(
            date: DateTime(2026, 3, 15),
            debitInn: '',
            debitBankAccount: baseAccount,
            creditInn: '',
            creditBankAccount: recipientAccount,
            debit: 2000,
            credit: null,
            note: 'Коммунальные 2',
            creditCounterpartyName: 'ООО ЖКХ длинное',
          ),
        ],
      );

      final result = await analyzer.analyze(statement, baseId: 'base1');

      expect(result.autoMatchedCategoryIds, isEmpty);
      expect(result.reviewItems, hasLength(1));
      final item = result.reviewItems.single as ImportExpenseCounterpartyItem;
      expect(item.originalAccountNumber, recipientAccount);
      expect(item.suggestedName, 'ООО ЖКХ длинное');
      expect(item.operations, hasLength(2));
    });

    test('auto-matches expense category by linked account in base', () async {
      final categoryId = await db.into(db.expenseCategories).insert(
        ExpenseCategoriesCompanion.insert(
          name: 'Упрощёнка',
          createdAt: DateTime(2026, 1, 1),
        ),
      );
      await db.into(db.expenseCategoryAccountNumbers).insert(
        ExpenseCategoryAccountNumbersCompanion.insert(
          baseId: 'base1',
          expenseCategoryId: categoryId,
          accountNumber: treasuryAccount,
        ),
      );

      final statement = buildStatement(
        operations: [
          BankStatementOperation(
            date: DateTime(2026, 3, 10),
            debitInn: '',
            debitBankAccount: baseAccount,
            creditInn: '',
            creditBankAccount: treasuryAccount,
            debit: 5000,
            credit: null,
            note: 'Налог УСН',
            creditCounterpartyName: 'Казначейство России',
          ),
        ],
      );

      final result = await analyzer.analyze(statement, baseId: 'base1');

      expect(result.reviewItems, isEmpty);
      expect(result.autoMatchedCategoryIds, {0: categoryId});
    });

    test('does not auto-match linked account from another base', () async {
      await db.into(db.bases).insert(
        BasesCompanion.insert(id: 'base2', name: 'База 2'),
      );
      final categoryId = await db.into(db.expenseCategories).insert(
        ExpenseCategoriesCompanion.insert(
          name: 'Упрощёнка',
          createdAt: DateTime(2026, 1, 1),
        ),
      );
      await db.into(db.expenseCategoryAccountNumbers).insert(
        ExpenseCategoryAccountNumbersCompanion.insert(
          baseId: 'base2',
          expenseCategoryId: categoryId,
          accountNumber: treasuryAccount,
        ),
      );

      final statement = buildStatement(
        operations: [
          BankStatementOperation(
            date: DateTime(2026, 3, 10),
            debitInn: '',
            debitBankAccount: baseAccount,
            creditInn: '',
            creditBankAccount: treasuryAccount,
            debit: 5000,
            credit: null,
            note: 'Налог УСН',
          ),
        ],
      );

      final result = await analyzer.analyze(statement, baseId: 'base1');

      expect(result.autoMatchedCategoryIds, isEmpty);
      expect(result.reviewItems, hasLength(1));
    });

    test('creates standalone item for expense without account', () async {
      final statement = buildStatement(
        operations: [
          BankStatementOperation(
            date: DateTime(2026, 3, 5),
            debitInn: '',
            debitBankAccount: baseAccount,
            creditInn: '',
            creditBankAccount: '',
            debit: 1250,
            credit: null,
            note: 'Комиссия банка',
          ),
        ],
      );

      final result = await analyzer.analyze(statement, baseId: 'base1');

      expect(result.reviewItems, hasLength(1));
      expect(result.reviewItems.single, isA<ImportExpenseStandaloneItem>());
    });

    test('filters internal transfer to own account', () async {
      final statement = buildStatement(
        operations: [
          BankStatementOperation(
            date: DateTime(2026, 3, 5),
            debitInn: '',
            debitBankAccount: baseAccount,
            creditInn: '',
            creditBankAccount: otherOwnAccount,
            debit: 5000,
            credit: null,
            note: 'Перевод',
          ),
        ],
      );

      final result = await analyzer.analyze(statement, baseId: 'base1');

      expect(result.reviewItems, isEmpty);
    });

    test('skips already classified expenses', () async {
      final statement = buildStatement(
        operations: [
          BankStatementOperation(
            date: DateTime(2026, 3, 10),
            debitInn: '',
            debitBankAccount: baseAccount,
            creditInn: '',
            creditBankAccount: recipientAccount,
            debit: 1000,
            credit: null,
            note: 'Налог',
            expenseCategoryId: 1,
          ),
        ],
      );

      final result = await analyzer.analyze(statement, baseId: 'base1');

      expect(result.reviewItems, isEmpty);
    });
  });

  test('applyExpenseClassification sets auto-matched and resolved categories', () {
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
          debitBankAccount: '40702810111111111111',
          creditInn: '',
          creditBankAccount: '40702810555555555555',
          debit: 100,
          credit: null,
          note: 'УСН',
        ),
        BankStatementOperation(
          date: DateTime(2026, 3, 2),
          debitInn: '',
          debitBankAccount: '40702810111111111111',
          creditInn: '',
          creditBankAccount: '40702810333333333333',
          debit: 50,
          credit: null,
          note: 'Коммунальные',
        ),
        BankStatementOperation(
          date: DateTime(2026, 3, 3),
          debitInn: '',
          debitBankAccount: '40702810111111111111',
          creditInn: '',
          creditBankAccount: '',
          debit: 25,
          credit: null,
          note: 'Комиссия',
        ),
      ],
    );

    final updated = applyExpenseClassification(
      statement,
      autoMatchedCategoryIds: {0: 5},
      resolutions: [
        const ImportExpenseResolution(
          operationIndices: [1],
          classification: ImportExpenseClassification.other,
          expenseCategoryId: 3,
          accountNumber: '40702810333333333333',
        ),
      ],
    );

    expect(updated.operations[0].expenseCategoryId, 5);
    expect(updated.operations[1].expenseCategoryId, 3);
    expect(updated.operations[2].expenseCategoryId, isNull);
  });
}
