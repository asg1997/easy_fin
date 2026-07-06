class ExpenseMonthlyReportItem {
  const ExpenseMonthlyReportItem({
    required this.month,
    required this.amount,
    this.isFutureMonth = false,
  });

  final DateTime month;
  final double amount;
  final bool isFutureMonth;
}
