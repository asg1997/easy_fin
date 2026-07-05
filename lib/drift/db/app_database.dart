import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:easy_fin/drift/models/bank_statement_operations_table.dart';
import 'package:easy_fin/drift/models/bank_statements_table.dart';
import 'package:easy_fin/drift/models/base_account_numbers_table.dart';
import 'package:easy_fin/drift/models/bases_table.dart';
import 'package:easy_fin/drift/models/renter_account_numbers_table.dart';
import 'package:easy_fin/drift/models/expense_category_account_numbers_table.dart';
import 'package:easy_fin/drift/models/expense_categories_table.dart';
import 'package:easy_fin/drift/models/income_categories_table.dart';
import 'package:easy_fin/drift/models/expense_documents_table.dart';
import 'package:easy_fin/drift/models/expense_lines_table.dart';
import 'package:easy_fin/drift/models/income_documents_table.dart';
import 'package:easy_fin/drift/models/income_lines_table.dart';
import 'package:easy_fin/drift/models/renter_assignments_table.dart';
import 'package:easy_fin/drift/models/renters_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Bases,
    BaseAccountNumbers,
    BankStatements,
    BankStatementOperations,
    Renters,
    RenterAccountNumbers,
    RenterAssignments,
    IncomeCategories,
    ExpenseCategories,
    ExpenseCategoryAccountNumbers,
    IncomeDocuments,
    IncomeLines,
    ExpenseDocuments,
    ExpenseLines,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 14;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await _seedIncomeCategories(migrator.database);
      await _seedExpenseCategories(migrator.database);
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await _migrateToV2(migrator);
      }
      if (from < 3) {
        await migrator.createTable(renters);
        await migrator.createTable(renterAccountNumbers);
      }
      if (from < 4) {
        await migrator.database.customStatement(
          'ALTER TABLE renters ADD COLUMN base_id TEXT REFERENCES bases (id) ON DELETE CASCADE',
        );
      }
      if (from < 5) {
        await migrator.database.customStatement(
          'ALTER TABLE renters ADD COLUMN is_archived INTEGER NOT NULL DEFAULT 0',
        );
      }
      if (from < 6) {
        await migrator.database.customStatement(
          'ALTER TABLE base_account_numbers ADD COLUMN bank_name TEXT NOT NULL DEFAULT \'\'',
        );
      }
      if (from < 7) {
        await migrator.createTable(renterAssignments);
      }
      if (from < 8) {
        final table = await migrator.database
            .customSelect(
              "SELECT name FROM sqlite_master "
              "WHERE type = 'table' AND name = 'renter_assignments'",
            )
            .getSingleOrNull();
        if (table == null) {
          await migrator.createTable(renterAssignments);
        }
      }
      if (from < 9) {
        await migrator.database.customStatement('''
          UPDATE renters
          SET base_id = (SELECT id FROM bases ORDER BY id LIMIT 1)
          WHERE base_id IS NULL
            AND EXISTS (SELECT 1 FROM bases LIMIT 1)
        ''');
        await migrator.database.customStatement(
          'DELETE FROM renters WHERE base_id IS NULL',
        );
        await migrator.database.customStatement(
          'UPDATE renters SET is_archived = 0 WHERE is_archived IS NULL',
        );
        await migrator.database.customStatement(
          "UPDATE base_account_numbers SET bank_name = '' "
          'WHERE bank_name IS NULL',
        );
      }
      if (from < 10) {
        await migrator.createTable(incomeCategories);
        await migrator.createTable(incomeDocuments);
        await migrator.createTable(incomeLines);
        await _seedIncomeCategories(migrator.database);
      }
      if (from < 11) {
        await migrator.database.customStatement(
          'ALTER TABLE bank_statement_operations '
          'ADD COLUMN renter_id TEXT REFERENCES renters (id) ON DELETE SET NULL',
        );
        await migrator.database.customStatement(
          'ALTER TABLE bank_statement_operations '
          'ADD COLUMN income_category_id INTEGER REFERENCES income_categories (id) '
          'ON DELETE SET NULL',
        );
      }
      if (from < 12) {
        await migrator.createTable(expenseCategories);
        await _seedExpenseCategories(migrator.database);
        await migrator.database.customStatement(
          'ALTER TABLE bank_statement_operations '
          'ADD COLUMN expense_category_id INTEGER REFERENCES expense_categories (id) '
          'ON DELETE SET NULL',
        );
      }
      if (from < 13) {
        await migrator.createTable(expenseCategoryAccountNumbers);
      }
      if (from < 14) {
        await migrator.createTable(expenseDocuments);
        await migrator.createTable(expenseLines);
      }
    },
  );
}

