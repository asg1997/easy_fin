import 'package:easy_fin/models/document_type.dart';

class DocumentsTableItem {
  const DocumentsTableItem({
    required this.operationId,
    required this.date,
    required this.documentType,
    required this.accountType,
    required this.baseName,
    required this.amount,
    required this.note,
  });

  final int operationId;
  final DateTime date;
  final DocumentType documentType;
  final String accountType;
  final String baseName;
  final double amount;
  final String note;
}
