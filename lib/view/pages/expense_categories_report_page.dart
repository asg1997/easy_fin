import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/models/report_period.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/expense_categories_charts_provider.dart';
import 'package:easy_fin/view/providers/expense_categories_report_filters_provider.dart';
import 'package:easy_fin/view/providers/expense_categories_report_provider.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/widgets/expense_categories_pie_chart.dart';
import 'package:easy_fin/view/widgets/expense_categories_report_charts.dart';
import 'package:easy_fin/view/widgets/expense_categories_table.dart';
import 'package:easy_fin/view/widgets/expense_chart_common.dart';
import 'package:easy_fin/view/widgets/report_period_selector.dart';
import 'package:easy_fin/view/widgets/report_table_theme.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

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
    final period = filters.period;
    final monthPeriod = period is MonthReportPeriod ? period : null;

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

    final periodLabel = period.label;
    final previousMonthLabel = monthPeriod?.previousMonth().label;

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
                  ReportPeriodSelector(
                    period: period,
                    onChanged: filtersNotifier.setPeriod,
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
                      subtitle: periodLabel,
                      child: ExpenseCategoriesPieChart(items: items),
                    ),
                    const Gap(_sectionGap),
                    ExpenseChartSection(
                      title: 'Расходы по категориям',
                      subtitle: periodLabel,
                      child: ExpenseCategoriesVerticalBarChart(items: items),
                    ),
                    const Gap(_sectionGap),
                    ExpenseChartSection(
                      title: 'Топ-5 категорий',
                      subtitle: periodLabel,
                      child: ExpenseCategoriesTop5Chart(items: items),
                    ),
                    const Gap(_sectionGap),
                    ExpenseChartSection(
                      title: 'Диаграмма Парето',
                      subtitle: periodLabel,
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
              if (monthPeriod != null) ...[
                const Gap(_sectionGap),
                monthlyAsync.when(
                  data: (items) => ExpenseChartSection(
                    title: 'Динамика расходов по месяцам',
                    subtitle: '${monthPeriod.month.year} год',
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
                      currentMonthLabel: periodLabel,
                      previousMonthLabel: previousMonthLabel!,
                    ),
                  ),
                  loading: () => const _ChartLoading(),
                  error: (_, _) => const _ChartError(),
                ),
              ],
              const Gap(_sectionGap),
              basesReportAsync.when(
                data: (items) => ExpenseChartSection(
                  title: 'Структура расходов по базам',
                  subtitle: periodLabel,
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
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.appColors.border),
      ),
      child: Center(
        child: Text(label, style: filterFieldHintTextStyleOf(context)),
      ),
    );
  }
}
