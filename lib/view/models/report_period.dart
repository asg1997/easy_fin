import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

enum ReportPeriodKind {
  month,
  allTime,
  custom,
}

extension ReportPeriodKindLabel on ReportPeriodKind {
  String get label => switch (this) {
        ReportPeriodKind.month => 'Месяц',
        ReportPeriodKind.allTime => 'За всё время',
        ReportPeriodKind.custom => 'Даты',
      };
}

sealed class ReportPeriod extends Equatable {
  const ReportPeriod();

  ReportPeriodKind get kind;

  DateTime? get startDate;

  DateTime? get endDate;

  String get label;

  bool get isComplete;

  static ReportPeriod month([DateTime? month]) {
    final source = month ?? DateTime.now();
    return MonthReportPeriod(DateTime(source.year, source.month));
  }

  static ReportPeriod allTime() => const AllTimeReportPeriod();

  static ReportPeriod custom({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return CustomReportPeriod(
      startDate: startDate,
      endDate: endDate,
    );
  }

  static ReportPeriod forKind(ReportPeriodKind kind, {ReportPeriod? previous}) {
    return switch (kind) {
      ReportPeriodKind.month => switch (previous) {
          MonthReportPeriod(:final month) => ReportPeriod.month(month),
          CustomReportPeriod(:final startDate?) =>
            ReportPeriod.month(startDate),
          _ => ReportPeriod.month(),
        },
      ReportPeriodKind.allTime => ReportPeriod.allTime(),
      ReportPeriodKind.custom => switch (previous) {
          final CustomReportPeriod custom => custom,
          MonthReportPeriod(:final month) => ReportPeriod.custom(
              startDate: DateTime(month.year, month.month),
              endDate: DateTime(month.year, month.month + 1, 0),
            ),
          _ => _defaultCustomPeriod(),
        },
    };
  }

  static CustomReportPeriod _defaultCustomPeriod() {
    final now = DateTime.now();
    return CustomReportPeriod(
      startDate: DateTime(now.year, now.month),
      endDate: DateTime(now.year, now.month + 1, 0),
    );
  }
}

final class MonthReportPeriod extends ReportPeriod {
  const MonthReportPeriod(this.month);

  final DateTime month;

  @override
  ReportPeriodKind get kind => ReportPeriodKind.month;

  @override
  DateTime get startDate => DateTime(month.year, month.month);

  @override
  DateTime get endDate => DateTime(month.year, month.month + 1, 0);

  @override
  bool get isComplete => true;

  bool get canGoForward {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    return month.isBefore(currentMonth);
  }

  MonthReportPeriod previousMonth() {
    final previous = month.month == 1
        ? DateTime(month.year - 1, 12)
        : DateTime(month.year, month.month - 1);
    return MonthReportPeriod(previous);
  }

  MonthReportPeriod? nextMonth() {
    if (!canGoForward) return null;
    final next = month.month == 12
        ? DateTime(month.year + 1)
        : DateTime(month.year, month.month + 1);
    return MonthReportPeriod(next);
  }

  @override
  String get label {
    final formatted = DateFormat('LLLL yyyy', 'ru').format(month);
    if (formatted.isEmpty) return formatted;
    return '${formatted[0].toUpperCase()}${formatted.substring(1)}';
  }

  @override
  List<Object?> get props => [month];
}

final class AllTimeReportPeriod extends ReportPeriod {
  const AllTimeReportPeriod();

  @override
  ReportPeriodKind get kind => ReportPeriodKind.allTime;

  @override
  DateTime? get startDate => null;

  @override
  DateTime? get endDate => null;

  @override
  bool get isComplete => true;

  @override
  String get label => 'За всё время';

  @override
  List<Object?> get props => [];
}

final class CustomReportPeriod extends ReportPeriod {
  const CustomReportPeriod({
    this.startDate,
    this.endDate,
  });

  @override
  final DateTime? startDate;

  @override
  final DateTime? endDate;

  @override
  ReportPeriodKind get kind => ReportPeriodKind.custom;

  @override
  bool get isComplete => startDate != null || endDate != null;

  @override
  String get label {
    final formatter = DateFormat('dd.MM.yyyy', 'ru');
    final start = startDate;
    final end = endDate;
    if (start != null && end != null) {
      return '${formatter.format(start)} — ${formatter.format(end)}';
    }
    if (start != null) return 'с ${formatter.format(start)}';
    if (end != null) return 'до ${formatter.format(end)}';
    return 'Даты не выбраны';
  }

  CustomReportPeriod copyWith({
    DateTime? startDate,
    DateTime? endDate,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return CustomReportPeriod(
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
    );
  }

  @override
  List<Object?> get props => [startDate, endDate];
}
