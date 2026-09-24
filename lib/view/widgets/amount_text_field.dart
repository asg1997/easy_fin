import 'package:easy_fin/utils/amount_input_formatter.dart';
import 'package:flutter/material.dart';

/// Amount field that selects the whole value on focus and formats with kopecks.
class AmountTextField extends StatefulWidget {
  const AmountTextField({
    required this.controller,
    required this.focusNode,
    super.key,
    this.style,
    this.decoration,
    this.textAlign = TextAlign.right,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final TextStyle? style;
  final InputDecoration? decoration;
  final TextAlign textAlign;

  @override
  State<AmountTextField> createState() => _AmountTextFieldState();
}

class _AmountTextFieldState extends State<AmountTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant AmountTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChange);
      widget.focusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (!widget.focusNode.hasFocus) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !widget.focusNode.hasFocus) return;
      final text = widget.controller.text;
      widget.controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: text.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      textAlign: widget.textAlign,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: const [AmountInputFormatter()],
      style: widget.style,
      decoration: widget.decoration,
    );
  }
}
