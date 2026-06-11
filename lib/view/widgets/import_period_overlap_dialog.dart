import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ImportPeriodOverlapDialog extends StatelessWidget {
  const ImportPeriodOverlapDialog({
    required this.existingStartDate,
    required this.existingEndDate,
    required this.newStartDate,
    required this.newEndDate,
    super.key,
  });

  final DateTime existingStartDate;
  final DateTime existingEndDate;
  final DateTime newStartDate;
  final DateTime newEndDate;

  static final _dateFormat = DateFormat('dd.MM.yyyy', 'ru');

  String _formatPeriod(DateTime start, DateTime end) =>
      '${_dateFormat.format(start)} — ${_dateFormat.format(end)}';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
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
                color: Colors.grey.withValues(alpha: 0.5),
                thickness: 0.5,
                height: 1,
              ),
              const Gap(20),
              Text(
                'Период новой выписки пересекается с уже загруженной. '
                'Операции за пересекающиеся даты будут дублироваться в документах.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.grey.shade600,
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
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    onPressed: () => Navigator.of(context).pop(),
                    height: 40,
                    minWidth: 110,
                    color: Colors.grey.shade200,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Пропустить',
                      style: TextStyle(
                        color: Colors.grey.shade800,
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
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: highlight ? Colors.orange.shade800 : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
