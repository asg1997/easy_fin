import 'package:drift/drift.dart';

/// База (организация) с привязанными банковскими счетами
@DataClassName('BaseRow')
class Bases extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}
