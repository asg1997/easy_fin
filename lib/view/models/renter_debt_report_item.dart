class RenterDebtReportItem {
  const RenterDebtReportItem({
    required this.renterName,
    required this.baseName,
    required this.debt,
    required this.overpayment,
  });

  final String renterName;
  final String baseName;

  /// Сумма задолженности (положительный баланс начислений − оплат).
  final double debt;

  /// Сумма переплаты (отрицательный баланс начислений − оплат).
  final double overpayment;
}
