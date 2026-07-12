import 'package:easy_fin/data/bank_statements_storage/bank_statement_storage.dart';
import 'package:easy_fin/data/expense_categories_storage/expense_categories_storage.dart';
import 'package:easy_fin/data/expenses_storage/expenses_storage.dart';
import 'package:easy_fin/data/income_categories_storage/income_categories_storage.dart';
import 'package:easy_fin/data/incomes_storage/incomes_storage.dart';
import 'package:easy_fin/data/models/get_statements_filters.dart';
import 'package:easy_fin/data/renters_storage/renters_storage.dart';
import 'package:easy_fin/models/account_filter_type.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:easy_fin/models/expense_category.dart';
import 'package:easy_fin/models/income.dart';
import 'package:easy_fin/models/income_category.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:easy_fin/models/report_template.dart';
import 'package:easy_fin/view/models/report_template_result_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportTemplateResultsStorageProvider =
    Provider<ReportTemplateResultsStorage>(
  ReportTemplateResultsStorageImpl.new,
);

abstract class ReportTemplateResultsStorage {
  Future<List<ReportTemplateResultItem>> getResults({
    required ReportTemplate template,
    required DateTime month,
  });
}

class ReportTemplateResultsStorageImpl
    implements ReportTemplateResultsStorage {
  const ReportTemplateResultsStorageImpl(this.ref);

  final Ref ref;

  @override
  Future<List<ReportTemplateResultItem>> getResults({
    required ReportTemplate template,
    required DateTime month,
  }) async {
    final monthStart = DateTime(month.year, month.month);
    final monthEnd = DateTime(month.year, month.month + 1, 0);

    return switch (template.kind) {
      ReportTemplateKind.income => _getIncomeResults(
          template: template,
          startDate: monthStart,
          endDate: monthEnd,
        ),
      ReportTemplateKind.expense => _getExpenseResults(
          template: template,
          startDate: monthStart,
          endDate: monthEnd,
        ),
    };
  }

  Future<List<ReportTemplateResultItem>> _getIncomeResults({
    required ReportTemplate template,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final income = template.income;
    if (income == null) return [];

    return switch (income.sourceKind) {
      ReportIncomeSourceKind.renters => _getRenterIncomeResults(
          template: template,
          income: income,
          startDate: startDate,
          endDate: endDate,
        ),
      ReportIncomeSourceKind.other => _getOtherIncomeResults(
          template: template,
          income: income,
          startDate: startDate,
          endDate: endDate,
        ),
    };
  }

  Future<List<ReportTemplateResultItem>> _getRenterIncomeResults({
    required ReportTemplate template,
    required ReportIncomeConfig income,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final sumsByRenterId = await _aggregateRenterIncome(
      template: template,
      startDate: startDate,
      endDate: endDate,
    );

    final renters = await ref.read(rentersStorageProvider).getAll();
    final renterById = {for (final renter in renters) renter.id: renter};

    final List<RenterId> targetIds;
    if (income.allRenters) {
      targetIds = sumsByRenterId.keys
          .where((id) => (sumsByRenterId[id] ?? 0) > 0)
          .toList();
    } else {
      targetIds = income.renterIds;
    }

    final items = <ReportTemplateResultItem>[];
    for (final renterId in targetIds) {
      final amount = sumsByRenterId[renterId] ?? 0;
      if (income.allRenters && amount <= 0) continue;

      final renter = renterById[renterId];
      items.add(
        ReportTemplateResultItem(
          label: renter?.name ?? 'Неизвестный арендатор',
          amount: amount,
        ),
      );
    }

    return items..sort((a, b) => b.amount.compareTo(a.amount));
  }

  Future<List<ReportTemplateResultItem>> _getOtherIncomeResults({
    required ReportTemplate template,
    required ReportIncomeConfig income,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final sumsByCategoryId = await _aggregateOtherIncome(
      template: template,
      startDate: startDate,
      endDate: endDate,
    );

    final categories =
        await ref.read(incomeCategoriesStorageProvider).getAll();
    final nameById = {
      for (final category in categories) category.id: category.name,
    };

    final items = income.incomeCategoryIds.map((categoryId) {
      return ReportTemplateResultItem(
        label: nameById[categoryId] ?? 'Прочее',
        amount: sumsByCategoryId[categoryId] ?? 0,
      );
    }).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return items;
  }

  Future<List<ReportTemplateResultItem>> _getExpenseResults({
    required ReportTemplate template,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final expense = template.expense;
    if (expense == null) return [];

    final sumsByCategoryId = await _aggregateExpenses(
      template: template,
      startDate: startDate,
      endDate: endDate,
    );

    final categories =
        await ref.read(expenseCategoriesStorageProvider).getAll();
    final nameById = {
      for (final category in categories) category.id: category.name,
    };

    final items = expense.expenseCategoryIds.map((categoryId) {
      return ReportTemplateResultItem(
        label: nameById[categoryId] ?? 'Прочее',
        amount: sumsByCategoryId[categoryId] ?? 0,
      );
    }).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return items;
  }

  Future<Map<RenterId, double>> _aggregateRenterIncome({
    required ReportTemplate template,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final filters = _buildFilters(
      template: template,
      startDate: startDate,
      endDate: endDate,
      documentType: DocumentType.income,
    );

    final sums = <RenterId, double>{};

    final documents =
        await ref.read(incomesStorageProvider).getByFilters(filters);
    for (final document in documents) {
      for (final line in document.lines) {
        final source = line.incomeSource;
        if (source is! IncomeSourceFromRenter) continue;
        sums[source.renterId] = (sums[source.renterId] ?? 0) + line.sum;
      }
    }

    final statements =
        await ref.read(bankStatementStorageProvider).getStatements(filters);
    for (final statement in statements) {
      for (final operation in statement.operations) {
        if (!operation.isCredit) continue;
        final renterId = operation.renterId;
        if (renterId == null) continue;
        final amount = operation.credit ?? 0;
        if (amount <= 0) continue;
        sums[renterId] = (sums[renterId] ?? 0) + amount;
      }
    }

    return sums;
  }

  Future<Map<IncomeCategoryId, double>> _aggregateOtherIncome({
    required ReportTemplate template,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final filters = _buildFilters(
      template: template,
      startDate: startDate,
      endDate: endDate,
      documentType: DocumentType.income,
    );

    final sums = <IncomeCategoryId, double>{};

    final documents =
        await ref.read(incomesStorageProvider).getByFilters(filters);
    for (final document in documents) {
      for (final line in document.lines) {
        final source = line.incomeSource;
        if (source is! IncomeSourceFromOther) continue;
        sums[source.categoryId] = (sums[source.categoryId] ?? 0) + line.sum;
      }
    }

    final statements =
        await ref.read(bankStatementStorageProvider).getStatements(filters);
    for (final statement in statements) {
      for (final operation in statement.operations) {
        if (!operation.isCredit) continue;
        final categoryId = operation.incomeCategoryId;
        if (categoryId == null) continue;
        final amount = operation.credit ?? 0;
        if (amount <= 0) continue;
        sums[categoryId] = (sums[categoryId] ?? 0) + amount;
      }
    }

    return sums;
  }

  Future<Map<ExpenseCategoryId, double>> _aggregateExpenses({
    required ReportTemplate template,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final filters = _buildFilters(
      template: template,
      startDate: startDate,
      endDate: endDate,
      documentType: DocumentType.outcome,
    );

    final sums = <ExpenseCategoryId, double>{};

    final documents =
        await ref.read(expensesStorageProvider).getByFilters(filters);
    for (final document in documents) {
      for (final line in document.lines) {
        sums[line.categoryId] = (sums[line.categoryId] ?? 0) + line.sum;
      }
    }

    final statements =
        await ref.read(bankStatementStorageProvider).getStatements(filters);
    for (final statement in statements) {
      for (final operation in statement.operations) {
        if (!operation.isDebit) continue;
        final categoryId = operation.expenseCategoryId;
        if (categoryId == null) continue;
        final amount = operation.debit ?? 0;
        if (amount <= 0) continue;
        sums[categoryId] = (sums[categoryId] ?? 0) + amount;
      }
    }

    return sums;
  }

  GetStatementsFilters _buildFilters({
    required ReportTemplate template,
    required DateTime startDate,
    required DateTime endDate,
    required DocumentType documentType,
  }) {
    final baseId = template.baseId;
    final accountType = template.accountType;

    return GetStatementsFilters(
      startDate: startDate,
      endDate: endDate,
      baseIds: baseId == null ? null : <BaseId>[baseId],
      accountFilterTypes:
          accountType == null ? null : <AccountFilterType>[accountType],
      documentTypes: [documentType],
    );
  }
}
