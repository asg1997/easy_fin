import 'dart:math' as math;

import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/view/models/expense_category_report_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseCategoriesTable extends StatelessWidget {
  const ExpenseCategoriesTable({
    required this.items,
    super.key,
  });

  final List<ExpenseCategoryReportItem> items;

  static const maxHeight = 360.0;
  static const maxWidth = 440.0;

  static const _headerHeight = 30.0;
  static const _rowHeight = 28.0;
  static const _footerHeight = 30.0;
  static const _emptyHeight = 72.0;

  static final _amountFormat = NumberFormat('#,##0.00', 'ru');
  static final _percentFormat = NumberFormat('#,##0.0', 'ru');

  @override
  Widget build(BuildContext context) {
    final tableHeight = _resolveTableHeight();
    final totalAmount = items.fold<double>(0, (sum, item) => sum + item.amount);

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
                const _ExpenseCategoriesTableHeader(),
                Expanded(
                  child: items.isEmpty
                      ? const Center(
                          child: Text(
                            'Нет расходов за период',
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

    final contentHeight = _headerHeight + bodyHeight + _footerHeight + 1;

    return math.min(contentHeight, maxHeight);
  }
}

class _ExpenseCategoriesTableHeader extends StatelessWidget {
  const _ExpenseCategoriesTableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ExpenseCategoriesTable._headerHeight,
      color: const Color(0xFFF9F9F9),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Категория',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Сумма',
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
              'Доля, %',
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
      height: ExpenseCategoriesTable._rowHeight,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              categoryName,
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
              amountFormat.format(amount),
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
              percentFormat.format(percentage),
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
        const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.border,
        ),
        Container(
          height: ExpenseCategoriesTable._footerHeight,
          color: const Color(0xFFFCFCFC),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: Row(
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'Итого',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  amountFormat.format(totalAmount),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Expanded(
                flex: 2,
                child: Text(
                  '100,0',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
