import 'package:easy_fin/models/base.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseCategoriesReportFilters extends Equatable {
  const ExpenseCategoriesReportFilters({
    required this.selectedMonth,
    this.selectedBase,
  });

  final Base? selectedBase;
  final DateTime selectedMonth;

  DateTime get monthStart => DateTime(selectedMonth.year, selectedMonth.month);

  DateTime get monthEnd =>
      DateTime(selectedMonth.year, selectedMonth.month + 1, 0);

  bool get canGoForward {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    return selectedMonth.isBefore(currentMonth);
  }

  ExpenseCategoriesReportFilters copyWith({
    Base? selectedBase,
    DateTime? selectedMonth,
    bool clearSelectedBase = false,
  }) {
    return ExpenseCategoriesReportFilters(
      selectedBase: clearSelectedBase ? null : (selectedBase ?? this.selectedBase),
      selectedMonth: selectedMonth ?? this.selectedMonth,
    );
  }

  @override
  List<Object?> get props => [selectedBase, selectedMonth];
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
    final now = DateTime.now();
    return ExpenseCategoriesReportFilters(
      selectedMonth: DateTime(now.year, now.month),
    );
  }

  void setSelectedBase(Base? base) {
    state = state.copyWith(selectedBase: base);
  }

  void setSelectedMonth(DateTime month) {
    state = state.copyWith(
      selectedMonth: DateTime(month.year, month.month),
    );
  }

  void goToPreviousMonth() {
    final month = state.selectedMonth;
    final previousMonth = month.month == 1
        ? DateTime(month.year - 1, 12)
        : DateTime(month.year, month.month - 1);
    setSelectedMonth(previousMonth);
  }

  void goToNextMonth() {
    if (!state.canGoForward) return;

    final month = state.selectedMonth;
    final nextMonth = month.month == 12
        ? DateTime(month.year + 1)
        : DateTime(month.year, month.month + 1);
    setSelectedMonth(nextMonth);
  }
}
