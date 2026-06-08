import 'package:drift/drift.dart';

/// Выписка по банковскому счету
class BankStatements extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get startDate => dateTime()();

  DateTimeColumn get endDate => dateTime()();

  TextColumn get accountNumber => text()();

  RealColumn get initialBalance => real()();

  RealColumn get finalBalance => real()();
}
