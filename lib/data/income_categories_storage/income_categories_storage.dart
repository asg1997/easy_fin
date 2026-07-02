import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/drift/mappers/income_category_mapper.dart';
import 'package:easy_fin/models/income_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final incomeCategoriesStorageProvider = Provider<IncomeCategoriesStorage>(
  IncomeCategoriesStorageImpl.new,
);

sealed class IncomeCategoriesStorageError implements Exception {
  const IncomeCategoriesStorageError();
}

class IncomeCategoryInUseError extends IncomeCategoriesStorageError {
  const IncomeCategoryInUseError();
}

class IncomeCategoryNotFoundError extends IncomeCategoriesStorageError {
  const IncomeCategoryNotFoundError();
}

abstract class IncomeCategoriesStorage {
  Future<List<IncomeCategory>> getAll({bool includeArchived = true});

  Future<List<IncomeCategory>> getActive();

  Future<IncomeCategory> save(String name);

  Future<void> rename(IncomeCategoryId id, String name);

  Future<void> archive(IncomeCategoryId id);

  Future<void> unarchive(IncomeCategoryId id);

  Future<void> delete(IncomeCategoryId id);

  Future<bool> isUsed(IncomeCategoryId id);
}

class IncomeCategoriesStorageImpl implements IncomeCategoriesStorage {
  const IncomeCategoriesStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<List<IncomeCategory>> getAll({bool includeArchived = true}) async {
    final db = ref.read(appDatabaseProvider);
    final query = db.select(db.incomeCategories)
      ..orderBy([(table) => OrderingTerm.asc(table.sortOrder)]);

    if (!includeArchived) {
      query.where((table) => table.isArchived.equals(false));
    }

    final rows = await query.get();
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<List<IncomeCategory>> getActive() {
    return getAll(includeArchived: false);
  }

  @override
  Future<IncomeCategory> save(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Название категории не может быть пустым');
    }

    final db = ref.read(appDatabaseProvider);
    final maxSort = await db
        .customSelect('SELECT MAX(sort_order) AS max_sort FROM income_categories')
        .getSingle();
    final nextSort = ((maxSort.data['max_sort'] as int?) ?? -1) + 1;

    final id = await db.into(db.incomeCategories).insert(
      IncomeCategoriesCompanion.insert(
        name: trimmed,
        sortOrder: Value(nextSort),
        createdAt: DateTime.now(),
      ),
    );

    final row = await (db.select(db.incomeCategories)
          ..where((table) => table.id.equals(id)))
        .getSingle();

    return row.toDomain();
  }

  @override
  Future<void> rename(IncomeCategoryId id, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Название категории не может быть пустым');
    }

    final db = ref.read(appDatabaseProvider);
    final updated = await (db.update(db.incomeCategories)
          ..where((table) => table.id.equals(id)))
        .write(IncomeCategoriesCompanion(name: Value(trimmed)));

    if (updated == 0) {
      throw const IncomeCategoryNotFoundError();
    }
  }

  @override
  Future<void> archive(IncomeCategoryId id) async {
    await _setArchived(id, isArchived: true);
  }

  @override
  Future<void> unarchive(IncomeCategoryId id) async {
    await _setArchived(id, isArchived: false);
  }

  Future<void> _setArchived(
    IncomeCategoryId id, {
    required bool isArchived,
  }) async {
    final db = ref.read(appDatabaseProvider);
    final updated = await (db.update(db.incomeCategories)
          ..where((table) => table.id.equals(id)))
        .write(IncomeCategoriesCompanion(isArchived: Value(isArchived)));

    if (updated == 0) {
      throw const IncomeCategoryNotFoundError();
    }
  }

  @override
  Future<void> delete(IncomeCategoryId id) async {
    if (await isUsed(id)) {
      throw const IncomeCategoryInUseError();
    }

    final db = ref.read(appDatabaseProvider);
    final deleted = await (db.delete(db.incomeCategories)
          ..where((table) => table.id.equals(id)))
        .go();

    if (deleted == 0) {
      throw const IncomeCategoryNotFoundError();
    }
  }

  @override
  Future<bool> isUsed(IncomeCategoryId id) async {
    final db = ref.read(appDatabaseProvider);
    final row = await (db.select(db.incomeLines)
          ..where((table) => table.categoryId.equals(id))
          ..limit(1))
        .getSingleOrNull();

    return row != null;
  }
}
