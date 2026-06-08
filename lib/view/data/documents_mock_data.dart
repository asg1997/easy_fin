import 'package:easy_fin/models/document_type.dart';
import 'package:easy_fin/view/models/documents_table_item.dart';

final documentsMockData = [
  DocumentsTableItem(
    date: DateTime(2026, 3, 15),
    documentType: DocumentType.income,
    accountType: 'Банк',
    baseName: 'ООО Альфа',
    amount: 125_000,
  ),
  DocumentsTableItem(
    date: DateTime(2026, 3, 12),
    documentType: DocumentType.outcome,
    accountType: 'Касса',
    baseName: 'ИП Иванов',
    amount: 18_500.50,
  ),
  DocumentsTableItem(
    date: DateTime(2026, 3, 8),
    documentType: DocumentType.renterAssignment,
    accountType: 'Банк',
    baseName: 'ООО Бета',
    amount: 74_320,
  ),
  DocumentsTableItem(
    date: DateTime(2026, 2, 28),
    documentType: DocumentType.income,
    accountType: 'Касса',
    baseName: 'ООО Альфа',
    amount: 9_750,
  ),
  DocumentsTableItem(
    date: DateTime(2026, 2, 20),
    documentType: DocumentType.outcome,
    accountType: 'Банк',
    baseName: 'ИП Петров',
    amount: 210_400,
  ),
];
