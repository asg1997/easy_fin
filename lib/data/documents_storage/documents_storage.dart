import 'package:easy_fin/data/bank_statements_storage/bank_statement_storage.dart';
import 'package:easy_fin/data/bases_storage/bases_storage.dart';
import 'package:easy_fin/data/expense_categories_storage/expense_categories_storage.dart';
import 'package:easy_fin/data/income_categories_storage/income_categories_storage.dart';
import 'package:easy_fin/data/expenses_storage/expenses_storage.dart';
import 'package:easy_fin/data/incomes_storage/incomes_storage.dart';
import 'package:easy_fin/data/models/bank_statement_operation.dart';
import 'package:easy_fin/data/models/get_statements_filters.dart';
import 'package:easy_fin/data/renter_assignments_storage/renter_assignments_storage.dart';
import 'package:easy_fin/data/renters_storage/renters_storage.dart';
import 'package:easy_fin/models/account_filter_type.dart';
import 'package:easy_fin/models/document_type.dart';
import 'package:easy_fin/models/expense.dart';
import 'package:easy_fin/models/expense_document.dart';
import 'package:easy_fin/models/income.dart';
import 'package:easy_fin/models/income_document.dart';
import 'package:easy_fin/models/renter_assignment.dart';
import 'package:easy_fin/view/models/documents_table_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final documentsStorageProvider = Provider<DocumentsStorage>(
  DocumentsStorageImpl.new,
);

abstract class DocumentsStorage {
  Future<List<DocumentsTableItem>> getDocuments(
    GetStatementsFilters filters,
  );
}

