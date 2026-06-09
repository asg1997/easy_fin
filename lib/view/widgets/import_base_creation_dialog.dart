import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

sealed class ImportBaseDialogResult {
  const ImportBaseDialogResult();
}

final class ImportBaseDialogSelectExisting extends ImportBaseDialogResult {
  const ImportBaseDialogSelectExisting(this.baseId);

  final BaseId baseId;
}

final class ImportBaseDialogCreateNew extends ImportBaseDialogResult {
  const ImportBaseDialogCreateNew(this.baseName);

  final String baseName;
}

class ImportBaseCreationDialog extends StatefulWidget {
  const ImportBaseCreationDialog({
    required this.accountNumber,
    required this.existingBases,
    super.key,
  });

  final AccountNumber accountNumber;
  final List<Base> existingBases;

  @override
  State<ImportBaseCreationDialog> createState() =>
      _ImportBaseCreationDialogState();
}

class _ImportBaseCreationDialogState extends State<ImportBaseCreationDialog> {
  final _nameController = TextEditingController();

  late bool _isCreatingNew;
  Base? _selectedBase;

  static const _fieldDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(
      horizontal: filterFieldHorizontalPadding,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: AppColors.primary),
    ),
  );

  bool get _hasExistingBases => widget.existingBases.isNotEmpty;

  bool get _canContinue {
    if (_isCreatingNew) {
      return _nameController.text.trim().isNotEmpty;
    }
    return _selectedBase != null;
  }

  @override
  void initState() {
    super.initState();
    _isCreatingNew = !_hasExistingBases;
    if (_hasExistingBases) {
      _selectedBase = widget.existingBases.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_canContinue) return;

    if (_isCreatingNew) {
      Navigator.of(context).pop(
        ImportBaseDialogCreateNew(_nameController.text.trim()),
      );
      return;
    }

    Navigator.of(context).pop(
      ImportBaseDialogSelectExisting(_selectedBase!.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Счёт не найден',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(12),
              Divider(
                color: Colors.grey.withValues(alpha: 0.5),
                thickness: 0.5,
                height: 1,
              ),
              const Gap(20),
              Text(
                _hasExistingBases
                    ? 'В системе нет базы с таким расчётным счётом. '
                        'Выберите существующую базу или создайте новую, '
                        'чтобы продолжить импорт.'
                    : 'В системе нет баз с таким расчётным счётом. '
                        'Введите название новой базы, чтобы продолжить импорт.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.grey.shade600,
                ),
              ),
              const Gap(20),
              const Text(
                'Номер счёта',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(8),
              Container(
                height: filterFieldHeight,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: filterFieldHorizontalPadding,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.accountNumber,
                  style: filterFieldTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (_hasExistingBases) ...[
                const Gap(20),
                Row(
                  children: [
                    Expanded(
                      child: _ModeOption(
                        label: 'Выбрать базу',
                        isSelected: !_isCreatingNew,
                        onTap: () => setState(() => _isCreatingNew = false),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: _ModeOption(
                        label: 'Создать новую',
                        isSelected: _isCreatingNew,
                        onTap: () => setState(() => _isCreatingNew = true),
                      ),
                    ),
                  ],
                ),
              ],
              const Gap(16),
              if (_isCreatingNew) ...[
                const Text(
                  'Название базы',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(8),
                SizedBox(
                  height: filterFieldHeight,
                  child: TextField(
                    controller: _nameController,
                    autofocus: !_hasExistingBases,
                    style: filterFieldTextStyle,
                    decoration: _fieldDecoration.copyWith(
                      hintText: 'Введите название',
                      hintStyle: filterFieldHintTextStyle,
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: _canContinue ? (_) => _onContinue() : null,
                  ),
                ),
              ] else ...[
                const Text(
                  'База',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(8),
                DropdownWidget<Base>(
                  expand: true,
                  items: widget.existingBases,
                  selectedItem: _selectedBase,
                  hint: 'Выберите базу',
                  labelBuilder: (base) => base.name,
                  onChanged: (base) => setState(() => _selectedBase = base),
                ),
              ],
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Отмена',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Gap(8),
                  MaterialButton(
                    onPressed: _canContinue ? _onContinue : null,
                    height: 40,
                    minWidth: 110,
                    color: AppColors.primary,
                    disabledColor: AppColors.primary.withValues(alpha: 0.35),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Продолжить',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  const _ModeOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primary : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 40,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
