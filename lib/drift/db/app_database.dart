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
import 'package:easy_fin/drift/models/note_tags_table.dart';
import 'package:easy_fin/drift/models/notes_table.dart';
import 'package:easy_fin/drift/models/renter_assignment_documents_table.dart';
import 'package:easy_fin/drift/models/renter_assignments_table.dart';
import 'package:easy_fin/drift/models/renters_table.dart';
import 'package:easy_fin/utils/database_path.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Bases,
    BaseAccountNumbers,
    BankStatements,
    BankStatementOperations,
    Renters,
    RenterAccountNumbers,
    RenterAssignmentDocuments,
    RenterAssignments,
    IncomeCategories,
    ExpenseCategories,
    ExpenseCategoryAccountNumbers,
    IncomeDocuments,
    IncomeLines,
    ExpenseDocuments,
    ExpenseLines,
    Notes,
    NoteTags,
  ],
)
class AppDatabase extends _$AppDatabase {
  static const int currentSchemaVersion = 18;

  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => currentSchemaVersion;

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
      if (from < 15) {
        await _migrateToV15(migrator);
      }
      if (from < 16) {
        await migrator.createTable(notes);
      }
      if (from < 17) {
        await migrator.createTable(noteTags);
      }
      if (from < 18) {
        await _migrateToV18(migrator);
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
    final file = await getDatabaseFile();
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

Future<void> _migrateToV15(Migrator migrator) async {
  final db = migrator.database;

  await db.transaction(() async {
    await db.customStatement('PRAGMA foreign_keys = OFF');

    await db.customStatement('''
      CREATE TABLE renter_account_numbers_new (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        renter_id TEXT NOT NULL REFERENCES renters (id) ON DELETE CASCADE,
        account_number TEXT NOT NULL,
        UNIQUE (renter_id, account_number)
      )
    ''');

    await db.customStatement('''
      INSERT INTO renter_account_numbers_new (id, renter_id, account_number)
      SELECT id, renter_id, account_number
      FROM renter_account_numbers
    ''');

    await db.customStatement('DROP TABLE renter_account_numbers');
    await db.customStatement(
      'ALTER TABLE renter_account_numbers_new RENAME TO renter_account_numbers',
    );

    await db.customStatement('PRAGMA foreign_keys = ON');
  });
}

/// Начисления: одна таблица строк → документ + строки (как приход).
/// Существующие строки за (база, месяц) склеиваются в один документ.
Future<void> _migrateToV18(Migrator migrator) async {
  final db = migrator.database;

  await db.transaction(() async {
    await db.customStatement('PRAGMA foreign_keys = OFF');

    await db.customStatement('''
      CREATE TABLE renter_assignment_documents (
        id TEXT NOT NULL PRIMARY KEY,
        base_id TEXT NOT NULL REFERENCES bases (id) ON DELETE CASCADE,
        date INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.customStatement('''
      CREATE TABLE renter_assignments_new (
        id TEXT NOT NULL PRIMARY KEY,
        document_id TEXT NOT NULL
          REFERENCES renter_assignment_documents (id) ON DELETE CASCADE,
        renter_id TEXT NOT NULL REFERENCES renters (id) ON DELETE CASCADE,
        account_number TEXT NOT NULL,
        amount_minor INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    final oldRows = await db
        .customSelect(
          'SELECT id, base_id, renter_id, account_number, date, '
          'amount_minor, created_at FROM renter_assignments',
        )
        .get();

    final groups = <String, List<QueryRow>>{};
    for (final row in oldRows) {
      final dateMs = row.read<int>('date');
      final date = DateTime.fromMillisecondsSinceEpoch(dateMs);
      final baseId = row.read<String>('base_id');
      final key = '${baseId}_${date.year}_${date.month}';
      groups.putIfAbsent(key, () => []).add(row);
    }

    var documentIndex = 0;
    for (final group in groups.values) {
      final baseId = group.first.read<String>('base_id');
      var maxDateMs = group.first.read<int>('date');
      var minCreatedAtMs = group.first.read<int>('created_at');
      for (final row in group) {
        final dateMs = row.read<int>('date');
        final createdAtMs = row.read<int>('created_at');
        if (dateMs > maxDateMs) maxDateMs = dateMs;
        if (createdAtMs < minCreatedAtMs) minCreatedAtMs = createdAtMs;
      }

      final documentId =
          'migrated_ra_${++documentIndex}_$maxDateMs';

      await db.customInsert(
        'INSERT INTO renter_assignment_documents '
        '(id, base_id, date, created_at) VALUES (?, ?, ?, ?)',
        variables: [
          Variable.withString(documentId),
          Variable.withString(baseId),
          Variable.withInt(maxDateMs),
          Variable.withInt(minCreatedAtMs),
        ],
      );

      for (final row in group) {
        await db.customInsert(
          'INSERT INTO renter_assignments_new '
          '(id, document_id, renter_id, account_number, amount_minor, created_at) '
          'VALUES (?, ?, ?, ?, ?, ?)',
          variables: [
            Variable.withString(row.read<String>('id')),
            Variable.withString(documentId),
            Variable.withString(row.read<String>('renter_id')),
            Variable.withString(row.read<String>('account_number')),
            Variable.withInt(row.read<int>('amount_minor')),
            Variable.withInt(row.read<int>('created_at')),
          ],
        );
      }
    }

    await db.customStatement('DROP TABLE renter_assignments');
    await db.customStatement(
      'ALTER TABLE renter_assignments_new RENAME TO renter_assignments',
    );

    await db.customStatement('PRAGMA foreign_keys = ON');
  });
}
