import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

sealed class ImportBaseDialogResult {
  const ImportBaseDialogResult();
}

final class ImportBaseDialogCreateNew extends ImportBaseDialogResult {
  const ImportBaseDialogCreateNew(this.baseName);

  final String baseName;
}

final class ImportBaseDialogLinkExisting extends ImportBaseDialogResult {
  const ImportBaseDialogLinkExisting(this.baseId);

  final BaseId baseId;
}

enum _ImportBaseAction {
  create,
  link,
}

class ImportBaseCreationDialog extends StatefulWidget {
  const ImportBaseCreationDialog({
    required this.accountNumber,
    required this.bases,
    super.key,
  });

  final AccountNumber accountNumber;
  final List<Base> bases;

  @override
  State<ImportBaseCreationDialog> createState() =>
      _ImportBaseCreationDialogState();
}

class _ImportBaseCreationDialogState extends State<ImportBaseCreationDialog> {
  final _nameController = TextEditingController();
  late _ImportBaseAction _action;
  BaseId? _selectedBaseId;

  @override
  void initState() {
    super.initState();
    _action = _ImportBaseAction.create;
  }

  Base? get _selectedBase {
    final selectedId = _selectedBaseId;
    if (selectedId == null) return null;
    for (final base in widget.bases) {
      if (base.id == selectedId) return base;
    }
    return null;
  }

  InputDecoration _fieldDecoration(BuildContext context) {
    final colors = context.appColors;
    return InputDecoration(
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: filterFieldHorizontalPadding,
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: colors.accent),
      ),
    );
  }

  bool get _canLink => widget.bases.isNotEmpty;

  bool get _canContinue => switch (_action) {
        _ImportBaseAction.create => _nameController.text.trim().isNotEmpty,
        _ImportBaseAction.link => _selectedBaseId != null && _selectedBase != null,
      };

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_canContinue) return;

    final result = switch (_action) {
      _ImportBaseAction.create =>
        ImportBaseDialogCreateNew(_nameController.text.trim()),
      _ImportBaseAction.link =>
        ImportBaseDialogLinkExisting(_selectedBaseId!),
    };

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.appColors.surface,
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
                color: context.appColors.border,
                thickness: 0.5,
                height: 1,
              ),
              const Gap(20),
              Text(
                'Этот расчётный счёт ещё не привязан ни к одной базе. '
                'Можно добавить его в существующую базу или создать новую. '
                'Выписка будет сохранена только на указанный счёт.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: context.appColors.secondaryText,
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
                  color: context.appColors.navActiveBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.appColors.border),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.accountNumber,
                  style: filterFieldTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Gap(16),
              const Text(
                'Действие',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(8),
              RadioGroup<_ImportBaseAction>(
                groupValue: _action,
                onChanged: (value) {
                  if (value == null) return;
                  if (value == _ImportBaseAction.link && !_canLink) return;
                  setState(() => _action = value);
                },
                child: Column(
                  children: [
                    const _DialogRadioTile<_ImportBaseAction>(
                      value: _ImportBaseAction.create,
                      title: 'Создать новую базу',
                    ),
                    if (_action == _ImportBaseAction.create)
                      Padding(
                        padding: const EdgeInsets.only(left: 28, bottom: 8),
                        child: SizedBox(
                          height: filterFieldHeight,
                          child: TextField(
                            controller: _nameController,
                            autofocus: true,
                            style: filterFieldTextStyle,
                            decoration: _fieldDecoration(context).copyWith(
                              hintText: 'Введите название',
                              hintStyle: filterFieldHintTextStyleOf(context),
                            ),
                            onChanged: (_) => setState(() {}),
                            onSubmitted:
                                _canContinue ? (_) => _onContinue() : null,
                          ),
                        ),
                      ),
                    _DialogRadioTile<_ImportBaseAction>(
                      value: _ImportBaseAction.link,
                      title: 'Добавить счёт в существующую базу',
                      enabled: _canLink,
                    ),
                    if (_action == _ImportBaseAction.link && _canLink)
                      Padding(
                        padding: const EdgeInsets.only(left: 28, bottom: 8),
                        child: DropdownWidget<Base>(
                          items: widget.bases,
                          selectedItem: _selectedBase,
                          hint: 'Выберите базу',
                          labelBuilder: (base) => base.name,
                          expand: true,
                          onChanged: (base) {
                            setState(() => _selectedBaseId = base.id);
                          },
                        ),
                      ),
                  ],
                ),
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: context.appColors.secondaryText,
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
                    color: context.appColors.accent,
                    disabledColor:
                        context.appColors.accent.withValues(alpha: 0.35),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Продолжить',
                      style: TextStyle(
                        color: context.appColors.onAccent,
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

class _DialogRadioTile<T> extends StatelessWidget {
  const _DialogRadioTile({
    required this.value,
    required this.title,
    this.enabled = true,
  });

  final T value;
  final String title;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: value,
      enabled: enabled,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          color: enabled ? null : context.appColors.secondaryText,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
