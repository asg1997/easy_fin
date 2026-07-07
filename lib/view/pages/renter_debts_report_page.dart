import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_by_base_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_monthly_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_report_filters_provider.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/widgets/renter_debts_bar_chart.dart';
import 'package:easy_fin/view/widgets/renter_debts_base_filter_dropdown.dart';
import 'package:easy_fin/view/widgets/renter_debts_by_base_table.dart';
import 'package:easy_fin/view/widgets/report_table_theme.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class RenterDebtsReportPage extends ConsumerWidget {
  const RenterDebtsReportPage({super.key});

  static Future<void> navigate(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const RenterDebtsReportPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(renterDebtsReportFiltersProvider);
    final filtersNotifier = ref.read(renterDebtsReportFiltersProvider.notifier);
    final basesAsync = ref.watch(basesListProvider);
    final debtsByBaseAsync = ref.watch(renterDebtsByBaseProvider);
    final monthlyDebtsAsync = ref.watch(renterDebtsMonthlyProvider);

    return Scaffold(
      body: TemplatePage(
        title: 'Задолженности арендаторов',
        hasBackButton: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FilterRow(
                children: [
                  _FilterField(
                    child: basesAsync.when(
                      data: (bases) => RenterDebtsBaseFilterDropdown(
                        bases: bases,
                        selectedFilter: filters.selectedBaseFilter,
                        onChanged: filtersNotifier.setSelectedBaseFilter,
                      ),
                      loading: () =>
                          const _FilterPlaceholder(label: 'Выбор базы'),
                      error: (_, _) =>
                          const _FilterPlaceholder(label: 'Выбор базы'),
                    ),
                  ),
                ],
              ),
              const Gap(24),
              const ReportTableTitle('Задолженности по базам'),
              const Gap(12),
              debtsByBaseAsync.when(
                data: (items) => RenterDebtsByBaseTable(
                  items: items,
                  expanded: true,
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, _) => const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text('Не удалось загрузить задолженности'),
                ),
              ),
              const ReportTableSectionDivider(),
              monthlyDebtsAsync.when(
                data: (items) {
                  final availableYears =
                      filtersNotifier.availableYears;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ReportTableTitle('Задолженность за период'),
                      const Gap(12),
                      Text(
                        'Сумма задолженности на конец каждого месяца',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.appColors.secondaryText,
                        ),
                      ),
                      const Gap(12),
                      _FilterField(
                        child: DropdownWidget<int>(
                          expand: true,
                          items: availableYears,
                          selectedItem: filters.selectedYear,
                          labelBuilder: (year) => year.toString(),
                          onChanged: filtersNotifier.setSelectedYear,
                        ),
                      ),
                      const Gap(16),
                      RenterDebtsBarChart(items: items),
                    ],
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, _) => const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text('Не удалось загрузить данные для графика'),
                ),
              ),
              const Gap(20),
            ],
          ),
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
