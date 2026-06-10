import 'package:easy_fin/data/bases_storage/bases_storage.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/utils/money.dart';
import 'package:easy_fin/view/models/account_balance_report_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    final balancesByAccountNumber = await _getLatestBalancesByAccountNumber();

    return bases
        .map((base) => _toReportItem(base, balancesByAccountNumber))
        .toList();
  }

  Future<Map<AccountNumber, double>> _getLatestBalancesByAccountNumber() async {
    final db = ref.read(appDatabaseProvider);
    final statementRows = await db.select(db.bankStatements).get();
    if (statementRows.isEmpty) return {};

    statementRows.sort((a, b) {
      final endDateCompare = b.endDate.compareTo(a.endDate);
      if (endDateCompare != 0) return endDateCompare;

      final startDateCompare = b.startDate.compareTo(a.startDate);
      if (startDateCompare != 0) return startDateCompare;

      return b.id.compareTo(a.id);
    });

    final balancesByAccountNumber = <AccountNumber, double>{};
    for (final row in statementRows) {
      balancesByAccountNumber.putIfAbsent(
        row.accountNumber,
        () => moneyFromMinor(row.finalBalanceMinor),
      );
    }

    return balancesByAccountNumber;
  }

  AccountBalanceReportItem _toReportItem(
    Base base,
    Map<AccountNumber, double> balancesByAccountNumber,
  ) {
    final accounts = base.accounts
        .map(
          (account) => AccountBalanceItem(
            name: account.displayName,
            balance: balancesByAccountNumber[account.accountNumber] ?? 0,
          ),
        )
        .toList();

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
