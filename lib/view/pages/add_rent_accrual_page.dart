import 'dart:async';

import 'package:easy_fin/data/renter_assignments_storage/renter_assignments_storage.dart';
import 'package:easy_fin/data/renters_storage/renters_storage.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:easy_fin/models/renter_assignment.dart';
import 'package:easy_fin/utils/account_number_validator.dart';
import 'package:easy_fin/utils/amount_input_formatter.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_shortcuts.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_snack_bar.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/utils/search_match.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/documents_list_provider.dart';
import 'package:easy_fin/view/providers/github_sync_provider.dart';
import 'package:easy_fin/view/providers/renter_debts_provider.dart';
import 'package:easy_fin/view/providers/renters_list_provider.dart';
import 'package:easy_fin/view/widgets/add_renter_dialog.dart';
import 'package:easy_fin/view/widgets/amount_text_field.dart';
import 'package:easy_fin/view/widgets/date_picker_field.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/widgets/simple_table.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class _RenterRow {
  const _RenterRow({
    required this.renterId,
    required this.name,
    required this.accountNumbers,
  });

  final RenterId renterId;
  final String name;
  final List<String> accountNumbers;

  String get accountNumbersLabel {
    if (accountNumbers.isEmpty) return '—';
    return accountNumbers.join(', ');
  }
}

class _AccrualEntry {
  _AccrualEntry({
    required this.renter,
    required this.amountController,
    required this.amountFocusNode,
  });

  final _RenterRow renter;
  final TextEditingController amountController;
  final FocusNode amountFocusNode;
}

class AddRentAccrualPage extends ConsumerStatefulWidget {
  const AddRentAccrualPage({
    super.key,
    this.initialBaseId,
    this.initialDocumentId,
    this.copyFromDocumentId,
  });

  final String? initialBaseId;
  final String? initialDocumentId;

  /// Загружает строки из документа, но сохраняет как новый.
  final String? copyFromDocumentId;

  static Future<void> navigate(
    BuildContext context, {
    String? baseId,
    String? documentId,
    String? copyFromDocumentId,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => AddRentAccrualPage(
          initialBaseId: baseId,
          initialDocumentId: documentId,
          copyFromDocumentId: copyFromDocumentId,
        ),
      ),
    );
  }

  @override
  ConsumerState<AddRentAccrualPage> createState() => _AddRentAccrualPageState();
}

class _AddRentAccrualPageState extends ConsumerState<AddRentAccrualPage> {
  Base? _selectedBase;
  late DateTime _selectedDate;
  final List<_AccrualEntry> _accrualEntries = [];
  final _rentersTableKey = GlobalKey<_RentersTableState>();
  String? _editingDocumentId;
  DateTime? _editingCreatedAt;
  bool _isLoadingDocument = false;

