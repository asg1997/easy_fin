import 'package:easy_fin/models/report_template.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportTemplateMonthProvider =
    NotifierProvider.family<ReportTemplateMonthNotifier, DateTime,
        ReportTemplateId>(
  ReportTemplateMonthNotifier.new,
);

class ReportTemplateMonthNotifier extends Notifier<DateTime> {
  ReportTemplateMonthNotifier(this.templateId);

  final ReportTemplateId templateId;

  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  bool get canGoForward {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    return state.isBefore(currentMonth);
  }

  void setMonth(DateTime month) {
    state = DateTime(month.year, month.month);
  }

  void goToPreviousMonth() {
    final previousMonth = state.month == 1
        ? DateTime(state.year - 1, 12)
        : DateTime(state.year, state.month - 1);
    setMonth(previousMonth);
  }

  void goToNextMonth() {
    if (!canGoForward) return;

    final nextMonth = state.month == 12
        ? DateTime(state.year + 1)
        : DateTime(state.year, state.month + 1);
    setMonth(nextMonth);
  }
}