Future<void> _seedIncomeCategories(GeneratedDatabase db) async {
  final existing = await db
      .customSelect('SELECT COUNT(*) AS count FROM income_categories')
      .getSingle();
  if ((existing.data['count']! as int) > 0) return;

  final now = DateTime.now();
  const names = ['Кредит', 'Возврат', 'Перевод', 'Прочее'];
  for (var i = 0; i < names.length; i++) {
    await db.customInsert(
      'INSERT INTO income_categories (name, is_archived, sort_order, created_at) '
      'VALUES (?, 0, ?, ?)',
      variables: [
        Variable.withString(names[i]),
        Variable.withInt(i),
        Variable.withDateTime(now),
      ],
    );
  }
}

Future<void> _seedExpenseCategories(GeneratedDatabase db) async {
  final existing = await db
      .customSelect('SELECT COUNT(*) AS count FROM expense_categories')
      .getSingle();
  if ((existing.data['count']! as int) > 0) return;

  final now = DateTime.now();
  const names = ['Коммунальные', 'Налоги', 'Банк', 'Перевод', 'Прочее'];
  for (var i = 0; i < names.length; i++) {
    await db.customInsert(
      'INSERT INTO expense_categories (name, is_archived, sort_order, created_at) '
      'VALUES (?, 0, ?, ?)',
      variables: [
        Variable.withString(names[i]),
        Variable.withInt(i),
        Variable.withDateTime(now),
      ],
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'easy_fin.sqlite'));

    return NativeDatabase(file);
  });
}

Future<void> _migrateToV2(Migrator migrator) async {
  final db = migrator.database;

  final statementsTable = await db
      .customSelect(
        "SELECT sql FROM sqlite_master WHERE type = 'table' AND name = 'bank_statements'",
      )
      .getSingleOrNull();
  if (statementsTable == null) {
    await migrator.createAll();
    return;
  }

  final statementsSql = statementsTable.data['sql']! as String;
  if (statementsSql.contains('initial_balance_minor')) {
    return;
  }

  await db.transaction(() async {
    await db.customStatement('PRAGMA foreign_keys = OFF');

    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS bank_statements_new (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        base_id TEXT NOT NULL REFERENCES bases (id) ON DELETE CASCADE,
        account_number TEXT NOT NULL REFERENCES base_account_numbers (account_number) ON DELETE RESTRICT,
        start_date INTEGER NOT NULL,
        end_date INTEGER NOT NULL,
        initial_balance_minor INTEGER NOT NULL,
        final_balance_minor INTEGER NOT NULL,
        UNIQUE (account_number, start_date, end_date)
      )
    ''');

    await db.customStatement('''
      INSERT INTO bank_statements_new (
        id,
        base_id,
        account_number,
        start_date,
        end_date,
        initial_balance_minor,
        final_balance_minor
      )
      SELECT
        bank_statements.id,
        base_account_numbers.base_id,
        bank_statements.account_number,
        bank_statements.start_date,
        bank_statements.end_date,
        CAST(ROUND(bank_statements.initial_balance * 100) AS INTEGER),
        CAST(ROUND(bank_statements.final_balance * 100) AS INTEGER)
      FROM bank_statements
      INNER JOIN base_account_numbers
        ON base_account_numbers.account_number = bank_statements.account_number
    ''');

    await db.customStatement('''
      CREATE TABLE bank_statement_operations_new (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        statement_id INTEGER NOT NULL,
        date INTEGER NOT NULL,
        debit_inn TEXT NOT NULL,
        debit_bank_account TEXT NOT NULL,
        credit_inn TEXT NOT NULL,
        credit_bank_account TEXT NOT NULL,
        debit_minor INTEGER,
        credit_minor INTEGER,
        note TEXT NOT NULL
      )
    ''');

    await db.customStatement('''
      INSERT INTO bank_statement_operations_new (
        id,
        statement_id,
        date,
        debit_inn,
        debit_bank_account,
        credit_inn,
        credit_bank_account,
        debit_minor,
        credit_minor,
        note
      )
      SELECT
        bank_statement_operations.id,
        bank_statement_operations.statement_id,
        bank_statement_operations.date,
        bank_statement_operations.debit_inn,
        bank_statement_operations.debit_bank_account,
        bank_statement_operations.credit_inn,
        bank_statement_operations.credit_bank_account,
        CAST(ROUND(bank_statement_operations.debit * 100) AS INTEGER),
        CAST(ROUND(bank_statement_operations.credit * 100) AS INTEGER),
        bank_statement_operations.note
      FROM bank_statement_operations
      INNER JOIN bank_statements_new
        ON bank_statements_new.id = bank_statement_operations.statement_id
    ''');

    await db.customStatement('DROP TABLE bank_statement_operations');
    await db.customStatement('DROP TABLE bank_statements');
    await db.customStatement(
      'ALTER TABLE bank_statements_new RENAME TO bank_statements',
    );
    await db.customStatement(
      'ALTER TABLE bank_statement_operations_new RENAME TO bank_statement_operations',
    );

    await db.customStatement('''
      CREATE INDEX IF NOT EXISTS bank_statements_base_start_date
      ON bank_statements (base_id, start_date)
    ''');

    await db.customStatement('PRAGMA foreign_keys = ON');
  });
}
