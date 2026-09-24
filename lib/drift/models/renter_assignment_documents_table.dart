import 'package:drift/drift.dart';
import 'package:easy_fin/drift/models/bases_table.dart';

/// Документ начисления по аренде (заголовок)
@DataClassName('RenterAssignmentDocumentRow')
class RenterAssignmentDocuments extends Table {
  TextColumn get id => text()();

  TextColumn get baseId =>
      text().references(Bases, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get date => dateTime()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
