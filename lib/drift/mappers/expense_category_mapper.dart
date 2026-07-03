import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/models/expense_category.dart' as domain;

extension ExpenseCategoryMapper on domain.ExpenseCategory {
  ExpenseCategoriesCompanion toCompanion() {
    return ExpenseCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      isArchived: Value(isArchived),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }
}

extension ExpenseCategoryRowMapper on ExpenseCategoryRow {
  domain.ExpenseCategory toDomain() {
    return domain.ExpenseCategory(
      id: id,
      name: name,
      isArchived: isArchived,
      sortOrder: sortOrder,
      createdAt: createdAt,
    );
  }
}
