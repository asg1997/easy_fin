import 'package:easy_fin/models/report_template.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/utils/app_theme_colors.dart';
import 'package:easy_fin/view/pages/edit_report_template_page.dart';
import 'package:easy_fin/view/providers/report_templates_provider.dart';
import 'package:easy_fin/view/widgets/confirm_dialog.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ReportTemplatesPage extends ConsumerWidget {
  const ReportTemplatesPage({super.key});

  static Future<void> navigate(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const ReportTemplatesPage(),
      ),
    );
  }

  Future<void> _onDelete(
    BuildContext context,
    WidgetRef ref,
    ReportTemplate template,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Удалить шаблон?',
        message: 'Шаблон «${template.name}» будет удалён безвозвратно.',
        confirmLabel: 'Удалить',
      ),
    );
    if (confirmed != true) return;

    await ref.read(reportTemplatesProvider.notifier).delete(template.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(reportTemplatesProvider);
    final colors = context.appColors;

    return Scaffold(
      body: TemplatePage(
        hasBackButton: true,
        title: 'Шаблоны отчётов',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MaterialButton(
              onPressed: () => EditReportTemplatePage.navigate(context),
              height: filterFieldHeight,
              minWidth: 180,
              color: AppColors.purple,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.plus, size: 18, color: Colors.white),
                  Gap(8),
                  Text(
                    'Создать шаблон',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            Expanded(
              child: templatesAsync.when(
                data: (templates) {
                  if (templates.isEmpty) {
                    return Center(
                      child: Text(
                        'Пока нет шаблонов отчётов',
                        style: filterFieldHintTextStyleOf(context),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: templates.length,
                    separatorBuilder: (_, _) => const Gap(12),
                    itemBuilder: (context, index) {
                      final template = templates[index];
                      return Material(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () => EditReportTemplatePage.navigate(
                            context,
                            template: template,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: colors.border),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        template.name,
                                        style: filterFieldTextStyle.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: colors.primaryText,
                                        ),
                                      ),
                                      const Gap(4),
                                      Text(
                                        template.kind.label,
                                        style:
                                            filterFieldHintTextStyleOf(context),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      _onDelete(context, ref, template),
                                  icon: Icon(
                                    LucideIcons.trash2,
                                    size: 18,
                                    color: colors.secondaryText,
                                  ),
                                  tooltip: 'Удалить',
                                ),
                                Icon(
                                  LucideIcons.chevronRight,
                                  size: 18,
                                  color: colors.secondaryText,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (_, _) => const Center(
                  child: Text('Не удалось загрузить шаблоны'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
