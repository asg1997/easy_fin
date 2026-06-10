import 'package:easy_fin/view/providers/account_balances_provider.dart';
import 'package:easy_fin/view/widgets/account_balances_table.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balancesAsync = ref.watch(accountBalancesProvider);

    return TemplatePage(
      title: 'Отчеты',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Остатки по счетам',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(8),
          balancesAsync.when(
            data: (items) => AccountBalancesTable(items: items),
            loading: () => const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text('Не удалось загрузить остатки'),
            ),
          ),
        ],
      ),
    );
  }
}
