import 'package:easy_fin/data/renter_debts_storage/renter_debts_storage.dart';
import 'package:easy_fin/view/models/renter_debt_report_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final renterDebtsProvider =
    FutureProvider<List<RenterDebtReportItem>>((ref) async {
  return ref.read(renterDebtsStorageProvider).getReport();
});
