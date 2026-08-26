import 'dart:async';

import 'package:easy_fin/models/expense_category.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/providers/financial_result_excluded_categories_provider.dart';
import 'package:easy_fin/view/widgets/multi_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinancialResultExcludedCategoriesField extends ConsumerWidget {
  const FinancialResultExcludedCategoriesField({
    this.expand = true,
    this.width = 250,
    super.key,
  });

  final bool expand;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync =
        ref.watch(financialResultExpenseCategoriesForExclusionProvider);
    final excludedAsync =
        ref.watch(financialResultExcludedExpenseCategoryIdsProvider);

    if (categoriesAsync.isLoading || excludedAsync.isLoading) {
      return const _Placeholder();
    }

    if (categoriesAsync.hasError || excludedAsync.hasError) {
      return const _Placeholder();
    }

    final categories = categoriesAsync.value ?? [];
    final excludedIds = excludedAsync.value ?? {};
    final selected = categories
        .where((category) => excludedIds.contains(category.id))
        .toSet();

    return MultiDropdownWidget<ExpenseCategory>(
      expand: expand,
      width: width,
      items: categories,
      selectedItems: selected,
      hint: 'Исключить категории',
      labelBuilder: (category) => category.name,
      onChanged: (selectedCategories) {
        unawaited(
          ref
              .read(
                financialResultExcludedExpenseCategoryIdsProvider.notifier,
              )
              .setExcluded(
                selectedCategories.map((category) => category.id).toSet(),
              ),
        );
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      height: filterFieldHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.border),
        ),
        child: Center(
          child: Text(
            'Исключить категории',
            style: filterFieldHintTextStyleOf(context),
          ),
        ),
      ),
    );
  }
}
