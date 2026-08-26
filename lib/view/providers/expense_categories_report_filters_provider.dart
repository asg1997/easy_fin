import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/view/models/report_period.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseCategoriesReportFilters extends Equatable {
  const ExpenseCategoriesReportFilters({
    required this.period,
    this.selectedBase,
  });

  final Base? selectedBase;
  final ReportPeriod period;

  ExpenseCategoriesReportFilters copyWith({
    Base? selectedBase,
    ReportPeriod? period,
    bool clearSelectedBase = false,
  }) {
    return ExpenseCategoriesReportFilters(
      selectedBase:
          clearSelectedBase ? null : (selectedBase ?? this.selectedBase),
      period: period ?? this.period,
    );
  }

  @override
  List<Object?> get props => [selectedBase, period];
}

final expenseCategoriesReportFiltersProvider =
    NotifierProvider<ExpenseCategoriesReportFiltersNotifier,
        ExpenseCategoriesReportFilters>(
  ExpenseCategoriesReportFiltersNotifier.new,
);

class ExpenseCategoriesReportFiltersNotifier
    extends Notifier<ExpenseCategoriesReportFilters> {
  @override
  ExpenseCategoriesReportFilters build() {
    return ExpenseCategoriesReportFilters(
      period: ReportPeriod.month(),
    );
  }

  void setSelectedBase(Base? base) {
    state = state.copyWith(selectedBase: base);
  }

  void setPeriod(ReportPeriod period) {
    state = state.copyWith(period: period);
  }
}
