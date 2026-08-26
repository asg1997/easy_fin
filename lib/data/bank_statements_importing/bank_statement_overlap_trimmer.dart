import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/data/models/bank_statement_operation.dart';
import 'package:easy_fin/utils/money.dart';

/// Обрезает новую выписку до раннего фрагмента без пересечения
/// с уже загруженной.
class BankStatementOverlapTrimmer {
  const BankStatementOverlapTrimmer();

  /// Возвращает выписку только с операциями до начала уже загруженного
  /// периода, либо `null`, если раннего фрагмента нет.
  BankStatement? trimToEarlyNonOverlapping({
    required BankStatement statement,
    required DateTime overlappingStartDate,
  }) {
    final cutoff = _dateOnly(overlappingStartDate);
    final statementStart = _dateOnly(statement.startDate);

    if (!statementStart.isBefore(cutoff)) return null;

    final keptOperations = statement.operations
        .where((operation) => _dateOnly(operation.date).isBefore(cutoff))
        .toList(growable: false);

    if (keptOperations.isEmpty) return null;

    final newEndDate = DateTime(cutoff.year, cutoff.month, cutoff.day - 1);
    if (newEndDate.isBefore(statementStart)) return null;

    return statement.copyWith(
      endDate: newEndDate,
      finalBalance: _calculateFinalBalance(
        statement.initialBalance,
        keptOperations,
      ),
      operations: keptOperations,
    );
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  double _calculateFinalBalance(
    double initialBalance,
    List<BankStatementOperation> operations,
  ) {
    var balanceMinor = moneyToMinor(initialBalance);
    for (final operation in operations) {
      if (operation.credit != null) {
        balanceMinor += moneyToMinor(operation.credit!);
      }
      if (operation.debit != null) {
        balanceMinor -= moneyToMinor(operation.debit!);
      }
    }
    return moneyFromMinor(balanceMinor);
  }
}
