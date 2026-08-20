import 'package:equatable/equatable.dart';

typedef TodoItemId = String;

class TodoItem extends Equatable {
  const TodoItem({
    required this.id,
    required this.text,
    required this.isDone,
    required this.createdAt,
    this.sortOrder = 0,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'] as String,
      text: json['text'] as String,
      isDone: json['isDone'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }

  final TodoItemId id;
  final String text;
  final bool isDone;
  final DateTime createdAt;
  final int sortOrder;

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isDone': isDone,
        'createdAt': createdAt.toIso8601String(),
        'sortOrder': sortOrder,
      };

  TodoItem copyWith({
    String? text,
    bool? isDone,
    int? sortOrder,
  }) {
    return TodoItem(
      id: id,
      text: text ?? this.text,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [id, text, isDone, createdAt, sortOrder];
}
