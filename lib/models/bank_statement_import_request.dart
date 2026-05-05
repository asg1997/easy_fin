import 'dart:io';

import 'package:equatable/equatable.dart';

/// Запрос на импорт выписок по банковскому счету
class BankStatementImportRequest extends Equatable {
  const BankStatementImportRequest({required this.files});
  final List<File> files;
  @override
  List<Object?> get props => [files];
}
