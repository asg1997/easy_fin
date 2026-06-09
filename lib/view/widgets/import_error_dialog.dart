import 'package:flutter/material.dart';

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
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('ОК'),
        ),
      ],
    );
  }
}
