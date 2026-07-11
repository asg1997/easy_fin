import 'package:easy_fin/view/controllers/import_controller.dart';
import 'package:easy_fin/view/pages/add_expense_page.dart';
import 'package:easy_fin/view/pages/add_income_page.dart';
import 'package:easy_fin/view/pages/add_rent_accrual_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void openAddIncome(BuildContext context) {
  AddIncomePage.navigate(context);
}

void openAddExpense(BuildContext context) {
  AddExpensePage.navigate(context);
}

void openAddRentAccrual(BuildContext context) {
  AddRentAccrualPage.navigate(context);
}

Future<void> openImport(BuildContext context, WidgetRef ref) async {
  if (ref.read(importControllerProvider).isImportInProgress) return;
  await ref.read(importControllerProvider.notifier).pickAndImport();
}
