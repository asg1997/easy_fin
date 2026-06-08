import 'package:easy_fin/models/base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final basesStorageProvider = Provider<BasesStorage>(
  BasesStorageImpl.new,
);

abstract class BasesStorage {
  Future<void> save(Base base);
  Future<Base?> findByAccount(AccountNumber id);
  Future<List<Base>> getAll();
}

class BasesStorageImpl implements BasesStorage {
  const BasesStorageImpl(this.ref);
  final Ref ref;

  @override
  Future<Base?> findByAccount(AccountNumber id) {
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
