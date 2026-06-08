enum AccountFilterType {
  cash,
  bank;

  String get label => switch (this) {
    AccountFilterType.cash => 'Касса',
    AccountFilterType.bank => 'Банк',
  };
}
