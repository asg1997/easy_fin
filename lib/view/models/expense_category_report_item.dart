class ExpenseCategoryReportItem {
  const ExpenseCategoryReportItem({
    required this.categoryName,
    required this.amount,
    required this.percentage,
  });

  final String categoryName;
  final double amount;
  final double percentage;
}
