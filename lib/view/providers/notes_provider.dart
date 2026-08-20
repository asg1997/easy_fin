import 'package:easy_fin/data/notes_storage/notes_storage.dart';
import 'package:easy_fin/models/note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notesListProvider = FutureProvider<List<Note>>((ref) async {
  return ref.read(notesStorageProvider).getAll();
});
