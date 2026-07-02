import 'package:drift/drift.dart';

/// Категория прочего прихода
@DataClassName('IncomeCategoryRow')
class IncomeCategories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  BoolColumn get isArchived =>
      boolean().withDefault(const Constant(false))();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime()();
}
