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
    this.renterAssignmentDocumentId,
    this.incomeDocumentId,
    this.expenseDocumentId,
  }) : assert(
         operationId != null ||
             (renterAssignmentDocumentId != null &&
                 documentType == DocumentType.renterAssignment) ||
             (incomeDocumentId != null &&
                 documentType == DocumentType.income) ||
             (expenseDocumentId != null &&
                 documentType == DocumentType.outcome),
         'Bank operations need operationId, rent accruals need '
         'renterAssignmentDocumentId, manual incomes need incomeDocumentId, '
         'manual outcomes need expenseDocumentId',
       );

  final DateTime date;
  final DocumentType documentType;
  final String accountType;
  final String baseName;
  final double amount;
  final String note;
  final int? operationId;
  final String? renterAssignmentDocumentId;
  final String? incomeDocumentId;
  final String? expenseDocumentId;

  bool get canDelete =>
      operationId != null ||
      incomeDocumentId != null ||
      expenseDocumentId != null ||
      isRenterAssignmentDocument;

  bool get isRenterAssignmentDocument =>
      documentType == DocumentType.renterAssignment &&
      renterAssignmentDocumentId != null;

  bool get isManualIncomeDocument =>
      documentType == DocumentType.income && incomeDocumentId != null;

  bool get isManualExpenseDocument =>
      documentType == DocumentType.outcome && expenseDocumentId != null;

  bool get isBankOperation => operationId != null;

  String get selectionKey {
    if (operationId != null) return 'operation:$operationId';
    if (incomeDocumentId != null) return 'income:$incomeDocumentId';
    if (expenseDocumentId != null) return 'expense:$expenseDocumentId';
    return 'renterAssignment:$renterAssignmentDocumentId';
  }
}
