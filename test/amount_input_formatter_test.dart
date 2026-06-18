import 'package:easy_fin/utils/amount_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  test('formatAmount formats with regular spaces', () {
    expect(AmountInputFormatter.formatAmount(10000), '10 000,00');
  });

  test('parseAmount parses formatted amount', () {
    expect(AmountInputFormatter.parseAmount('10 000,00'), 10000);
  });

  test('parseAmount parses NumberFormat ru output', () {
    final formatted = NumberFormat('#,##0.00', 'ru').format(10000);
    expect(AmountInputFormatter.parseAmount(formatted), 10000);
  });
}
