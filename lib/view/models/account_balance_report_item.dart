class AccountBalanceItem {
  const AccountBalanceItem({
    required this.name,
    required this.balance,
  });

  final String name;
  final double balance;
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
}
