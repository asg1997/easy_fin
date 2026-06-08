import 'package:equatable/equatable.dart';

typedef AccountNumber = String;

class Base extends Equatable {
  const Base({required this.id, required this.name});

  final AccountNumber id;
  final String name;

  @override
  List<Object?> get props => [id];
}
