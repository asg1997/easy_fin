import 'package:easy_fin/data/todos_storage/todos_storage.dart';
import 'package:easy_fin/models/todo_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final todosProvider =
    AsyncNotifierProvider<TodosNotifier, List<TodoItem>>(TodosNotifier.new);

class TodosNotifier extends AsyncNotifier<List<TodoItem>> {
  @override
  Future<List<TodoItem>> build() {
    return ref.read(todosStorageProvider).getAll();
  }

  Future<void> add(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw const TodoEmptyTextError();
    }

    final items = await ref.read(todosStorageProvider).getAll();
    final item = TodoItem(
      id: const Uuid().v4(),
      text: trimmed,
      isDone: false,
      createdAt: DateTime.now(),
      sortOrder: items.length,
    );
    await ref.read(todosStorageProvider).save(item);
    state = AsyncData(await ref.read(todosStorageProvider).getAll());
  }

  Future<void> save(TodoItem item) async {
    await ref.read(todosStorageProvider).save(item);
    state = AsyncData(await ref.read(todosStorageProvider).getAll());
  }

  Future<void> toggleDone(TodoItem item) async {
    await save(item.copyWith(isDone: !item.isDone));
  }

  Future<void> delete(TodoItemId id) async {
    await ref.read(todosStorageProvider).delete(id);
    state = AsyncData(await ref.read(todosStorageProvider).getAll());
  }
}
