import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/providers/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class NotesTagFilterBar extends ConsumerWidget {
  const NotesTagFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(allNoteTagsProvider);
    final selected = ref.watch(notesTagFilterProvider);
    final colors = context.appColors;

    return tagsAsync.when(
      data: (tags) {
        if (tags.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SizedBox(
            height: 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(
                  label: 'Все',
                  isSelected: selected == null,
                  onTap: () =>
                      ref.read(notesTagFilterProvider.notifier).selectAll(),
                ),
                const Gap(8),
                for (var i = 0; i < tags.length; i++) ...[
                  if (i > 0) const Gap(8),
                  _FilterChip(
                    label: tags[i],
                    isSelected: selected != null &&
                        selected.toLowerCase() == tags[i].toLowerCase(),
                    onTap: () => ref
                        .read(notesTagFilterProvider.notifier)
                        .selectTag(tags[i]),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => Text(
        'Не удалось загрузить теги',
        style: filterFieldHintTextStyleOf(context).copyWith(
          color: colors.secondaryText,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
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

    return Material(
      color: isSelected ? colors.accent : colors.navActiveBackground,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            label,
            style: filterFieldTextStyle.copyWith(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? colors.onAccent : colors.primaryText,
            ),
          ),
        ),
      ),
    );
  }
}
