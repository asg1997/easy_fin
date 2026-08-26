import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/view/models/report_period.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

sealed class FinancialResultBaseFilter extends Equatable {
  const FinancialResultBaseFilter();

  BaseId? get baseId;
  String get label;
}

class AllBasesFinancialResultFilter extends FinancialResultBaseFilter {
  const AllBasesFinancialResultFilter();

  @override
  BaseId? get baseId => null;

  @override
  String get label => 'Все базы';

  @override
  List<Object?> get props => [];
}

class SingleBaseFinancialResultFilter extends FinancialResultBaseFilter {
  const SingleBaseFinancialResultFilter(this.base);

  final Base base;

  @override
  BaseId? get baseId => base.id;

  @override
  String get label => base.name;

  @override
  List<Object?> get props => [base];
}

class FinancialResultReportFilters extends Equatable {
  const FinancialResultReportFilters({
    required this.selectedBaseFilter,
    required this.period,
  });

  final FinancialResultBaseFilter selectedBaseFilter;
  final ReportPeriod period;

  FinancialResultReportFilters copyWith({
    FinancialResultBaseFilter? selectedBaseFilter,
    ReportPeriod? period,
  }) {
    return FinancialResultReportFilters(
      selectedBaseFilter: selectedBaseFilter ?? this.selectedBaseFilter,
      period: period ?? this.period,
    );
  }

  @override
  List<Object?> get props => [selectedBaseFilter, period];
}

final financialResultReportFiltersProvider = NotifierProvider<
    FinancialResultReportFiltersNotifier, FinancialResultReportFilters>(
  FinancialResultReportFiltersNotifier.new,
);

class FinancialResultReportFiltersNotifier
    extends Notifier<FinancialResultReportFilters> {
  @override
  FinancialResultReportFilters build() {
    return FinancialResultReportFilters(
      selectedBaseFilter: const AllBasesFinancialResultFilter(),
      period: ReportPeriod.month(),
    );
  }

  void setSelectedBaseFilter(FinancialResultBaseFilter filter) {
    state = state.copyWith(selectedBaseFilter: filter);
  }

  void setPeriod(ReportPeriod period) {
    state = state.copyWith(period: period);
  }
}
