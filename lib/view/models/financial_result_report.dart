class FinancialResultReport {
  const FinancialResultReport({
    required this.revenue,
    required this.expenses,
  });

  final double revenue;
  final double expenses;

  double get profit => revenue - expenses;

  static const empty = FinancialResultReport(revenue: 0, expenses: 0);
}
