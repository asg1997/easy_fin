import 'package:drift/drift.dart';
import 'package:easy_fin/drift/models/income_categories_table.dart';
import 'package:easy_fin/drift/models/income_documents_table.dart';
import 'package:easy_fin/drift/models/renters_table.dart';

/// Строка документа прихода
@DataClassName('IncomeLineRow')
class IncomeLines extends Table {
  TextColumn get id => text()();

  TextColumn get documentId =>
      text().references(IncomeDocuments, #id, onDelete: KeyAction.cascade)();

  IntColumn get amountMinor => integer()();

  TextColumn get sourceType => text()();

  TextColumn get renterId =>
      text().nullable().references(Renters, #id, onDelete: KeyAction.restrict)();

  TextColumn get accountNumber => text().nullable()();

  IntColumn get categoryId => integer().nullable().references(
    IncomeCategories,
    #id,
    onDelete: KeyAction.restrict,
  )();

  TextColumn get note => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
