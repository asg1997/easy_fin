import 'package:easy_fin/drift/bases_database/db/bases_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final basesDatabaseProvider = Provider<BasesDatabase>((ref) {
  final database = BasesDatabase();
  ref.onDispose(database.close);
  return database;
});
