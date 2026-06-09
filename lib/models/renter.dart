import 'package:easy_fin/models/base.dart';
import 'package:equatable/equatable.dart';

typedef RenterId = String;

class Renter extends Equatable {
  const Renter({
    required this.id,
    required this.baseId,
    required this.name,
    required this.accountNumbers,
    this.isArchived = false,
  });

  factory Renter.create({
    required BaseId baseId,
    required String name,
    required List<AccountNumber> accountNumbers,
  }) =>
      Renter(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        baseId: baseId,
        name: name,
        accountNumbers: accountNumbers,
      );

  final RenterId id;
  final BaseId baseId;
  final String name;
  final List<AccountNumber> accountNumbers;
  final bool isArchived;

  @override
  List<Object?> get props => [id, baseId, name, accountNumbers, isArchived];
}
