import 'package:easy_fin/models/account_filter_type.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/expense_category.dart';
import 'package:easy_fin/models/income_category.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:equatable/equatable.dart';

typedef ReportTemplateId = String;

enum ReportTemplateKind {
  income,
  expense;

  String get label => switch (this) {
        ReportTemplateKind.income => 'Приход',
        ReportTemplateKind.expense => 'Расход',
      };

  static ReportTemplateKind fromJson(String value) => switch (value) {
        'income' => ReportTemplateKind.income,
        'expense' => ReportTemplateKind.expense,
        _ => throw FormatException('Unknown report template kind: $value'),
      };

  String toJson() => name;
}

enum ReportIncomeSourceKind {
  renters,
  other;

  String get label => switch (this) {
        ReportIncomeSourceKind.renters => 'Взаиморасчёты',
        ReportIncomeSourceKind.other => 'Прочее',
      };

  static ReportIncomeSourceKind fromJson(String value) => switch (value) {
        'renters' => ReportIncomeSourceKind.renters,
        'other' => ReportIncomeSourceKind.other,
        _ => throw FormatException('Unknown income source kind: $value'),
      };

  String toJson() => name;
}

class ReportIncomeConfig extends Equatable {
  const ReportIncomeConfig({
    required this.sourceKind,
    this.allRenters = false,
    this.renterIds = const [],
    this.incomeCategoryIds = const [],
  });

  factory ReportIncomeConfig.fromJson(Map<String, dynamic> json) {
    return ReportIncomeConfig(
      sourceKind: ReportIncomeSourceKind.fromJson(
        json['sourceKind'] as String,
      ),
      allRenters: json['allRenters'] as bool? ?? false,
      renterIds: (json['renterIds'] as List<dynamic>? ?? const [])
          .map((id) => id as String)
          .toList(),
      incomeCategoryIds: (json['incomeCategoryIds'] as List<dynamic>? ??
              const [])
          .map((id) => id as int)
          .toList(),
    );
  }

  final ReportIncomeSourceKind sourceKind;
  final bool allRenters;
  final List<RenterId> renterIds;
  final List<IncomeCategoryId> incomeCategoryIds;

  Map<String, dynamic> toJson() => {
        'sourceKind': sourceKind.toJson(),
        'allRenters': allRenters,
        'renterIds': renterIds,
        'incomeCategoryIds': incomeCategoryIds,
      };

  @override
  List<Object?> get props => [
        sourceKind,
        allRenters,
        renterIds,
        incomeCategoryIds,
      ];
}

class ReportExpenseConfig extends Equatable {
  const ReportExpenseConfig({
    this.expenseCategoryIds = const [],
  });

  factory ReportExpenseConfig.fromJson(Map<String, dynamic> json) {
    return ReportExpenseConfig(
      expenseCategoryIds: (json['expenseCategoryIds'] as List<dynamic>? ??
              const [])
          .map((id) => id as int)
          .toList(),
    );
  }

  final List<ExpenseCategoryId> expenseCategoryIds;

  Map<String, dynamic> toJson() => {
        'expenseCategoryIds': expenseCategoryIds,
      };

  @override
  List<Object?> get props => [expenseCategoryIds];
}

class ReportTemplate extends Equatable {
  const ReportTemplate({
    required this.id,
    required this.name,
    required this.kind,
    this.baseId,
    this.accountType,
    this.income,
    this.expense,
  });

  factory ReportTemplate.fromJson(Map<String, dynamic> json) {
    final kind = ReportTemplateKind.fromJson(json['kind'] as String);
    final accountTypeRaw = json['accountType'] as String?;

    return ReportTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      kind: kind,
      baseId: json['baseId'] as String?,
      accountType: accountTypeRaw == null
          ? null
          : AccountFilterType.values.byName(accountTypeRaw),
      income: json['income'] == null
          ? null
          : ReportIncomeConfig.fromJson(
              json['income'] as Map<String, dynamic>,
            ),
      expense: json['expense'] == null
          ? null
          : ReportExpenseConfig.fromJson(
              json['expense'] as Map<String, dynamic>,
            ),
    );
  }

  final ReportTemplateId id;
  final String name;
  final ReportTemplateKind kind;
  final BaseId? baseId;
  final AccountFilterType? accountType;
  final ReportIncomeConfig? income;
  final ReportExpenseConfig? expense;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'kind': kind.toJson(),
        'baseId': baseId,
        'accountType': accountType?.name,
        'income': income?.toJson(),
        'expense': expense?.toJson(),
      };

  ReportTemplate copyWith({
    String? name,
    ReportTemplateKind? kind,
    BaseId? baseId,
    AccountFilterType? accountType,
    ReportIncomeConfig? income,
    ReportExpenseConfig? expense,
    bool clearBaseId = false,
    bool clearAccountType = false,
    bool clearIncome = false,
    bool clearExpense = false,
  }) {
    return ReportTemplate(
      id: id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      baseId: clearBaseId ? null : (baseId ?? this.baseId),
      accountType:
          clearAccountType ? null : (accountType ?? this.accountType),
      income: clearIncome ? null : (income ?? this.income),
      expense: clearExpense ? null : (expense ?? this.expense),
    );
  }

  /// Возвращает текст ошибки валидации или `null`, если шаблон корректен.
  String? validate() {
    if (name.trim().isEmpty) {
      return 'Укажите название шаблона';
    }

    if (baseId == null && accountType != null) {
      return 'Счёт можно выбрать только для одной базы';
    }

    switch (kind) {
      case ReportTemplateKind.income:
        final incomeConfig = income;
        if (incomeConfig == null) {
          return 'Заполните настройки прихода';
        }
        return switch (incomeConfig.sourceKind) {
          ReportIncomeSourceKind.renters => incomeConfig.allRenters ||
                  incomeConfig.renterIds.isNotEmpty
              ? null
              : 'Выберите арендаторов или включите «Все арендаторы»',
          ReportIncomeSourceKind.other => incomeConfig.incomeCategoryIds.isEmpty
              ? 'Выберите категории прочих приходов'
              : null,
        };
      case ReportTemplateKind.expense:
        final expenseConfig = expense;
        if (expenseConfig == null ||
            expenseConfig.expenseCategoryIds.isEmpty) {
          return 'Выберите категории расходов';
        }
        return null;
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        kind,
        baseId,
        accountType,
        income,
        expense,
      ];
}
