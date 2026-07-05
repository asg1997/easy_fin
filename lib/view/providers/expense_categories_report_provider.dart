import 'package:easy_fin/data/expense_categories_report_storage/expense_categories_report_storage.dart';
import 'package:easy_fin/view/models/expense_category_report_item.dart';
import 'package:easy_fin/view/providers/expense_categories_report_filters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseCategoriesReportProvider =
    FutureProvider<List<ExpenseCategoryReportItem>>((ref) async {
  final filters = ref.watch(expenseCategoriesReportFiltersProvider);
  final base = filters.selectedBase;
  if (base == null) return [];

  return ref.read(expenseCategoriesReportStorageProvider).getReport(
        baseId: base.id,
        month: filters.selectedMonth,
      );
});
