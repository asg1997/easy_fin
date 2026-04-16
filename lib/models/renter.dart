import 'package:equatable/equatable.dart';

typedef RenterId = String;

class Renter extends Equatable {
  const Renter({required this.id, required this.name});

  final RenterId id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
