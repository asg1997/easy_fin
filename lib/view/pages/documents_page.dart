import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentsPage extends ConsumerWidget {
  const DocumentsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TemplatePage(
      title: 'Документы',
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Text('Document $index');
        },
      ),
    );
  }
}
