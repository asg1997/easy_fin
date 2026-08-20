import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/drift/mappers/note_mapper.dart';
import 'package:easy_fin/models/note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final notesStorageProvider = Provider<NotesStorage>(
  NotesStorageImpl.new,
);

sealed class NotesStorageError implements Exception {
  const NotesStorageError();
}

class NoteNotFoundError extends NotesStorageError {
  const NoteNotFoundError();
}

class NoteEmptyTextError extends NotesStorageError {
  const NoteEmptyTextError();
}

abstract class NotesStorage {
  Future<List<Note>> getAll();

  Future<Note> create(String text);

  Future<Note> update(NoteId id, String text);

  Future<void> delete(NoteId id);
}

class NotesStorageImpl implements NotesStorage {
  const NotesStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<List<Note>> getAll() async {
    final db = ref.read(appDatabaseProvider);
    final query = db.select(db.notes)
      ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);
    final rows = await query.get();
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<Note> create(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw const NoteEmptyTextError();
    }

    final now = DateTime.now();
    final note = Note(
      id: const Uuid().v4(),
      text: trimmed,
      createdAt: now,
      updatedAt: now,
    );

    final db = ref.read(appDatabaseProvider);
    await db.into(db.notes).insert(note.toCompanion());
    return note;
  }

  @override
  Future<Note> update(NoteId id, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw const NoteEmptyTextError();
    }

    final db = ref.read(appDatabaseProvider);
    final existing = await (db.select(db.notes)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    if (existing == null) {
      throw const NoteNotFoundError();
    }

    final updated = existing.toDomain().copyWith(
          text: trimmed,
          updatedAt: DateTime.now(),
        );
    await db.into(db.notes).insertOnConflictUpdate(updated.toCompanion());
    return updated;
  }

  @override
  Future<void> delete(NoteId id) async {
    final db = ref.read(appDatabaseProvider);
    final deleted = await (db.delete(db.notes)
          ..where((table) => table.id.equals(id)))
        .go();
    if (deleted == 0) {
      throw const NoteNotFoundError();
    }
  }
}
