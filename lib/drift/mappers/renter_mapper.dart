import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/models/renter.dart' as domain;

extension RenterMapper on domain.Renter {
  RentersCompanion toCompanion() {
    return RentersCompanion(
      id: Value(id),
      name: Value(name),
    );
  }
}

extension RenterRowMapper on RenterRow {
  domain.Renter toDomain({required List<String> accountNumbers}) {
    return domain.Renter(
      id: id,
      name: name,
      accountNumbers: accountNumbers,
    );
  }
}
