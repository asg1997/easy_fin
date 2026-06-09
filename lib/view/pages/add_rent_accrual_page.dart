import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/utils/amount_input_formatter.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/widgets/date_picker_field.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/widgets/simple_table.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class _RenterRow {
  const _RenterRow({
    required this.name,
    required this.accountNumber,
  });

  final String name;
  final String accountNumber;
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
  const AddRentAccrualPage({super.key});

  static Future<void> navigate(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const AddRentAccrualPage()),
    );
  }

  @override
  ConsumerState<AddRentAccrualPage> createState() => _AddRentAccrualPageState();
}

class _AddRentAccrualPageState extends ConsumerState<AddRentAccrualPage> {
  static const _testRenters = [
    _RenterRow(name: 'ООО «Ромашка»', accountNumber: '40702810123456789012'),
    _RenterRow(name: 'ИП Иванов А.С.', accountNumber: '40802810987654321098'),
    _RenterRow(name: 'ООО «Вектор»', accountNumber: '40702810555555555555'),
  ];

  Base? _selectedBase;
  late DateTime _selectedDate;
  final List<_AccrualEntry> _accrualEntries = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, 1);
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

  @override
  Widget build(BuildContext context) {
    final basesAsync = ref.watch(basesListProvider);

    return Scaffold(
      body: TemplatePage(
        hasBackButton: true,
        title: 'Начисление по аренде',
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
                    loading: () => const _FilterPlaceholder(label: 'Выбор базы'),
                    error: (_, _) =>
                        const _FilterPlaceholder(label: 'Выбор базы'),
                  ),
                ),
                const Gap(12),
                _FilterField(
                  child: DatePickerField(
                    expand: true,
                    hint: 'Дата',
                    selectedDate: _selectedDate,
                    onChanged: (date) {
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                        });
                      }
                    },
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
                        child: _RentAccrualsTable(
                          entries: _accrualEntries,
                          onRemoveEntry: _removeAccrualEntry,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: _RentersTable(
                          renters: _testRenters,
                          onRenterDoubleTap: _addRenterToAccruals,
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
    );
  }
}

class _RentersTable extends StatefulWidget {
  const _RentersTable({
    required this.renters,
    required this.onRenterDoubleTap,
  });

  final List<_RenterRow> renters;
  final void Function(_RenterRow renter) onRenterDoubleTap;

  @override
  State<_RentersTable> createState() => _RentersTableState();
}

class _RentersTableState extends State<_RentersTable> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_RenterRow> get _filteredRenters {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return widget.renters;

    return widget.renters.where((renter) {
      return renter.name.toLowerCase().contains(query) ||
          renter.accountNumber.contains(query);
    }).toList();
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
              renter.accountNumber,
            ],
          )
          .toList(),
      emptyMessage: _searchQuery.trim().isEmpty
          ? 'Нет данных'
          : 'Ничего не найдено',
      belowHeader: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: TextField(
          controller: _searchController,
          style: filterFieldTextStyle,
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Поиск арендатора',
            hintStyle: filterFieldHintTextStyle,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            prefixIcon: const Icon(
              LucideIcons.search,
              size: 16,
              color: Colors.grey,
            ),
            suffixIcon: _searchQuery.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Очистить',
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
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
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
      ),
      onRowDoubleTap: (index) {
        widget.onRenterDoubleTap(filteredRenters[index]);
      },
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
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            Container(
              color: const Color(0xFFF9F9F9),
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
                  ? const Center(
                      child: Text(
                        'Дважды нажмите на арендатора справа',
                        style: filterFieldHintTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      itemCount: entries.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.border,
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
                                child: TextField(
                                  controller: entry.amountController,
                                  focusNode: entry.amountFocusNode,
                                  textAlign: TextAlign.right,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  inputFormatters: const [
                                    AmountInputFormatter(),
                                  ],
                                  style: filterFieldTextStyle,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    hintText: '0,00',
                                    hintStyle: filterFieldHintTextStyle,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Удалить',
                                onPressed: () => onRemoveEntry(index),
                                icon: const Icon(
                                  LucideIcons.x,
                                  size: 16,
                                  color: Colors.grey,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE7E7E7)),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: filterFieldHintTextStyle,
      ),
    );
  }
}
