import 'package:equatable/equatable.dart';

typedef NoteId = String;

class Note extends Equatable {
  const Note({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
  });

  final NoteId id;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Отсортированные имена тегов (как ввели после trim).
  final List<String> tags;

  Note copyWith({
    String? text,
    DateTime? updatedAt,
    List<String>? tags,
  }) {
    return Note(
      id: id,
      text: text ?? this.text,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [id, text, createdAt, updatedAt, tags];
}
