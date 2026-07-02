import 'package:easy_fin/data/bank_statements_importing/bank_statement_parser/sber_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SberParser counterparty cell', () {
    test('extracts account, inn and name from multiline value', () {
      final parser = SberParser();
      final result = parser.parseCounterpartyCell(
        '40702810999999999999\n7701234567\nООО "Ромашка"',
      );

      expect(result.$1, '7701234567');
      expect(result.$2, '40702810999999999999');
      expect(result.$3, 'ООО "Ромашка"');
    });

    test('returns empty values for blank cell', () {
      final parser = SberParser();
      final result = parser.parseCounterpartyCell('');

      expect(result.$1, isEmpty);
      expect(result.$2, isEmpty);
      expect(result.$3, isEmpty);
    });
  });
}
