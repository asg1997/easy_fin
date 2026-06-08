import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:easy_fin/drift/bases_database/models/base_account_numbers_table.dart';
import 'package:easy_fin/drift/bases_database/models/bases_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'bases_database.g.dart';

@DriftDatabase(tables: [Bases, BaseAccountNumbers])
class BasesDatabase extends _$BasesDatabase {
  BasesDatabase([QueryExecutor? executor])
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
