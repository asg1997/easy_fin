import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/providers/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class NotesSearchField extends ConsumerStatefulWidget {
  const NotesSearchField({super.key});

  @override
  ConsumerState<NotesSearchField> createState() => _NotesSearchFieldState();
}

class _NotesSearchFieldState extends ConsumerState<NotesSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(notesSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final query = ref.watch(notesSearchQueryProvider);

    ref.listen<String>(notesSearchQueryProvider, (previous, next) {
      if (_controller.text != next) {
        _controller.value = TextEditingValue(
          text: next,
          selection: TextSelection.collapsed(offset: next.length),
        );
      }
    });

    return TextField(
      controller: _controller,
      style: filterFieldTextStyle.copyWith(color: colors.primaryText),
      decoration: composerFieldDecorationOf(
        context,
        hintText: 'Поиск по заметкам…',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ).copyWith(
        prefixIcon: Icon(
          LucideIcons.search,
          size: 16,
          color: colors.secondaryText,
        ),
        suffixIcon: query.trim().isEmpty
            ? null
            : IconButton(
                tooltip: 'Очистить',
                onPressed: () {
                  _controller.clear();
                  ref.read(notesSearchQueryProvider.notifier).clear();
                },
                icon: Icon(
                  LucideIcons.x,
                  size: 16,
                  color: colors.secondaryText,
                ),
              ),
      ),
      onChanged: (value) {
        ref.read(notesSearchQueryProvider.notifier).setQuery(value);
      },
    );
  }
}
