import 'dart:math' as math;

import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/models/renter_debt_report_item.dart';
import 'package:easy_fin/view/widgets/report_table_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RenterDebtsTable extends StatelessWidget {
  const RenterDebtsTable({
    required this.items,
    super.key,
  });

  final List<RenterDebtReportItem> items;

  static const maxHeight = 360.0;
  static const maxWidth = ReportTableTheme.standardWidth;

  static const _emptyHeight = 120.0;
  static const _amountBaseGap = 16.0;

  static final _amountFormat = NumberFormat('#,##0', 'ru');

  @override
  Widget build(BuildContext context) {
    final tableHeight = _resolveTableHeight();
    final totalDebt = items.fold<double>(0, (sum, item) => sum + item.debt);

    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: maxWidth,
        height: tableHeight,
        child: ReportTableFrame(
          child: Column(
            children: [
                const _RenterDebtsTableHeader(),
                ReportTableTheme.sectionDivider(context),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Text(
                            'Нет задолженностей',
                            style: filterFieldHintTextStyleOf(context),
                          ),
                        )
                      : ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, _) =>
                              ReportTableTheme.rowDivider(context),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return _RenterDebtsTableRow(
                              renterName: item.renterName,
                              debt: item.debt,
                              baseName: item.baseName,
                              amountFormat: _amountFormat,
                            );
                          },
                        ),
                ),
                if (items.isNotEmpty)
                  ReportTableSumFooter(
                    amount: _amountFormat.format(totalDebt),
                    suffix: ' ₽',
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

class _RenterDebtsTableHeader extends StatelessWidget {
  const _RenterDebtsTableHeader();

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
              label: 'Арендатор',
            ),
          ),
          Expanded(
            flex: 3,
            child: ReportTableHeaderLabel(
              label: 'Сумма задолженности',
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: RenterDebtsTable._amountBaseGap),
          Expanded(
            flex: 2,
            child: ReportTableHeaderLabel(
              label: 'База',
            ),
          ),
        ],
      ),
    );
  }
}

class _RenterDebtsTableRow extends StatelessWidget {
  const _RenterDebtsTableRow({
    required this.renterName,
    required this.debt,
    required this.baseName,
    required this.amountFormat,
  });

  final String renterName;
  final double debt;
  final String baseName;
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
              renterName,
              style: ReportTableTheme.cellTextStyle(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${amountFormat.format(debt)} ₽',
              textAlign: TextAlign.right,
              style: ReportTableTheme.cellTextStyle(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: RenterDebtsTable._amountBaseGap),
          Expanded(
            flex: 2,
            child: Text(
              baseName,
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
