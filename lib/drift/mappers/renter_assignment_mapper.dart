import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/models/renter_assignment.dart' as domain;
import 'package:easy_fin/utils/money.dart';

extension RenterAssignmentMapper on domain.RenterAssignment {
  RenterAssignmentsCompanion toCompanion() {
    return RenterAssignmentsCompanion(
      id: Value(id),
      baseId: Value(baseId),
      renterId: Value(renterId),
      accountNumber: Value(accountNumber),
      date: Value(date),
      amountMinor: Value(moneyToMinor(sum)),
      createdAt: Value(createdAt),
    );
  }
}

extension RenterAssignmentRowMapper on RenterAssignmentRow {
  domain.RenterAssignment toDomain() {
    return domain.RenterAssignment(
      id: id,
      createdAt: createdAt,
      baseId: baseId,
      renterId: renterId,
      accountNumber: accountNumber,
      date: date,
      sum: moneyFromMinor(amountMinor),
    );
  }
}
