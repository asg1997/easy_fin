import 'package:easy_fin/data/bases_storage/bases_storage.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/models/account_filter_type.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/utils/money.dart';
import 'package:easy_fin/view/models/account_balance_report_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _accountTypeCash = 'cash';

final accountBalancesStorageProvider = Provider<AccountBalancesStorage>(
  AccountBalancesStorageImpl.new,
);

abstract class AccountBalancesStorage {
  Future<List<AccountBalanceReportItem>> getReport();
}

class AccountBalancesStorageImpl implements AccountBalancesStorage {
  const AccountBalancesStorageImpl(this.ref);

  final Ref ref;

  @override
  Future<List<AccountBalanceReportItem>> getReport() async {
    final bases = await ref.read(basesStorageProvider).getAll();
    if (bases.isEmpty) return [];

    final balancesByAccountNumber = await _getBalancesByAccountNumber();
    final cashBalancesByBaseId = await _getCashBalancesByBaseId();

    return bases
        .map(
          (base) => _toReportItem(
            base,
            balancesByAccountNumber,
            cashBalancesByBaseId,
          ),
        )
        .toList();
  }

  Future<Map<BaseId, double>> _getCashBalancesByBaseId() async {
    final db = ref.read(appDatabaseProvider);
    final cashIncomeDocuments = await (db.select(db.incomeDocuments)
          ..where((table) => table.accountType.equals(_accountTypeCash)))
        .get();
    final cashExpenseDocuments = await (db.select(db.expenseDocuments)
          ..where((table) => table.accountType.equals(_accountTypeCash)))
        .get();

    if (cashIncomeDocuments.isEmpty && cashExpenseDocuments.isEmpty) {
      return {};
    }

    final incomeDocumentIds =
        cashIncomeDocuments.map((document) => document.id).toList();
    final expenseDocumentIds =
        cashExpenseDocuments.map((document) => document.id).toList();

    final incomeLines = incomeDocumentIds.isEmpty
        ? <IncomeLineRow>[]
        : await (db.select(db.incomeLines)
              ..where((table) => table.documentId.isIn(incomeDocumentIds)))
            .get();
    final expenseLines = expenseDocumentIds.isEmpty
        ? <ExpenseLineRow>[]
        : await (db.select(db.expenseLines)
              ..where((table) => table.documentId.isIn(expenseDocumentIds)))
            .get();

    final baseIdByIncomeDocumentId = {
      for (final document in cashIncomeDocuments) document.id: document.baseId,
    };
    final baseIdByExpenseDocumentId = {
      for (final document in cashExpenseDocuments) document.id: document.baseId,
    };

    final balancesByBaseId = <BaseId, double>{};
    for (final line in incomeLines) {
      final baseId = baseIdByIncomeDocumentId[line.documentId];
      if (baseId == null) continue;

      balancesByBaseId[baseId] =
          (balancesByBaseId[baseId] ?? 0) + moneyFromMinor(line.amountMinor);
    }
    for (final line in expenseLines) {
      final baseId = baseIdByExpenseDocumentId[line.documentId];
      if (baseId == null) continue;

      balancesByBaseId[baseId] =
          (balancesByBaseId[baseId] ?? 0) - moneyFromMinor(line.amountMinor);
    }

    return balancesByBaseId;
  }

  Future<Map<AccountNumber, double>> _getBalancesByAccountNumber() async {
    final db = ref.read(appDatabaseProvider);
    final statementRows = await db.select(db.bankStatements).get();
    if (statementRows.isEmpty) return {};

    final latestStatementByAccount = <AccountNumber, BankStatementRow>{};
    final earliestStatementByAccount = <AccountNumber, BankStatementRow>{};

    for (final row in statementRows) {
      final accountNumber = row.accountNumber;

      final latest = latestStatementByAccount[accountNumber];
      if (latest == null || _isLaterStatement(row, latest)) {
        latestStatementByAccount[accountNumber] = row;
      }

      final earliest = earliestStatementByAccount[accountNumber];
      if (earliest == null || _isEarlierStatement(row, earliest)) {
        earliestStatementByAccount[accountNumber] = row;
      }
    }

    return {
      for (final entry in latestStatementByAccount.entries)
        entry.key: _resolveAccountBalance(
          latestStatement: entry.value,
          earliestInitialBalance: moneyFromMinor(
            earliestStatementByAccount[entry.key]!.initialBalanceMinor,
          ),
        ),
    };
  }

  bool _isLaterStatement(BankStatementRow a, BankStatementRow b) {
    final endDateCompare = a.endDate.compareTo(b.endDate);
    if (endDateCompare != 0) return endDateCompare > 0;

    final startDateCompare = a.startDate.compareTo(b.startDate);
    if (startDateCompare != 0) return startDateCompare > 0;

    return a.id > b.id;
  }

  bool _isEarlierStatement(BankStatementRow a, BankStatementRow b) {
    final startDateCompare = a.startDate.compareTo(b.startDate);
    if (startDateCompare != 0) return startDateCompare < 0;

    final endDateCompare = a.endDate.compareTo(b.endDate);
    if (endDateCompare != 0) return endDateCompare < 0;

    return a.id < b.id;
  }

  double _resolveAccountBalance({
    required BankStatementRow latestStatement,
    required double? earliestInitialBalance,
  }) {
    final finalBalance = moneyFromMinor(latestStatement.finalBalanceMinor);
    if (moneyToMinor(finalBalance) != 0) {
      return finalBalance;
    }

    final latestInitial = moneyFromMinor(latestStatement.initialBalanceMinor);
    if (moneyToMinor(latestInitial) != 0) {
      return latestInitial;
    }

    return earliestInitialBalance ?? 0;
  }

  AccountBalanceReportItem _toReportItem(
    Base base,
    Map<AccountNumber, double> balancesByAccountNumber,
    Map<BaseId, double> cashBalancesByBaseId,
  ) {
    final accounts = [
      AccountBalanceItem(
        name: AccountFilterType.cash.label,
        balance: cashBalancesByBaseId[base.id] ?? 0,
      ),
      ...base.accounts.map(
        (account) => AccountBalanceItem(
          name: account.displayName,
          balance: balancesByAccountNumber[account.accountNumber] ?? 0,
        ),
      ),
    ];

    final totalBalance = accounts.fold<double>(
      0,
      (sum, account) => sum + account.balance,
    );

    return AccountBalanceReportItem(
      baseName: base.name,
      balance: totalBalance,
      accounts: accounts,
    );
  }
}
