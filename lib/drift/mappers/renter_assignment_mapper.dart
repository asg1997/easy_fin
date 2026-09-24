import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/models/renter_assignment.dart' as domain;
import 'package:easy_fin/utils/money.dart';

extension RenterAssignmentDocumentMapper on domain.RenterAssignmentDocument {
  RenterAssignmentDocumentsCompanion toHeaderCompanion() {
    return RenterAssignmentDocumentsCompanion(
      id: Value(id),
      baseId: Value(baseId),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  List<RenterAssignmentsCompanion> toLineCompanions() {
    return lines
        .map(
          (line) => line.toCompanion(
            documentId: id,
            createdAt: createdAt,
          ),
        )
        .toList();
  }
}

extension RenterAssignmentLineMapper on domain.RenterAssignmentLine {
  RenterAssignmentsCompanion toCompanion({
    required String documentId,
    required DateTime createdAt,
  }) {
    return RenterAssignmentsCompanion(
      id: Value(id),
      documentId: Value(documentId),
      renterId: Value(renterId),
      accountNumber: Value(accountNumber),
      amountMinor: Value(moneyToMinor(sum)),
      createdAt: Value(createdAt),
    );
  }
}

extension RenterAssignmentDocumentRowMapper on RenterAssignmentDocumentRow {
  domain.RenterAssignmentDocument toDomain(List<RenterAssignmentRow> lineRows) {
    return domain.RenterAssignmentDocument(
      id: id,
      createdAt: createdAt,
      baseId: baseId,
      date: date,
      lines: lineRows.map((row) => row.toDomain()).toList(),
    );
  }
}

extension RenterAssignmentRowMapper on RenterAssignmentRow {
  domain.RenterAssignmentLine toDomain() {
    return domain.RenterAssignmentLine(
      id: id,
      renterId: renterId,
      accountNumber: accountNumber,
      sum: moneyFromMinor(amountMinor),
    );
  }
}
