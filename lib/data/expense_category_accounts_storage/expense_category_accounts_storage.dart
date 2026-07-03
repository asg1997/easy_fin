import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/expense_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseCategoryAccountsStorageProvider =
    Provider<ExpenseCategoryAccountsStorage>(
      ExpenseCategoryAccountsStorageImpl.new,
    );

abstract class ExpenseCategoryAccountsStorage {
  Future<ExpenseCategoryId?> findCategoryIdByAccount({
    required BaseId baseId,
    required String accountNumber,
  });

  Future<void> saveLink({
    required BaseId baseId,
    required ExpenseCategoryId categoryId,
    required String accountNumber,
  });
}

class ExpenseCategoryAccountsStorageImpl
    implements ExpenseCategoryAccountsStorage {
  const ExpenseCategoryAccountsStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<ExpenseCategoryId?> findCategoryIdByAccount({
    required BaseId baseId,
    required String accountNumber,
  }) async {
    final db = ref.read(appDatabaseProvider);
    final row = await (db.select(db.expenseCategoryAccountNumbers)
          ..where(
            (table) =>
                table.baseId.equals(baseId) &
                table.accountNumber.equals(accountNumber),
          ))
        .getSingleOrNull();

    return row?.expenseCategoryId;
  }

  @override
  Future<void> saveLink({
    required BaseId baseId,
    required ExpenseCategoryId categoryId,
    required String accountNumber,
  }) async {
    final trimmedAccount = accountNumber.trim();
    if (trimmedAccount.isEmpty) return;

    final db = ref.read(appDatabaseProvider);
    final existing = await (db.select(db.expenseCategoryAccountNumbers)
          ..where(
            (table) =>
                table.baseId.equals(baseId) &
                table.accountNumber.equals(trimmedAccount),
          ))
        .getSingleOrNull();

    if (existing != null) {
      await (db.update(db.expenseCategoryAccountNumbers)
            ..where((table) => table.id.equals(existing.id)))
          .write(
            ExpenseCategoryAccountNumbersCompanion(
              expenseCategoryId: Value(categoryId),
            ),
          );
      return;
    }

    await db.into(db.expenseCategoryAccountNumbers).insert(
      ExpenseCategoryAccountNumbersCompanion.insert(
        baseId: baseId,
        expenseCategoryId: categoryId,
        accountNumber: trimmedAccount,
      ),
    );
  }
}
