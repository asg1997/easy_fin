import 'package:easy_fin/models/document_type.dart';

class DocumentsTableItem {
  const DocumentsTableItem({
    required this.date,
    required this.documentType,
    required this.accountType,
    required this.baseName,
    required this.amount,
    required this.note,
    this.operationId,
    this.baseId,
    this.incomeDocumentId,
  }) : assert(
         operationId != null ||
             (baseId != null &&
                 documentType == DocumentType.renterAssignment) ||
             (incomeDocumentId != null &&
                 documentType == DocumentType.income),
         'Bank operations need operationId, rent accruals need baseId, '
         'manual incomes need incomeDocumentId',
       );

  final DateTime date;
  final DocumentType documentType;
  final String accountType;
  final String baseName;
  final double amount;
  final String note;
  final int? operationId;
  final String? baseId;
  final String? incomeDocumentId;

  bool get canDelete =>
      operationId != null || incomeDocumentId != null;

  bool get isRenterAssignmentDocument =>
      documentType == DocumentType.renterAssignment && baseId != null;

  bool get isManualIncomeDocument =>
      documentType == DocumentType.income && incomeDocumentId != null;
}
