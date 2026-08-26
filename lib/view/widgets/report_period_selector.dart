import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/view/models/report_period.dart';
import 'package:easy_fin/view/widgets/date_picker_field.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/widgets/month_navigator_field.dart';
import 'package:flutter/material.dart';

class ReportPeriodSelector extends StatelessWidget {
  const ReportPeriodSelector({
    required this.period,
    required this.onChanged,
    this.fieldWidth = 250,
    this.kindFieldWidth = 180,
    super.key,
  });

  final ReportPeriod period;
  final ValueChanged<ReportPeriod> onChanged;
  final double fieldWidth;
  final double kindFieldWidth;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: kindFieldWidth,
          height: filterFieldHeight,
          child: DropdownWidget<ReportPeriodKind>(
            expand: true,
            items: ReportPeriodKind.values,
            selectedItem: period.kind,
            labelBuilder: (kind) => kind.label,
            onChanged: (kind) => onChanged(
              ReportPeriod.forKind(kind, previous: period),
            ),
          ),
        ),
        ...switch (period) {
          final MonthReportPeriod monthPeriod => [
              SizedBox(
                width: fieldWidth,
                height: filterFieldHeight,
                child: MonthNavigatorField(
                  expand: true,
                  selectedMonth: monthPeriod.month,
                  canGoForward: monthPeriod.canGoForward,
                  onPrevious: () => onChanged(monthPeriod.previousMonth()),
                  onNext: () {
                    final next = monthPeriod.nextMonth();
                    if (next != null) onChanged(next);
                  },
                ),
              ),
            ],
          AllTimeReportPeriod() => const <Widget>[],
          final CustomReportPeriod customPeriod => [
              SizedBox(
                width: fieldWidth,
                height: filterFieldHeight,
                child: DatePickerField(
                  expand: true,
                  hint: 'Дата начала',
                  selectedDate: customPeriod.startDate,
                  onChanged: (date) => onChanged(
                    customPeriod.copyWith(
                      startDate: date,
                      clearStartDate: date == null,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: fieldWidth,
                height: filterFieldHeight,
                child: DatePickerField(
                  expand: true,
                  hint: 'Дата конца',
                  selectedDate: customPeriod.endDate,
                  onChanged: (date) => onChanged(
                    customPeriod.copyWith(
                      endDate: date,
                      clearEndDate: date == null,
                    ),
                  ),
                ),
              ),
            ],
        },
      ],
    );
  }
}
