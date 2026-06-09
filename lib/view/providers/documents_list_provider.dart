import 'package:easy_fin/data/documents_storage/documents_storage.dart';
import 'package:easy_fin/view/models/documents_table_item.dart';
import 'package:easy_fin/view/providers/documents_filters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final documentsListProvider = FutureProvider<List<DocumentsTableItem>>((
  ref,
) async {
  final filters = ref.watch(documentsFiltersProvider);

  return ref
      .read(documentsStorageProvider)
      .getDocuments(filters.toGetStatementsFilters());
});
