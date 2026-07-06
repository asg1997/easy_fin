import 'package:easy_fin/data/renter_debts_storage/renter_debts_storage.dart';
import 'package:easy_fin/view/models/renter_debt_monthly_report_item.dart';
import 'package:easy_fin/view/providers/renter_debts_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_report_filters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final renterDebtsMonthlyProvider =
    FutureProvider<List<RenterDebtMonthlyReportItem>>((ref) async {
  ref.watch(renterDebtsProvider);
  final filters = ref.watch(renterDebtsReportFiltersProvider);
  return ref.read(renterDebtsStorageProvider).getMonthlyReport(
        year: filters.selectedYear,
        baseId: filters.selectedBaseFilter.baseId,
      );
});
