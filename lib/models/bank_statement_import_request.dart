import 'dart:io';

import 'package:equatable/equatable.dart';

/// Запрос на импорт выписок по банковскому счету
class BankStatementImportRequest extends Equatable {
  const BankStatementImportRequest({required this.xlsFiles});

  /// Файлы в формате .xls
  final List<File> xlsFiles;
  @override
  List<Object?> get props => [xlsFiles];
}
