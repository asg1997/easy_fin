class ExpenseBaseReportItem {
  const ExpenseBaseReportItem({
    required this.baseName,
    required this.amount,
    required this.percentage,
  });

  final String baseName;
  final double amount;
  final double percentage;
}
