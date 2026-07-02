import 'package:drift/drift.dart';
import 'package:easy_fin/drift/models/bases_table.dart';

/// Документ ручного прихода (заголовок)
@DataClassName('IncomeDocumentRow')
class IncomeDocuments extends Table {
  TextColumn get id => text()();

  TextColumn get baseId =>
      text().references(Bases, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get date => dateTime()();

  TextColumn get accountType => text()();

  TextColumn get accountRef => text()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
