import 'dart:math' as math;

import 'package:easy_fin/data/bank_statements_storage/bank_statement_storage.dart';
import 'package:easy_fin/data/expenses_storage/expenses_storage.dart';
import 'package:easy_fin/data/incomes_storage/incomes_storage.dart';
import 'package:easy_fin/data/renter_assignments_storage/renter_assignments_storage.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/models/documents_table_item.dart';
import 'package:easy_fin/view/pages/add_expense_page.dart';
import 'package:easy_fin/view/pages/add_income_page.dart';
import 'package:easy_fin/view/pages/add_rent_accrual_page.dart';
import 'package:easy_fin/view/providers/account_balances_provider.dart';
import 'package:easy_fin/view/providers/documents_list_provider.dart';
import 'package:easy_fin/view/providers/github_sync_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_provider.dart';
import 'package:easy_fin/view/widgets/confirm_dialog.dart';
import 'package:easy_fin/view/widgets/edit_bank_operation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

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
  final TextEditingController _descriptionSearchController =
      TextEditingController();
  final FocusNode _descriptionSearchFocusNode = FocusNode();
  final Set<String> _selectedKeys = {};

  bool _isAmountSearchVisible = false;
  bool _isDescriptionSearchVisible = false;
  bool _isSelectionMode = false;
  String _amountSearchQuery = '';
  String _descriptionSearchQuery = '';

  static final _dateFormat = DateFormat('dd.MM.yyyy', 'ru');
  static final _amountFormat = NumberFormat('#,##0.00', 'ru');

  @override
  void didUpdateWidget(covariant DocumentsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (identical(oldWidget.items, widget.items)) return;

    final availableKeys = widget.items.map((item) => item.selectionKey).toSet();
    _selectedKeys.removeWhere((key) => !availableKeys.contains(key));
  }

  @override
  void dispose() {
    _amountSearchController.dispose();
    _amountSearchFocusNode.dispose();
    _descriptionSearchController.dispose();
    _descriptionSearchFocusNode.dispose();
    super.dispose();
  }

  void _enterSelectionMode() {
    setState(() {
      _isSelectionMode = true;
      _selectedKeys.clear();
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedKeys.clear();
    });
  }

  void _toggleItemSelection(DocumentsTableItem item) {
    if (!item.canDelete) return;

    setState(() {
      final key = item.selectionKey;
      if (_selectedKeys.contains(key)) {
        _selectedKeys.remove(key);
      } else {
        _selectedKeys.add(key);
      }
    });
  }

  void _toggleSelectAll(List<DocumentsTableItem> items) {
    final selectableKeys = items
        .where((item) => item.canDelete)
        .map((item) => item.selectionKey)
        .toSet();
    if (selectableKeys.isEmpty) return;

    setState(() {
      final allSelected = selectableKeys.every(_selectedKeys.contains);
      if (allSelected) {
        _selectedKeys.removeAll(selectableKeys);
      } else {
        _selectedKeys.addAll(selectableKeys);
      }
    });
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

  void _toggleDescriptionSearch() {
    setState(() {
      _isDescriptionSearchVisible = !_isDescriptionSearchVisible;
      if (!_isDescriptionSearchVisible) {
        _descriptionSearchController.clear();
        _descriptionSearchQuery = '';
      }
    });

    if (_isDescriptionSearchVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _descriptionSearchFocusNode.requestFocus();
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

  bool _matchesDescriptionSearch(DocumentsTableItem item) {
    final query = _descriptionSearchQuery.trim();
    if (query.isEmpty) return true;

    return item.note.toLowerCase().contains(query.toLowerCase());
  }

  List<DocumentsTableItem> get _filteredItems {
    return widget.items
        .where(_matchesAmountSearch)
        .where(_matchesDescriptionSearch)
        .toList();
  }

  Future<void> _confirmDeleteOperation(DocumentsTableItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          title: _deleteConfirmTitle(item),
          message: _deleteConfirmMessage(item),
          confirmLabel: 'Удалить',
        );
      },
    );

    if (confirmed != true || !mounted) return;

    await _deleteItem(item);
    if (!mounted) return;

    _invalidateAfterDelete();
  }

  Future<void> _deleteItem(DocumentsTableItem item) async {
    final operationId = item.operationId;
    if (operationId != null) {
      await ref.read(bankStatementStorageProvider).deleteOperation(operationId);
      return;
    }

    final incomeDocumentId = item.incomeDocumentId;
    if (incomeDocumentId != null) {
      await ref.read(incomesStorageProvider).deleteDocument(incomeDocumentId);
      return;
    }

    final expenseDocumentId = item.expenseDocumentId;
    if (expenseDocumentId != null) {
      await ref.read(expensesStorageProvider).deleteDocument(expenseDocumentId);
      return;
    }

    if (item.isRenterAssignmentDocument) {
      await ref.read(renterAssignmentsStorageProvider).deleteByBaseAndMonth(
        item.baseId!,
        item.date,
      );
    }
  }

  void _invalidateAfterDelete() {
    ref
      ..invalidate(documentsListProvider)
      ..invalidate(accountBalancesProvider)
      ..invalidate(renterDebtsProvider)
      ..invalidate(githubSyncDirtyProvider);
  }

  Future<void> _confirmDeleteSelected(
    List<DocumentsTableItem> visibleItems,
  ) async {
    final selectedItems = visibleItems
        .where((item) => _selectedKeys.contains(item.selectionKey))
        .toList();
    if (selectedItems.isEmpty) return;

    final count = selectedItems.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          title: count == 1 ? 'Удалить документ?' : 'Удалить документы?',
          message: count == 1
              ? 'Выбранный документ будет удалён безвозвратно.'
              : 'Выбранные документы ($count) будут удалены безвозвратно.',
          confirmLabel: 'Удалить',
        );
      },
    );

    if (confirmed != true || !mounted) return;

    for (final item in selectedItems) {
      await _deleteItem(item);
    }

    if (!mounted) return;

    _invalidateAfterDelete();
    _exitSelectionMode();
  }

  String _deleteConfirmTitle(DocumentsTableItem item) {
    if (item.isManualIncomeDocument) return 'Удалить приход?';
    if (item.isManualExpenseDocument) return 'Удалить расход?';
    if (item.isRenterAssignmentDocument) return 'Удалить начисление?';
    return 'Удалить операцию?';
  }

  String _deleteConfirmMessage(DocumentsTableItem item) {
    if (item.isManualIncomeDocument) {
      return 'Документ прихода будет удалён безвозвратно.';
    }
    if (item.isManualExpenseDocument) {
      return 'Документ расхода будет удалён безвозвратно.';
    }
    if (item.isRenterAssignmentDocument) {
      final monthLabel = DateFormat('MMMM yyyy', 'ru').format(item.date);
      return 'Начисление аренды за $monthLabel будет удалено безвозвратно.';
    }
    return 'Операция будет удалена безвозвратно.';
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
    final selectableItems =
        filteredItems.where((item) => item.canDelete).toList();
    final selectedCount = selectableItems
        .where((item) => _selectedKeys.contains(item.selectionKey))
        .length;
    final allSelectableSelected = selectableItems.isNotEmpty &&
        selectableItems.every(
          (item) => _selectedKeys.contains(item.selectionKey),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (_isSelectionMode) ...[
              Text(
                selectedCount == 0
                    ? 'Выберите документы'
                    : 'Выбрано: $selectedCount',
                style: filterFieldTextStyle.copyWith(
                  color: context.appColors.secondaryText,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: selectedCount == 0
                    ? null
                    : () => _confirmDeleteSelected(filteredItems),
                child: Text(
                  'Удалить',
                  style: TextStyle(
                    color: selectedCount == 0
                        ? context.appColors.secondaryText
                        : AppColors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: _exitSelectionMode,
                child: Text(
                  'Отмена',
                  style: TextStyle(
                    color: context.appColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ] else ...[
              const Spacer(),
              IconButton(
                tooltip: 'Выбрать',
                onPressed: filteredItems.any((item) => item.canDelete)
                    ? _enterSelectionMode
                    : null,
                icon: Icon(
                  LucideIcons.checkCheck,
                  size: 18,
                  color: context.appColors.secondaryText,
                ),
              ),
              IconButton(
                tooltip: 'Столбцы',
                onPressed: _showColumnSettings,
                icon: Icon(
                  LucideIcons.columns3,
                  size: 18,
                  color: context.appColors.secondaryText,
                ),
              ),
            ],
          ],
        ),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: context.appColors.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final tableWidth = math.max(
                    constraints.maxWidth,
                    _DocumentsTableLayout.minWidthFor(
                      visibleColumns,
                      isSelectionMode: _isSelectionMode,
                    ),
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
                            isSelectionMode: _isSelectionMode,
                            allSelected: allSelectableSelected,
                            hasSelectableItems: selectableItems.isNotEmpty,
                            isAmountSearchVisible: _isAmountSearchVisible,
                            amountSearchController: _amountSearchController,
                            amountSearchFocusNode: _amountSearchFocusNode,
                            onAmountSearchToggle: _toggleAmountSearch,
                            isDescriptionSearchVisible:
                                _isDescriptionSearchVisible,
                            descriptionSearchController:
                                _descriptionSearchController,
                            descriptionSearchFocusNode:
                                _descriptionSearchFocusNode,
                            onDescriptionSearchToggle: _toggleDescriptionSearch,
                            onSelectAll: () =>
                                _toggleSelectAll(filteredItems),
                            onAmountSearchChanged: (value) {
                              setState(() {
                                _amountSearchQuery = value;
                              });
                            },
                            onDescriptionSearchChanged: (value) {
                              setState(() {
                                _descriptionSearchQuery = value;
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
                                      style: filterFieldHintTextStyleOf(context),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: filteredItems.length,
                                    separatorBuilder: (_, _) =>
                                        Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: context.appColors.border,
                                    ),
                                    itemBuilder: (context, index) {
                                      final item = filteredItems[index];
                                      final isSelected = _selectedKeys.contains(
                                        item.selectionKey,
                                      );
                                      return _DocumentsTableRow(
                                        item: item,
                                        columns: visibleColumns,
                                        dateFormat: _dateFormat,
                                        amountFormat: _amountFormat,
                                        isSelectionMode: _isSelectionMode,
                                        isSelected: isSelected,
                                        onSelectionToggle: () =>
                                            _toggleItemSelection(item),
                                        onDelete: () =>
                                            _confirmDeleteOperation(item),
                                        onTap: _isSelectionMode
                                            ? (item.canDelete
                                                  ? () =>
                                                      _toggleItemSelection(item)
                                                  : null)
                                            : item.isRenterAssignmentDocument
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
                                            : item.isManualExpenseDocument
                                            ? () => AddExpensePage.navigate(
                                                context,
                                                documentId:
                                                    item.expenseDocumentId,
                                              )
                                            : item.isBankOperation
                                            ? () =>
                                                  EditBankOperationDialog.show(
                                                    context,
                                                    operationId:
                                                        item.operationId!,
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
    required this.isSelectionMode,
    required this.allSelected,
    required this.hasSelectableItems,
    required this.isAmountSearchVisible,
    required this.amountSearchController,
    required this.amountSearchFocusNode,
    required this.onAmountSearchToggle,
    required this.isDescriptionSearchVisible,
    required this.descriptionSearchController,
    required this.descriptionSearchFocusNode,
    required this.onDescriptionSearchToggle,
    required this.onSelectAll,
    required this.onAmountSearchChanged,
    required this.onDescriptionSearchChanged,
  });

  final List<DocumentsTableColumn> columns;
  final bool isSelectionMode;
  final bool allSelected;
  final bool hasSelectableItems;
  final bool isAmountSearchVisible;
  final TextEditingController amountSearchController;
  final FocusNode amountSearchFocusNode;
  final VoidCallback onAmountSearchToggle;
  final bool isDescriptionSearchVisible;
  final TextEditingController descriptionSearchController;
  final FocusNode descriptionSearchFocusNode;
  final VoidCallback onDescriptionSearchToggle;
  final VoidCallback onSelectAll;
  final ValueChanged<String> onAmountSearchChanged;
  final ValueChanged<String> onDescriptionSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.appColors.navActiveBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (isSelectionMode)
            SizedBox(
              width: _DocumentsTableLayout.selectionColumnWidth,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Checkbox(
                  value: allSelected,
                  onChanged: hasSelectableItems
                      ? (_) => onSelectAll()
                      : null,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          for (final column in columns)
            _DocumentsTableCell(
              column: column,
              child: switch (column) {
                DocumentsTableColumn.amount => _SearchableColumnHeader(
                    label: column.label,
                    searchHint: 'Поиск по сумме',
                    isSearchVisible: isAmountSearchVisible,
                    searchController: amountSearchController,
                    searchFocusNode: amountSearchFocusNode,
                    onSearchToggle: onAmountSearchToggle,
                    onSearchChanged: onAmountSearchChanged,
                    alignEnd: true,
                  ),
                DocumentsTableColumn.description => _SearchableColumnHeader(
                    label: column.label,
                    searchHint: 'Поиск по описанию',
                    isSearchVisible: isDescriptionSearchVisible,
                    searchController: descriptionSearchController,
                    searchFocusNode: descriptionSearchFocusNode,
                    onSearchToggle: onDescriptionSearchToggle,
                    onSearchChanged: onDescriptionSearchChanged,
                  ),
                _ => Text(
                    column.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              },
            ),
          if (!isSelectionMode)
            const SizedBox(width: _DocumentsTableLayout.actionsColumnWidth),
        ],
      ),
    );
  }
}

class _SearchableColumnHeader extends StatelessWidget {
  const _SearchableColumnHeader({
    required this.label,
    required this.searchHint,
    required this.isSearchVisible,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearchToggle,
    required this.onSearchChanged,
    this.alignEnd = false,
  });

  final String label;
  final String searchHint;
  final bool isSearchVisible;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onSearchChanged;
  final bool alignEnd;

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
          hintText: searchHint,
          hintStyle: filterFieldHintTextStyleOf(context),
          filled: true,
          fillColor: context.appColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          suffixIcon: IconButton(
            tooltip: 'Закрыть поиск',
            onPressed: onSearchToggle,
            icon: Icon(
              LucideIcons.x,
              size: 16,
              color: context.appColors.secondaryText,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: context.appColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: context.appColors.border),
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
      mainAxisAlignment:
          alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        IconButton(
          tooltip: searchHint,
          onPressed: onSearchToggle,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 28,
            minHeight: 28,
          ),
          icon: Icon(
            LucideIcons.search,
            size: 16,
            color: context.appColors.secondaryText,
          ),
        ),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
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
    required this.isSelectionMode,
    required this.isSelected,
    required this.onSelectionToggle,
    required this.onDelete,
    this.onTap,
  });

  final DocumentsTableItem item;
  final List<DocumentsTableColumn> columns;
  final DateFormat dateFormat;
  final NumberFormat amountFormat;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onSelectionToggle;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  Future<void> _showContextMenu(
    BuildContext context,
    Offset globalPosition,
  ) async {
    if (isSelectionMode || !item.canDelete) return;

    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(globalPosition, globalPosition),
      Offset.zero & overlay.size,
    );

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
    final colors = context.appColors;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onSecondaryTapUp: (details) =>
          _showContextMenu(context, details.globalPosition),
      child: MouseRegion(
        cursor: onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: ColoredBox(
          color: isSelected
              ? colors.navActiveBackground.withValues(alpha: 0.55)
              : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                if (isSelectionMode)
                  SizedBox(
                    width: _DocumentsTableLayout.selectionColumnWidth,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: item.canDelete
                          ? Checkbox(
                              value: isSelected,
                              onChanged: (_) => onSelectionToggle(),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                for (final column in columns)
                  _DocumentsTableCell(
                    column: column,
                    child: switch (column) {
                      DocumentsTableColumn.amount => Text(
                          amountFormat.format(item.amount),
                          textAlign: TextAlign.right,
                          style: filterFieldTextStyle.copyWith(
                            color: _amountColor(item.documentType),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      DocumentsTableColumn.description =>
                        _DescriptionText(note: item.note),
                      _ => Text(
                          _valueForColumn(column),
                          style: filterFieldTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    },
                  ),
                if (!isSelectionMode)
                  SizedBox(
                    width: _DocumentsTableLayout.actionsColumnWidth,
                    child: item.canDelete
                        ? IconButton(
                            tooltip: 'Удалить',
                            onPressed: onDelete,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            icon: Icon(
                              LucideIcons.trash2,
                              size: 16,
                              color: colors.secondaryText,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
              ],
            ),
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

class _DescriptionText extends StatelessWidget {
  const _DescriptionText({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final separatorIndex = note.indexOf(':');
    if (separatorIndex < 0 || separatorIndex == note.length - 1) {
      return Text(
        note,
        style: filterFieldTextStyle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    final prefix = note.substring(0, separatorIndex + 1);
    final suffix = note.substring(separatorIndex + 1);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: prefix,
            style: filterFieldTextStyle,
          ),
          TextSpan(
            text: suffix,
            style: filterFieldTextStyle.copyWith(
              fontWeight: FontWeight.w300,
              color: context.appColors.secondaryText,
            ),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _DocumentsTableLayout {
  static const Map<DocumentsTableColumn, int> flexByColumn = {
    DocumentsTableColumn.date: 2,
    DocumentsTableColumn.bankCash: 3,
    DocumentsTableColumn.base: 2,
    DocumentsTableColumn.amount: 2,
    DocumentsTableColumn.description: 4,
  };

  static const Map<DocumentsTableColumn, double> minWidthByColumn = {
    DocumentsTableColumn.date: 96,
    DocumentsTableColumn.bankCash: 160,
    DocumentsTableColumn.base: 90,
    DocumentsTableColumn.amount: 130,
    DocumentsTableColumn.description: 200,
  };

  static const double horizontalPadding = 32;
  static const double selectionColumnWidth = 40;
  static const double actionsColumnWidth = 32;

  static EdgeInsets paddingForColumn(DocumentsTableColumn column) {
    return switch (column) {
      DocumentsTableColumn.amount => const EdgeInsets.only(right: 20),
      DocumentsTableColumn.description => const EdgeInsets.only(left: 4),
      _ => EdgeInsets.zero,
    };
  }

  static double minWidthFor(
    List<DocumentsTableColumn> columns, {
    required bool isSelectionMode,
  }) {
    var width = horizontalPadding;
    if (isSelectionMode) {
      width += selectionColumnWidth;
    } else {
      width += actionsColumnWidth;
    }
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
