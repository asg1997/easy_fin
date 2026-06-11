import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/utils/money.dart';

enum BankStatementImportIssueLevel { error, warning, info }

enum BankStatementImportIssueType {
  internalBalance,
  balanceContinuity,
  outOfOrder,
  periodOverlap,
}

class BankStatementImportIssue {
  const BankStatementImportIssue({
    required this.level,
    required this.type,
    required this.message,
    this.expectedBalance,
    this.actualBalance,
    this.previousStatement,
    this.nextStatement,
    this.overlappingStatement,
  });

  final BankStatementImportIssueLevel level;
  final BankStatementImportIssueType type;
  final String message;
  final double? expectedBalance;
  final double? actualBalance;
  final BankStatement? previousStatement;
  final BankStatement? nextStatement;
  final BankStatement? overlappingStatement;
}

class BankStatementImportValidator {
  const BankStatementImportValidator();

  static bool periodsOverlap(
    DateTime aStart,
    DateTime aEnd,
    DateTime bStart,
    DateTime bEnd,
  ) =>
      !aStart.isAfter(bEnd) && !aEnd.isBefore(bStart);

  BankStatementImportIssue? findInternalBalanceIssue(BankStatement statement) {
    final calculatedFinalBalance = _calculateFinalBalance(statement);
    if (moneyToMinor(calculatedFinalBalance) ==
        moneyToMinor(statement.finalBalance)) {
      return null;
    }

    return BankStatementImportIssue(
      level: BankStatementImportIssueLevel.error,
      type: BankStatementImportIssueType.internalBalance,
      message:
          'Внутренняя проверка выписки не пройдена: '
          'исходящий остаток (${statement.finalBalance}) '
          'не совпадает с рассчитанным ($calculatedFinalBalance) '
          'по операциям за период '
          '${_formatDate(statement.startDate)} — ${_formatDate(statement.endDate)}',
      expectedBalance: calculatedFinalBalance,
      actualBalance: statement.finalBalance,
    );
  }

  double _calculateFinalBalance(BankStatement statement) {
    var balance = statement.initialBalance;
    for (final operation in statement.operations) {
      if (operation.credit != null) {
        balance += operation.credit!;
      }
      if (operation.debit != null) {
        balance -= operation.debit!;
      }
    }
    return balance;
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.'
      '${date.year}';

  BankStatementImportIssue? findOutOfOrderIssue(
    BankStatement statement,
    BankStatement nextStatement,
  ) {
    final hasBalanceGap =
        moneyToMinor(statement.finalBalance) !=
        moneyToMinor(nextStatement.initialBalance);

    return BankStatementImportIssue(
      level: BankStatementImportIssueLevel.warning,
      type: BankStatementImportIssueType.outOfOrder,
      message: hasBalanceGap
          ? 'Выписка загружается не по хронологии: исходящий остаток '
              'не совпадает с входящим остатком следующей выписки'
          : 'Выписка загружается не по хронологии: уже есть более '
              'новая выписка по этому счёту',
      expectedBalance: nextStatement.initialBalance,
      actualBalance: statement.finalBalance,
      nextStatement: nextStatement,
    );
  }

  List<BankStatementImportIssue> validate(
    BankStatement statement, {
    BankStatement? previousStatement,
    BankStatement? nextStatement,
    BankStatement? overlappingStatement,
  }) {
    final issues = <BankStatementImportIssue>[];

    final internalBalanceIssue = findInternalBalanceIssue(statement);
    if (internalBalanceIssue != null) {
      issues.add(internalBalanceIssue);
    }

    if (overlappingStatement != null) {
      issues.add(
        BankStatementImportIssue(
          level: BankStatementImportIssueLevel.error,
          type: BankStatementImportIssueType.periodOverlap,
          message:
              'Период выписки пересекается с уже загруженной выпиской по этому счёту',
          overlappingStatement: overlappingStatement,
        ),
      );
    }

    if (previousStatement != null &&
        moneyToMinor(statement.initialBalance) !=
            moneyToMinor(previousStatement.finalBalance)) {
      issues.add(
        BankStatementImportIssue(
          level: BankStatementImportIssueLevel.warning,
          type: BankStatementImportIssueType.balanceContinuity,
          message:
              'Входящий остаток не совпадает с исходящим остатком предыдущей выписки',
          expectedBalance: previousStatement.finalBalance,
          actualBalance: statement.initialBalance,
          previousStatement: previousStatement,
        ),
      );
    }

    if (nextStatement != null) {
      final outOfOrderIssue = findOutOfOrderIssue(statement, nextStatement);
      if (outOfOrderIssue != null) {
        issues.add(outOfOrderIssue);
      }
    }

    return issues;
  }
}
