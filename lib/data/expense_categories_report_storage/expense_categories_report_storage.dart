import 'package:easy_fin/data/bank_statements_storage/bank_statement_storage.dart';
import 'package:easy_fin/data/bases_storage/bases_storage.dart';
import 'package:easy_fin/data/expense_categories_storage/expense_categories_storage.dart';
import 'package:easy_fin/data/expenses_storage/expenses_storage.dart';
import 'package:easy_fin/data/models/get_statements_filters.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:easy_fin/models/expense_category.dart';
import 'package:easy_fin/view/models/expense_base_report_item.dart';
import 'package:easy_fin/view/models/expense_category_comparison_item.dart';
import 'package:easy_fin/view/models/expense_category_report_item.dart';
import 'package:easy_fin/view/models/expense_monthly_report_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _uncategorizedCategoryId = -1;

final expenseCategoriesReportStorageProvider =
    Provider<ExpenseCategoriesReportStorage>(
  ExpenseCategoriesReportStorageImpl.new,
);

abstract class ExpenseCategoriesReportStorage {
  Future<List<ExpenseCategoryReportItem>> getReport({
    required BaseId baseId,
    required DateTime month,
  });

  Future<List<ExpenseMonthlyReportItem>> getMonthlyReport({
    required BaseId baseId,
    required int year,
  });

  Future<List<ExpenseCategoryComparisonItem>> getComparisonReport({
    required BaseId baseId,
    required DateTime month,
  });

  Future<List<ExpenseBaseReportItem>> getBasesReport({
    required DateTime month,
  });
}

