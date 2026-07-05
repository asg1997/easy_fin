enum DocumentType {
  income,
  outcome,
  renterAssignment;

  String get label => switch (this) {
    DocumentType.income => 'Приход',
    DocumentType.outcome => 'Расход',
    DocumentType.renterAssignment => 'Начисление по аренде',
  };

  String get tabLabel => switch (this) {
    DocumentType.income => 'Приход',
    DocumentType.outcome => 'Расход',
    DocumentType.renterAssignment => 'Начисления',
  };

  static const List<DocumentType> tabOrder = [
    DocumentType.outcome,
    DocumentType.income,
    DocumentType.renterAssignment,
  ];
}
