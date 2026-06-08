class DocumentsTableItem {
  const DocumentsTableItem({
    required this.date,
    required this.accountType,
    required this.baseName,
    required this.amount,
  });

  final DateTime date;
  final String accountType;
  final String baseName;
  final double amount;
}
