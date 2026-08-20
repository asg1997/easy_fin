import 'package:drift/drift.dart';

/// Текстовая заметка (синхронизируется через файл БД)
@DataClassName('NoteRow')
class Notes extends Table {
  TextColumn get id => text()();

  /// Содержимое заметки (в domain-модели — поле `text`)
  TextColumn get content => text()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
