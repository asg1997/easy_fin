import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/view/models/documents_table_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum DocumentsTableColumn {
  date,
  bankCash,
  base,
  amount;

  String get label => switch (this) {
    DocumentsTableColumn.date => 'Дата',
    DocumentsTableColumn.bankCash => 'Банк/Касса',
    DocumentsTableColumn.base => 'База',
    DocumentsTableColumn.amount => 'Сумма',
  };

  bool get canHide => this != date && this != amount;
}

class DocumentsTable extends StatefulWidget {
  const DocumentsTable({
    required this.items,
    super.key,
  });

  final List<DocumentsTableItem> items;

  @override
  State<DocumentsTable> createState() => _DocumentsTableState();
}

class _DocumentsTableState extends State<DocumentsTable> {
  final Set<DocumentsTableColumn> _visibleColumns =
      DocumentsTableColumn.values.toSet();

  static final _dateFormat = DateFormat('dd.MM.yyyy', 'ru');
  static final _amountFormat = NumberFormat('#,##0.00', 'ru');

  void _toggleColumn(DocumentsTableColumn column, bool isVisible) {
    if (!column.canHide) return;

    setState(() {
      if (isVisible) {
        _visibleColumns.add(column);
      } else {
        _visibleColumns.remove(column);
      }
    });
  }

  Future<void> _showColumnSettings() async {
    var showBankCash = _visibleColumns.contains(DocumentsTableColumn.bankCash);
    var showBase = _visibleColumns.contains(DocumentsTableColumn.base);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Столбцы'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Дата'),
                    value: true,
                    onChanged: null,
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Банк/Касса'),
                    value: showBankCash,
                    onChanged: (value) {
                      setDialogState(() {
                        showBankCash = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('База'),
                    value: showBase,
                    onChanged: (value) {
                      setDialogState(() {
                        showBase = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Сумма'),
                    value: true,
                    onChanged: null,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Отмена'),
                ),
                TextButton(
                  onPressed: () {
                    _toggleColumn(DocumentsTableColumn.bankCash, showBankCash);
                    _toggleColumn(DocumentsTableColumn.base, showBase);
                    Navigator.pop(context);
                  },
                  child: const Text('Применить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleColumns = DocumentsTableColumn.values
        .where(_visibleColumns.contains)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            tooltip: 'Столбцы',
            onPressed: _showColumnSettings,
            icon: const Icon(
              LucideIcons.columns3,
              size: 18,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                children: [
                  _DocumentsTableHeader(columns: visibleColumns),
                  Expanded(
                    child: widget.items.isEmpty
                        ? const Center(
                            child: Text(
                              'Нет документов',
                              style: filterFieldHintTextStyle,
                            ),
                          )
                        : ListView.separated(
                            itemCount: widget.items.length,
                            separatorBuilder: (_, _) => const Divider(
                              height: 1,
                              thickness: 1,
                              color: AppColors.border,
                            ),
                            itemBuilder: (context, index) {
                              return _DocumentsTableRow(
                                item: widget.items[index],
                                columns: visibleColumns,
                                dateFormat: _dateFormat,
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
      ],
    );
  }
}

class _DocumentsTableHeader extends StatelessWidget {
  const _DocumentsTableHeader({required this.columns});

  final List<DocumentsTableColumn> columns;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9F9F9),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          for (final column in columns) ...[
            _DocumentsTableCell(
              column: column,
              child: Text(
                column.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DocumentsTableRow extends StatelessWidget {
  const _DocumentsTableRow({
    required this.item,
    required this.columns,
    required this.dateFormat,
    required this.amountFormat,
  });

  final DocumentsTableItem item;
  final List<DocumentsTableColumn> columns;
  final DateFormat dateFormat;
  final NumberFormat amountFormat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          for (final column in columns)
            _DocumentsTableCell(
              column: column,
              child: Text(
                _valueForColumn(column),
                style: filterFieldTextStyle,
              ),
            ),
        ],
      ),
    );
  }

  String _valueForColumn(DocumentsTableColumn column) {
    return switch (column) {
      DocumentsTableColumn.date => dateFormat.format(item.date),
      DocumentsTableColumn.bankCash => item.accountType,
      DocumentsTableColumn.base => item.baseName,
      DocumentsTableColumn.amount => amountFormat.format(item.amount),
    };
  }
}

class _DocumentsTableCell extends StatelessWidget {
  const _DocumentsTableCell({
    required this.column,
    required this.child,
  });

  final DocumentsTableColumn column;
  final Widget child;

  static const Map<DocumentsTableColumn, int> _flexByColumn = {
    DocumentsTableColumn.date: 2,
    DocumentsTableColumn.bankCash: 2,
    DocumentsTableColumn.base: 3,
    DocumentsTableColumn.amount: 2,
  };

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: _flexByColumn[column]!,
      child: Align(
        alignment: column == DocumentsTableColumn.amount
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: child,
      ),
    );
  }
}
