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
    this.expenseDocumentId,
  }) : assert(
         operationId != null ||
             (baseId != null &&
                 documentType == DocumentType.renterAssignment) ||
             (incomeDocumentId != null &&
                 documentType == DocumentType.income) ||
             (expenseDocumentId != null &&
                 documentType == DocumentType.outcome),
         'Bank operations need operationId, rent accruals need baseId, '
         'manual incomes need incomeDocumentId, '
         'manual outcomes need expenseDocumentId',
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
  final String? expenseDocumentId;

  bool get canDelete =>
      operationId != null ||
      incomeDocumentId != null ||
      expenseDocumentId != null ||
      isRenterAssignmentDocument;

  bool get isRenterAssignmentDocument =>
      documentType == DocumentType.renterAssignment && baseId != null;

  bool get isManualIncomeDocument =>
      documentType == DocumentType.income && incomeDocumentId != null;

  bool get isManualExpenseDocument =>
      documentType == DocumentType.outcome && expenseDocumentId != null;

  bool get isBankOperation => operationId != null;
}
