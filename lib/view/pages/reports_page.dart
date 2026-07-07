import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/providers/account_balances_provider.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/expense_categories_report_filters_provider.dart';
import 'package:easy_fin/view/providers/expense_categories_report_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_summary_filters_provider.dart';
import 'package:easy_fin/view/widgets/account_balances_table.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/pages/expense_categories_report_page.dart';
import 'package:easy_fin/view/pages/renter_debts_report_page.dart';
import 'package:easy_fin/view/widgets/expense_categories_table.dart';
import 'package:easy_fin/view/widgets/month_navigator_field.dart';
import 'package:easy_fin/view/widgets/renter_debts_base_filter_dropdown.dart';
import 'package:easy_fin/view/widgets/renter_debts_table.dart';
import 'package:easy_fin/view/widgets/report_table_theme.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

const _expenseFiltersGap = 12.0;

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balancesAsync = ref.watch(accountBalancesProvider);
    final renterDebtsAsync = ref.watch(renterDebtsProvider);
    final renterDebtsFilter = ref.watch(renterDebtsSummaryFiltersProvider);
    final renterDebtsFilterNotifier =
        ref.read(renterDebtsSummaryFiltersProvider.notifier);
    final basesAsync = ref.watch(basesListProvider);
    final expenseFilters = ref.watch(expenseCategoriesReportFiltersProvider);
    final expenseReportAsync = ref.watch(expenseCategoriesReportProvider);
    final expenseFiltersNotifier =
        ref.read(expenseCategoriesReportFiltersProvider.notifier);

    void ensureBaseSelected(List<Base> bases) {
      if (bases.isEmpty) return;
      if (ref.read(expenseCategoriesReportFiltersProvider).selectedBase != null) {
        return;
      }
      expenseFiltersNotifier.setSelectedBase(bases.first);
    }

    ref.listen(basesListProvider, (previous, next) {
      next.whenData(ensureBaseSelected);
    });

    basesAsync.whenData((bases) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ensureBaseSelected(bases);
      });
    });

    return TemplatePage(
      title: 'Отчеты',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: ReportTableTheme.standardWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ReportTableTitle('Остатки по счетам'),
                  const Gap(12),
                  balancesAsync.when(
                    data: (items) => AccountBalancesTable(items: items),
                    loading: () => const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, _) => const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text('Не удалось загрузить остатки'),
                    ),
                  ),
                ],
              ),
            ),
            const ReportTableSectionDivider(),
            SizedBox(
              width: ReportTableTheme.standardWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: ReportTableTitle('Долги по арендаторам'),
                      ),
                      TextButton(
                        onPressed: () =>
                            RenterDebtsReportPage.navigate(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: AppColors.purple,
                        ),
                        child: const Text(
                          'Показать все',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  _ReportFilterField(
                    child: basesAsync.when(
                      data: (bases) => RenterDebtsBaseFilterDropdown(
                        bases: bases,
                        selectedFilter: renterDebtsFilter,
                        onChanged:
                            renterDebtsFilterNotifier.setSelectedBaseFilter,
                      ),
                      loading: () => const _FilterPlaceholder(
                        label: 'Выбор базы',
                      ),
                      error: (_, _) => const _FilterPlaceholder(
                        label: 'Выбор базы',
                      ),
                    ),
                  ),
                  const Gap(12),
                  renterDebtsAsync.when(
                    data: (items) => RenterDebtsTable(items: items),
                    loading: () => const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, _) => const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text('Не удалось загрузить задолженности'),
                    ),
                  ),
                ],
              ),
            ),
            const ReportTableSectionDivider(),
            SizedBox(
              width: ReportTableTheme.standardWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: ReportTableTitle('Расходы по категориям'),
                      ),
                      TextButton(
                        onPressed: () =>
                            ExpenseCategoriesReportPage.navigate(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: AppColors.purple,
                        ),
                        child: const Text(
                          'Показать все',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Row(
                    children: [
                      Expanded(
                        child: _ReportFilterField(
                          child: basesAsync.when(
                            data: (bases) => DropdownWidget<Base>(
                              expand: true,
                              items: bases,
                              hint: 'Выбор базы',
                              selectedItem: expenseFilters.selectedBase,
                              labelBuilder: (item) => item.name,
                              onChanged:
                                  expenseFiltersNotifier.setSelectedBase,
                            ),
                            loading: () => const _FilterPlaceholder(
                              label: 'Выбор базы',
                            ),
                            error: (_, _) => const _FilterPlaceholder(
                              label: 'Выбор базы',
                            ),
                          ),
                        ),
                      ),
                      const Gap(_expenseFiltersGap),
                      Expanded(
                        child: _ReportFilterField(
                          child: MonthNavigatorField(
                            expand: true,
                            selectedMonth: expenseFilters.selectedMonth,
                            canGoForward: expenseFilters.canGoForward,
                            onPrevious:
                                expenseFiltersNotifier.goToPreviousMonth,
                            onNext: expenseFiltersNotifier.goToNextMonth,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  expenseReportAsync.when(
                    data: (items) => ExpenseCategoriesTable(items: items),
                    loading: () => const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, _) => const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text('Не удалось загрузить расходы'),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

class _ReportFilterField extends StatelessWidget {
  const _ReportFilterField({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: filterFieldHeight,
      child: child,
    );
  }
}

class _FilterPlaceholder extends StatelessWidget {
  const _FilterPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border),
      ),
      child: Center(
        child: Text(label, style: filterFieldHintTextStyleOf(context)),
      ),
    );
  }
}
