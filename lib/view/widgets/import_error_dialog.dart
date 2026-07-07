import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImportErrorDialog extends StatelessWidget {
  const ImportErrorDialog({
    required this.message,
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ошибка импорта'),
      content: SingleChildScrollView(
        child: SelectableText(message),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: message));
          },
          child: const Text('Копировать'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('ОК'),
        ),
      ],
    );
  }
}
