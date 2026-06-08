import 'package:easy_fin/models/base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final basesStorageProvider = Provider<BasesStorage>(
  BasesStorageImpl.new,
);

abstract class BasesStorage {
  Future<void> save(Base base);
  Future<Base?> findById(BaseId id);
  Future<Base?> findByAccount(AccountNumber accountNumber);
  Future<List<Base>> getAll();
}

class BasesStorageImpl implements BasesStorage {
  const BasesStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<Base?> findById(BaseId id) {
    // TODO: implement findById
    throw UnimplementedError();
  }

  @override
  Future<Base?> findByAccount(AccountNumber accountNumber) {
    // TODO: implement find
    throw UnimplementedError();
  }

  @override
  Future<List<Base>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<void> save(Base base) {
    // TODO: implement save
    throw UnimplementedError();
  }
}
