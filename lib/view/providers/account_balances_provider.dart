import 'package:easy_fin/data/account_balances_storage/account_balances_storage.dart';
import 'package:easy_fin/view/models/account_balance_report_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountBalancesProvider =
    FutureProvider<List<AccountBalanceReportItem>>((ref) async {
  return ref.read(accountBalancesStorageProvider).getReport();
});
