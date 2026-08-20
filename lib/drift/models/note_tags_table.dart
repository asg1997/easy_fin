import 'package:drift/drift.dart';
import 'package:easy_fin/drift/models/notes_table.dart';

/// Связь заметка ↔ тег (sync через файл БД)
@DataClassName('NoteTagRow')
class NoteTags extends Table {
  TextColumn get noteId =>
      text().references(Notes, #id, onDelete: KeyAction.cascade)();

  TextColumn get tagName => text()();

  @override
  Set<Column> get primaryKey => {noteId, tagName};
}
