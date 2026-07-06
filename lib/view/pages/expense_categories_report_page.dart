import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/expense_categories_charts_provider.dart';
import 'package:easy_fin/view/providers/expense_categories_report_filters_provider.dart';
import 'package:easy_fin/view/providers/expense_categories_report_provider.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/widgets/expense_categories_pie_chart.dart';
import 'package:easy_fin/view/widgets/expense_categories_report_charts.dart';
import 'package:easy_fin/view/widgets/expense_categories_table.dart';
import 'package:easy_fin/view/widgets/expense_chart_common.dart';
import 'package:easy_fin/view/widgets/month_navigator_field.dart';
import 'package:easy_fin/view/widgets/report_table_theme.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

const _filtersGap = 12.0;
const _sectionGap = 32.0;

class ExpenseCategoriesReportPage extends ConsumerWidget {
  const ExpenseCategoriesReportPage({super.key});

  static Future<void> navigate(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const ExpenseCategoriesReportPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(expenseCategoriesReportFiltersProvider);
    final filtersNotifier =
        ref.read(expenseCategoriesReportFiltersProvider.notifier);
    final basesAsync = ref.watch(basesListProvider);
    final reportAsync = ref.watch(expenseCategoriesReportProvider);
    final monthlyAsync = ref.watch(expenseCategoriesMonthlyProvider);
    final comparisonAsync = ref.watch(expenseCategoriesComparisonProvider);
    final basesReportAsync = ref.watch(expenseBasesReportProvider);

    void ensureBaseSelected(List<Base> bases) {
      if (bases.isEmpty) return;
      if (ref.read(expenseCategoriesReportFiltersProvider).selectedBase != null) {
        return;
      }
      filtersNotifier.setSelectedBase(bases.first);
    }

    ref.listen(basesListProvider, (previous, next) {
      next.whenData(ensureBaseSelected);
    });

    basesAsync.whenData((bases) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ensureBaseSelected(bases);
      });
    });

    final monthLabel = _formatMonth(filters.selectedMonth);
    final previousMonth = filters.selectedMonth.month == 1
        ? DateTime(filters.selectedMonth.year - 1, 12)
        : DateTime(
            filters.selectedMonth.year,
            filters.selectedMonth.month - 1,
          );
    final previousMonthLabel = _formatMonth(previousMonth);

    return Scaffold(
      body: TemplatePage(
        title: 'Расходы по категориям',
        hasBackButton: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FilterRow(
                children: [
                  _FilterField(
                    child: basesAsync.when(
                      data: (bases) => DropdownWidget<Base>(
                        expand: true,
                        items: bases,
                        hint: 'Выбор базы',
                        selectedItem: filters.selectedBase,
                        labelBuilder: (item) => item.name,
                        onChanged: filtersNotifier.setSelectedBase,
                      ),
                      loading: () =>
                          const _FilterPlaceholder(label: 'Выбор базы'),
                      error: (_, _) =>
                          const _FilterPlaceholder(label: 'Выбор базы'),
                    ),
                  ),
                  const Gap(_filtersGap),
                  _FilterField(
                    child: MonthNavigatorField(
                      expand: true,
                      selectedMonth: filters.selectedMonth,
                      canGoForward: filters.canGoForward,
                      onPrevious: filtersNotifier.goToPreviousMonth,
                      onNext: filtersNotifier.goToNextMonth,
                    ),
                  ),
                ],
              ),
              const Gap(24),
              reportAsync.when(
                data: (items) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: ReportTableTheme.standardWidth,
                      child: ExpenseCategoriesTable(items: items),
                    ),
                    const Gap(_sectionGap),
                    ExpenseChartSection(
                      title: 'Структура расходов',
                      subtitle: monthLabel,
                      child: ExpenseCategoriesPieChart(items: items),
                    ),
                    const Gap(_sectionGap),
                    ExpenseChartSection(
                      title: 'Расходы по категориям',
                      subtitle: monthLabel,
                      child: ExpenseCategoriesVerticalBarChart(items: items),
                    ),
                    const Gap(_sectionGap),
                    ExpenseChartSection(
                      title: 'Топ-5 категорий',
                      subtitle: monthLabel,
                      child: ExpenseCategoriesTop5Chart(items: items),
                    ),
                    const Gap(_sectionGap),
                    ExpenseChartSection(
                      title: 'Диаграмма Парето',
                      subtitle: monthLabel,
                      child: ExpenseCategoriesParetoChart(items: items),
                    ),
                  ],
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
              const Gap(_sectionGap),
              monthlyAsync.when(
                data: (items) => ExpenseChartSection(
                  title: 'Динамика расходов по месяцам',
                  subtitle: '${filters.selectedMonth.year} год',
                  child: ExpenseCategoriesMonthlyChart(items: items),
                ),
                loading: () => const _ChartLoading(),
                error: (_, _) => const _ChartError(),
              ),
              const Gap(_sectionGap),
              comparisonAsync.when(
                data: (items) => ExpenseChartSection(
                  title: 'Сравнение с прошлым месяцем',
                  child: ExpenseCategoriesComparisonChart(
                    items: items,
                    currentMonthLabel: monthLabel,
                    previousMonthLabel: previousMonthLabel,
                  ),
                ),
                loading: () => const _ChartLoading(),
                error: (_, _) => const _ChartError(),
              ),
              const Gap(_sectionGap),
              basesReportAsync.when(
                data: (items) => ExpenseChartSection(
                  title: 'Структура расходов по базам',
                  subtitle: monthLabel,
                  child: ExpenseBasesStructureChart(items: items),
                ),
                loading: () => const _ChartLoading(),
                error: (_, _) => const _ChartError(),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatMonth(DateTime month) {
    final formatted = DateFormat('LLLL yyyy', 'ru').format(month);
    if (formatted.isEmpty) return formatted;
    return '${formatted[0].toUpperCase()}${formatted.substring(1)}';
  }
}

class _ChartLoading extends StatelessWidget {
  const _ChartLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ChartError extends StatelessWidget {
  const _ChartError();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Text('Не удалось загрузить данные для диаграммы'),
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
