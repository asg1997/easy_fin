import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class DropdownWidget<T> extends StatelessWidget {
  const DropdownWidget({
    required this.items,
    required this.onChanged,
    required this.labelBuilder,
    this.selectedItem,
    this.hint,
    this.width = 220,
    this.expand = false,
    super.key,
  });
  final List<T> items;
  final T? selectedItem;
  final String? hint;
  final double width;
  final bool expand;
  final void Function(T item) onChanged;
  final String Function(T item) labelBuilder;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: filterFieldHeight,
      width: expand ? double.infinity : width,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          valueListenable: ValueNotifier<T?>(selectedItem),
          hint: hint == null
              ? null
              : Text(hint!, style: filterFieldHintTextStyle),
          items: items
              .map(
                (item) => DropdownItem(
                  value: item,
                  child: Text(
                    labelBuilder(item),
                    style: filterFieldTextStyle,
                  ),
                ),
              )
              .toList(),

          buttonStyleData: ButtonStyleData(
            height: filterFieldHeight,
            width: expand ? double.infinity : width,
            padding: const EdgeInsets.symmetric(
              horizontal: filterFieldHorizontalPadding,
            ),
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
      ),
    );
  }
}
