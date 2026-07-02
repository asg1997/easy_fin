import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/models/income_category.dart' as domain;

extension IncomeCategoryMapper on domain.IncomeCategory {
  IncomeCategoriesCompanion toCompanion() {
    return IncomeCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      isArchived: Value(isArchived),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }
}

extension IncomeCategoryRowMapper on IncomeCategoryRow {
  domain.IncomeCategory toDomain() {
    return domain.IncomeCategory(
      id: id,
      name: name,
      isArchived: isArchived,
      sortOrder: sortOrder,
      createdAt: createdAt,
    );
  }
}
