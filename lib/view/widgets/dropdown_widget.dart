import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:flutter/material.dart';

class DropdownWidget<T> extends StatefulWidget {
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
  State<DropdownWidget<T>> createState() => _DropdownWidgetState<T>();
}

class _DropdownWidgetState<T> extends State<DropdownWidget<T>> {
  late final ValueNotifier<T?> _valueListenable;

  T? _resolveSelected(T? selected) {
    if (selected == null) return null;
    for (final item in widget.items) {
      if (item == selected) return item;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _valueListenable = ValueNotifier(_resolveSelected(widget.selectedItem));
  }

  @override
  void didUpdateWidget(covariant DropdownWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final resolved = _resolveSelected(widget.selectedItem);
    if (_valueListenable.value != resolved) {
      _valueListenable.value = resolved;
    }
  }

  @override
  void dispose() {
    _valueListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      height: widget.height,
      width: widget.expand ? double.infinity : widget.width,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          isExpanded: true,
          valueListenable: _valueListenable,
          hint: widget.hint == null
              ? null
              : Text(
                  widget.hint!,
                  style: filterFieldHintTextStyleOf(context),
                ),
          items: widget.items
              .map(
                (item) => DropdownItem<T>(
                  value: item,
                  child: Text(
                    widget.labelBuilder(item),
                    style: filterFieldTextStyle.copyWith(
                      color: colors.primaryText,
                    ),
                  ),
                ),
              )
              .toList(),
          buttonStyleData: ButtonStyleData(
            height: widget.height,
            width: widget.expand ? double.infinity : widget.width,
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
              widget.onChanged(value);
            }
          },
        ),
      ),
    );
  }
}
