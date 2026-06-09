import 'package:easy_fin/models/account_filter_type.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:equatable/equatable.dart';

class GetStatementsFilters extends Equatable {
  const GetStatementsFilters({
    this.startDate,
    this.endDate,
    this.accountFilterTypes,
    this.baseIds,
    this.documentTypes,
  });
  final DateTime? startDate;
  final DateTime? endDate;
  final List<AccountFilterType>? accountFilterTypes;
  final List<BaseId>? baseIds;
  final List<DocumentType>? documentTypes;

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    accountFilterTypes,
    baseIds,
    documentTypes,
  ];
}
