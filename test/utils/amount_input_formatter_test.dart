import 'package:easy_fin/utils/amount_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const formatter = AmountInputFormatter();

  TextEditingValue format(
    String oldText,
    String newText, {
    int? oldCursor,
    int? newCursor,
    int? oldSelectionStart,
  }) {
    final oldSelection = oldSelectionStart != null
        ? TextSelection(
            baseOffset: oldSelectionStart,
            extentOffset: oldCursor ?? oldText.length,
          )
        : TextSelection.collapsed(offset: oldCursor ?? oldText.length);
    return formatter.formatEditUpdate(
      TextEditingValue(text: oldText, selection: oldSelection),
      TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: newCursor ?? newText.length,
        ),
      ),
    );
  }

  group('AmountInputFormatter', () {
    test('always shows kopecks when typing digits', () {
      final result = format('', '5', newCursor: 1);
      expect(result.text, '5,00');
      expect(result.selection.baseOffset, 1);
    });

    test('keeps kopecks while appending integer digits', () {
      final result = format('5,00', '56,00', oldCursor: 1, newCursor: 2);
      expect(result.text, '56,00');
      expect(result.selection.baseOffset, 2);
    });

    test('formats thousands with spaces and keeps cursor in place', () {
      // Insert "2" after "1" in "1 34,00" → "1 234,00"
      final result = format(
        '134,00',
        '1234,00',
        oldCursor: 1,
        newCursor: 2,
      );
      expect(result.text, '1 234,00');
      expect(result.selection.baseOffset, 3);
    });

    test('deleting a middle digit keeps cursor at the edit point', () {
      // Delete "2" from "1 234,00" (cursor after 2)
      final result = format(
        '1 234,00',
        '1 34,00',
        oldCursor: 3,
        newCursor: 2,
      );
      expect(result.text, '134,00');
      expect(result.selection.baseOffset, 1);
    });

    test('inserting digit in the middle keeps cursor after inserted digit', () {
      final result = format(
        '134,00',
        '1234,00',
        oldCursor: 1,
        newCursor: 2,
      );
      expect(result.text, '1 234,00');
      expect(result.selection.baseOffset, 3);
    });

    test('typing separator selects kopecks', () {
      final result = format(
        '56,00',
        '56,,00',
        oldCursor: 2,
        newCursor: 3,
      );
      expect(result.text, '56,00');
      expect(result.selection.baseOffset, 3);
      expect(result.selection.extentOffset, 5);
    });

    test('editing kopecks after separator', () {
      final result = format(
        '56,00',
        '56,50',
        oldCursor: 3,
        newCursor: 4,
        oldSelectionStart: 3,
      );
      expect(result.text, '56,50');
      expect(result.selection.baseOffset, 4);
    });

    test('replacing full selection with a digit', () {
      final result = format(
        '1 234,00',
        '5',
        oldCursor: 8,
        newCursor: 1,
        oldSelectionStart: 0,
      );
      expect(result.text, '5,00');
      expect(result.selection.baseOffset, 1);
    });

    test('formatAmount and parseAmount round-trip', () {
      expect(AmountInputFormatter.formatAmount(1234.5), '1 234,50');
      expect(AmountInputFormatter.parseAmount('1 234,50'), 1234.5);
    });
  });
}
