import 'package:easy_fin/data/financial_result_report_storage/financial_result_report_storage.dart';
import 'package:easy_fin/view/models/financial_result_monthly_report_item.dart';
import 'package:easy_fin/view/models/financial_result_report.dart';
import 'package:easy_fin/view/models/report_period.dart';
import 'package:easy_fin/view/providers/financial_result_report_filters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final financialResultReportProvider =
    FutureProvider<FinancialResultReport>((ref) async {
  final filters = ref.watch(financialResultReportFiltersProvider);
  final period = filters.period;
  if (!period.isComplete) return FinancialResultReport.empty;

  return ref.read(financialResultReportStorageProvider).getReport(
        baseId: filters.selectedBaseFilter.baseId,
        startDate: period.startDate,
        endDate: period.endDate,
      );
});

final financialResultMonthlyProvider =
    FutureProvider<List<FinancialResultMonthlyReportItem>>((ref) async {
  final filters = ref.watch(financialResultReportFiltersProvider);
  final period = filters.period;
  if (period is! MonthReportPeriod) return [];

  return ref.read(financialResultReportStorageProvider).getMonthlyReport(
        baseId: filters.selectedBaseFilter.baseId,
        year: period.month.year,
      );
});
