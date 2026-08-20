import 'dart:async';

import 'package:easy_fin/data/notes_storage/notes_storage.dart';
import 'package:easy_fin/models/note.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/providers/github_sync_provider.dart';
import 'package:easy_fin/view/providers/notes_provider.dart';
import 'package:easy_fin/view/widgets/confirm_dialog.dart';
import 'package:easy_fin/view/widgets/note_tag_chips.dart';
import 'package:easy_fin/view/widgets/notes_search_field.dart';
import 'package:easy_fin/view/widgets/notes_tag_filter_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class NotesList extends ConsumerWidget {
  const NotesList({super.key});

  static final _dateFormat = DateFormat('d MMM yyyy', 'ru');

  Future<void> _onDelete(
    BuildContext context,
    WidgetRef ref,
    Note note,
  ) async {
    final preview = note.text.length > 60
        ? '${note.text.substring(0, 60)}…'
        : note.text;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Удалить заметку?',
        message: 'Заметка «$preview» будет удалена безвозвратно.',
        confirmLabel: 'Удалить',
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(notesStorageProvider).delete(note.id);
      ref
        ..invalidate(notesListProvider)
        ..invalidate(allNoteTagsProvider)
        ..invalidate(githubSyncDirtyProvider);

      final selected = ref.read(notesTagFilterProvider);
      if (selected != null) {
        final remaining = await ref.read(notesStorageProvider).getAllTags();
        final stillExists = remaining.any(
          (tag) => tag.toLowerCase() == selected.toLowerCase(),
        );
        if (!stillExists) {
          ref.read(notesTagFilterProvider.notifier).selectAll();
        }
      }
    } on NoteNotFoundError {
      // Уже удалена — просто обновим список.
      ref.invalidate(notesListProvider);
    }
  }

  String _metaLabel(Note note) {
    final created = _dateFormat.format(note.createdAt);
    if (note.updatedAt.isAtSameMomentAs(note.createdAt) ||
        note.updatedAt.difference(note.createdAt).inSeconds.abs() < 1) {
      return created;
    }
    return '$created · изменено ${_dateFormat.format(note.updatedAt)}';
  }

  String _emptyMessage({
    required String? tagFilter,
    required String searchQuery,
  }) {
    final hasSearch = searchQuery.trim().isNotEmpty;
    final hasTag = tagFilter != null;
    if (hasSearch || hasTag) return 'Ничего не найдено';
    return 'Пока нет заметок';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesListProvider);
    final tagFilter = ref.watch(notesTagFilterProvider);
    final searchQuery = ref.watch(notesSearchQueryProvider);
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _NewNoteField(),
        const Gap(12),
        const NotesSearchField(),
        const NotesTagFilterBar(),
        const Gap(12),
        Expanded(
          child: notesAsync.when(
            data: (notes) {
              if (notes.isEmpty) {
                return Center(
                  child: Text(
                    _emptyMessage(
                      tagFilter: tagFilter,
                      searchQuery: searchQuery,
                    ),
                    style: filterFieldHintTextStyleOf(context),
                  ),
                );
              }

              return ListView.separated(
                itemCount: notes.length,
                separatorBuilder: (_, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: colors.border, thickness: 0.5),
                ),
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Material(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.border),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _metaLabel(note),
                                  style: filterFieldHintTextStyleOf(context)
                                      .copyWith(fontSize: 12),
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _onDelete(context, ref, note),
                                icon: Icon(
                                  LucideIcons.trash2,
                                  size: 16,
                                  color: colors.secondaryText,
                                ),
                                tooltip: 'Удалить',
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                              ),
                            ],
                          ),
                          NoteTagChips(note: note),
                          _NoteTextField(note: note),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const Center(
              child: Text('Не удалось загрузить заметки'),
            ),
          ),
        ),
      ],
    );
  }
}

class _NewNoteField extends ConsumerStatefulWidget {
  const _NewNoteField();

  @override
  ConsumerState<_NewNoteField> createState() => _NewNoteFieldState();
}

class _NewNoteFieldState extends ConsumerState<_NewNoteField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode(onKeyEvent: _onKeyEvent)
      ..addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey != LogicalKeyboardKey.enter) {
      return KeyEventResult.ignored;
    }

    final isMac = defaultTargetPlatform == TargetPlatform.macOS;
    final hasShortcutModifier = isMac
        ? HardwareKeyboard.instance.isMetaPressed
        : HardwareKeyboard.instance.isControlPressed;
    if (!hasShortcutModifier) return KeyEventResult.ignored;

    unawaited(_commitFromShortcut());
    return KeyEventResult.handled;
  }

  Future<void> _onFocusChange() async {
    if (_focusNode.hasFocus || _isSaving) return;
    await _commit();
  }

  Future<void> _commit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _isSaving = true;
    try {
      await ref.read(notesStorageProvider).create(text);
      ref
        ..invalidate(notesListProvider)
        ..invalidate(githubSyncDirtyProvider);
      if (!mounted) return;
      _controller.clear();
    } on NoteEmptyTextError {
      // Пустой текст не сохраняем.
    } finally {
      _isSaving = false;
    }
  }

  Future<void> _commitFromShortcut() async {
    await _commit();
    if (mounted) _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      minLines: 3,
      maxLines: 8,
      style: filterFieldTextStyle.copyWith(
        color: colors.primaryText,
        height: 1.4,
      ),
      decoration: composerFieldDecorationOf(
        context,
        hintText: 'Новая заметка…',
      ),
    );
  }
}

class _NoteTextField extends ConsumerStatefulWidget {
  const _NoteTextField({required this.note});

  final Note note;

  @override
  ConsumerState<_NoteTextField> createState() => _NoteTextFieldState();
}

class _NoteTextFieldState extends ConsumerState<_NoteTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note.text);
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant _NoteTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus &&
        (oldWidget.note.id != widget.note.id ||
            oldWidget.note.text != widget.note.text)) {
      _controller.text = widget.note.text;
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onFocusChange() async {
    if (_focusNode.hasFocus || _isSaving) return;
    await _commit();
  }

  Future<void> _commit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _controller.text = widget.note.text;
      return;
    }
    if (text == widget.note.text) return;

    _isSaving = true;
    try {
      await ref.read(notesStorageProvider).update(widget.note.id, text);
      ref
        ..invalidate(notesListProvider)
        ..invalidate(githubSyncDirtyProvider);
    } on NoteEmptyTextError {
      if (!mounted) return;
      _controller.text = widget.note.text;
    } on NoteNotFoundError {
      ref.invalidate(notesListProvider);
    } finally {
      _isSaving = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      minLines: 1,
      maxLines: null,
      style: filterFieldTextStyle.copyWith(
        color: colors.primaryText,
        height: 1.4,
      ),
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        contentPadding: EdgeInsets.only(top: 4),
      ),
    );
  }
}
