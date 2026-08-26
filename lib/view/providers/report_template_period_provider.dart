import 'package:easy_fin/models/report_template.dart';
import 'package:easy_fin/view/models/report_period.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: specify_nonobvious_property_types
final reportTemplatePeriodProvider = NotifierProvider.family<
    ReportTemplatePeriodNotifier, ReportPeriod, ReportTemplateId>(
  ReportTemplatePeriodNotifier.new,
);

class ReportTemplatePeriodNotifier extends Notifier<ReportPeriod> {
  ReportTemplatePeriodNotifier(this.templateId);

  final ReportTemplateId templateId;

  @override
  ReportPeriod build() => ReportPeriod.month();

  void setPeriod(ReportPeriod period) {
    state = period;
  }
}
