import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/models/renter_debt_by_base_report_item.dart';
import 'package:easy_fin/view/widgets/report_table_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RenterDebtsByBaseTable extends StatelessWidget {
  const RenterDebtsByBaseTable({
    required this.items,
    this.expanded = false,
    super.key,
  });

  final List<RenterDebtByBaseReportItem> items;
  final bool expanded;

  static const maxHeight = 360.0;
  static const maxWidth = ReportTableTheme.standardWidth;

  static const _emptyHeight = 120.0;

  static final _amountFormat = NumberFormat('#,##0', 'ru');

  @override
  Widget build(BuildContext context) {
    final tableHeight = expanded ? null : _resolveTableHeight();
    final totalDebt = items.fold<double>(0, (sum, item) => sum + item.debt);

    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: maxWidth,
        height: tableHeight,
        child: ReportTableFrame(
          child: Column(
            mainAxisSize: expanded ? MainAxisSize.min : MainAxisSize.max,
            children: [
                const _RenterDebtsByBaseTableHeader(),
                ReportTableTheme.sectionDivider(context),
                if (expanded)
                  _buildBody(context)
                else
                  Expanded(child: _buildBody(context)),
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

  Widget _buildBody(BuildContext context) {
    if (items.isEmpty) {
      return SizedBox(
        height: expanded ? _emptyHeight : null,
        child: Center(
          child: Text(
            'Нет задолженностей',
            style: filterFieldHintTextStyleOf(context),
          ),
        ),
      );
    }

    final listView = ListView.separated(
      shrinkWrap: expanded,
      physics: expanded ? const NeverScrollableScrollPhysics() : null,
      itemCount: items.length,
      separatorBuilder: (_, _) => ReportTableTheme.rowDivider(context),
      itemBuilder: (context, index) {
        final item = items[index];
        return _RenterDebtsByBaseTableRow(
          baseName: item.baseName,
          debt: item.debt,
          amountFormat: _amountFormat,
        );
      },
    );

    return expanded ? listView : listView;
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

    return contentHeight.clamp(_emptyHeight, maxHeight);
  }
}

class _RenterDebtsByBaseTableHeader extends StatelessWidget {
  const _RenterDebtsByBaseTableHeader();

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
              label: 'База',
            ),
          ),
          Expanded(
            flex: 2,
            child: ReportTableHeaderLabel(
              label: 'Сумма задолженности',
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _RenterDebtsByBaseTableRow extends StatelessWidget {
  const _RenterDebtsByBaseTableRow({
    required this.baseName,
    required this.debt,
    required this.amountFormat,
  });

  final String baseName;
  final double debt;
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
              baseName,
              style: ReportTableTheme.cellTextStyle(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${amountFormat.format(debt)} ₽',
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
