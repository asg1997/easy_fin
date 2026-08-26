import 'package:easy_fin/models/report_template.dart';
import 'package:easy_fin/view/providers/report_template_period_provider.dart';
import 'package:easy_fin/view/providers/report_template_results_provider.dart';
import 'package:easy_fin/view/widgets/report_period_selector.dart';
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
    final period = ref.watch(reportTemplatePeriodProvider(template.id));
    final periodNotifier =
        ref.read(reportTemplatePeriodProvider(template.id).notifier);
    final resultsAsync = ref.watch(reportTemplateResultsProvider(template.id));

    return SizedBox(
      width: ReportTableTheme.standardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReportTableTitle(template.name),
          const Gap(12),
          ReportPeriodSelector(
            period: period,
            onChanged: periodNotifier.setPeriod,
            fieldWidth: 220,
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
