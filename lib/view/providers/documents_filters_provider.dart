import 'package:easy_fin/data/models/get_statements_filters.dart';
import 'package:easy_fin/models/account_filter_type.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentsFilters extends Equatable {
  const DocumentsFilters({
    this.documentTypes = const {DocumentType.outcome},
    this.selectedBases = const {},
    this.accountFilters = const {},
    this.startDate,
    this.endDate,
  });

  final Set<DocumentType> documentTypes;
  final Set<Base> selectedBases;
  final Set<AccountFilterType> accountFilters;
  final DateTime? startDate;
  final DateTime? endDate;

  DocumentType get documentType =>
      documentTypes.isEmpty ? DocumentType.outcome : documentTypes.first;

  DocumentsFilters copyWith({
    Set<DocumentType>? documentTypes,
    Set<Base>? selectedBases,
    Set<AccountFilterType>? accountFilters,
    DateTime? startDate,
    DateTime? endDate,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return DocumentsFilters(
      documentTypes: documentTypes ?? this.documentTypes,
      selectedBases: selectedBases ?? this.selectedBases,
      accountFilters: accountFilters ?? this.accountFilters,
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
    );
  }

  GetStatementsFilters toGetStatementsFilters() {
    return GetStatementsFilters(
      startDate: startDate,
      endDate: endDate,
      accountFilterTypes: accountFilters.isEmpty
          ? null
          : accountFilters.toList(),
      baseIds: selectedBases.isEmpty
          ? null
          : selectedBases.map((base) => base.id).toList(),
      documentTypes: documentTypes.isEmpty ? null : documentTypes.toList(),
    );
  }

  @override
  List<Object?> get props => [
    documentTypes,
    selectedBases,
    accountFilters,
    startDate,
    endDate,
  ];
}

final documentsFiltersProvider =
    NotifierProvider<DocumentsFiltersNotifier, DocumentsFilters>(
      DocumentsFiltersNotifier.new,
    );

class DocumentsFiltersNotifier extends Notifier<DocumentsFilters> {
  @override
  DocumentsFilters build() => const DocumentsFilters();

  void setDocumentTypes(Set<DocumentType> documentTypes) {
    state = state.copyWith(documentTypes: documentTypes);
  }

  void setDocumentType(DocumentType documentType) {
    state = state.copyWith(documentTypes: {documentType});
  }

  void setSelectedBases(Set<Base> selectedBases) {
    state = state.copyWith(selectedBases: selectedBases);
  }

  void setAccountFilters(Set<AccountFilterType> accountFilters) {
    state = state.copyWith(accountFilters: accountFilters);
  }

  void setStartDate(DateTime? startDate) {
    state = startDate == null
        ? state.copyWith(clearStartDate: true)
        : state.copyWith(startDate: startDate);
  }

  void setEndDate(DateTime? endDate) {
    state = endDate == null
        ? state.copyWith(clearEndDate: true)
        : state.copyWith(endDate: endDate);
  }
}
