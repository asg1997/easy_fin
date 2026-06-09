const accountNumberLength = 20;

bool isValidAccountNumber(String accountNumber) {
  return accountNumber.trim().length == accountNumberLength;
}
