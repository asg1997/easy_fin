import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/view/providers/account_balances_provider.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/expense_categories_report_filters_provider.dart';
import 'package:easy_fin/view/providers/expense_categories_report_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_provider.dart';
import 'package:easy_fin/view/widgets/account_balances_table.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/widgets/expense_categories_pie_chart.dart';
import 'package:easy_fin/view/widgets/expense_categories_table.dart';
import 'package:easy_fin/view/widgets/month_navigator_field.dart';
import 'package:easy_fin/view/widgets/renter_debts_table.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balancesAsync = ref.watch(accountBalancesProvider);
    final renterDebtsAsync = ref.watch(renterDebtsProvider);
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
            const Text(
              'Остатки по счетам',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(8),
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
            const Gap(32),
            const Text(
              'Задолженности арендаторов',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(8),
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
            const Gap(32),
            const Text(
              'Расходы по категориям',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(8),
            _FilterRow(
              children: [
                _FilterField(
                  child: basesAsync.when(
                    data: (bases) => DropdownWidget<Base>(
                      expand: true,
                      items: bases,
                      hint: 'Выбор базы',
                      selectedItem: expenseFilters.selectedBase,
                      labelBuilder: (item) => item.name,
                      onChanged: expenseFiltersNotifier.setSelectedBase,
                    ),
                    loading: () =>
                        const _FilterPlaceholder(label: 'Выбор базы'),
                    error: (_, _) =>
                        const _FilterPlaceholder(label: 'Выбор базы'),
                  ),
                ),
                const Gap(12),
                _FilterField(
                  child: MonthNavigatorField(
                    expand: true,
                    selectedMonth: expenseFilters.selectedMonth,
                    canGoForward: expenseFilters.canGoForward,
                    onPrevious: expenseFiltersNotifier.goToPreviousMonth,
                    onNext: expenseFiltersNotifier.goToNextMonth,
                  ),
                ),
              ],
            ),
            const Gap(12),
            expenseReportAsync.when(
              data: (items) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpenseCategoriesTable(items: items),
                    const Gap(32),
                    ExpenseCategoriesPieChart(items: items),
                  ],
                ),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Text('Не удалось загрузить расходы'),
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _FilterField extends StatelessWidget {
  const _FilterField({required this.child});

  static const _fieldWidth = 250.0;

  static const _constraints = BoxConstraints(
    minWidth: _fieldWidth,
    maxWidth: _fieldWidth,
    minHeight: filterFieldHeight,
    maxHeight: filterFieldHeight,
  );

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: _constraints,
      child: child,
    );
  }
}

class _FilterPlaceholder extends StatelessWidget {
  const _FilterPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Text(label, style: filterFieldHintTextStyle),
      ),
    );
  }
}
