import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:flutter/material.dart';

class MultiDropdownWidget<T> extends StatelessWidget {
  const MultiDropdownWidget({
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    required this.labelBuilder,
    this.hint,
    this.width = 220,
    this.expand = false,
    super.key,
  });

  final List<T> items;
  final Set<T> selectedItems;
  final ValueChanged<Set<T>> onChanged;
  final String Function(T item) labelBuilder;
  final String? hint;
  final double width;
  final bool expand;

  String _buttonLabel() {
    if (selectedItems.isEmpty) {
      return hint ?? '';
    }
    if (selectedItems.length == 1) {
      return labelBuilder(selectedItems.first);
    }
    return '${selectedItems.length} выбрано';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      height: filterFieldHeight,
      width: expand ? double.infinity : width,
      child: MenuAnchor(
        style: MenuStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 8),
          ),
          backgroundColor: WidgetStateProperty.all(colors.surface),
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: colors.border),
            ),
          ),
        ),
        alignmentOffset: const Offset(0, 4),
        menuChildren: [
          for (final item in items)
            CheckboxMenuButton(
              value: selectedItems.contains(item),
              style: const ButtonStyle(
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              onChanged: (isSelected) {
                final updated = Set<T>.from(selectedItems);
                if (isSelected ?? false) {
                  updated.add(item);
                } else {
                  updated.remove(item);
                }
                onChanged(updated);
              },
              child: Text(
                labelBuilder(item),
                style: filterFieldTextStyle.copyWith(
                  color: colors.primaryText,
                ),
              ),
            ),
        ],
        builder: (context, controller, child) {
          return Material(
            color: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: colors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: SizedBox(
                height: filterFieldHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: filterFieldHorizontalPadding,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _buttonLabel(),
                          overflow: TextOverflow.ellipsis,
                          style: selectedItems.isEmpty
                              ? filterFieldHintTextStyleOf(context)
                              : filterFieldTextStyle.copyWith(
                                  color: colors.primaryText,
                                ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: colors.secondaryText,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
