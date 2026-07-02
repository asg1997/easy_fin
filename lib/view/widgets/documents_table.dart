import 'dart:math' as math;

import 'package:easy_fin/data/bank_statements_storage/bank_statement_storage.dart';
import 'package:easy_fin/data/incomes_storage/incomes_storage.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/view/models/documents_table_item.dart';
import 'package:easy_fin/view/pages/add_income_page.dart';
import 'package:easy_fin/view/pages/add_rent_accrual_page.dart';
import 'package:easy_fin/view/providers/documents_list_provider.dart';
import 'package:easy_fin/view/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum DocumentsTableColumn {
  date,
  bankCash,
  base,
  amount,
  description;

  String get label => switch (this) {
    DocumentsTableColumn.date => 'Дата',
    DocumentsTableColumn.bankCash => 'Банк/Касса',
    DocumentsTableColumn.base => 'База',
    DocumentsTableColumn.amount => 'Сумма',
    DocumentsTableColumn.description => 'Описание',
  };

  bool get canHide => this != date && this != amount;
}

class DocumentsTable extends ConsumerStatefulWidget {
  const DocumentsTable({
    required this.items,
    super.key,
  });

  final List<DocumentsTableItem> items;

  @override
  ConsumerState<DocumentsTable> createState() => _DocumentsTableState();
}

class _DocumentsTableState extends ConsumerState<DocumentsTable> {
  final Set<DocumentsTableColumn> _visibleColumns =
      DocumentsTableColumn.values.toSet();
  final TextEditingController _amountSearchController =
      TextEditingController();
  final FocusNode _amountSearchFocusNode = FocusNode();

  bool _isAmountSearchVisible = false;
  String _amountSearchQuery = '';

  static final _dateFormat = DateFormat('dd.MM.yyyy', 'ru');
  static final _amountFormat = NumberFormat('#,##0.00', 'ru');

  @override
  void dispose() {
    _amountSearchController.dispose();
    _amountSearchFocusNode.dispose();
    super.dispose();
  }

