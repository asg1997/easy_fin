import 'dart:async';

import 'package:easy_fin/data/notes_storage/notes_storage.dart';
import 'package:easy_fin/models/note.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/providers/github_sync_provider.dart';
import 'package:easy_fin/view/providers/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class NoteTagChips extends ConsumerStatefulWidget {
  const NoteTagChips({required this.note, super.key});

  final Note note;

  @override
  ConsumerState<NoteTagChips> createState() => _NoteTagChipsState();
}

class _NoteTagChipsState extends ConsumerState<NoteTagChips> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  var _isAdding = false;
  var _isBusy = false;
  var _query = '';
  /// Не закрывать поле при клике по подсказке (фокус уходит раньше onTap).
  var _ignoreNextBlur = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_onQueryChanged);
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    _controller
      ..removeListener(_onQueryChanged)
      ..dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    final next = _controller.text.trim();
    if (next == _query) return;
    setState(() => _query = next);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus || _isBusy) return;
    if (_ignoreNextBlur) {
      _ignoreNextBlur = false;
      return;
    }
    if (_controller.text.trim().isEmpty) {
      setState(() => _isAdding = false);
      return;
    }
    unawaited(_commit());
  }

  void _onSuggestionPointerDown() {
    _ignoreNextBlur = true;
  }

  List<String> _availableSuggestions(List<String> allTags) {
    final noteTagLowers =
        widget.note.tags.map((tag) => tag.toLowerCase()).toSet();
    final queryLower = _query.toLowerCase();

    return allTags.where((tag) {
      final lower = tag.toLowerCase();
      if (noteTagLowers.contains(lower)) return false;
      if (queryLower.isEmpty) return true;
      return lower.contains(queryLower);
    }).toList();
  }

  Future<void> _commit([String? rawOverride]) async {
    final raw = (rawOverride ?? _controller.text).trim();
    if (raw.isEmpty) {
      if (mounted) setState(() => _isAdding = false);
      return;
    }

    _isBusy = true;
    try {
      await ref.read(notesStorageProvider).addTag(widget.note.id, raw);
      ref
        ..invalidate(notesListProvider)
        ..invalidate(allNoteTagsProvider)
        ..invalidate(githubSyncDirtyProvider);
      if (!mounted) return;
      _controller.clear();
      setState(() {
        _query = '';
        // Остаёмся в режиме добавления, чтобы можно было выбрать ещё теги.
        _isAdding = true;
      });
      _focusNode.requestFocus();
    } on NoteTagEmptyError {
      if (!mounted) return;
      _controller.clear();
      setState(() {
        _query = '';
        _isAdding = false;
      });
    } on NoteTagTooLongError {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Тег слишком длинный (макс. $noteTagMaxLength)'),
        ),
      );
    } on NoteTagInvalidError {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Некорректное имя тега')),
      );
    } on NoteNotFoundError {
      ref.invalidate(notesListProvider);
    } finally {
      _isBusy = false;
    }
  }

  Future<void> _removeTag(String tagName) async {
    if (_isBusy) return;
    _isBusy = true;
    try {
      await ref.read(notesStorageProvider).removeTag(widget.note.id, tagName);
      ref
        ..invalidate(notesListProvider)
        ..invalidate(allNoteTagsProvider)
        ..invalidate(githubSyncDirtyProvider);

      final selected = ref.read(notesTagFilterProvider);
      if (selected != null &&
          selected.toLowerCase() == tagName.toLowerCase()) {
        final remaining = await ref.read(notesStorageProvider).getAllTags();
        final stillExists = remaining.any(
          (tag) => tag.toLowerCase() == tagName.toLowerCase(),
        );
        if (!stillExists) {
          ref.read(notesTagFilterProvider.notifier).selectAll();
        }
      }
    } on NoteNotFoundError {
      ref.invalidate(notesListProvider);
    } finally {
      _isBusy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tags = widget.note.tags;
    final allTags = ref.watch(allNoteTagsProvider).value ?? const <String>[];
    final suggestions =
        _isAdding ? _availableSuggestions(allTags) : const <String>[];

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final tag in tags)
                _TagChip(
                  label: tag,
                  onRemove: () => unawaited(_removeTag(tag)),
                ),
              if (_isAdding)
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    style: filterFieldTextStyle.copyWith(
                      fontSize: 12,
                      color: colors.primaryText,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'тег',
                      hintStyle: filterFieldHintTextStyleOf(context).copyWith(
                        fontSize: 12,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: colors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: colors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: colors.primaryText),
                      ),
                    ),
                    onSubmitted: (_) => unawaited(_commit()),
                    maxLength: noteTagMaxLength + 1,
                    buildCounter: (
                      context, {
                      required currentLength,
                      required isFocused,
                      maxLength,
                    }) =>
                        null,
                  ),
                )
              else
                InkWell(
                  onTap: () => setState(() => _isAdding = true),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.plus,
                          size: 12,
                          color: colors.secondaryText,
                        ),
                        const Gap(2),
                        Text(
                          'тег',
                          style: filterFieldHintTextStyleOf(context).copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          if (suggestions.isNotEmpty) ...[
            const Gap(6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final tag in suggestions)
                  Listener(
                    onPointerDown: (_) => _onSuggestionPointerDown(),
                    child: _SuggestionChip(
                      label: tag,
                      onTap: () => unawaited(_commit(tag)),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.onRemove,
  });

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.only(left: 8, right: 2, top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: colors.navActiveBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#$label',
            style: filterFieldTextStyle.copyWith(
              fontSize: 12,
              color: colors.secondaryText,
            ),
          ),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                LucideIcons.x,
                size: 12,
                color: colors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: colors.border),
          ),
          child: Text(
            '#$label',
            style: filterFieldTextStyle.copyWith(
              fontSize: 12,
              color: colors.secondaryText,
            ),
          ),
        ),
      ),
    );
  }
}
