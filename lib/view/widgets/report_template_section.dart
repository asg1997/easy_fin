import 'package:easy_fin/models/report_template.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/view/providers/report_template_month_provider.dart';
import 'package:easy_fin/view/providers/report_template_results_provider.dart';
import 'package:easy_fin/view/widgets/month_navigator_field.dart';
import 'package:easy_fin/view/widgets/report_table_theme.dart';
import 'package:easy_fin/view/widgets/report_template_results_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ReportTemplateSection extends ConsumerWidget {
  const ReportTemplateSection({
    required this.template,
    super.key,
  });

  final ReportTemplate template;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(reportTemplateMonthProvider(template.id));
    final monthNotifier =
        ref.read(reportTemplateMonthProvider(template.id).notifier);
    final resultsAsync = ref.watch(reportTemplateResultsProvider(template.id));

    return SizedBox(
      width: ReportTableTheme.standardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReportTableTitle(template.name),
          const Gap(12),
          SizedBox(
            height: filterFieldHeight,
            width: 220,
            child: MonthNavigatorField(
              expand: true,
              selectedMonth: month,
              canGoForward: monthNotifier.canGoForward,
              onPrevious: monthNotifier.goToPreviousMonth,
              onNext: monthNotifier.goToNextMonth,
            ),
          ),
          const Gap(12),
          resultsAsync.when(
            data: (items) => ReportTemplateResultsTable(items: items),
            loading: () => const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text('Не удалось загрузить отчёт'),
            ),
          ),
        ],
      ),
    );
  }
}
