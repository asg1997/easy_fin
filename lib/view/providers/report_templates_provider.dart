import 'package:easy_fin/data/report_templates_storage/report_templates_storage.dart';
import 'package:easy_fin/models/report_template.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportTemplatesProvider =
    AsyncNotifierProvider<ReportTemplatesNotifier, List<ReportTemplate>>(
  ReportTemplatesNotifier.new,
);

class ReportTemplatesNotifier extends AsyncNotifier<List<ReportTemplate>> {
  @override
  Future<List<ReportTemplate>> build() {
    return ref.read(reportTemplatesStorageProvider).getAll();
  }

  Future<void> save(ReportTemplate template) async {
    await ref.read(reportTemplatesStorageProvider).save(template);
    state = AsyncData(await ref.read(reportTemplatesStorageProvider).getAll());
  }

  Future<void> delete(ReportTemplateId id) async {
    await ref.read(reportTemplatesStorageProvider).delete(id);
    state = AsyncData(await ref.read(reportTemplatesStorageProvider).getAll());
  }
}
