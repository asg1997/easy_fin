import 'package:drift/drift.dart';
import 'package:easy_fin/drift/models/renter_assignment_documents_table.dart';
import 'package:easy_fin/drift/models/renters_table.dart';

/// Строка документа начисления по аренде
@DataClassName('RenterAssignmentRow')
class RenterAssignments extends Table {
  TextColumn get id => text()();

  TextColumn get documentId => text().references(
    RenterAssignmentDocuments,
    #id,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get renterId =>
      text().references(Renters, #id, onDelete: KeyAction.cascade)();

  TextColumn get accountNumber => text()();

  IntColumn get amountMinor => integer()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
