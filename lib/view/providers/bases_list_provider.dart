import 'package:easy_fin/data/bases_storage/bases_storage.dart';
import 'package:easy_fin/models/base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final basesListProvider = FutureProvider<List<Base>>((ref) async {
  return ref.read(basesStorageProvider).getAll();
});
