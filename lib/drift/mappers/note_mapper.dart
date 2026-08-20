import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/models/note.dart' as domain;

extension NoteMapper on domain.Note {
  NotesCompanion toCompanion() {
    return NotesCompanion(
      id: Value(id),
      content: Value(text),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
}

extension NoteRowMapper on NoteRow {
  domain.Note toDomain() {
    return domain.Note(
      id: id,
      text: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
