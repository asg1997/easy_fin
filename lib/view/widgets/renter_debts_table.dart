import 'dart:math' as math;

import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/view/models/renter_debt_report_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RenterDebtsTable extends StatelessWidget {
  const RenterDebtsTable({
    required this.items,
    super.key,
  });

  final List<RenterDebtReportItem> items;

  static const maxHeight = 360.0;
  static const maxWidth = 560.0;

  static const _headerHeight = 30.0;
  static const _rowHeight = 28.0;
  static const _footerHeight = 30.0;
  static const _emptyHeight = 72.0;

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
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              children: [
                const _RenterDebtsTableHeader(),
                Expanded(
                  child: items.isEmpty
                      ? const Center(
                          child: Text(
                            'Нет задолженностей',
                            style: filterFieldHintTextStyle,
                          ),
                        )
                      : ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, _) => const Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xFFF3F3F3),
                          ),
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
                  _RenterDebtsTableFooter(
                    totalDebt: totalDebt,
                    amountFormat: _amountFormat,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _resolveTableHeight() {
    if (items.isEmpty) {
      return _emptyHeight;
    }

    var bodyHeight = items.length * _rowHeight;
    if (items.length > 1) {
      bodyHeight += items.length - 1;
    }

    final contentHeight =
        _headerHeight + bodyHeight + _footerHeight + 1;

    return math.min(contentHeight, maxHeight);
  }
}

class _RenterDebtsTableHeader extends StatelessWidget {
  const _RenterDebtsTableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: RenterDebtsTable._headerHeight,
      color: const Color(0xFFF9F9F9),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Арендатор',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Сумма задолженности',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'База',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
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
      height: RenterDebtsTable._rowHeight,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              renterName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${amountFormat.format(debt)} ₽',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              baseName,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _RenterDebtsTableFooter extends StatelessWidget {
  const _RenterDebtsTableFooter({
    required this.totalDebt,
    required this.amountFormat,
  });

  final double totalDebt;
  final NumberFormat amountFormat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.border,
        ),
        Container(
          height: RenterDebtsTable._footerHeight,
          color: const Color(0xFFFCFCFC),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: Row(
            children: [
              const Expanded(
                flex: 3,
                child: SizedBox.shrink(),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Sum ${amountFormat.format(totalDebt)}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Expanded(
                flex: 2,
                child: SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