  bool get _isEditing => _editingDocumentId != null;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);

    final documentIdToLoad =
        widget.initialDocumentId ?? widget.copyFromDocumentId;
    if (documentIdToLoad != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(
          _loadDocument(
            documentIdToLoad,
            asCopy: widget.copyFromDocumentId != null,
          ),
        );
      });
    } else if (widget.initialBaseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_loadInitialBase());
      });
    }
  }

  Future<void> _loadInitialBase() async {
    final bases = await ref.read(basesListProvider.future);
    if (!mounted) return;

    final base = bases
        .where((item) => item.id == widget.initialBaseId)
        .firstOrNull;
    if (base == null) return;

    setState(() {
      _selectedBase = base;
    });
  }

  Future<void> _loadDocument(String documentId, {required bool asCopy}) async {
    setState(() => _isLoadingDocument = true);

    final document =
        await ref.read(renterAssignmentsStorageProvider).getById(documentId);
    if (!mounted) return;

    if (document == null) {
      setState(() => _isLoadingDocument = false);
      await _showErrorDialog('Документ не найден');
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final bases = await ref.read(basesListProvider.future);
    final base = bases.where((item) => item.id == document.baseId).firstOrNull;

    final renters =
        await ref.read(rentersStorageProvider).getByBase(document.baseId);
    final archivedRenters = await ref
        .read(rentersStorageProvider)
        .getArchivedByBase(document.baseId);
    final renterById = {
      for (final renter in [...renters, ...archivedRenters]) renter.id: renter,
    };

    _clearAccruals();
    if (!asCopy) {
      _editingDocumentId = document.id;
      _editingCreatedAt = document.createdAt;
    }

    setState(() {
      _selectedBase = base;
      _selectedDate = normalizeRenterAssignmentDate(document.date);
      _accrualEntries.addAll(
        _buildAccrualEntriesFromLines(document.lines, renterById),
      );
      _isLoadingDocument = false;
    });
  }

  @override
  void dispose() {
    _clearAccruals();
    super.dispose();
  }

  void _clearAccruals() {
    for (final entry in _accrualEntries) {
      entry.amountController.dispose();
      entry.amountFocusNode.dispose();
    }
    _accrualEntries.clear();
  }

  void _onBaseChanged(Base base) {
    _clearAccruals();
    setState(() {
      _selectedBase = base;
    });
  }

  void _onDateChanged(DateTime? date) {
    if (date == null) return;
    setState(() {
      _selectedDate = date;
    });
  }

  void _addRenterToAccruals(_RenterRow renter) {
    final focusNode = FocusNode();

    setState(() {
      _accrualEntries.add(
        _AccrualEntry(
          renter: renter,
          amountController: TextEditingController(),
          amountFocusNode: focusNode,
        ),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  void _removeAccrualEntry(int index) {
    final entry = _accrualEntries[index];
    entry.amountController.dispose();
    entry.amountFocusNode.dispose();
    setState(() {
      _accrualEntries.removeAt(index);
    });
  }

  List<_AccrualEntry> _buildAccrualEntriesFromLines(
    List<RenterAssignmentLine> lines,
    Map<RenterId, Renter> renterById,
  ) {
    return [
      for (final line in lines)
        if (renterById.containsKey(line.renterId))
          _AccrualEntry(
            renter: _RenterRow(
              renterId: line.renterId,
              name: renterById[line.renterId]!.name,
              accountNumbers: renterById[line.renterId]!.accountNumbers,
            ),
            amountController: TextEditingController(
              text: AmountInputFormatter.formatAmount(line.sum),
            ),
            amountFocusNode: FocusNode(),
          ),
    ];
  }

  Future<void> _onSave() async {
    final baseId = _selectedBase?.id;
    if (baseId == null) return;

    if (_accrualEntries.isEmpty) {
      await _showErrorDialog('Добавьте хотя бы одно начисление');
      return;
    }

    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final lines = <RenterAssignmentLine>[];

    for (var i = 0; i < _accrualEntries.length; i++) {
      final entry = _accrualEntries[i];
      final amount = AmountInputFormatter.parseAmount(
        entry.amountController.text,
      );
      if (amount == null || amount <= 0) {
        await _showErrorDialog('Укажите сумму для «${entry.renter.name}»');
        return;
      }

      lines.add(
        RenterAssignmentLine(
          id: '${timestamp}_$i',
          renterId: entry.renter.renterId,
          // Общее начисление на арендатора, без привязки к конкретному р/с.
          accountNumber: '',
          sum: amount,
        ),
      );
    }

    final postingDate = normalizeRenterAssignmentDate(_selectedDate);
    final document = RenterAssignmentDocument(
      id: _editingDocumentId ?? timestamp.toString(),
      createdAt: _editingCreatedAt ?? DateTime.now(),
      baseId: baseId,
      date: postingDate,
      lines: lines,
    );

    try {
      final storage = ref.read(renterAssignmentsStorageProvider);
      if (_isEditing) {
        await storage.updateDocument(document);
      } else {
        await storage.saveDocument(document);
      }

      if (!mounted) return;
      ref.invalidate(documentsListProvider);
      ref.invalidate(renterDebtsProvider);
      ref.invalidate(githubSyncDirtyProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Начисление обновлено' : 'Начисление сохранено',
          ),
        ),
      );
      Navigator.of(context).pop();
    } on EmptyRenterAssignmentsError {
      if (!mounted) return;
      await _showErrorDialog('Добавьте хотя бы одно начисление');
    } on InvalidRenterAssignmentAmountError {
      if (!mounted) return;
      await _showErrorDialog('Сумма должна быть больше нуля');
    } on RenterAssignmentDocumentNotFoundError {
      if (!mounted) return;
      await _showErrorDialog('Документ не найден');
    } on Object catch (error) {
      if (!mounted) return;
      await _showErrorDialog('Не удалось сохранить начисление\n$error');
    }
  }

  List<_RenterRow> _toRenterRows(List<Renter> renters) {
    return [
      for (final renter in renters)
        _RenterRow(
          renterId: renter.id,
          name: renter.name,
          accountNumbers: renter.accountNumbers,
        ),
    ];
  }

  Future<void> _onAddRenter() async {
    final result = await showDialog<AddRenterDialogResult>(
      context: context,
      builder: (context) => const AddRenterDialog(),
    );
    if (result == null) return;

    try {
      final baseId = _selectedBase?.id;
      if (baseId == null) return;

      await ref.read(rentersStorageProvider).save(
        Renter.create(
          baseId: baseId,
          name: result.name,
          accountNumbers: result.accountNumbers,
        ),
      );
      ref.invalidate(rentersListProvider);
    } on DuplicateRenterAccountNumbersError {
      if (!mounted) return;
      await _showErrorDialog('Счета не должны повторяться');
    } on InvalidRenterAccountNumberError {
      if (!mounted) return;
      await _showErrorDialog(
        'Номер р/с должен содержать $accountNumberLength символов',
      );
    } on AccountBelongsToAnotherRenterError catch (error) {
      if (!mounted) return;
      await _showErrorDialog(
        'Счёт ${error.accountNumber} уже привязан к другому арендатору',
      );
    }
  }

  Future<void> _showErrorDialog(String message) {
    return AppSnackBar.showErrorDialog(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final basesAsync = ref.watch(basesListProvider);
    final rentersAsync = ref.watch(
      rentersListProvider(RentersListFilter(baseId: _selectedBase?.id)),
    );

    if (_isLoadingDocument) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return CallbackShortcuts(
      bindings: {
        appPrimaryShortcut(LogicalKeyboardKey.keyN): () {
          _rentersTableKey.currentState?.focusSearchAndClear();
        },
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          body: TemplatePage(
            hasBackButton: true,
            title: _isEditing
                ? 'Редактирование начисления'
                : 'Начисление по аренде',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FilterRow(
                  children: [
                    _FilterField(
                      child: basesAsync.when(
                        data: (bases) => DropdownWidget<Base>(
                          expand: true,
                          items: bases,
                          hint: 'Выбор базы',
                          selectedItem: _selectedBase,
                          labelBuilder: (item) => item.name,
                          onChanged: _onBaseChanged,
                        ),
                        loading: () =>
                            const _FilterPlaceholder(label: 'Выбор базы'),
                        error: (_, _) =>
                            const _FilterPlaceholder(label: 'Выбор базы'),
                      ),
                    ),
                    const Gap(12),
                    _FilterField(
                      child: DatePickerField(
                        expand: true,
                        hint: 'Дата начисления',
                        selectedDate: _selectedDate,
                        onChanged: _onDateChanged,
                      ),
                    ),
                  ],
                ),
                if (_selectedBase != null) ...[
                  const Gap(12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _RentAccrualsTable(
                                    entries: _accrualEntries,
                                    onRemoveEntry: _removeAccrualEntry,
                                  ),
                                ),
                                const Gap(12),
                                MaterialButton(
                                  onPressed: _onSave,
                                  height: filterFieldHeight,
                                  minWidth: 140,
                                  color: AppColors.purple,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: const Text(
                                    'Сохранить',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: rentersAsync.when(
                              data: (renters) => _RentersTable(
                                key: _rentersTableKey,
                                renters: _toRenterRows(renters),
                                onRenterDoubleTap: _addRenterToAccruals,
                                onAddRenter: _onAddRenter,
                              ),
                              loading: () => const _RentersTablePlaceholder(),
                              error: (_, _) => const _RentersTablePlaceholder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RentersTable extends StatefulWidget {
  const _RentersTable({
    required this.renters,
    required this.onRenterDoubleTap,
    required this.onAddRenter,
    super.key,
  });

  final List<_RenterRow> renters;
  final void Function(_RenterRow renter) onRenterDoubleTap;
  final VoidCallback onAddRenter;

  @override
  State<_RentersTable> createState() => _RentersTableState();
}

class _RentersTableState extends State<_RentersTable> {
  final _searchController = TextEditingController();
  late final FocusNode _searchFocusNode;
  final _highlightedRowKey = GlobalKey();
  String _searchQuery = '';
  int? _highlightedIndex;

  Color get _highlightColor => AppColors.purple.withValues(alpha: 0.12);

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode(onKeyEvent: _onSearchKeyEvent);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void focusSearchAndClear() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _highlightedIndex = null;
    });
    _searchFocusNode.requestFocus();
  }

  List<_RenterRow> get _filteredRenters {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return widget.renters;

    return widget.renters.where((renter) {
      return renter.name.toLowerCase().contains(query) ||
          renter.accountNumbers.any((account) => account.contains(query));
    }).toList();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      final renters = _filteredRenters;
      _highlightedIndex = indexOfBestSearchMatch(
        candidates: [
          for (final renter in renters) [renter.name, ...renter.accountNumbers],
        ],
        query: value,
      );
    });
    _scrollToHighlighted();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _highlightedIndex = null;
    });
  }

  void _scrollToHighlighted() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ensureSearchHighlightVisible(_highlightedRowKey);
    });
  }

  void _moveHighlight(int delta) {
    final renters = _filteredRenters;
    if (renters.isEmpty) return;

    setState(() {
      final current = _highlightedIndex;
      if (current == null) {
        _highlightedIndex = delta > 0 ? 0 : renters.length - 1;
      } else {
        _highlightedIndex = (current + delta).clamp(0, renters.length - 1);
      }
    });
    _scrollToHighlighted();
  }

  void _activateHighlighted() {
    final index = _highlightedIndex;
    if (index == null) return;
    final renters = _filteredRenters;
    if (index < 0 || index >= renters.length) return;
    widget.onRenterDoubleTap(renters[index]);
  }

  KeyEventResult _onSearchKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (_searchQuery.trim().isEmpty || _filteredRenters.isEmpty) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _moveHighlight(1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _moveHighlight(-1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      _activateHighlighted();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final filteredRenters = _filteredRenters;

    return SimpleTable(
      columns: const ['Арендатор', 'номер р/с'],
      columnFlex: const [2, 3],
      rows: filteredRenters
          .map(
            (renter) => [
              renter.name,
              renter.accountNumbersLabel,
            ],
          )
          .toList(),
      emptyMessage: _searchQuery.trim().isEmpty
          ? 'Нет данных'
          : 'Ничего не найдено',
      selectedRowIndex: _highlightedIndex,
      selectedRowKey: _highlightedRowKey,
      selectedRowColor: _highlightColor,
      belowHeader: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                style: filterFieldTextStyle,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Поиск арендатора',
                  hintStyle: filterFieldHintTextStyleOf(context),
                  filled: true,
                  fillColor: context.appColors.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  prefixIcon: Icon(
                    LucideIcons.search,
                    size: 16,
                    color: context.appColors.secondaryText,
                  ),
                  suffixIcon: _searchQuery.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Очистить',
                          onPressed: _clearSearch,
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
                onChanged: _onSearchChanged,
              ),
            ),
            const Gap(8),
            IconButton(
              tooltip: 'Добавить арендатора',
              onPressed: widget.onAddRenter,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 36,
                minHeight: 36,
              ),
              style: IconButton.styleFrom(
                backgroundColor: context.appColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: context.appColors.border),
                ),
              ),
              icon: const Icon(
                LucideIcons.plus,
                size: 18,
                color: AppColors.purple,
              ),
            ),
          ],
        ),
      ),
      onRowDoubleTap: (index) {
        widget.onRenterDoubleTap(filteredRenters[index]);
      },
    );
  }
}

