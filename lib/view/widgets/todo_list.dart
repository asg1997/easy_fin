import 'package:easy_fin/data/todos_storage/todos_storage.dart';
import 'package:easy_fin/models/todo_item.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/providers/todos_provider.dart';
import 'package:easy_fin/view/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class TodoList extends ConsumerWidget {
  const TodoList({super.key});

  Future<void> _onDelete(
    BuildContext context,
    WidgetRef ref,
    TodoItem item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Удалить задачу?',
        message: 'Задача «${item.text}» будет удалена безвозвратно.',
        confirmLabel: 'Удалить',
      ),
    );
    if (confirmed != true) return;

    await ref.read(todosProvider.notifier).delete(item.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todosProvider);
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _NewTodoField(),
        const Gap(16),
        Expanded(
          child: todosAsync.when(
            data: (todos) {
              if (todos.isEmpty) {
                return Center(
                  child: Text(
                    'Пока нет задач',
                    style: filterFieldHintTextStyleOf(context),
                  ),
                );
              }

              return ListView.separated(
                itemCount: todos.length,
                separatorBuilder: (_, _) => const Gap(8),
                itemBuilder: (context, index) {
                  final item = todos[index];
                  return Material(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.border),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: item.isDone,
                            onChanged: (_) async {
                              await ref
                                  .read(todosProvider.notifier)
                                  .toggleDone(item);
                            },
                          ),
                          Expanded(
                            child: _TodoTextField(item: item),
                          ),
                          IconButton(
                            onPressed: () => _onDelete(context, ref, item),
                            icon: Icon(
                              LucideIcons.trash2,
                              size: 18,
                              color: colors.secondaryText,
                            ),
                            tooltip: 'Удалить',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const Center(
              child: Text('Не удалось загрузить задачи'),
            ),
          ),
        ),
      ],
    );
  }
}

class _NewTodoField extends ConsumerStatefulWidget {
  const _NewTodoField();

  @override
  ConsumerState<_NewTodoField> createState() => _NewTodoFieldState();
}

class _NewTodoFieldState extends ConsumerState<_NewTodoField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode()..addListener(_onFocusChange);
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
    if (text.isEmpty) return;

    _isSaving = true;
    try {
      await ref.read(todosProvider.notifier).add(text);
      if (!mounted) return;
      _controller.clear();
    } on TodoEmptyTextError {
      // Пустой текст не сохраняем.
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
      maxLines: 3,
      textInputAction: TextInputAction.done,
      style: filterFieldTextStyle.copyWith(color: colors.primaryText),
      decoration: composerFieldDecorationOf(
        context,
        hintText: 'Новая задача…',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
      onSubmitted: (_) async {
        await _commit();
        if (mounted) _focusNode.requestFocus();
      },
    );
  }
}

class _TodoTextField extends ConsumerStatefulWidget {
  const _TodoTextField({required this.item});

  final TodoItem item;

  @override
  ConsumerState<_TodoTextField> createState() => _TodoTextFieldState();
}

class _TodoTextFieldState extends ConsumerState<_TodoTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.item.text);
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant _TodoTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus &&
        (oldWidget.item.id != widget.item.id ||
            oldWidget.item.text != widget.item.text)) {
      _controller.text = widget.item.text;
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
      _controller.text = widget.item.text;
      return;
    }
    if (text == widget.item.text) return;

    _isSaving = true;
    try {
      await ref.read(todosProvider.notifier).save(
            widget.item.copyWith(text: text),
          );
    } on TodoEmptyTextError {
      if (!mounted) return;
      _controller.text = widget.item.text;
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
      maxLines: 4,
      style: filterFieldTextStyle.copyWith(
        color: colors.primaryText,
        decoration: widget.item.isDone
            ? TextDecoration.lineThrough
            : TextDecoration.none,
        decorationColor: colors.secondaryText,
      ),
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}
