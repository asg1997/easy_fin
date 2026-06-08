import 'package:easy_fin/view/models/documents_table_item.dart';

final documentsMockData = [
  DocumentsTableItem(
    date: DateTime(2026, 3, 15),
    accountType: 'Банк',
    baseName: 'ООО Альфа',
    amount: 125_000,
  ),
  DocumentsTableItem(
    date: DateTime(2026, 3, 12),
    accountType: 'Касса',
    baseName: 'ИП Иванов',
    amount: 18_500.50,
  ),
  DocumentsTableItem(
    date: DateTime(2026, 3, 8),
    accountType: 'Банк',
    baseName: 'ООО Бета',
    amount: 74_320,
  ),
  DocumentsTableItem(
    date: DateTime(2026, 2, 28),
    accountType: 'Касса',
    baseName: 'ООО Альфа',
    amount: 9_750,
  ),
  DocumentsTableItem(
    date: DateTime(2026, 2, 20),
    accountType: 'Банк',
    baseName: 'ИП Петров',
    amount: 210_400,
  ),
];
