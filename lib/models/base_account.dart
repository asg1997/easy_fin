import 'package:easy_fin/models/base.dart';
import 'package:equatable/equatable.dart';

class BaseAccount extends Equatable {
  const BaseAccount({
    required this.accountNumber,
    required this.bankName,
  });

  final AccountNumber accountNumber;
  final String bankName;

  String get displayName =>
      bankName.isNotEmpty ? bankName : accountNumber;

  @override
  List<Object?> get props => [accountNumber, bankName];
}
