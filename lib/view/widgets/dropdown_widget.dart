import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DropdownWidget<T> extends StatelessWidget {
  const DropdownWidget({
    required this.items,
    required this.onChanged,
    required this.labelBuilder,
    this.selectedItem,
    this.width = 220,
    super.key,
  });
  final List<T> items;
  final T? selectedItem;
  final double width;
  final void Function(T item) onChanged;
  final String Function(T item) labelBuilder;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        valueListenable: ValueNotifier<T?>(selectedItem),
        items: items
            .map(
              (item) => DropdownItem(
                value: item,
                child: Text(
                  labelBuilder(item),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            )
            .toList(),

        buttonStyleData: ButtonStyleData(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
        ),
        iconStyleData: const IconStyleData(
          iconSize: 20,
          iconEnabledColor: Colors.grey,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          elevation: 0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
        ),

        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}
