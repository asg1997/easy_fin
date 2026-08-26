import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

enum ImportPeriodOverlapDialogResult { skip, importWithoutOverlap }

class ImportPeriodOverlapDialog extends StatelessWidget {
  const ImportPeriodOverlapDialog({
    required this.existingStartDate,
    required this.existingEndDate,
    required this.newStartDate,
    required this.newEndDate,
    required this.canImportWithoutOverlap,
    this.trimmedStartDate,
    this.trimmedEndDate,
    super.key,
  });

  final DateTime existingStartDate;
  final DateTime existingEndDate;
  final DateTime newStartDate;
  final DateTime newEndDate;
  final bool canImportWithoutOverlap;
  final DateTime? trimmedStartDate;
  final DateTime? trimmedEndDate;

  static final _dateFormat = DateFormat('dd.MM.yyyy', 'ru');

  String _formatPeriod(DateTime start, DateTime end) =>
      '${_dateFormat.format(start)} — ${_dateFormat.format(end)}';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.appColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Пересечение периодов',
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
                canImportWithoutOverlap
                    ? 'Период новой выписки пересекается с уже загруженной. '
                        'Можно загрузить только ранний фрагмент без '
                        'пересекающихся дат — тогда дублирования операций '
                        'не будет.'
                    : 'Период новой выписки пересекается с уже загруженной. '
                        'Операции за пересекающиеся даты будут дублироваться '
                        'в документах.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: context.appColors.secondaryText,
                ),
              ),
              const Gap(20),
              _InfoRow(
                label: 'Загружена',
                value: _formatPeriod(existingStartDate, existingEndDate),
              ),
              const Gap(8),
              _InfoRow(
                label: 'Новая выписка',
                value: _formatPeriod(newStartDate, newEndDate),
                highlight: true,
              ),
              if (canImportWithoutOverlap &&
                  trimmedStartDate != null &&
                  trimmedEndDate != null) ...[
                const Gap(8),
                _InfoRow(
                  label: 'Будет загружено',
                  value: _formatPeriod(trimmedStartDate!, trimmedEndDate!),
                ),
              ],
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(
                      ImportPeriodOverlapDialogResult.skip,
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: context.appColors.secondaryText,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Пропустить',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (canImportWithoutOverlap) ...[
                    const Gap(8),
                    MaterialButton(
                      onPressed: () => Navigator.of(context).pop(
                        ImportPeriodOverlapDialogResult.importWithoutOverlap,
                      ),
                      height: 40,
                      color: context.appColors.accent,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Загрузить без пересечений',
                        style: TextStyle(
                          color: context.appColors.onAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: context.appColors.secondaryText,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: highlight
                  ? Colors.orange.shade800
                  : context.appColors.primaryText,
            ),
          ),
        ),
      ],
    );
  }
}