class ExpenseCategoriesReportStorageImpl
    implements ExpenseCategoriesReportStorage {
  const ExpenseCategoriesReportStorageImpl(this.ref);

  final Ref ref;

  @override
  Future<List<ExpenseCategoryReportItem>> getReport({
    required BaseId baseId,
    required DateTime month,
  }) async {
    final monthStart = DateTime(month.year, month.month);
    final monthEnd = DateTime(month.year, month.month + 1, 0);

    final sumsByCategoryId = await _aggregateByCategory(
      baseId: baseId,
      startDate: monthStart,
      endDate: monthEnd,
    );

    return _buildCategoryItems(sumsByCategoryId);
  }

  @override
  Future<List<ExpenseMonthlyReportItem>> getMonthlyReport({
    required BaseId baseId,
    required int year,
  }) async {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    final months = List.generate(12, (index) => DateTime(year, index + 1));

    final items = <ExpenseMonthlyReportItem>[];
    for (final month in months) {
      final monthStart = DateTime(month.year, month.month);
      final isFutureMonth = monthStart.isAfter(currentMonth);

      if (isFutureMonth) {
        items.add(
          ExpenseMonthlyReportItem(
            month: month,
            amount: 0,
            isFutureMonth: true,
          ),
        );
        continue;
      }

      final monthEnd = DateTime(month.year, month.month + 1, 0);
      final sums = await _aggregateByCategory(
        baseId: baseId,
        startDate: monthStart,
        endDate: monthEnd,
      );
      final total = sums.values.fold<double>(0, (sum, amount) => sum + amount);

      items.add(
        ExpenseMonthlyReportItem(
          month: month,
          amount: total,
        ),
      );
    }

    return items;
  }

  @override
  Future<List<ExpenseCategoryComparisonItem>> getComparisonReport({
    required BaseId baseId,
    required DateTime month,
  }) async {
    final currentMonth = DateTime(month.year, month.month);
    final previousMonth = currentMonth.month == 1
        ? DateTime(currentMonth.year - 1, 12)
        : DateTime(currentMonth.year, currentMonth.month - 1);

    final currentItems = await getReport(baseId: baseId, month: currentMonth);
    final previousItems =
        await getReport(baseId: baseId, month: previousMonth);

    final currentByName = {
      for (final item in currentItems) item.categoryName: item.amount,
    };
    final previousByName = {
      for (final item in previousItems) item.categoryName: item.amount,
    };

    final categoryNames = {
      ...currentByName.keys,
      ...previousByName.keys,
    };

    final items = categoryNames.map((categoryName) {
      return ExpenseCategoryComparisonItem(
        categoryName: categoryName,
        currentAmount: currentByName[categoryName] ?? 0,
        previousAmount: previousByName[categoryName] ?? 0,
      );
    }).toList();

    items.sort(
      (a, b) => b.currentAmount.compareTo(a.currentAmount),
    );

    return items;
  }

  @override
  Future<List<ExpenseBaseReportItem>> getBasesReport({
    required DateTime month,
  }) async {
    final bases = await ref.read(basesStorageProvider).getAll();
    if (bases.isEmpty) return [];

    final monthStart = DateTime(month.year, month.month);
    final monthEnd = DateTime(month.year, month.month + 1, 0);

    final amountByBaseId = <BaseId, double>{};
    for (final base in bases) {
      final sums = await _aggregateByCategory(
        baseId: base.id,
        startDate: monthStart,
        endDate: monthEnd,
      );
      final total = sums.values.fold<double>(0, (sum, amount) => sum + amount);
      if (total > 0) {
        amountByBaseId[base.id] = total;
      }
    }

    if (amountByBaseId.isEmpty) return [];

    final total = amountByBaseId.values.fold<double>(
      0,
      (sum, amount) => sum + amount,
    );
    if (total <= 0) return [];

    final baseNameById = {for (final base in bases) base.id: base.name};

    final items = amountByBaseId.entries.map((entry) {
      return ExpenseBaseReportItem(
        baseName: baseNameById[entry.key] ?? '',
        amount: entry.value,
        percentage: entry.value / total * 100,
      );
    }).toList();

    items.sort((a, b) => b.amount.compareTo(a.amount));
    return items;
  }

  Future<Map<ExpenseCategoryId, double>> _aggregateByCategory({
    required BaseId baseId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final filters = GetStatementsFilters(
      startDate: startDate,
      endDate: endDate,
      baseIds: [baseId],
      documentTypes: const [DocumentType.outcome],
    );

    final sumsByCategoryId = <ExpenseCategoryId, double>{};

    final expenseDocuments = await ref
        .read(expensesStorageProvider)
        .getByFilters(filters);
    for (final document in expenseDocuments) {
      for (final line in document.lines) {
        sumsByCategoryId[line.categoryId] =
            (sumsByCategoryId[line.categoryId] ?? 0) + line.sum;
      }
    }

    final statements = await ref
        .read(bankStatementStorageProvider)
        .getStatements(filters);
    for (final statement in statements) {
      for (final operation in statement.operations) {
        if (!operation.isDebit) continue;

        final amount = operation.debit ?? 0;
        if (amount <= 0) continue;

        final categoryId =
            operation.expenseCategoryId ?? _uncategorizedCategoryId;
        sumsByCategoryId[categoryId] =
            (sumsByCategoryId[categoryId] ?? 0) + amount;
      }
    }

    return sumsByCategoryId;
  }

  Future<List<ExpenseCategoryReportItem>> _buildCategoryItems(
    Map<ExpenseCategoryId, double> sumsByCategoryId,
  ) async {
    if (sumsByCategoryId.isEmpty) return [];

    final total = sumsByCategoryId.values.fold<double>(
      0,
      (sum, amount) => sum + amount,
    );
    if (total <= 0) return [];

    final categories = await ref.read(expenseCategoriesStorageProvider).getAll();
    final categoryNameById = {
      for (final category in categories) category.id: category.name,
    };

    final items = sumsByCategoryId.entries.map((entry) {
      final categoryName = entry.key == _uncategorizedCategoryId
          ? 'Прочее'
          : (categoryNameById[entry.key] ?? 'Прочее');

      return ExpenseCategoryReportItem(
        categoryName: categoryName,
        amount: entry.value,
        percentage: entry.value / total * 100,
      );
    }).toList();

    items.sort((a, b) => b.amount.compareTo(a.amount));
    return items;
  }
}
