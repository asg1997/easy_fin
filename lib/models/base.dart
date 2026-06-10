import 'package:easy_fin/models/base_account.dart';
import 'package:equatable/equatable.dart';

typedef BaseId = String;
typedef AccountNumber = String;

class Base extends Equatable {
  const Base({
    required this.id,
    required this.name,
    required this.accounts,
  });

  factory Base.create(String name, List<BaseAccount> accounts) => Base(
    id: DateTime.now().microsecondsSinceEpoch.toString(),
    name: name,
    accounts: accounts,
  );

  final BaseId id;
  final String name;
  final List<BaseAccount> accounts;

  List<AccountNumber> get accountNumbers =>
      accounts.map((account) => account.accountNumber).toList();

  @override
  List<Object?> get props => [id, name, accounts];
}
