import 'package:drift/drift.dart';
import 'package:easy_fin/data/bases_storage/bases_storage.dart';
import 'package:easy_fin/data/renters_storage/renters_storage.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/utils/money.dart';
import 'package:easy_fin/view/models/renter_debt_report_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final renterDebtsStorageProvider = Provider<RenterDebtsStorage>(
  RenterDebtsStorageImpl.new,
);

abstract class RenterDebtsStorage {
  Future<List<RenterDebtReportItem>> getReport();
}

class RenterDebtsStorageImpl implements RenterDebtsStorage {
  const RenterDebtsStorageImpl(this.ref);

  final Ref ref;

  static const _sourceTypeRenter = 'renter';

  @override
  Future<List<RenterDebtReportItem>> getReport() async {
    final bases = await ref.read(basesStorageProvider).getAll();
    if (bases.isEmpty) return [];

    final baseNameById = {for (final base in bases) base.id: base.name};

    final renters = await ref.read(rentersStorageProvider).getAll();
    final activeRenters =
        renters.where((renter) => !renter.isArchived).toList();
    if (activeRenters.isEmpty) return [];

    final db = ref.read(appDatabaseProvider);

    final accrualsByKey = await _getAccrualsByKey(db);
    final paymentsByKey = await _getPaymentsByKey(db);

    final items = <RenterDebtReportItem>[];
    for (final renter in activeRenters) {
      final key = _debtKey(renter.baseId, renter.id);
      final debtMinor = (accrualsByKey[key] ?? 0) - (paymentsByKey[key] ?? 0);
      if (debtMinor <= 0) continue;

      items.add(
        RenterDebtReportItem(
          renterName: renter.name,
          baseName: baseNameById[renter.baseId] ?? '',
          debt: moneyFromMinor(debtMinor),
        ),
      );
    }

    items.sort((a, b) {
      final baseCompare = a.baseName.toLowerCase().compareTo(
        b.baseName.toLowerCase(),
      );
      if (baseCompare != 0) return baseCompare;

      return a.renterName.toLowerCase().compareTo(b.renterName.toLowerCase());
    });

    return items;
  }

  Future<Map<String, int>> _getAccrualsByKey(AppDatabase db) async {
    final rows = await db.select(db.renterAssignments).get();
    final accrualsByKey = <String, int>{};

    for (final row in rows) {
      final key = _debtKey(row.baseId, row.renterId);
      accrualsByKey[key] = (accrualsByKey[key] ?? 0) + row.amountMinor;
    }

    return accrualsByKey;
  }

  Future<Map<String, int>> _getPaymentsByKey(AppDatabase db) async {
    final paymentsByKey = <String, int>{};

    final incomeLines = await (db.select(db.incomeLines)..where(
      (table) =>
          table.sourceType.equals(_sourceTypeRenter) &
          table.renterId.isNotNull(),
    )).get();

    if (incomeLines.isNotEmpty) {
      final documentIds = incomeLines.map((line) => line.documentId).toSet();
      final headers = await (db.select(db.incomeDocuments)
            ..where((table) => table.id.isIn(documentIds.toList())))
          .get();
      final baseIdByDocumentId = {
        for (final header in headers) header.id: header.baseId,
      };

      for (final line in incomeLines) {
        final baseId = baseIdByDocumentId[line.documentId];
        final renterId = line.renterId;
        if (baseId == null || renterId == null) continue;

        final key = _debtKey(baseId, renterId);
        paymentsByKey[key] = (paymentsByKey[key] ?? 0) + line.amountMinor;
      }
    }

    final bankOperations = await (db.select(db.bankStatementOperations)..where(
      (table) =>
          table.renterId.isNotNull() & table.creditMinor.isNotNull(),
    )).get();

    if (bankOperations.isNotEmpty) {
      final statementIds =
          bankOperations.map((operation) => operation.statementId).toSet();
      final statements = await (db.select(db.bankStatements)
            ..where((table) => table.id.isIn(statementIds.toList())))
          .get();
      final baseIdByStatementId = {
        for (final statement in statements) statement.id: statement.baseId,
      };

      for (final operation in bankOperations) {
        final baseId = baseIdByStatementId[operation.statementId];
        final renterId = operation.renterId;
        final creditMinor = operation.creditMinor;
        if (baseId == null || renterId == null || creditMinor == null) {
          continue;
        }

        final key = _debtKey(baseId, renterId);
        paymentsByKey[key] = (paymentsByKey[key] ?? 0) + creditMinor;
      }
    }

    return paymentsByKey;
  }

  String _debtKey(String baseId, String renterId) => '$baseId:$renterId';
}
