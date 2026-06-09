import 'package:easy_fin/data/renters_storage/renters_storage.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rentersListProvider = FutureProvider<List<Renter>>((ref) async {
  return ref.read(rentersStorageProvider).getAll();
});
