const accountNumberLength = 20;

bool isValidAccountNumber(String accountNumber) {
  return normalizeAccountNumber(accountNumber).length == accountNumberLength;
}

String normalizeAccountNumber(String accountNumber) {
  final digits = accountNumber.replaceAll(RegExp(r'\D'), '');
  if (digits.length == accountNumberLength) return digits;
  return accountNumber.trim();
}
