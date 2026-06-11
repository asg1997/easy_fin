import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/utils/money.dart';

enum BankStatementImportIssueLevel { error, warning, info }

enum BankStatementImportIssueType { balanceContinuity, periodOverlap }

class BankStatementImportIssue {
  const BankStatementImportIssue({
    required this.level,
    required this.type,
    required this.message,
    this.expectedBalance,
    this.actualBalance,
    this.previousStatement,
    this.overlappingStatement,
  });

  final BankStatementImportIssueLevel level;
  final BankStatementImportIssueType type;
  final String message;
  final double? expectedBalance;
  final double? actualBalance;
  final BankStatement? previousStatement;
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

  List<BankStatementImportIssue> validate(
    BankStatement statement, {
    BankStatement? previousStatement,
    BankStatement? overlappingStatement,
  }) {
    final issues = <BankStatementImportIssue>[];

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

    return issues;
  }
}
