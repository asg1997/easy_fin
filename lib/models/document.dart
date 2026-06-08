import 'package:easy_fin/models/base.dart';
import 'package:equatable/equatable.dart';

typedef DocumentId = String;

/// Документ - расход, приход, начисление по аренде
class Document extends Equatable {
  const Document({
    required this.id,
    required this.createdAt,
    required this.baseId,
  });

  final DocumentId id;
  final DateTime createdAt;
  final BaseId baseId;

  @override
  List<Object?> get props => [id, createdAt, baseId];
}
