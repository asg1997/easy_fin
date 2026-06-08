import 'package:easy_fin/drift/bank_statement_database/db/bank_statement_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bankStatementDatabaseProvider = Provider<BankStatementDatabase>((ref) {
  final database = BankStatementDatabase();
  ref.onDispose(database.close);
  return database;
});
