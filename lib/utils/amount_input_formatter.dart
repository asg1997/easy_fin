import 'package:flutter/services.dart';

class AmountInputFormatter extends TextInputFormatter {
  const AmountInputFormatter({this.decimalPlaces = 2});

  final int decimalPlaces;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final normalized = newValue.text.replaceAll(' ', '').replaceAll('.', ',');
    if (normalized.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    var integerPart = '';
    String? fractionPart;
    var hasComma = false;

    for (var i = 0; i < normalized.length; i++) {
      final char = normalized[i];
      if (char == ',') {
        if (hasComma) continue;
        hasComma = true;
        fractionPart = '';
        continue;
      }

      final isDigit = char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;
      if (!isDigit) continue;

      if (hasComma) {
        if ((fractionPart?.length ?? 0) >= decimalPlaces) continue;
        fractionPart = '${fractionPart ?? ''}$char';
      } else {
        integerPart += char;
      }
    }

    if (integerPart.length > 1) {
      integerPart = integerPart.replaceFirst(RegExp(r'^0+'), '');
    }
    if (integerPart.isEmpty && !hasComma) {
      integerPart = '0';
    }

    final formattedInteger = integerPart.isEmpty
        ? '0'
        : _formatWithSpaces(integerPart);

    final formatted = hasComma
        ? '$formattedInteger,${fractionPart ?? ''}'
        : formattedInteger;

    if (formatted == newValue.text && newValue.selection.isValid) {
      return newValue;
    }

    final logicalBeforeCursor = _logicalCharsBefore(
      normalized,
      newValue.selection.end,
    );
    final selectionOffset = _offsetForLogicalCount(
      formatted,
      logicalBeforeCursor,
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionOffset),
    );
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

  static int _logicalCharsBefore(String text, int offset) {
    var count = 0;
    final limit = offset.clamp(0, text.length);

    for (var i = 0; i < limit; i++) {
      final char = text[i];
      if (char == ',' || (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57)) {
        count++;
      }
    }

    return count;
  }

  static int _offsetForLogicalCount(String formatted, int logicalCount) {
    var count = 0;

    for (var i = 0; i < formatted.length; i++) {
      final char = formatted[i];
      if (char == ',' || (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57)) {
        if (count == logicalCount) return i;
        count++;
      }
    }

    return formatted.length;
  }

  static double? parseAmount(String formatted) {
    final trimmed = formatted.trim();
    if (trimmed.isEmpty) return null;

    final normalized = trimmed.replaceAll(' ', '').replaceAll(',', '.');
    return double.tryParse(normalized);
  }
}
