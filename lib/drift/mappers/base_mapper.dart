import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/models/base.dart' as domain;

extension BaseMapper on domain.Base {
  BasesCompanion toCompanion() {
    return BasesCompanion(
      id: Value(id),
      name: Value(name),
    );
  }
}

extension BaseRowMapper on BaseRow {
  domain.Base toDomain({required List<String> accountNumbers}) {
    return domain.Base(
      id: id,
      name: name,
      accountNumbers: accountNumbers,
    );
  }
}
