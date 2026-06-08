import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:easy_fin/drift/bank_statement_database/models/bank_statement_operations_table.dart';
import 'package:easy_fin/drift/bank_statement_database/models/bank_statements_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'bank_statement_database.g.dart';

@DriftDatabase(tables: [BankStatements, BankStatementOperations])
class BankStatementDatabase extends _$BankStatementDatabase {
  BankStatementDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'easy_fin.sqlite'));

    return NativeDatabase(file);
  });
}
