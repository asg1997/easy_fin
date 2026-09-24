import 'package:flutter/services.dart';

class AmountInputFormatter extends TextInputFormatter {
  const AmountInputFormatter({this.decimalPlaces = 2});

  final int decimalPlaces;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final stripped = newValue.text.replaceAll(RegExp(r'\s'), '');
    if (stripped.isEmpty) {
      return const TextEditingValue(
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    if (_isSeparatorInsertion(oldValue, newValue)) {
      final parsed = _parse(oldValue.text);
      final formatted = _compose(parsed.integer, parsed.fraction);
      final commaIndex = formatted.indexOf(',');
      return TextEditingValue(
        text: formatted,
        selection: TextSelection(
          baseOffset: commaIndex + 1,
          extentOffset: formatted.length,
        ),
      );
    }

    final parsed = _parse(newValue.text);
    final formatted = _compose(parsed.integer, parsed.fraction);

    final selectionEnd = newValue.selection.isValid
        ? newValue.selection.extentOffset.clamp(0, newValue.text.length)
        : newValue.text.length;

    final separatorIndex = _separatorIndex(newValue.text);
    final editingFraction =
        separatorIndex >= 0 && selectionEnd > separatorIndex;

    final int selectionOffset;
    if (editingFraction) {
      final fractionText = newValue.text.substring(separatorIndex + 1);
      final fractionCursor = (selectionEnd - separatorIndex - 1).clamp(
        0,
        fractionText.length,
      );
      final typedFractionDigits = _logicalCharsBefore(
        fractionText,
        fractionCursor,
      ).clamp(0, decimalPlaces);
      final commaIndex = formatted.indexOf(',');
      selectionOffset = commaIndex + 1 + typedFractionDigits;
    } else {
      final logicalBefore = _logicalCharsBefore(newValue.text, selectionEnd);
      final commaIndex = formatted.indexOf(',');
      selectionOffset = _offsetForLogicalCount(
        formatted.substring(0, commaIndex),
        logicalBefore,
      ).clamp(0, commaIndex);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionOffset),
    );
  }

  bool _isSeparatorInsertion(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final oldSelection = oldValue.selection;
    if (!oldSelection.isValid) return false;

    if (!oldSelection.isCollapsed) {
      final replacement = newValue.text.replaceAll(RegExp(r'\s'), '');
      return replacement == ',' || replacement == '.';
    }

    final lengthDiff = newValue.text.length - oldValue.text.length;
    if (lengthDiff != 1) return false;

    final insertAt = oldSelection.end;
    if (insertAt < 0 || insertAt >= newValue.text.length) return false;

    final inserted = newValue.text[insertAt];
    if (inserted != ',' && inserted != '.') return false;

    final oldComma = _separatorIndex(oldValue.text);
    return oldComma < 0 || insertAt <= oldComma;
  }

  ({String integer, String fraction}) _parse(String text) {
    final normalized = text.replaceAll(RegExp(r'\s'), '').replaceAll('.', ',');

    var integerPart = '';
    var fractionPart = '';
    var hasComma = false;

    for (var i = 0; i < normalized.length; i++) {
      final char = normalized[i];
      if (char == ',') {
        if (!hasComma) hasComma = true;
        continue;
      }

      final isDigit = char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;
      if (!isDigit) continue;

      if (hasComma) {
        if (fractionPart.length >= decimalPlaces) continue;
        fractionPart += char;
      } else {
        integerPart += char;
      }
    }

    if (integerPart.length > 1) {
      integerPart = integerPart.replaceFirst(RegExp('^0+'), '');
    }
    if (integerPart.isEmpty) {
      integerPart = '0';
    }

    fractionPart = fractionPart
        .padRight(decimalPlaces, '0')
        .substring(0, decimalPlaces);

    return (integer: integerPart, fraction: fractionPart);
  }

  String _compose(String integerPart, String fractionPart) {
    return '${_formatWithSpaces(integerPart)},$fractionPart';
  }

  static int _separatorIndex(String text) {
    final comma = text.indexOf(',');
    if (comma >= 0) return comma;
    return text.indexOf('.');
  }

  static String _formatWithSpaces(String digits) {
    final buffer = StringBuffer();
    final length = digits.length;

    for (var i = 0; i < length; i++) {
      if (i > 0 && (length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }

    return buffer.toString();
  }

  /// Counts digits and decimal separators before [offset] in [text].
  /// Spaces and other characters are ignored, so the offset must refer to
  /// [text] itself (not a space-stripped copy).
  static int _logicalCharsBefore(String text, int offset) {
    var count = 0;
    final limit = offset.clamp(0, text.length);

    for (var i = 0; i < limit; i++) {
      final char = text[i];
      if (char == ',' ||
          char == '.' ||
          (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57)) {
        count++;
      }
    }

    return count;
  }

  static int _offsetForLogicalCount(String formatted, int logicalCount) {
    var count = 0;

    for (var i = 0; i < formatted.length; i++) {
      final char = formatted[i];
      if (char == ',' ||
          char == '.' ||
          (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57)) {
        if (count == logicalCount) return i;
        count++;
      }
    }

    return formatted.length;
  }

  static String formatAmount(double value, {int decimalPlaces = 2}) {
    final parts = value.toStringAsFixed(decimalPlaces).split('.');
    final integerPart = parts[0];
    final fractionPart = parts.length > 1 ? parts[1] : '';
    return '${_formatWithSpaces(integerPart)},$fractionPart';
  }

  static double? parseAmount(String formatted) {
    final trimmed = formatted.trim();
    if (trimmed.isEmpty) return null;

    final withoutSpaces = trimmed.replaceAll(RegExp(r'\s'), '');
    final normalized = withoutSpaces.replaceAll(',', '.');
    return double.tryParse(normalized);
  }
}
