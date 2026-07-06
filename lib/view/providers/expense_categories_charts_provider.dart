import 'package:easy_fin/data/expense_categories_report_storage/expense_categories_report_storage.dart';
import 'package:easy_fin/view/models/expense_base_report_item.dart';
import 'package:easy_fin/view/models/expense_category_comparison_item.dart';
import 'package:easy_fin/view/models/expense_monthly_report_item.dart';
import 'package:easy_fin/view/providers/expense_categories_report_filters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseCategoriesMonthlyProvider =
    FutureProvider<List<ExpenseMonthlyReportItem>>((ref) async {
  final filters = ref.watch(expenseCategoriesReportFiltersProvider);
  final base = filters.selectedBase;
  if (base == null) return [];

  return ref.read(expenseCategoriesReportStorageProvider).getMonthlyReport(
        baseId: base.id,
        year: filters.selectedMonth.year,
      );
});

final expenseCategoriesComparisonProvider =
    FutureProvider<List<ExpenseCategoryComparisonItem>>((ref) async {
  final filters = ref.watch(expenseCategoriesReportFiltersProvider);
  final base = filters.selectedBase;
  if (base == null) return [];

  return ref.read(expenseCategoriesReportStorageProvider).getComparisonReport(
        baseId: base.id,
        month: filters.selectedMonth,
      );
});

final expenseBasesReportProvider =
    FutureProvider<List<ExpenseBaseReportItem>>((ref) async {
  final filters = ref.watch(expenseCategoriesReportFiltersProvider);

  return ref.read(expenseCategoriesReportStorageProvider).getBasesReport(
        month: filters.selectedMonth,
      );
});
