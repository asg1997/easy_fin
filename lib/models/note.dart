import 'package:equatable/equatable.dart';

typedef NoteId = String;

class Note extends Equatable {
  const Note({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  final NoteId id;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note copyWith({
    String? text,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id,
      text: text ?? this.text,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, text, createdAt, updatedAt];
}
