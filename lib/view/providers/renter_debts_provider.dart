import 'package:easy_fin/data/renter_debts_storage/renter_debts_storage.dart';
import 'package:easy_fin/view/models/renter_debt_report_item.dart';
import 'package:easy_fin/view/providers/renter_debts_summary_filters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final renterDebtsProvider =
    FutureProvider<List<RenterDebtReportItem>>((ref) async {
  final filter = ref.watch(renterDebtsSummaryFiltersProvider);
  return ref.read(renterDebtsStorageProvider).getReport(
        baseId: filter.baseId,
      );
});
