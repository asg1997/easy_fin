import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/models/base.dart' as domain;
import 'package:easy_fin/models/base_account.dart';

extension BaseMapper on domain.Base {
  BasesCompanion toCompanion() {
    return BasesCompanion(
      id: Value(id),
      name: Value(name),
    );
  }
}

extension BaseRowMapper on BaseRow {
  domain.Base toDomain({required List<BaseAccount> accounts}) {
    return domain.Base(
      id: id,
      name: name,
      accounts: accounts,
    );
  }
}

extension BaseAccountNumberMapper on BaseAccountNumber {
  BaseAccount toAccountDomain() {
    return BaseAccount(
      accountNumber: accountNumber,
      bankName: bankName,
    );
  }
}
