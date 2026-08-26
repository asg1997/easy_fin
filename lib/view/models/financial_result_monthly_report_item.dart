class FinancialResultMonthlyReportItem {
  const FinancialResultMonthlyReportItem({
    required this.month,
    required this.revenue,
    required this.expenses,
    this.isFutureMonth = false,
  });

  final DateTime month;
  final double revenue;
  final double expenses;
  final bool isFutureMonth;

  double get profit => revenue - expenses;
}
