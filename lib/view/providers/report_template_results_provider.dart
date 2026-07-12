import 'package:easy_fin/data/report_template_results_storage/report_template_results_storage.dart';
import 'package:easy_fin/models/report_template.dart';
import 'package:easy_fin/view/models/report_template_result_item.dart';
import 'package:easy_fin/view/providers/report_template_month_provider.dart';
import 'package:easy_fin/view/providers/report_templates_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportTemplateResultsProvider = FutureProvider.family<
    List<ReportTemplateResultItem>, ReportTemplateId>((ref, templateId) async {
  final templates = await ref.watch(reportTemplatesProvider.future);
  ReportTemplate? template;
  for (final item in templates) {
    if (item.id == templateId) {
      template = item;
      break;
    }
  }
  if (template == null) return [];

  final month = ref.watch(reportTemplateMonthProvider(templateId));
  return ref.read(reportTemplateResultsStorageProvider).getResults(
        template: template,
        month: month,
      );
});
