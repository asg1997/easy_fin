import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/drift/mappers/expense_category_mapper.dart';
import 'package:easy_fin/models/expense_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseCategoriesStorageProvider = Provider<ExpenseCategoriesStorage>(
  ExpenseCategoriesStorageImpl.new,
);

sealed class ExpenseCategoriesStorageError implements Exception {
  const ExpenseCategoriesStorageError();
}

class ExpenseCategoryInUseError extends ExpenseCategoriesStorageError {
  const ExpenseCategoryInUseError();
}

class ExpenseCategoryNotFoundError extends ExpenseCategoriesStorageError {
  const ExpenseCategoryNotFoundError();
}

abstract class ExpenseCategoriesStorage {
  Future<List<ExpenseCategory>> getAll({bool includeArchived = true});

  Future<List<ExpenseCategory>> getActive();

  Future<ExpenseCategory> save(String name);

  Future<void> rename(ExpenseCategoryId id, String name);

  Future<void> archive(ExpenseCategoryId id);

  Future<void> unarchive(ExpenseCategoryId id);

  Future<void> delete(ExpenseCategoryId id);

  Future<bool> isUsed(ExpenseCategoryId id);
}

class ExpenseCategoriesStorageImpl implements ExpenseCategoriesStorage {
  const ExpenseCategoriesStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<List<ExpenseCategory>> getAll({bool includeArchived = true}) async {
    final db = ref.read(appDatabaseProvider);
    final query = db.select(db.expenseCategories)
      ..orderBy([(table) => OrderingTerm.asc(table.sortOrder)]);

    if (!includeArchived) {
      query.where((table) => table.isArchived.equals(false));
    }

    final rows = await query.get();
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<List<ExpenseCategory>> getActive() {
    return getAll(includeArchived: false);
  }

  @override
  Future<ExpenseCategory> save(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Название категории не может быть пустым');
    }

    final db = ref.read(appDatabaseProvider);
    final maxSort = await db
        .customSelect('SELECT MAX(sort_order) AS max_sort FROM expense_categories')
        .getSingle();
    final nextSort = ((maxSort.data['max_sort'] as int?) ?? -1) + 1;

    final id = await db.into(db.expenseCategories).insert(
      ExpenseCategoriesCompanion.insert(
        name: trimmed,
        sortOrder: Value(nextSort),
        createdAt: DateTime.now(),
      ),
    );

    final row = await (db.select(db.expenseCategories)
          ..where((table) => table.id.equals(id)))
        .getSingle();

    return row.toDomain();
  }

  @override
  Future<void> rename(ExpenseCategoryId id, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Название категории не может быть пустым');
    }

    final db = ref.read(appDatabaseProvider);
    final updated = await (db.update(db.expenseCategories)
          ..where((table) => table.id.equals(id)))
        .write(ExpenseCategoriesCompanion(name: Value(trimmed)));

    if (updated == 0) {
      throw const ExpenseCategoryNotFoundError();
    }
  }

  @override
  Future<void> archive(ExpenseCategoryId id) async {
    await _setArchived(id, isArchived: true);
  }

  @override
  Future<void> unarchive(ExpenseCategoryId id) async {
    await _setArchived(id, isArchived: false);
  }

  Future<void> _setArchived(
    ExpenseCategoryId id, {
    required bool isArchived,
  }) async {
    final db = ref.read(appDatabaseProvider);
    final updated = await (db.update(db.expenseCategories)
          ..where((table) => table.id.equals(id)))
        .write(ExpenseCategoriesCompanion(isArchived: Value(isArchived)));

    if (updated == 0) {
      throw const ExpenseCategoryNotFoundError();
    }
  }

  @override
  Future<void> delete(ExpenseCategoryId id) async {
    if (await isUsed(id)) {
      throw const ExpenseCategoryInUseError();
    }

    final db = ref.read(appDatabaseProvider);
    final deleted = await (db.delete(db.expenseCategories)
          ..where((table) => table.id.equals(id)))
        .go();

    if (deleted == 0) {
      throw const ExpenseCategoryNotFoundError();
    }
  }

  @override
  Future<bool> isUsed(ExpenseCategoryId id) async {
    final db = ref.read(appDatabaseProvider);

    final operation = await (db.select(db.bankStatementOperations)
          ..where((table) => table.expenseCategoryId.equals(id))
          ..limit(1))
        .getSingleOrNull();
    if (operation != null) return true;

    final accountBinding = await (db.select(db.expenseCategoryAccountNumbers)
          ..where((table) => table.expenseCategoryId.equals(id))
          ..limit(1))
        .getSingleOrNull();

    return accountBinding != null;
  }
}
