import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/models/report_period.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/financial_result_report_filters_provider.dart';
import 'package:easy_fin/view/providers/financial_result_report_provider.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/widgets/expense_chart_common.dart';
import 'package:easy_fin/view/widgets/financial_result_excluded_categories_field.dart';
import 'package:easy_fin/view/widgets/financial_result_report_charts.dart';
import 'package:easy_fin/view/widgets/financial_result_table.dart';
import 'package:easy_fin/view/widgets/report_period_selector.dart';
import 'package:easy_fin/view/widgets/report_table_theme.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

const _filtersGap = 12.0;
const _sectionGap = 32.0;

class FinancialResultReportPage extends ConsumerWidget {
  const FinancialResultReportPage({super.key});

  static Future<void> navigate(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const FinancialResultReportPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(financialResultReportFiltersProvider);
    final filtersNotifier =
        ref.read(financialResultReportFiltersProvider.notifier);
    final basesAsync = ref.watch(basesListProvider);
    final reportAsync = ref.watch(financialResultReportProvider);
    final monthlyAsync = ref.watch(financialResultMonthlyProvider);
    final period = filters.period;
    final monthPeriod = period is MonthReportPeriod ? period : null;

    return Scaffold(
      body: TemplatePage(
        title: 'Финансовый результат',
        hasBackButton: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FilterRow(
                children: [
                  _FilterField(
                    child: basesAsync.when(
                      data: (bases) =>
                          DropdownWidget<FinancialResultBaseFilter>(
                        expand: true,
                        items: _baseFilterItems(bases),
                        hint: 'Выбор базы',
                        selectedItem: filters.selectedBaseFilter,
                        labelBuilder: (item) => item.label,
                        onChanged: filtersNotifier.setSelectedBaseFilter,
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
                  const Gap(_filtersGap),
                  const _FilterField(
                    child: FinancialResultExcludedCategoriesField(),
                  ),
                ],
              ),
              const Gap(24),
              reportAsync.when(
                data: (report) => SizedBox(
                  width: ReportTableTheme.standardWidth,
                  child: FinancialResultTable(report: report),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, _) => const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text('Не удалось загрузить финансовый результат'),
                ),
              ),
              if (monthPeriod != null) ...[
                const Gap(_sectionGap),
                monthlyAsync.when(
                  data: (items) => ExpenseChartSection(
                    title: 'Динамика финансового результата',
                    subtitle: '${monthPeriod.month.year} год',
                    child: FinancialResultMonthlyLineChart(items: items),
                  ),
                  loading: () => const _ChartLoading(),
                  error: (_, _) => const _ChartError(),
                ),
              ],
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  List<FinancialResultBaseFilter> _baseFilterItems(List<Base> bases) {
    return [
      const AllBasesFinancialResultFilter(),
      ...bases.map(SingleBaseFinancialResultFilter.new),
    ];
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
