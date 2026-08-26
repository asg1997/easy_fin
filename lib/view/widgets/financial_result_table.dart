import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/models/financial_result_report.dart';
import 'package:easy_fin/view/widgets/report_table_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinancialResultTable extends StatelessWidget {
  const FinancialResultTable({
    required this.report,
    this.width = defaultWidth,
    super.key,
  });

  final FinancialResultReport report;
  final double width;

  static const double defaultWidth = ReportTableTheme.standardWidth;

  static final _amountFormat = NumberFormat('#,##0.00', 'ru');

  @override
  Widget build(BuildContext context) {
    final rows = [
      _MetricRowData(label: 'Выручка', amount: report.revenue),
      _MetricRowData(label: 'Расходы', amount: report.expenses),
      _MetricRowData(
        label: 'Прибыль',
        amount: report.profit,
        emphasize: true,
      ),
    ];

    final bodyHeight =
        rows.length * ReportTableTheme.rowHeight + (rows.length - 1);
    final tableHeight =
        ReportTableTheme.headerHeight + bodyHeight + 1;

    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: width,
        height: tableHeight,
        child: ReportTableFrame(
          child: Column(
            children: [
              const _Header(),
              ReportTableTheme.sectionDivider(context),
              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rows.length,
                  separatorBuilder: (_, _) =>
                      ReportTableTheme.rowDivider(context),
                  itemBuilder: (context, index) {
                    final row = rows[index];
                    return _MetricRow(
                      label: row.label,
                      amount: row.amount,
                      emphasize: row.emphasize,
                      amountFormat: _amountFormat,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricRowData {
  const _MetricRowData({
    required this.label,
    required this.amount,
    this.emphasize = false,
  });

  final String label;
  final double amount;
  final bool emphasize;
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ReportTableTheme.headerHeight,
      color: context.appColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: ReportTableTheme.horizontalPadding,
      ),
      alignment: Alignment.center,
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: ReportTableHeaderLabel(label: 'Показатель'),
          ),
          Expanded(
            flex: 2,
            child: ReportTableHeaderLabel(
              label: 'Сумма',
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.amount,
    required this.amountFormat,
    this.emphasize = false,
  });

  final String label;
  final double amount;
  final NumberFormat amountFormat;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? ReportTableTheme.cellTextStyle(context).copyWith(
            fontWeight: FontWeight.w500,
          )
        : ReportTableTheme.cellTextStyle(context);

    return Container(
      height: ReportTableTheme.rowHeight,
      color: context.appColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: ReportTableTheme.horizontalPadding,
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              amountFormat.format(amount),
              textAlign: TextAlign.right,
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
