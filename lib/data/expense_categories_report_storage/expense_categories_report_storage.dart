import 'package:easy_fin/data/bank_statements_storage/bank_statement_storage.dart';
import 'package:easy_fin/data/expense_categories_storage/expense_categories_storage.dart';
import 'package:easy_fin/data/expenses_storage/expenses_storage.dart';
import 'package:easy_fin/data/models/get_statements_filters.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:easy_fin/models/expense_category.dart';
import 'package:easy_fin/view/models/expense_category_report_item.dart';
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
}

class ExpenseCategoriesReportStorageImpl implements ExpenseCategoriesReportStorage {
  const ExpenseCategoriesReportStorageImpl(this.ref);

  final Ref ref;

  @override
  Future<List<ExpenseCategoryReportItem>> getReport({
    required BaseId baseId,
    required DateTime month,
  }) async {
    final monthStart = DateTime(month.year, month.month);
    final monthEnd = DateTime(month.year, month.month + 1, 0);

    final filters = GetStatementsFilters(
      startDate: monthStart,
      endDate: monthEnd,
      baseIds: [baseId],
      documentTypes: const [DocumentType.outcome],
    );

    final categories = await ref.read(expenseCategoriesStorageProvider).getAll();
    final categoryNameById = {
      for (final category in categories) category.id: category.name,
    };

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

    if (sumsByCategoryId.isEmpty) return [];

    final total = sumsByCategoryId.values.fold<double>(
      0,
      (sum, amount) => sum + amount,
    );
    if (total <= 0) return [];

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
