import 'dart:math' as math;

import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/models/expense_category_report_item.dart';
import 'package:easy_fin/view/widgets/report_table_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseCategoriesTable extends StatelessWidget {
  const ExpenseCategoriesTable({
    required this.items,
    this.width = defaultWidth,
    super.key,
  });

  final List<ExpenseCategoryReportItem> items;
  final double width;

  static const maxHeight = 360.0;
  static const defaultWidth = ReportTableTheme.standardWidth;

  static const _emptyHeight = 120.0;

  static final _amountFormat = NumberFormat('#,##0.00', 'ru');
  static final _percentFormat = NumberFormat('#,##0.0', 'ru');

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
                const _ExpenseCategoriesTableHeader(),
                ReportTableTheme.sectionDivider(context),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Text(
                            'Нет расходов за период',
                            style: filterFieldHintTextStyleOf(context),
                          ),
                        )
                      : ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, _) =>
                              ReportTableTheme.rowDivider(context),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return _ExpenseCategoriesTableRow(
                              categoryName: item.categoryName,
                              amount: item.amount,
                              percentage: item.percentage,
                              amountFormat: _amountFormat,
                              percentFormat: _percentFormat,
                            );
                          },
                        ),
                ),
                if (items.isNotEmpty)
                  _ExpenseCategoriesTableFooter(
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

class _ExpenseCategoriesTableHeader extends StatelessWidget {
  const _ExpenseCategoriesTableHeader();

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
            child: ReportTableHeaderLabel(
              label: 'Категория',
            ),
          ),
          Expanded(
            flex: 2,
            child: ReportTableHeaderLabel(
              label: 'Сумма',
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: ReportTableHeaderLabel(
              label: 'Доля, %',
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseCategoriesTableRow extends StatelessWidget {
  const _ExpenseCategoriesTableRow({
    required this.categoryName,
    required this.amount,
    required this.percentage,
    required this.amountFormat,
    required this.percentFormat,
  });

  final String categoryName;
  final double amount;
  final double percentage;
  final NumberFormat amountFormat;
  final NumberFormat percentFormat;

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
              categoryName,
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
          Expanded(
            flex: 2,
            child: Text(
              percentFormat.format(percentage),
              textAlign: TextAlign.right,
              style: ReportTableTheme.secondaryCellTextStyle(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseCategoriesTableFooter extends StatelessWidget {
  const _ExpenseCategoriesTableFooter({
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
              Expanded(
                flex: 2,
                child: Text(
                  '100,0',
                  textAlign: TextAlign.right,
                  style: ReportTableTheme.secondaryCellTextStyle(context).copyWith(
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
