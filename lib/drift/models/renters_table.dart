import 'package:drift/drift.dart';

/// Арендатор
@DataClassName('RenterRow')
class Renters extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}
