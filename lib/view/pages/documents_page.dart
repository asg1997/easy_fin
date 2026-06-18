import 'package:easy_fin/models/account_filter_type.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/view/providers/bases_list_provider.dart';
import 'package:easy_fin/view/providers/documents_filters_provider.dart';
import 'package:easy_fin/view/providers/documents_list_provider.dart';
import 'package:easy_fin/view/widgets/date_picker_field.dart';
import 'package:easy_fin/view/widgets/documents_table.dart';
import 'package:easy_fin/view/widgets/multi_dropdown_widget.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class DocumentsPage extends ConsumerWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basesAsync = ref.watch(basesListProvider);
    final filters = ref.watch(documentsFiltersProvider);
    final documentsAsync = ref.watch(documentsListProvider);
    final filtersNotifier = ref.read(documentsFiltersProvider.notifier);

    return TemplatePage(
      title: 'Документы',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FilterRow(
            children: [
              _FilterField(
                child: MultiDropdownWidget<DocumentType>(
                  expand: true,
                  items: DocumentType.values,
                  hint: 'Тип',
                  selectedItems: filters.documentTypes,
                  labelBuilder: (item) => item.label,
                  onChanged: filtersNotifier.setDocumentTypes,
                ),
              ),
              const Gap(12),
              _FilterField(
                child: basesAsync.when(
                  data: (bases) => MultiDropdownWidget<Base>(
                    expand: true,
                    items: bases,
                    hint: 'Выбор базы',
                    selectedItems: filters.selectedBases,
                    labelBuilder: (item) => item.name,
                    onChanged: filtersNotifier.setSelectedBases,
                  ),
                  loading: () => const _FilterPlaceholder(label: 'Выбор базы'),
                  error: (_, _) =>
                      const _FilterPlaceholder(label: 'Выбор базы'),
                ),
              ),
              const Gap(12),
              _FilterField(
                child: MultiDropdownWidget<AccountFilterType>(
                  expand: true,
                  items: AccountFilterType.values,
                  hint: 'Касса/Банк',
                  selectedItems: filters.accountFilters,
                  labelBuilder: (item) => item.label,
                  onChanged: filtersNotifier.setAccountFilters,
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
                  selectedDate: filters.startDate,
                  onChanged: filtersNotifier.setStartDate,
                ),
              ),
              const Gap(12),
              _FilterField(
                child: DatePickerField(
                  expand: true,
                  hint: 'Дата конца',
                  selectedDate: filters.endDate,
                  onChanged: filtersNotifier.setEndDate,
                ),
              ),
            ],
          ),
          const Gap(12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: documentsAsync.when(
                data: (items) => DocumentsTable(items: items),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Не удалось загрузить документы\n$error',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
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
