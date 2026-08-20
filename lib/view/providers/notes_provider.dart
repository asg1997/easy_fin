import 'package:easy_fin/data/notes_storage/notes_storage.dart';
import 'package:easy_fin/models/note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `null` = все заметки, иначе имя выбранного тега.
final notesTagFilterProvider =
    NotifierProvider<NotesTagFilterNotifier, String?>(
  NotesTagFilterNotifier.new,
);

class NotesTagFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void selectAll() => state = null;

  void selectTag(String tagName) => state = tagName;
}

final allNoteTagsProvider = FutureProvider<List<String>>((ref) async {
  return ref.read(notesStorageProvider).getAllTags();
});

final notesListProvider = FutureProvider<List<Note>>((ref) async {
  final tagFilter = ref.watch(notesTagFilterProvider);
  return ref.read(notesStorageProvider).getAll(tagFilter: tagFilter);
});
