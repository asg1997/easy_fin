class FinancialResultBaseReportItem {
  const FinancialResultBaseReportItem({
    required this.baseName,
    required this.revenue,
    required this.expenses,
  });

  final String baseName;
  final double revenue;
  final double expenses;

  double get profit => revenue - expenses;
}
