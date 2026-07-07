import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    required this.onChanged,
    this.selectedDate,
    this.hint = 'Выберите дату',
    this.width = 220,
    this.expand = false,
    super.key,
  });
  final DateTime? selectedDate;
  final void Function(DateTime? date) onChanged;
  final String hint;
  final double width;
  final bool expand;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      height: filterFieldHeight,
      width: expand ? double.infinity : width,
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: colors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  var initialDate = selectedDate ?? today;
                  if (initialDate.isAfter(today)) {
                    initialDate = today;
                  }

                  final date = await showDatePicker(
                    context: context,
                    locale: const Locale('ru'),
                    initialDate: initialDate,
                    firstDate: DateTime(2000),
                    lastDate: today,
                  );
                  if (date != null) {
                    onChanged(date);
                  }
                },
                child: SizedBox(
                  height: filterFieldHeight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: filterFieldHorizontalPadding,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        selectedDate == null
                            ? hint
                            : DateFormat(
                                'dd.MM.yyyy',
                                'ru',
                              ).format(selectedDate!),
                        style: selectedDate == null
                            ? filterFieldHintTextStyleOf(context)
                            : filterFieldTextStyle.copyWith(
                                color: colors.primaryText,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (selectedDate != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  tooltip: 'Сбросить',
                  onPressed: () => onChanged(null),
                  icon: Icon(
                    LucideIcons.x,
                    size: 16,
                    color: colors.secondaryText,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
