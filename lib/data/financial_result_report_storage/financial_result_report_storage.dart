import 'package:easy_fin/data/bank_statements_storage/bank_statement_storage.dart';
import 'package:easy_fin/data/expenses_storage/expenses_storage.dart';
import 'package:easy_fin/data/incomes_storage/incomes_storage.dart';
import 'package:easy_fin/data/models/get_statements_filters.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:easy_fin/models/expense_category.dart';
import 'package:easy_fin/view/models/financial_result_monthly_report_item.dart';
import 'package:easy_fin/view/models/financial_result_report.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final financialResultReportStorageProvider =
    Provider<FinancialResultReportStorage>(
  FinancialResultReportStorageImpl.new,
);

abstract class FinancialResultReportStorage {
  Future<FinancialResultReport> getReport({
    BaseId? baseId,
    DateTime? startDate,
    DateTime? endDate,
    Set<ExpenseCategoryId> excludedExpenseCategoryIds = const {},
  });

  Future<List<FinancialResultMonthlyReportItem>> getMonthlyReport({
    required int year,
    BaseId? baseId,
    Set<ExpenseCategoryId> excludedExpenseCategoryIds = const {},
  });
}

class FinancialResultReportStorageImpl implements FinancialResultReportStorage {
  const FinancialResultReportStorageImpl(this.ref);

  final Ref ref;

  @override
  Future<FinancialResultReport> getReport({
    BaseId? baseId,
    DateTime? startDate,
    DateTime? endDate,
    Set<ExpenseCategoryId> excludedExpenseCategoryIds = const {},
  }) async {
    final revenue = await _sumIncome(
      baseId: baseId,
      startDate: startDate,
      endDate: endDate,
    );
    final expenses = await _sumExpenses(
      baseId: baseId,
      startDate: startDate,
      endDate: endDate,
      excludedExpenseCategoryIds: excludedExpenseCategoryIds,
    );

    return FinancialResultReport(
      revenue: revenue,
      expenses: expenses,
    );
  }

  @override
  Future<List<FinancialResultMonthlyReportItem>> getMonthlyReport({
    required int year,
    BaseId? baseId,
    Set<ExpenseCategoryId> excludedExpenseCategoryIds = const {},
  }) async {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final months = List.generate(12, (index) => DateTime(year, index + 1));

    final items = <FinancialResultMonthlyReportItem>[];
    for (final month in months) {
      final monthStart = DateTime(month.year, month.month);
      final isFutureMonth = monthStart.isAfter(currentMonth);

      if (isFutureMonth) {
        items.add(
          FinancialResultMonthlyReportItem(
            month: month,
            revenue: 0,
            expenses: 0,
            isFutureMonth: true,
          ),
        );
        continue;
      }

      final monthEnd = DateTime(month.year, month.month + 1, 0);
      final report = await getReport(
        baseId: baseId,
        startDate: monthStart,
        endDate: monthEnd,
        excludedExpenseCategoryIds: excludedExpenseCategoryIds,
      );

      items.add(
        FinancialResultMonthlyReportItem(
          month: month,
          revenue: report.revenue,
          expenses: report.expenses,
        ),
      );
    }

    return items;
  }

  Future<double> _sumIncome({
    BaseId? baseId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final filters = _buildFilters(
      baseId: baseId,
      startDate: startDate,
      endDate: endDate,
      documentType: DocumentType.income,
    );

    var total = 0.0;

    final documents =
        await ref.read(incomesStorageProvider).getByFilters(filters);
    for (final document in documents) {
      total += document.totalSum;
    }

    final statements =
        await ref.read(bankStatementStorageProvider).getStatements(filters);
    for (final statement in statements) {
      for (final operation in statement.operations) {
        if (!operation.isCredit) continue;
        final amount = operation.credit ?? 0;
        if (amount <= 0) continue;
        total += amount;
      }
    }

    return total;
  }

  Future<double> _sumExpenses({
    BaseId? baseId,
    DateTime? startDate,
    DateTime? endDate,
    Set<ExpenseCategoryId> excludedExpenseCategoryIds = const {},
  }) async {
    final filters = _buildFilters(
      baseId: baseId,
      startDate: startDate,
      endDate: endDate,
      documentType: DocumentType.outcome,
    );

    var total = 0.0;

    final documents =
        await ref.read(expensesStorageProvider).getByFilters(filters);
    for (final document in documents) {
      for (final line in document.lines) {
        if (excludedExpenseCategoryIds.contains(line.categoryId)) continue;
        total += line.sum;
      }
    }

    final statements =
        await ref.read(bankStatementStorageProvider).getStatements(filters);
    for (final statement in statements) {
      for (final operation in statement.operations) {
        if (!operation.isDebit) continue;
        final categoryId = operation.expenseCategoryId;
        if (categoryId != null &&
            excludedExpenseCategoryIds.contains(categoryId)) {
          continue;
        }
        final amount = operation.debit ?? 0;
        if (amount <= 0) continue;
        total += amount;
      }
    }

    return total;
  }

  GetStatementsFilters _buildFilters({
    required DocumentType documentType,
    BaseId? baseId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return GetStatementsFilters(
      startDate: startDate,
      endDate: endDate,
      baseIds: baseId == null ? null : <BaseId>[baseId],
      documentTypes: [documentType],
    );
  }
}
