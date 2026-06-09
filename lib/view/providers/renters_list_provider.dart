import 'package:easy_fin/data/renters_storage/renters_storage.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/models/renter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RentersListFilter extends Equatable {
  const RentersListFilter({
    required this.baseId,
    this.includeArchived = false,
  });

  final BaseId? baseId;
  final bool includeArchived;

  @override
  List<Object?> get props => [baseId, includeArchived];
}

final rentersListProvider = FutureProvider.family<List<Renter>, RentersListFilter>(
  (ref, filter) async {
    final baseId = filter.baseId;
    if (baseId == null) return [];

    final storage = ref.read(rentersStorageProvider);
    final activeRenters = await storage.getByBase(baseId);
    if (!filter.includeArchived) return activeRenters;

    final archivedRenters = await storage.getArchivedByBase(baseId);
    return [...archivedRenters, ...activeRenters];
  },
);
