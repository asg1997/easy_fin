import 'package:easy_fin/models/account_filter_type.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/view/data/documents_mock_data.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/widgets/date_picker_field.dart';
import 'package:easy_fin/view/widgets/documents_table.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class DocumentsPage extends ConsumerStatefulWidget {
  const DocumentsPage({super.key});

  @override
  ConsumerState<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends ConsumerState<DocumentsPage> {
  DocumentType? _documentType;
  Base? _selectedBase;
  AccountFilterType? _accountFilter;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final basesAsync = ref.watch(basesListProvider);

    return TemplatePage(
      title: 'Документы',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FilterRow(
            children: [
              _FilterField(
                child: DropdownWidget<DocumentType>(
                  expand: true,
                  items: DocumentType.values,
                  hint: 'Тип',
                  selectedItem: _documentType,
                  labelBuilder: (item) => item.label,
                  onChanged: (item) {
                    setState(() {
                      _documentType = item;
                    });
                  },
                ),
              ),
              const Gap(12),
              _FilterField(
                child: basesAsync.when(
                  data: (bases) => DropdownWidget<Base>(
                    expand: true,
                    items: bases,
                    hint: 'Выбор базы',
                    selectedItem: _selectedBase,
                    labelBuilder: (item) => item.name,
                    onChanged: (item) {
                      setState(() {
                        _selectedBase = item;
                      });
                    },
                  ),
                  loading: () => const _FilterPlaceholder(label: 'Выбор базы'),
                  error: (_, _) =>
                      const _FilterPlaceholder(label: 'Выбор базы'),
                ),
              ),
              const Gap(12),
              _FilterField(
                child: DropdownWidget<AccountFilterType>(
                  expand: true,
                  items: AccountFilterType.values,
                  hint: 'Касса/Банк',
                  selectedItem: _accountFilter,
                  labelBuilder: (item) => item.label,
                  onChanged: (item) {
                    setState(() {
                      _accountFilter = item;
                    });
                  },
                ),
              ),
            ],
          ),
          const Gap(12),
          _FilterRow(
            children: [
              _FilterField(
                child: DatePickerField(
                  expand: true,
                  hint: 'Дата начала',
                  selectedDate: _startDate,
                  onChanged: (date) {
                    setState(() {
                      _startDate = date;
                    });
                  },
                ),
              ),
              const Gap(12),
              _FilterField(
                child: DatePickerField(
                  expand: true,
                  hint: 'Дата конца',
                  selectedDate: _endDate,
                  onChanged: (date) {
                    setState(() {
                      _endDate = date;
                    });
                  },
                ),
              ),
            ],
          ),
          const Gap(12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: DocumentsTable(items: documentsMockData),
            ),
          ),
        ],
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
