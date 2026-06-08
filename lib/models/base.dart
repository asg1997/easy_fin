import 'package:equatable/equatable.dart';

typedef BaseId = String;
typedef AccountNumber = String;

class Base extends Equatable {
  const Base({
    required this.id,
    required this.name,
    required this.accountNumbers,
  });

  final BaseId id;
  final String name;
  final List<AccountNumber> accountNumbers;

  @override
  List<Object?> get props => [id, name, accountNumbers];
}
