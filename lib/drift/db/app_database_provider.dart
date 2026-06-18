import 'package:easy_fin/drift/db/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  ref.keepAlive();
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