  void _toggleAmountSearch() {
    setState(() {
      _isAmountSearchVisible = !_isAmountSearchVisible;
      if (!_isAmountSearchVisible) {
        _amountSearchController.clear();
        _amountSearchQuery = '';
      }
    });

    if (_isAmountSearchVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _amountSearchFocusNode.requestFocus();
      });
    }
  }

  bool _matchesAmountSearch(DocumentsTableItem item) {
    final query = _amountSearchQuery.trim();
    if (query.isEmpty) return true;

    final normalizedQuery = query.replaceAll(RegExp(r'[\s,]'), '');
    final formattedAmount = _amountFormat
        .format(item.amount)
        .replaceAll(RegExp(r'[\s,]'), '');
    final rawAmount = item.amount
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'[\s,]'), '');

    return formattedAmount.contains(normalizedQuery) ||
        rawAmount.contains(normalizedQuery);
  }

  List<DocumentsTableItem> get _filteredItems {
    return widget.items.where(_matchesAmountSearch).toList();
  }

  Future<void> _confirmDeleteOperation(DocumentsTableItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          title: item.isManualIncomeDocument
              ? 'Удалить приход?'
              : 'Удалить операцию?',
          message: item.isManualIncomeDocument
              ? 'Документ прихода будет удалён безвозвратно.'
              : 'Операция будет удалена безвозвратно.',
          confirmLabel: 'Удалить',
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final operationId = item.operationId;
    if (operationId != null) {
      await ref.read(bankStatementStorageProvider).deleteOperation(operationId);
      ref.invalidate(documentsListProvider);
      return;
    }

    final incomeDocumentId = item.incomeDocumentId;
    if (incomeDocumentId != null) {
      await ref
          .read(incomesStorageProvider)
          .deleteDocument(incomeDocumentId);
      ref.invalidate(documentsListProvider);
    }
  }

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
    var showDescription = _visibleColumns.contains(
      DocumentsTableColumn.description,
    );

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
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Описание'),
                    value: showDescription,
                    onChanged: (value) {
                      setDialogState(() {
                        showDescription = value ?? false;
                      });
                    },
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
                    _toggleColumn(
                      DocumentsTableColumn.description,
                      showDescription,
                    );
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
    final filteredItems = _filteredItems;

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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final tableWidth = math.max(
                    constraints.maxWidth,
                    _DocumentsTableLayout.minWidthFor(visibleColumns),
                  );

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: tableWidth,
                      height: constraints.maxHeight,
                      child: Column(
                        children: [
                          _DocumentsTableHeader(
                            columns: visibleColumns,
                            isAmountSearchVisible: _isAmountSearchVisible,
                            amountSearchController: _amountSearchController,
                            amountSearchFocusNode: _amountSearchFocusNode,
                            onAmountSearchToggle: _toggleAmountSearch,
                            onAmountSearchChanged: (value) {
                              setState(() {
                                _amountSearchQuery = value;
                              });
                            },
                          ),
                          Expanded(
                            child: filteredItems.isEmpty
                                ? Center(
                                    child: Text(
                                      widget.items.isEmpty
                                          ? 'Нет документов'
                                          : 'Ничего не найдено',
                                      style: filterFieldHintTextStyle,
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: filteredItems.length,
                                    separatorBuilder: (_, _) =>
                                        const Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: AppColors.border,
                                    ),
                                    itemBuilder: (context, index) {
                                      final item = filteredItems[index];
                                      return _DocumentsTableRow(
                                        item: item,
                                        columns: visibleColumns,
                                        dateFormat: _dateFormat,
                                        amountFormat: _amountFormat,
                                        onDelete: () =>
                                            _confirmDeleteOperation(item),
                                        onTap: item.isRenterAssignmentDocument
                                            ? () => AddRentAccrualPage.navigate(
                                                context,
                                                baseId: item.baseId,
                                                month: item.date,
                                              )
                                            : item.isManualIncomeDocument
                                            ? () => AddIncomePage.navigate(
                                                context,
                                                documentId:
                                                    item.incomeDocumentId,
                                              )
                                            : null,
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DocumentsTableHeader extends StatelessWidget {
  const _DocumentsTableHeader({
    required this.columns,
    required this.isAmountSearchVisible,
    required this.amountSearchController,
    required this.amountSearchFocusNode,
    required this.onAmountSearchToggle,
    required this.onAmountSearchChanged,
  });

  final List<DocumentsTableColumn> columns;
  final bool isAmountSearchVisible;
  final TextEditingController amountSearchController;
  final FocusNode amountSearchFocusNode;
  final VoidCallback onAmountSearchToggle;
  final ValueChanged<String> onAmountSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9F9F9),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          for (final column in columns)
            _DocumentsTableCell(
              column: column,
              child: column == DocumentsTableColumn.amount
                  ? _AmountColumnHeader(
                      isSearchVisible: isAmountSearchVisible,
                      searchController: amountSearchController,
                      searchFocusNode: amountSearchFocusNode,
                      onSearchToggle: onAmountSearchToggle,
                      onSearchChanged: onAmountSearchChanged,
                    )
                  : Text(
                      column.label,
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

class _AmountColumnHeader extends StatelessWidget {
  const _AmountColumnHeader({
    required this.isSearchVisible,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearchToggle,
    required this.onSearchChanged,
  });

  final bool isSearchVisible;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    if (isSearchVisible) {
      return TextField(
        controller: searchController,
        focusNode: searchFocusNode,
        autofocus: true,
        style: filterFieldTextStyle,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Поиск по сумме',
          hintStyle: filterFieldHintTextStyle,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          suffixIcon: IconButton(
            tooltip: 'Закрыть поиск',
            onPressed: onSearchToggle,
            icon: const Icon(
              LucideIcons.x,
              size: 16,
              color: Colors.grey,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
        onChanged: onSearchChanged,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          tooltip: 'Поиск по сумме',
          onPressed: onSearchToggle,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 28,
            minHeight: 28,
          ),
          icon: const Icon(
            LucideIcons.search,
            size: 16,
            color: Colors.grey,
          ),
        ),
        const Flexible(
          child: Text(
            'Сумма',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _DocumentsTableRow extends StatelessWidget {
  const _DocumentsTableRow({
    required this.item,
    required this.columns,
    required this.dateFormat,
    required this.amountFormat,
    required this.onDelete,
    this.onTap,
  });

  final DocumentsTableItem item;
  final List<DocumentsTableColumn> columns;
  final DateFormat dateFormat;
  final NumberFormat amountFormat;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  Future<void> _showContextMenu(BuildContext context, Offset globalPosition) async {
    final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(globalPosition, globalPosition),
      Offset.zero & overlay.size,
    );

    if (!item.canDelete) return;

    final action = await showMenu<String>(
      context: context,
      position: position,
      items: const [
        PopupMenuItem(
          value: 'delete',
          child: Text('Удалить'),
        ),
      ],
    );

    if (action == 'delete') {
      onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onSecondaryTapUp: (details) =>
          _showContextMenu(context, details.globalPosition),
      child: MouseRegion(
        cursor: onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              for (final column in columns)
                _DocumentsTableCell(
                  column: column,
                  child: column == DocumentsTableColumn.amount
                      ? Text(
                          amountFormat.format(item.amount),
                          textAlign: TextAlign.right,
                          style: filterFieldTextStyle.copyWith(
                            color: _amountColor(item.documentType),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          _valueForColumn(column),
                          style: filterFieldTextStyle,
                          maxLines: column == DocumentsTableColumn.description
                              ? 2
                              : 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _valueForColumn(DocumentsTableColumn column) {
    return switch (column) {
      DocumentsTableColumn.date => dateFormat.format(item.date),
      DocumentsTableColumn.bankCash => item.accountType,
      DocumentsTableColumn.base => item.baseName,
      DocumentsTableColumn.amount => amountFormat.format(item.amount),
      DocumentsTableColumn.description => item.note,
    };
  }

  Color _amountColor(DocumentType documentType) {
    return switch (documentType) {
      DocumentType.income => AppColors.green,
      DocumentType.outcome => AppColors.red,
      DocumentType.renterAssignment => AppColors.primary,
    };
  }
}

class _DocumentsTableLayout {
  static const Map<DocumentsTableColumn, int> flexByColumn = {
    DocumentsTableColumn.date: 2,
    DocumentsTableColumn.bankCash: 2,
    DocumentsTableColumn.base: 3,
    DocumentsTableColumn.amount: 2,
    DocumentsTableColumn.description: 4,
  };

  static const Map<DocumentsTableColumn, double> minWidthByColumn = {
    DocumentsTableColumn.date: 96,
    DocumentsTableColumn.bankCash: 110,
    DocumentsTableColumn.base: 120,
    DocumentsTableColumn.amount: 130,
    DocumentsTableColumn.description: 200,
  };

  static const double horizontalPadding = 32;

  static EdgeInsets paddingForColumn(DocumentsTableColumn column) {
    return switch (column) {
      DocumentsTableColumn.amount => const EdgeInsets.only(right: 20),
      DocumentsTableColumn.description => const EdgeInsets.only(left: 4),
      _ => EdgeInsets.zero,
    };
  }

  static double minWidthFor(List<DocumentsTableColumn> columns) {
    var width = horizontalPadding;
    for (final column in columns) {
      width +=
          minWidthByColumn[column]! + paddingForColumn(column).horizontal;
    }
    return width;
  }
}

class _DocumentsTableCell extends StatelessWidget {
  const _DocumentsTableCell({
    required this.column,
    required this.child,
  });

  final DocumentsTableColumn column;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: _DocumentsTableLayout.flexByColumn[column]!,
      child: Padding(
        padding: _DocumentsTableLayout.paddingForColumn(column),
        child: child,
      ),
    );
  }
}
