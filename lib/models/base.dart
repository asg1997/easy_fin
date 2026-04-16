import 'package:equatable/equatable.dart';

typedef BaseId = String;

class Base extends Equatable {
  const Base({required this.id, required this.name});

  final BaseId id;
  final String name;

  @override
  List<Object?> get props => [id];
}
