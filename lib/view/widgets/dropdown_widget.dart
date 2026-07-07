import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
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
    this.height = filterFieldHeight,
    super.key,
  });
  final List<T> items;
  final T? selectedItem;
  final String? hint;
  final double width;
  final bool expand;
  final double height;
  final void Function(T item) onChanged;
  final String Function(T item) labelBuilder;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      height: height,
      width: expand ? double.infinity : width,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          valueListenable: ValueNotifier<T?>(selectedItem),
          hint: hint == null
              ? null
              : Text(hint!, style: filterFieldHintTextStyleOf(context)),
          items: items
              .map(
                (item) => DropdownItem(
                  value: item,
                  child: Text(
                    labelBuilder(item),
                    style: filterFieldTextStyle.copyWith(
                      color: colors.primaryText,
                    ),
                  ),
                ),
              )
              .toList(),

          buttonStyleData: ButtonStyleData(
            height: height,
            width: expand ? double.infinity : width,
            padding: const EdgeInsets.symmetric(
              horizontal: filterFieldHorizontalPadding,
            ),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.border),
            ),
          ),
          iconStyleData: IconStyleData(
            iconSize: 20,
            iconEnabledColor: colors.secondaryText,
            iconDisabledColor: colors.secondaryText,
          ),
          dropdownStyleData: DropdownStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            elevation: 0,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.border),
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
