import 'package:easy_fin/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    required this.onChanged,
    this.selectedDate,
    this.hint = 'Выберите дату',
    this.width = 220,
    super.key,
  });
  final DateTime? selectedDate;
  final void Function(DateTime? date) onChanged;
  final String hint;
  final double width;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      height: 55,
      minWidth: width,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.border),
      ),
      onPressed: () {
        showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
      },
      child: Text(
        DateFormat('dd.MM.yyyy').format(selectedDate ?? DateTime.now()),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
