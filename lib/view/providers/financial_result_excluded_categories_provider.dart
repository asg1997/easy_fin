import 'package:easy_fin/data/expense_categories_storage/expense_categories_storage.dart';
import 'package:easy_fin/data/financial_result_settings_storage/financial_result_settings_storage.dart';
import 'package:easy_fin/models/expense_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final financialResultExcludedExpenseCategoryIdsProvider =
    AsyncNotifierProvider<FinancialResultExcludedExpenseCategoryIdsNotifier,
        Set<ExpenseCategoryId>>(
  FinancialResultExcludedExpenseCategoryIdsNotifier.new,
);

class FinancialResultExcludedExpenseCategoryIdsNotifier
    extends AsyncNotifier<Set<ExpenseCategoryId>> {
  @override
  Future<Set<ExpenseCategoryId>> build() {
    return ref
        .read(financialResultSettingsStorageProvider)
        .getExcludedExpenseCategoryIds();
  }

  Future<void> setExcluded(Set<ExpenseCategoryId> ids) async {
    state = AsyncData(ids);
    await ref
        .read(financialResultSettingsStorageProvider)
        .setExcludedExpenseCategoryIds(ids);
  }
}

final financialResultExpenseCategoriesForExclusionProvider =
    FutureProvider<List<ExpenseCategory>>((ref) async {
  final categories = await ref
      .read(expenseCategoriesStorageProvider)
      .getAll();
  final excluded = await ref.watch(
    financialResultExcludedExpenseCategoryIdsProvider.future,
  );

  return categories
      .where(
        (category) => !category.isArchived || excluded.contains(category.id),
      )
      .toList();
});
