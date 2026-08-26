import 'package:easy_fin/models/expense_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _excludedExpenseCategoryIdsKey =
    'financial_result_excluded_expense_category_ids';

final financialResultSettingsStorageProvider =
    Provider<FinancialResultSettingsStorage>(
  (ref) => const FinancialResultSettingsStorage(),
);

class FinancialResultSettingsStorage {
  const FinancialResultSettingsStorage();

  Future<Set<ExpenseCategoryId>> getExcludedExpenseCategoryIds() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_excludedExpenseCategoryIdsKey) ?? [];
    return {
      for (final value in raw) int.parse(value),
    };
  }

  Future<void> setExcludedExpenseCategoryIds(
    Set<ExpenseCategoryId> ids,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final sorted = ids.toList()..sort();
    await prefs.setStringList(
      _excludedExpenseCategoryIdsKey,
      sorted.map((id) => id.toString()).toList(),
    );
  }
}
