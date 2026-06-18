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
  }) : assert(
         operationId != null ||
             (baseId != null &&
                 documentType == DocumentType.renterAssignment),
         'Bank operations need operationId, rent accruals need baseId',
       );

  final DateTime date;
  final DocumentType documentType;
  final String accountType;
  final String baseName;
  final double amount;
  final String note;
  final int? operationId;
  final String? baseId;

  bool get canDelete => operationId != null;

  bool get isRenterAssignmentDocument =>
      documentType == DocumentType.renterAssignment && baseId != null;
}
