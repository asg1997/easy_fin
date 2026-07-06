import 'package:easy_fin/view/providers/renter_debts_report_filters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final renterDebtsSummaryFiltersProvider =
    NotifierProvider<RenterDebtsSummaryFiltersNotifier, RenterDebtsBaseFilter>(
  RenterDebtsSummaryFiltersNotifier.new,
);

class RenterDebtsSummaryFiltersNotifier extends Notifier<RenterDebtsBaseFilter> {
  @override
  RenterDebtsBaseFilter build() => const AllBasesRenterDebtsFilter();

  void setSelectedBaseFilter(RenterDebtsBaseFilter filter) {
    state = filter;
  }
}
