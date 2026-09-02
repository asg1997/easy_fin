import 'dart:math' as math;

import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/utils/money.dart';
import 'package:easy_fin/view/models/renter_debt_report_item.dart';
import 'package:easy_fin/view/widgets/report_table_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RenterDebtsTable extends StatelessWidget {
  const RenterDebtsTable({
    required this.items,
    this.showOverpayment = true,
    super.key,
  });

  final List<RenterDebtReportItem> items;
  final bool showOverpayment;

  static const double maxHeight = 360;
  static const double maxWidth = ReportTableTheme.standardWidth * 4 / 3;

  static const double _emptyHeight = 120;
  static const double _amountGap = 12;

  static final _amountFormat = NumberFormat('#,##0.00', 'ru');

  @override
  Widget build(BuildContext context) {
    final visibleItems = showOverpayment
        ? items
        : items
            .where(
              (item) => item.debt > 0 || item.overpayment == 0,
            )
            .toList();
    final tableHeight = _resolveTableHeight(visibleItems.length);
    final totalDebt =
        visibleItems.fold<double>(0, (sum, item) => sum + item.debt);
    final totalOverpayment = showOverpayment
        ? visibleItems.fold<double>(0, (sum, item) => sum + item.overpayment)
        : 0.0;

    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: maxWidth,
        height: tableHeight,
        child: ReportTableFrame(
          child: Column(
            children: [
              _RenterDebtsTableHeader(showOverpayment: showOverpayment),
              ReportTableTheme.sectionDivider(context),
              Expanded(
                child: visibleItems.isEmpty
                    ? Center(
                        child: Text(
                          showOverpayment
                              ? 'Нет задолженностей и переплат'
                              : 'Нет задолженностей',
                          style: filterFieldHintTextStyleOf(context),
                        ),
                      )
                    : ListView.separated(
                        itemCount: visibleItems.length,
                        separatorBuilder: (_, _) =>
                            ReportTableTheme.rowDivider(context),
                        itemBuilder: (context, index) {
                          final item = visibleItems[index];
                          return _RenterDebtsTableRow(
                            renterName: item.renterName,
                            debt: item.debt,
                            overpayment: item.overpayment,
                            baseName: item.baseName,
                            showOverpayment: showOverpayment,
                            amountFormat: _amountFormat,
                          );
                        },
                      ),
              ),
              if (visibleItems.isNotEmpty)
                _RenterDebtsTableFooter(
                  totalDebt: totalDebt,
                  totalOverpayment: totalOverpayment,
                  showOverpayment: showOverpayment,
                  amountFormat: _amountFormat,
                ),
            ],
          ),
        ),
      ),
    );
  }

  double _resolveTableHeight(int itemCount) {
    if (itemCount == 0) {
      return _emptyHeight;
    }

    var bodyHeight = itemCount * ReportTableTheme.rowHeight;
    if (itemCount > 1) {
      bodyHeight += itemCount - 1;
    }

    final contentHeight = ReportTableTheme.headerHeight +
        bodyHeight +
        ReportTableTheme.footerHeight +
        2;

    return math.min(contentHeight, maxHeight);
  }
}

class _RenterDebtsTableHeader extends StatelessWidget {
  const _RenterDebtsTableHeader({
    required this.showOverpayment,
  });

  final bool showOverpayment;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ReportTableTheme.headerHeight,
      color: context.appColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: ReportTableTheme.horizontalPadding,
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          const Expanded(
            flex: 3,
            child: ReportTableHeaderLabel(
              label: 'Арендатор',
            ),
          ),
          Expanded(
            flex: showOverpayment ? 2 : 3,
            child: const ReportTableHeaderLabel(
              label: 'Задолженность',
              textAlign: TextAlign.right,
            ),
          ),
          if (showOverpayment) ...[
            const SizedBox(width: RenterDebtsTable._amountGap),
            const Expanded(
              flex: 2,
              child: ReportTableHeaderLabel(
                label: 'Переплата',
                textAlign: TextAlign.right,
              ),
            ),
          ],
          const SizedBox(width: RenterDebtsTable._amountGap),
          const Expanded(
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
    required this.overpayment,
    required this.baseName,
    required this.showOverpayment,
    required this.amountFormat,
  });

  final String renterName;
  final double debt;
  final double overpayment;
  final String baseName;
  final bool showOverpayment;
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
            flex: showOverpayment ? 2 : 3,
            child: Text(
              _formatAmount(debt),
              textAlign: TextAlign.right,
              style: ReportTableTheme.cellTextStyle(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (showOverpayment) ...[
            const SizedBox(width: RenterDebtsTable._amountGap),
            Expanded(
              flex: 2,
              child: Text(
                _formatAmount(overpayment),
                textAlign: TextAlign.right,
                style: ReportTableTheme.cellTextStyle(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(width: RenterDebtsTable._amountGap),
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

  String _formatAmount(double amount) {
    if (moneyToMinor(amount) == 0) return '—';
    return '${amountFormat.format(amount)} ₽';
  }
}

class _RenterDebtsTableFooter extends StatelessWidget {
  const _RenterDebtsTableFooter({
    required this.totalDebt,
    required this.totalOverpayment,
    required this.showOverpayment,
    required this.amountFormat,
  });

  final double totalDebt;
  final double totalOverpayment;
  final bool showOverpayment;
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
                  style: ReportTableTheme.secondaryCellTextStyle(context),
                ),
              ),
              Expanded(
                flex: showOverpayment ? 2 : 3,
                child: Text(
                  _formatTotal(totalDebt),
                  textAlign: TextAlign.right,
                  style: ReportTableTheme.cellTextStyle(context).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (showOverpayment) ...[
                const SizedBox(width: RenterDebtsTable._amountGap),
                Expanded(
                  flex: 2,
                  child: Text(
                    _formatTotal(totalOverpayment),
                    textAlign: TextAlign.right,
                    style: ReportTableTheme.cellTextStyle(context).copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              const SizedBox(width: RenterDebtsTable._amountGap),
              const Expanded(flex: 2, child: SizedBox.shrink()),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTotal(double amount) {
    if (moneyToMinor(amount) == 0) return '—';
    return '${amountFormat.format(amount)} ₽';
  }
}
