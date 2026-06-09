import 'package:easy_fin/models/base.dart';
import 'package:equatable/equatable.dart';

typedef RenterId = String;

class Renter extends Equatable {
  const Renter({
    required this.id,
    required this.name,
    required this.accountNumbers,
  });

  factory Renter.create(String name, List<AccountNumber> accountNumbers) =>
      Renter(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
        accountNumbers: accountNumbers,
      );

  final RenterId id;
  final String name;
  final List<AccountNumber> accountNumbers;

  @override
  List<Object?> get props => [id, name, accountNumbers];
}
