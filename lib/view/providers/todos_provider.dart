import 'package:easy_fin/data/todos_storage/todos_storage.dart';
import 'package:easy_fin/models/todo_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final todosProvider =
    AsyncNotifierProvider.autoDispose<TodosNotifier, List<TodoItem>>(
  TodosNotifier.new,
);

class TodosNotifier extends AsyncNotifier<List<TodoItem>> {
  @override
  Future<List<TodoItem>> build() async {
    final items = await ref.read(todosStorageProvider).getAll();
    return _sortedForScreen(items);
  }

  /// Сортировка только при загрузке экрана: сначала несделанные.
  List<TodoItem> _sortedForScreen(List<TodoItem> items) {
    return [...items]..sort((a, b) {
        final byDone = (a.isDone ? 1 : 0).compareTo(b.isDone ? 1 : 0);
        if (byDone != 0) return byDone;
        return a.sortOrder.compareTo(b.sortOrder);
      });
  }

  List<TodoItem> get _current => state.value ?? [];

  Future<void> add(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw const TodoEmptyTextError();
    }

    final current = _current;
    final item = TodoItem(
      id: const Uuid().v4(),
      text: trimmed,
      isDone: false,
      createdAt: DateTime.now(),
      sortOrder: current.length,
    );
    await ref.read(todosStorageProvider).save(item);
    // Новая задача сверху, без пересортировки всего списка.
    state = AsyncData([item, ...current]);
  }

  Future<void> save(TodoItem item) async {
    await ref.read(todosStorageProvider).save(item);
    state = AsyncData([
      for (final todo in _current)
        if (todo.id == item.id) item else todo,
    ]);
  }

  Future<void> toggleDone(TodoItem item) async {
    await save(item.copyWith(isDone: !item.isDone));
  }

  Future<void> delete(TodoItemId id) async {
    await ref.read(todosStorageProvider).delete(id);
    state = AsyncData([
      for (final todo in _current)
        if (todo.id != id) todo,
    ]);
  }
}
