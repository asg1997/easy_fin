import 'package:easy_fin/data/github_sync/models/sync_manifest.dart';
import 'package:easy_fin/utils/app_snack_bar.dart';
import 'package:easy_fin/view/providers/github_sync_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

Future<void> showGithubSyncConflictDialog(
  BuildContext context,
  WidgetRef ref, {
  required SyncManifest? localManifest,
  required SyncManifest remoteManifest,
}) async {
  final remoteDate = DateFormat('dd.MM.yyyy HH:mm')
      .format(remoteManifest.updatedAt.toLocal());
  final localDate = localManifest != null
      ? DateFormat('dd.MM.yyyy HH:mm').format(localManifest.updatedAt.toLocal())
      : 'неизвестно';

  final action = await showDialog<_SyncConflictAction>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Локальная версия новее'),
      content: Text(
        'На этом устройстве есть изменения, которые ещё не отправлены на GitHub.\n\n'
        'Локально: $localDate\n'
        'На GitHub: $remoteDate\n\n'
        'Что сделать?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, _SyncConflictAction.keepLocal),
          child: const Text('Продолжить с локальными'),
        ),
        TextButton(
          onPressed: () =>
              Navigator.pop(context, _SyncConflictAction.download),
          child: const Text('Скачать с GitHub'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _SyncConflictAction.upload),
          child: const Text('Отправить на GitHub'),
        ),
      ],
    ),
  );

  if (!context.mounted || action == null) return;

  switch (action) {
    case _SyncConflictAction.upload:
      try {
        await ref.read(githubSyncProvider.notifier).upload();
        if (!context.mounted) return;
        AppSnackBar.showMessage(context, 'Данные отправлены на GitHub');
      } catch (_) {}
    case _SyncConflictAction.download:
      try {
        await ref.read(githubSyncProvider.notifier).forceDownload();
        if (!context.mounted) return;
        AppSnackBar.showMessage(context, 'Данные скачаны с GitHub');
      } catch (e) {
        if (!context.mounted) return;
        AppSnackBar.showError(context, 'Ошибка скачивания: $e');
      }
    case _SyncConflictAction.keepLocal:
      if (!context.mounted) return;
      AppSnackBar.showMessage(context, 'Используются локальные данные');
  }
}

enum _SyncConflictAction { upload, download, keepLocal }
