import 'dart:convert';

import 'package:easy_fin/models/todo_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _todosKey = 'local_todos';

final todosStorageProvider = Provider<TodosStorage>(
  (ref) => const TodosStorage(),
);

sealed class TodosStorageError implements Exception {
  const TodosStorageError();
}

class TodoEmptyTextError extends TodosStorageError {
  const TodoEmptyTextError();
}

class TodosStorage {
  const TodosStorage();

  Future<List<TodoItem>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_todosKey);
    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    final items = decoded
        .map((item) => TodoItem.fromJson(item as Map<String, dynamic>))
        .toList()
      ..sort((a, b) {
        final byDone = (a.isDone ? 1 : 0).compareTo(b.isDone ? 1 : 0);
        if (byDone != 0) return byDone;
        return a.sortOrder.compareTo(b.sortOrder);
      });
    return items;
  }

  Future<void> save(TodoItem item) async {
    final trimmed = item.text.trim();
    if (trimmed.isEmpty) {
      throw const TodoEmptyTextError();
    }

    final items = await getAll();
    final index = items.indexWhere((todo) => todo.id == item.id);
    final toSave = item.copyWith(text: trimmed);
    if (index >= 0) {
      items[index] = toSave;
    } else {
      items.add(toSave);
    }
    await _writeAll(items);
  }

  Future<void> delete(TodoItemId id) async {
    final items = await getAll();
    items.removeWhere((todo) => todo.id == id);
    await _writeAll(items);
  }

  Future<void> _writeAll(List<TodoItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _todosKey,
      jsonEncode(items.map((item) => item.toJson()).toList()),
    );
  }
}
