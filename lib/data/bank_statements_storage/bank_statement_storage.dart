import 'package:easy_fin/data/bank_statements_storage/bank_statement_saver/bank_statement_saver.dart';
import 'package:easy_fin/data/models/back_statement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bankStatementStorageProvider = Provider<BankStatementStorage>(
  BankStatementStorageImpl.new,
);

/// Хранилище выписок по банковскому счету
abstract class BankStatementStorage {
  Future<void> save(BankStatement bankStatement);
}

class BankStatementStorageImpl implements BankStatementStorage {
  const BankStatementStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<void> save(BankStatement bankStatement) async {
    await ref.read(bankStatementSaverProvider).save(bankStatement);
  }
}
