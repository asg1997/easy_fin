import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/widgets/notes_list.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:easy_fin/view/widgets/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

enum NotesTabSection { todos, notes }

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  NotesTabSection _section = NotesTabSection.todos;

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      title: 'Заметки',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NotesSectionTabBar(
            selectedSection: _section,
            onChanged: (section) => setState(() => _section = section),
          ),
          const Gap(20),
          Expanded(
            child: switch (_section) {
              NotesTabSection.todos => const TodoList(),
              NotesTabSection.notes => const NotesList(),
            },
          ),
        ],
      ),
    );
  }
}

class _NotesSectionTabBar extends StatelessWidget {
  const _NotesSectionTabBar({
    required this.selectedSection,
    required this.onChanged,
  });

  final NotesTabSection selectedSection;
  final ValueChanged<NotesTabSection> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.border),
        ),
      ),
      child: Row(
        children: [
          _NotesSectionTab(
            label: 'TODO',
            isSelected: selectedSection == NotesTabSection.todos,
            onTap: () => onChanged(NotesTabSection.todos),
          ),
          _NotesSectionTab(
            label: 'Заметки',
            isSelected: selectedSection == NotesTabSection.notes,
            onTap: () => onChanged(NotesTabSection.notes),
          ),
        ],
      ),
    );
  }
}

class _NotesSectionTab extends StatelessWidget {
  const _NotesSectionTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? colors.primaryText : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: filterFieldTextStyle.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? colors.primaryText : colors.secondaryText,
          ),
        ),
      ),
    );
  }
}