class _RentersTablePlaceholder extends StatelessWidget {
  const _RentersTablePlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: context.appColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _RentAccrualsTable extends StatelessWidget {
  const _RentAccrualsTable({
    required this.entries,
    required this.onRemoveEntry,
  });

  final List<_AccrualEntry> entries;
  final void Function(int index) onRemoveEntry;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: context.appColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            Container(
              color: context.appColors.navActiveBackground,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Арендатор',
                      style: TextStyle(
                        fontSize: 14,
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
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: entries.isEmpty
                  ? Center(
                      child: Text(
                        'Дважды нажмите на арендатора справа',
                        style: filterFieldHintTextStyleOf(context),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      itemCount: entries.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        thickness: 1,
                        color: context.appColors.border,
                      ),
                      itemBuilder: (context, index) {
                        final entry = entries[index];

                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 8,
                            bottom: 8,
                            right: 8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  entry.renter.name,
                                  style: filterFieldTextStyle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: documentLineFieldHeight,
                                  child: AmountTextField(
                                    controller: entry.amountController,
                                    focusNode: entry.amountFocusNode,
                                    style: filterFieldTextStyle,
                                    decoration: documentLineFieldDecorationOf(
                                      context,
                                      hintText: '0,00',
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Удалить',
                                onPressed: () => onRemoveEntry(index),
                                icon: Icon(
                                  LucideIcons.x,
                                  size: 16,
                                  color: context.appColors.secondaryText,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _FilterField extends StatelessWidget {
  const _FilterField({required this.child});

  static const _fieldWidth = 250.0;

  static const _constraints = BoxConstraints(
    minWidth: _fieldWidth,
    maxWidth: _fieldWidth,
    minHeight: filterFieldHeight,
    maxHeight: filterFieldHeight,
  );

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: _constraints,
      child: child,
    );
  }
}

class _FilterPlaceholder extends StatelessWidget {
  const _FilterPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: filterFieldHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: filterFieldHorizontalPadding,
      ),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.appColors.border),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: filterFieldHintTextStyleOf(context),
      ),
    );
  }
}
