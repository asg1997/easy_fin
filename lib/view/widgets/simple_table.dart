import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:flutter/material.dart';

class SimpleTable extends StatelessWidget {
  const SimpleTable({
    required this.columns,
    this.rows = const [],
    this.emptyMessage = 'Нет данных',
    this.columnFlex = const [],
    this.alignRightColumns = const {},
    this.onRowDoubleTap,
    this.rowLeadingBuilder,
    this.leadingWidth = 32,
    this.belowHeader,
    super.key,
  });

  final List<String> columns;
  final List<List<String>> rows;
  final String emptyMessage;
  final List<int> columnFlex;
  final Set<int> alignRightColumns;
  final void Function(int index)? onRowDoubleTap;
  final Widget? Function(int index)? rowLeadingBuilder;
  final double leadingWidth;
  final Widget? belowHeader;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            _SimpleTableHeader(
              columns: columns,
              columnFlex: columnFlex,
              alignRightColumns: alignRightColumns,
              hasLeading: rowLeadingBuilder != null,
              leadingWidth: leadingWidth,
            ),
            if (belowHeader != null) ...[
              Divider(
                height: 1,
                thickness: 1,
                color: colors.border,
              ),
              belowHeader!,
              Divider(
                height: 1,
                thickness: 1,
                color: colors.border,
              ),
            ],
            Expanded(
              child: rows.isEmpty
                  ? Center(
                      child: Text(
                        emptyMessage,
                        style: filterFieldHintTextStyleOf(context),
                      ),
                    )
                  : ListView.separated(
                      itemCount: rows.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        thickness: 1,
                        color: colors.border,
                      ),
                      itemBuilder: (context, index) {
                        final row = rows[index];
                        final content = Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              if (rowLeadingBuilder != null) ...[
                                rowLeadingBuilder!(index)!,
                                const SizedBox(width: 4),
                              ],
                              for (var i = 0; i < columns.length; i++)
                                _SimpleTableCell(
                                  flex: _flexForColumn(i),
                                  child: Text(
                                    i < row.length ? row[i] : '',
                                    textAlign: alignRightColumns.contains(i)
                                        ? TextAlign.right
                                        : TextAlign.left,
                                    style: filterFieldTextStyle.copyWith(
                                      color: colors.primaryText,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        );

                        if (onRowDoubleTap == null) {
                          return content;
                        }

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onDoubleTap: () => onRowDoubleTap!(index),
                          child: content,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  int _flexForColumn(int index) {
    if (index < columnFlex.length) {
      return columnFlex[index];
    }
    return 1;
  }
}

class _SimpleTableHeader extends StatelessWidget {
  const _SimpleTableHeader({
    required this.columns,
    required this.columnFlex,
    required this.alignRightColumns,
    required this.hasLeading,
    required this.leadingWidth,
  });

  final List<String> columns;
  final List<int> columnFlex;
  final Set<int> alignRightColumns;
  final bool hasLeading;
  final double leadingWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      color: colors.navActiveBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (hasLeading) SizedBox(width: leadingWidth),
          if (hasLeading) const SizedBox(width: 4),
          for (var i = 0; i < columns.length; i++)
            _SimpleTableCell(
              flex: i < columnFlex.length ? columnFlex[i] : 1,
              child: Text(
                columns[i],
                textAlign: alignRightColumns.contains(i)
                    ? TextAlign.right
                    : TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.primaryText,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SimpleTableCell extends StatelessWidget {
  const _SimpleTableCell({
    required this.flex,
    required this.child,
  });

  final int flex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: child,
    );
  }
}
