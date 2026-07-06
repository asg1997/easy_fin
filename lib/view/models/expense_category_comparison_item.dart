class ExpenseCategoryComparisonItem {
  const ExpenseCategoryComparisonItem({
    required this.categoryName,
    required this.currentAmount,
    required this.previousAmount,
  });

  final String categoryName;
  final double currentAmount;
  final double previousAmount;
}
