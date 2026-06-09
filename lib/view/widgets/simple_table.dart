import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class SimpleTable extends StatelessWidget {
  const SimpleTable({
    required this.columns,
    this.rows = const [],
    this.emptyMessage = 'Нет данных',
    this.columnFlex = const [],
    this.alignRightColumns = const {},
    this.onRowDoubleTap,
    this.belowHeader,
    super.key,
  });

  final List<String> columns;
  final List<List<String>> rows;
  final String emptyMessage;
  final List<int> columnFlex;
  final Set<int> alignRightColumns;
  final void Function(int index)? onRowDoubleTap;
  final Widget? belowHeader;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
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
            ),
            if (belowHeader != null) ...[
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.border,
              ),
              belowHeader!,
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.border,
              ),
            ],
            Expanded(
              child: rows.isEmpty
                  ? Center(
                      child: Text(
                        emptyMessage,
                        style: filterFieldHintTextStyle,
                      ),
                    )
                  : ListView.separated(
                      itemCount: rows.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.border,
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
                              for (var i = 0; i < columns.length; i++)
                                _SimpleTableCell(
                                  flex: _flexForColumn(i),
                                  child: Text(
                                    i < row.length ? row[i] : '',
                                    textAlign: alignRightColumns.contains(i)
                                        ? TextAlign.right
                                        : TextAlign.left,
                                    style: filterFieldTextStyle,
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
  });

  final List<String> columns;
  final List<int> columnFlex;
  final Set<int> alignRightColumns;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9F9F9),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          for (var i = 0; i < columns.length; i++)
            _SimpleTableCell(
              flex: i < columnFlex.length ? columnFlex[i] : 1,
              child: Text(
                columns[i],
                textAlign: alignRightColumns.contains(i)
                    ? TextAlign.right
                    : TextAlign.left,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
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
