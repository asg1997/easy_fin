import 'package:easy_fin/data/renter_debts_storage/renter_debts_storage.dart';
import 'package:easy_fin/view/models/renter_debt_by_base_report_item.dart';
import 'package:easy_fin/view/providers/renter_debts_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_report_filters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final renterDebtsByBaseProvider =
    FutureProvider<List<RenterDebtByBaseReportItem>>((ref) async {
  ref.watch(renterDebtsProvider);
  final filters = ref.watch(renterDebtsReportFiltersProvider);
  return ref.read(renterDebtsStorageProvider).getReportByBase(
        baseId: filters.selectedBaseFilter.baseId,
      );
});
