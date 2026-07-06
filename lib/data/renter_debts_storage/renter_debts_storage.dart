import 'package:drift/drift.dart';
import 'package:easy_fin/data/bases_storage/bases_storage.dart';
import 'package:easy_fin/data/renters_storage/renters_storage.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:easy_fin/utils/money.dart';
import 'package:easy_fin/view/models/renter_debt_by_base_report_item.dart';
import 'package:easy_fin/view/models/renter_debt_monthly_report_item.dart';
import 'package:easy_fin/view/models/renter_debt_report_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final renterDebtsStorageProvider = Provider<RenterDebtsStorage>(
  RenterDebtsStorageImpl.new,
);

abstract class RenterDebtsStorage {
  Future<List<RenterDebtReportItem>> getReport({BaseId? baseId});

  Future<List<RenterDebtByBaseReportItem>> getReportByBase({BaseId? baseId});

  Future<List<RenterDebtMonthlyReportItem>> getMonthlyReport({
    required int year,
    BaseId? baseId,
  });
}

class RenterDebtsStorageImpl implements RenterDebtsStorage {
  const RenterDebtsStorageImpl(this.ref);

  final Ref ref;

  static const _sourceTypeRenter = 'renter';

  @override
  Future<List<RenterDebtReportItem>> getReport({BaseId? baseId}) async {
    final context = await _loadContext();
    if (context == null) return [];

    final items = <RenterDebtReportItem>[];
    for (final renter in context.activeRenters) {
      if (baseId != null && renter.baseId != baseId) continue;

      final key = _debtKey(renter.baseId, renter.id);
      final debtMinor = _debtMinorAt(
        key: key,
        endDate: DateTime.now(),
        accruals: context.accruals,
        payments: context.payments,
      );
      if (debtMinor <= 0) continue;

      items.add(
        RenterDebtReportItem(
          renterName: renter.name,
          baseName: context.baseNameById[renter.baseId] ?? '',
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

  @override
  Future<List<RenterDebtByBaseReportItem>> getReportByBase({
    BaseId? baseId,
  }) async {
    final context = await _loadContext();
    if (context == null) return [];

    final debtMinorByBaseId = <BaseId, int>{};
    for (final renter in context.activeRenters) {
      if (baseId != null && renter.baseId != baseId) continue;

      final key = _debtKey(renter.baseId, renter.id);
      final debtMinor = _debtMinorAt(
        key: key,
        endDate: DateTime.now(),
        accruals: context.accruals,
        payments: context.payments,
      );
      if (debtMinor <= 0) continue;

      debtMinorByBaseId[renter.baseId] =
          (debtMinorByBaseId[renter.baseId] ?? 0) + debtMinor;
    }

    final items = debtMinorByBaseId.entries
        .map(
          (entry) => RenterDebtByBaseReportItem(
            baseName: context.baseNameById[entry.key] ?? '',
            debt: moneyFromMinor(entry.value),
          ),
        )
        .toList();

    items.sort(
      (a, b) => a.baseName.toLowerCase().compareTo(b.baseName.toLowerCase()),
    );

    return items;
  }

  @override
  Future<List<RenterDebtMonthlyReportItem>> getMonthlyReport({
    required int year,
    BaseId? baseId,
  }) async {
    final context = await _loadContext();
    if (context == null) return [];

    final months = List.generate(12, (index) => DateTime(year, index + 1));

    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    return months.map((month) {
      final monthStart = DateTime(month.year, month.month);
      final isFutureMonth = monthStart.isAfter(currentMonth);

      if (isFutureMonth) {
        return RenterDebtMonthlyReportItem(
          month: month,
          debt: 0,
          isFutureMonth: true,
        );
      }

      final monthEnd = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
      var totalDebtMinor = 0;

      for (final renter in context.activeRenters) {
        if (baseId != null && renter.baseId != baseId) continue;

        final key = _debtKey(renter.baseId, renter.id);
        final debtMinor = _debtMinorAt(
          key: key,
          endDate: monthEnd,
          accruals: context.accruals,
          payments: context.payments,
        );
        if (debtMinor > 0) {
          totalDebtMinor += debtMinor;
        }
      }

      return RenterDebtMonthlyReportItem(
        month: month,
        debt: moneyFromMinor(totalDebtMinor),
        isFutureMonth: false,
      );
    }).toList();
  }

  Future<_RenterDebtsContext?> _loadContext() async {
    final bases = await ref.read(basesStorageProvider).getAll();
    if (bases.isEmpty) return null;

    final baseNameById = {for (final base in bases) base.id: base.name};

    final renters = await ref.read(rentersStorageProvider).getAll();
    final activeRenters =
        renters.where((renter) => !renter.isArchived).toList();
    if (activeRenters.isEmpty) return null;

    final db = ref.read(appDatabaseProvider);
    final accruals = await _getAccrualEvents(db);
    final payments = await _getPaymentEvents(db);

    return _RenterDebtsContext(
      baseNameById: baseNameById,
      activeRenters: activeRenters,
      accruals: accruals,
      payments: payments,
    );
  }

  Future<List<_DebtEvent>> _getAccrualEvents(AppDatabase db) async {
    final rows = await db.select(db.renterAssignments).get();
    return rows
        .map(
          (row) => _DebtEvent(
            key: _debtKey(row.baseId, row.renterId),
            date: row.date,
            amountMinor: row.amountMinor,
          ),
        )
        .toList();
  }

  Future<List<_DebtEvent>> _getPaymentEvents(AppDatabase db) async {
    final payments = <_DebtEvent>[];

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
      final documentById = {for (final header in headers) header.id: header};

      for (final line in incomeLines) {
        final header = documentById[line.documentId];
        final renterId = line.renterId;
        if (header == null || renterId == null) continue;

        payments.add(
          _DebtEvent(
            key: _debtKey(header.baseId, renterId),
            date: header.date,
            amountMinor: line.amountMinor,
          ),
        );
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

        payments.add(
          _DebtEvent(
            key: _debtKey(baseId, renterId),
            date: operation.date,
            amountMinor: creditMinor,
          ),
        );
      }
    }

    return payments;
  }

  int _debtMinorAt({
    required String key,
    required DateTime endDate,
    required List<_DebtEvent> accruals,
    required List<_DebtEvent> payments,
  }) {
    final accrualsMinor = accruals
        .where(
          (event) => event.key == key && !event.date.isAfter(endDate),
        )
        .fold<int>(0, (sum, event) => sum + event.amountMinor);

    final paymentsMinor = payments
        .where(
          (event) => event.key == key && !event.date.isAfter(endDate),
        )
        .fold<int>(0, (sum, event) => sum + event.amountMinor);

    return accrualsMinor - paymentsMinor;
  }

  String _debtKey(String baseId, String renterId) => '$baseId:$renterId';
}

class _RenterDebtsContext {
  const _RenterDebtsContext({
    required this.baseNameById,
    required this.activeRenters,
    required this.accruals,
    required this.payments,
  });

  final Map<BaseId, String> baseNameById;
  final List<Renter> activeRenters;
  final List<_DebtEvent> accruals;
  final List<_DebtEvent> payments;
}

class _DebtEvent {
  const _DebtEvent({
    required this.key,
    required this.date,
    required this.amountMinor,
  });

  final String key;
  final DateTime date;
  final int amountMinor;
}
