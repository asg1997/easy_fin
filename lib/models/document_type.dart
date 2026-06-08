enum DocumentType {
  income,
  outcome,
  renterAssignment;

  String get label => switch (this) {
    DocumentType.income => 'Приход',
    DocumentType.outcome => 'Расход',
    DocumentType.renterAssignment => 'Начисление по аренде',
  };
}