class DocumentsStorageImpl implements DocumentsStorage {
  const DocumentsStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<List<DocumentsTableItem>> getDocuments(
    GetStatementsFilters filters,
  ) async {
    final bases = await ref.read(basesStorageProvider).getAll();
    final baseNameById = {for (final base in bases) base.id: base.name};
    final baseByAccountNumber = <String, String>{};
    for (final base in bases) {
      for (final accountNumber in base.accountNumbers) {
        baseByAccountNumber[accountNumber] = base.name;
      }
    }

    final items = <DocumentsTableItem>[];

    final renters = await ref.read(rentersStorageProvider).getAll();
    final renterNameById = {
      for (final renter in renters) renter.id: renter.name,
    };
    final categories = await ref.read(incomeCategoriesStorageProvider).getAll();
    final categoryNameById = {
      for (final category in categories) category.id: category.name,
    };
    final expenseCategories = await ref
        .read(expenseCategoriesStorageProvider)
        .getAll();
    final expenseCategoryNameById = {
      for (final category in expenseCategories) category.id: category.name,
    };

    final statements = await ref
        .read(bankStatementStorageProvider)
        .getStatements(filters);

    for (final statement in statements) {
      final baseName = baseByAccountNumber[statement.accountNumber] ?? '';

      for (final operation in statement.operations) {
        final operationId = operation.id;
        if (operationId == null) continue;

        items.add(
          DocumentsTableItem(
            operationId: operationId,
            date: operation.date,
            documentType: _documentType(operation.isCredit),
            accountType: statement.accountNumber,
            baseName: baseName,
            amount: operation.credit ?? operation.debit ?? 0,
            note: _bankOperationNote(
              operation,
              renterNameById: renterNameById,
              categoryNameById: categoryNameById,
              expenseCategoryNameById: expenseCategoryNameById,
            ),
          ),
        );
      }
    }

    final assignments = await ref
        .read(renterAssignmentsStorageProvider)
        .getByFilters(filters);
    if (assignments.isNotEmpty) {
      final groupedAssignments = <String, List<RenterAssignment>>{};
      for (final assignment in assignments) {
        final key =
            '${assignment.baseId}_${assignment.date.year}_${assignment.date.month}';
        groupedAssignments.putIfAbsent(key, () => []).add(assignment);
      }

      for (final group in groupedAssignments.values) {
        final first = group.first;
        final totalAmount = group.fold<double>(
          0,
          (sum, assignment) => sum + assignment.sum,
        );

        items.add(
          DocumentsTableItem(
            baseId: first.baseId,
            date: first.date,
            documentType: DocumentType.renterAssignment,
            accountType: 'Аренда',
            baseName: baseNameById[first.baseId] ?? '',
            amount: totalAmount,
            note: '',
          ),
        );
      }
    }

    final incomeDocuments = await ref
        .read(incomesStorageProvider)
        .getByFilters(filters);
    if (incomeDocuments.isNotEmpty) {
      final incomeRenterNameById = {
        for (final renter in renters) renter.id: renter.name,
      };
      final incomeCategoryNameById = {
        for (final category in categories) category.id: category.name,
      };

      for (final document in incomeDocuments) {
        items.add(
          DocumentsTableItem(
            incomeDocumentId: document.id,
            date: document.date,
            documentType: DocumentType.income,
            accountType: _incomeAccountLabel(document.account),
            baseName: baseNameById[document.baseId] ?? '',
            amount: document.totalSum,
            note: _incomeNote(
              document.lines,
              categoryNameById: incomeCategoryNameById,
              renterNameById: incomeRenterNameById,
            ),
          ),
        );
      }
    }

    final expenseDocuments = await ref
        .read(expensesStorageProvider)
        .getByFilters(filters);
    if (expenseDocuments.isNotEmpty) {
      for (final document in expenseDocuments) {
        items.add(
          DocumentsTableItem(
            expenseDocumentId: document.id,
            date: document.date,
            documentType: DocumentType.outcome,
            accountType: _expenseAccountLabel(document.account),
            baseName: baseNameById[document.baseId] ?? '',
            amount: document.totalSum,
            note: _expenseNote(
              document.lines,
              categoryNameById: expenseCategoryNameById,
            ),
          ),
        );
      }
    }

    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  DocumentType _documentType(bool isCredit) {
    return isCredit ? DocumentType.income : DocumentType.outcome;
  }

  String _bankOperationNote(
    BankStatementOperation operation, {
    required Map<String, String> renterNameById,
    required Map<int, String> categoryNameById,
    required Map<int, String> expenseCategoryNameById,
  }) {
    if (operation.renterId != null) {
      final renterName =
          renterNameById[operation.renterId!] ?? 'Арендатор';
      return '$renterName: ${operation.note}';
    }
    if (operation.incomeCategoryId != null) {
      final categoryName =
          categoryNameById[operation.incomeCategoryId!] ?? 'Прочее';
      return '$categoryName: ${operation.note}';
    }
    if (operation.expenseCategoryId != null) {
      final categoryName =
          expenseCategoryNameById[operation.expenseCategoryId!] ?? 'Прочее';
      return '$categoryName: ${operation.note}';
    }
    return operation.note;
  }

  String _incomeAccountLabel(IncomeDocumentAccount account) {
    return switch (account) {
      IncomeDocumentCashAccount() => AccountFilterType.cash.label,
      IncomeDocumentBankAccount(:final accountNumber) => accountNumber,
    };
  }

  String _incomeNote(
    List<Income> lines, {
    required Map<int, String> categoryNameById,
    required Map<String, String> renterNameById,
  }) {
    final parts = <String>[];
    for (final line in lines) {
      final source = line.incomeSource;
      final label = switch (source) {
        IncomeSourceFromRenter(:final renterId) =>
          'Взаиморасчёты: ${renterNameById[renterId] ?? 'Арендатор'}',
        IncomeSourceFromOther(:final categoryId) =>
          categoryNameById[categoryId] ?? 'Прочее',
      };
      parts.add(label);
    }
    return parts.join(', ');
  }

  String _expenseAccountLabel(ExpenseDocumentAccount account) {
    return switch (account) {
      ExpenseDocumentCashAccount() => AccountFilterType.cash.label,
      ExpenseDocumentBankAccount(:final accountNumber) => accountNumber,
    };
  }

  String _expenseNote(
    List<Expense> lines, {
    required Map<int, String> categoryNameById,
  }) {
    final parts = <String>[];
    for (final line in lines) {
      parts.add(categoryNameById[line.categoryId] ?? 'Прочее');
    }
    return parts.join(', ');
  }
}
