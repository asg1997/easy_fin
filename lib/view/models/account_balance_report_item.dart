class AccountBalanceItem {
  const AccountBalanceItem({
    required this.name,
    required this.balance,
    required this.isCash,
  });

  final String name;
  final double balance;
  final bool isCash;
}

class AccountBalanceReportItem {
  const AccountBalanceReportItem({
    required this.baseName,
    required this.balance,
    required this.accounts,
  });

  final String baseName;
  final double balance;
  final List<AccountBalanceItem> accounts;

  double get cashBalance => accounts
      .where((account) => account.isCash)
      .fold<double>(0, (sum, account) => sum + account.balance);

  double get bankBalance => accounts
      .where((account) => !account.isCash)
      .fold<double>(0, (sum, account) => sum + account.balance);
}
