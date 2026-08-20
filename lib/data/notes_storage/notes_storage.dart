import 'package:drift/drift.dart';
import 'package:easy_fin/drift/db/app_database.dart';
import 'package:easy_fin/drift/db/app_database_provider.dart';
import 'package:easy_fin/drift/mappers/note_mapper.dart';
import 'package:easy_fin/models/note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final notesStorageProvider = Provider<NotesStorage>(
  NotesStorageImpl.new,
);

const int noteTagMaxLength = 40;

sealed class NotesStorageError implements Exception {
  const NotesStorageError();
}

class NoteNotFoundError extends NotesStorageError {
  const NoteNotFoundError();
}

class NoteEmptyTextError extends NotesStorageError {
  const NoteEmptyTextError();
}

class NoteTagEmptyError extends NotesStorageError {
  const NoteTagEmptyError();
}

class NoteTagTooLongError extends NotesStorageError {
  const NoteTagTooLongError();
}

class NoteTagInvalidError extends NotesStorageError {
  const NoteTagInvalidError();
}

abstract class NotesStorage {
  Future<List<Note>> getAll({String? tagFilter, String? textQuery});

  Future<List<String>> getAllTags();

  Future<Note> create(String text);

  Future<Note> update(NoteId id, String text);

  Future<void> delete(NoteId id);

  Future<Note> addTag(NoteId id, String tagName);

  Future<Note> removeTag(NoteId id, String tagName);
}

class NotesStorageImpl implements NotesStorage {
  const NotesStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<List<Note>> getAll({String? tagFilter, String? textQuery}) async {
    final db = ref.read(appDatabaseProvider);
    final query = db.select(db.notes)
      ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);
    final rows = await query.get();
    final tagsByNoteId = await _tagsByNoteId(db);

    var notes = rows
        .map(
          (row) => row.toDomain(
            tags: _sortedTags(tagsByNoteId[row.id] ?? const []),
          ),
        )
        .toList();

    final filter = tagFilter?.trim();
    if (filter != null && filter.isNotEmpty) {
      final filterLower = filter.toLowerCase();
      notes = notes
          .where(
            (note) => note.tags.any(
              (tag) => tag.toLowerCase() == filterLower,
            ),
          )
          .toList();
    }

    final text = textQuery?.trim();
    if (text != null && text.isNotEmpty) {
      final textLower = text.toLowerCase();
      notes = notes
          .where((note) => note.text.toLowerCase().contains(textLower))
          .toList();
    }

    return notes;
  }

  @override
  Future<List<String>> getAllTags() async {
    final db = ref.read(appDatabaseProvider);
    final rows = await db.select(db.noteTags).get();
    final byLower = <String, String>{};
    for (final row in rows) {
      final lower = row.tagName.toLowerCase();
      byLower.putIfAbsent(lower, () => row.tagName);
    }
    final tags = byLower.values.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return tags;
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

    final tags = await _tagsForNote(db, id);
    final updated = existing.toDomain(tags: tags).copyWith(
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

  @override
  Future<Note> addTag(NoteId id, String tagName) async {
    final normalized = _normalizeTagName(tagName);
    final db = ref.read(appDatabaseProvider);

    final existing = await (db.select(db.notes)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    if (existing == null) {
      throw const NoteNotFoundError();
    }

    final currentTags = await _tagsForNote(db, id);
    final alreadyHas = currentTags.any(
      (tag) => tag.toLowerCase() == normalized.toLowerCase(),
    );
    if (!alreadyHas) {
      await db.into(db.noteTags).insert(
            NoteTagsCompanion.insert(
              noteId: id,
              tagName: normalized,
            ),
          );
      currentTags.add(normalized);
    }

    return existing.toDomain(tags: _sortedTags(currentTags));
  }

  @override
  Future<Note> removeTag(NoteId id, String tagName) async {
    final db = ref.read(appDatabaseProvider);

    final existing = await (db.select(db.notes)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    if (existing == null) {
      throw const NoteNotFoundError();
    }

    final targetLower = tagName.trim().toLowerCase();
    await (db.delete(db.noteTags)..where(
          (table) =>
              table.noteId.equals(id) &
              table.tagName.lower().equals(targetLower),
        ))
        .go();

    final tags = await _tagsForNote(db, id);
    return existing.toDomain(tags: tags);
  }

  String _normalizeTagName(String raw) {
    var name = raw.trim();
    if (name.startsWith('#')) {
      name = name.substring(1).trim();
    }
    if (name.isEmpty) {
      throw const NoteTagEmptyError();
    }
    if (name.length > noteTagMaxLength) {
      throw const NoteTagTooLongError();
    }
    if (name.startsWith('#')) {
      throw const NoteTagInvalidError();
    }
    return name;
  }

  Future<Map<String, List<String>>> _tagsByNoteId(AppDatabase db) async {
    final rows = await db.select(db.noteTags).get();
    final result = <String, List<String>>{};
    for (final row in rows) {
      result.putIfAbsent(row.noteId, () => <String>[]).add(row.tagName);
    }
    return result;
  }

  Future<List<String>> _tagsForNote(AppDatabase db, NoteId id) async {
    final rows = await (db.select(db.noteTags)
          ..where((table) => table.noteId.equals(id)))
        .get();
    return _sortedTags(rows.map((row) => row.tagName).toList());
  }

  List<String> _sortedTags(List<String> tags) {
    final sorted = List<String>.from(tags)
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return sorted;
  }
}
