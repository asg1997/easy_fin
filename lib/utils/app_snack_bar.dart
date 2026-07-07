import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract final class AppSnackBar {
  AppSnackBar._();

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 8),
        content: _CopyableErrorContent(message: message),
      ),
    );
  }

  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static Future<void> showErrorDialog(
    BuildContext context,
    String message, {
    String title = 'Ошибка',
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
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
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('ОК'),
          ),
        ],
      ),
    );
  }
}

class _CopyableErrorContent extends StatelessWidget {
  const _CopyableErrorContent({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final textColor = DefaultTextStyle.of(context).style.color ?? Colors.white;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(message)),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: message));
          },
          style: TextButton.styleFrom(
            foregroundColor: textColor,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Копировать',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
