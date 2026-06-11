import 'package:easy_fin/data/models/back_statement.dart';
import 'package:easy_fin/utils/money.dart';

enum BankStatementImportIssueLevel { error, warning, info }

enum BankStatementImportIssueType { balanceContinuity }

class BankStatementImportIssue {
  const BankStatementImportIssue({
    required this.level,
    required this.type,
    required this.message,
    this.expectedBalance,
    this.actualBalance,
    this.previousStatement,
  });

  final BankStatementImportIssueLevel level;
  final BankStatementImportIssueType type;
  final String message;
  final double? expectedBalance;
  final double? actualBalance;
  final BankStatement? previousStatement;
}

class BankStatementImportValidator {
  const BankStatementImportValidator();

  List<BankStatementImportIssue> validate(
    BankStatement statement, {
    BankStatement? previousStatement,
  }) {
    final issues = <BankStatementImportIssue>[];

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
