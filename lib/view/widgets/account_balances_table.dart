import 'dart:math' as math;

import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/view/models/account_balance_report_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountBalancesTable extends StatelessWidget {
  const AccountBalancesTable({
    required this.items,
    super.key,
  });

  final List<AccountBalanceReportItem> items;

  static const maxHeight = 280.0;
  static const maxWidth = 440.0;

  static const _headerHeight = 30.0;
  static const _baseRowHeight = 28.0;
  static const _accountRowHeight = 24.0;
  static const _emptyHeight = 72.0;

  static final _amountFormat = NumberFormat('#,##0.00', 'ru');

  @override
  Widget build(BuildContext context) {
    final tableHeight = _resolveTableHeight();

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
                const _AccountBalancesTableHeader(),
                Expanded(
                  child: items.isEmpty
                      ? const Center(
                          child: Text(
                            'Нет данных',
                            style: filterFieldHintTextStyle,
                          ),
                        )
                      : ListView.separated(
                          itemCount: _rowCount,
                          separatorBuilder: (_, index) => Divider(
                            height: 1,
                            thickness: 1,
                            color: _isLastAccountInBase(index)
                                ? AppColors.border
                                : const Color(0xFFF3F3F3),
                          ),
                          itemBuilder: (context, index) {
                            final row = _rowAt(index);
                            return _AccountBalancesTableRow(
                              label: row.label,
                              balance: row.balance,
                              isBase: row.isBase,
                              amountFormat: _amountFormat,
                            );
                          },
                        ),
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

    var bodyHeight = 0.0;
    for (var index = 0; index < _rowCount; index++) {
      bodyHeight += _rowAt(index).isBase ? _baseRowHeight : _accountRowHeight;
    }
    if (_rowCount > 1) {
      bodyHeight += _rowCount - 1;
    }

    return math.min(_headerHeight + bodyHeight, maxHeight);
  }

  int get _rowCount {
    var count = 0;
    for (final item in items) {
      count += 1 + item.accounts.length;
    }
    return count;
  }

  ({String label, double balance, bool isBase}) _rowAt(int index) {
    var currentIndex = 0;
    for (final item in items) {
      if (currentIndex == index) {
        return (
          label: item.baseName,
          balance: item.balance,
          isBase: true,
        );
      }
      currentIndex++;

      for (final account in item.accounts) {
        if (currentIndex == index) {
          return (
            label: account.name,
            balance: account.balance,
            isBase: false,
          );
        }
        currentIndex++;
      }
    }

    throw RangeError.index(index, this, 'index', null, _rowCount);
  }

  bool _isLastAccountInBase(int index) {
    var currentIndex = 0;
    for (final item in items) {
      final groupEnd = currentIndex + item.accounts.length;
      if (index == groupEnd) {
        return true;
      }
      currentIndex = groupEnd + 1;
    }
    return false;
  }
}

class _AccountBalancesTableHeader extends StatelessWidget {
  const _AccountBalancesTableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AccountBalancesTable._headerHeight,
      color: const Color(0xFFF9F9F9),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'База',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Остаток',
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

class _AccountBalancesTableRow extends StatelessWidget {
  const _AccountBalancesTableRow({
    required this.label,
    required this.balance,
    required this.isBase,
    required this.amountFormat,
  });

  final String label;
  final double balance;
  final bool isBase;
  final NumberFormat amountFormat;

  @override
  Widget build(BuildContext context) {
    final rowHeight = isBase
        ? AccountBalancesTable._baseRowHeight
        : AccountBalancesTable._accountRowHeight;

    return Container(
      height: rowHeight,
      color: isBase ? const Color(0xFFFCFCFC) : Colors.white,
      padding: EdgeInsets.fromLTRB(
        isBase ? 12 : 24,
        0,
        12,
        0,
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isBase ? 13 : 12,
                fontWeight: isBase ? FontWeight.w600 : FontWeight.w400,
                color: isBase ? AppColors.primary : Colors.grey.shade700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              amountFormat.format(balance),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: isBase ? 13 : 12,
                fontWeight: isBase ? FontWeight.w600 : FontWeight.w400,
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
