import 'package:easy_fin/models/base.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

sealed class RenterDebtsBaseFilter extends Equatable {
  const RenterDebtsBaseFilter();

  BaseId? get baseId;
  String get label;
}

class AllBasesRenterDebtsFilter extends RenterDebtsBaseFilter {
  const AllBasesRenterDebtsFilter();

  @override
  BaseId? get baseId => null;

  @override
  String get label => 'Все базы';

  @override
  List<Object?> get props => [];
}

class SingleBaseRenterDebtsFilter extends RenterDebtsBaseFilter {
  const SingleBaseRenterDebtsFilter(this.base);

  final Base base;

  @override
  BaseId? get baseId => base.id;

  @override
  String get label => base.name;

  @override
  List<Object?> get props => [base];
}

class RenterDebtsReportFilters extends Equatable {
  const RenterDebtsReportFilters({
    required this.selectedBaseFilter,
    required this.selectedYear,
  });

  final RenterDebtsBaseFilter selectedBaseFilter;
  final int selectedYear;

  RenterDebtsReportFilters copyWith({
    RenterDebtsBaseFilter? selectedBaseFilter,
    int? selectedYear,
  }) {
    return RenterDebtsReportFilters(
      selectedBaseFilter: selectedBaseFilter ?? this.selectedBaseFilter,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }

  @override
  List<Object?> get props => [selectedBaseFilter, selectedYear];
}

final renterDebtsReportFiltersProvider =
    NotifierProvider<RenterDebtsReportFiltersNotifier, RenterDebtsReportFilters>(
  RenterDebtsReportFiltersNotifier.new,
);

class RenterDebtsReportFiltersNotifier
    extends Notifier<RenterDebtsReportFilters> {
  static const _yearsBack = 10;

  @override
  RenterDebtsReportFilters build() {
    return RenterDebtsReportFilters(
      selectedBaseFilter: const AllBasesRenterDebtsFilter(),
      selectedYear: DateTime.now().year,
    );
  }

  List<int> get availableYears {
    final currentYear = DateTime.now().year;
    return List.generate(
      _yearsBack + 1,
      (index) => currentYear - index,
    );
  }

  void setSelectedBaseFilter(RenterDebtsBaseFilter filter) {
    state = state.copyWith(selectedBaseFilter: filter);
  }

  void setSelectedYear(int year) {
    state = state.copyWith(selectedYear: year);
  }
}
