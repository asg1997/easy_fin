class RenterDebtMonthlyReportItem {
  const RenterDebtMonthlyReportItem({
    required this.month,
    required this.debt,
    this.isFutureMonth = false,
  });

  final DateTime month;
  final double debt;
  final bool isFutureMonth;
}
