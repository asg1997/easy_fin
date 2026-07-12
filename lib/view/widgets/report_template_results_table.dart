import 'dart:math' as math;

import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/models/report_template_result_item.dart';
import 'package:easy_fin/view/widgets/report_table_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportTemplateResultsTable extends StatelessWidget {
  const ReportTemplateResultsTable({
    required this.items,
    this.width = defaultWidth,
    this.emptyMessage = 'Нет данных за период',
    super.key,
  });

  final List<ReportTemplateResultItem> items;
  final double width;
  final String emptyMessage;

  static const double maxHeight = 360;
  static const double defaultWidth = ReportTableTheme.standardWidth;
  static const double _emptyHeight = 120;

  static final _amountFormat = NumberFormat('#,##0.00', 'ru');

  @override
  Widget build(BuildContext context) {
    final tableHeight = _resolveTableHeight();
    final totalAmount = items.fold<double>(0, (sum, item) => sum + item.amount);

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
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          emptyMessage,
                          style: filterFieldHintTextStyleOf(context),
                        ),
                      )
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, _) =>
                            ReportTableTheme.rowDivider(context),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _Row(
                            label: item.label,
                            amount: item.amount,
                            amountFormat: _amountFormat,
                          );
                        },
                      ),
              ),
              if (items.isNotEmpty)
                _Footer(
                  totalAmount: totalAmount,
                  amountFormat: _amountFormat,
                ),
            ],
          ),
        ),
      ),
    );
  }

  double _resolveTableHeight() {
    if (items.isEmpty) {
      return _emptyHeight;
    }

    var bodyHeight = items.length * ReportTableTheme.rowHeight;
    if (items.length > 1) {
      bodyHeight += items.length - 1;
    }

    final contentHeight = ReportTableTheme.headerHeight +
        bodyHeight +
        ReportTableTheme.footerHeight +
        2;

    return math.min(contentHeight, maxHeight);
  }
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
            child: ReportTableHeaderLabel(label: 'Название'),
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

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.amount,
    required this.amountFormat,
  });

  final String label;
  final double amount;
  final NumberFormat amountFormat;

  @override
  Widget build(BuildContext context) {
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
              style: ReportTableTheme.cellTextStyle(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              amountFormat.format(amount),
              textAlign: TextAlign.right,
              style: ReportTableTheme.cellTextStyle(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.totalAmount,
    required this.amountFormat,
  });

  final double totalAmount;
  final NumberFormat amountFormat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReportTableTheme.sectionDivider(context),
        Container(
          height: ReportTableTheme.footerHeight,
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
                  'Итого',
                  style: ReportTableTheme.cellTextStyle(context).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  amountFormat.format(totalAmount),
                  textAlign: TextAlign.right,
                  style: ReportTableTheme.cellTextStyle(context).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
