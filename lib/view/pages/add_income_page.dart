import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddIncomePage extends ConsumerStatefulWidget {
  const AddIncomePage({super.key});
  static Future<void> navigate(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const AddIncomePage()),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends ConsumerState<AddIncomePage> {
  String? _selectedIncomeSource;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TemplatePage(
        hasBackButton: true,
        title: 'Приход',
        child: Column(
          children: [
            DropdownWidget(
              items: const [
                'Арендатор',
                'Другое',
              ],
              hint: 'Выбор базы',
              selectedItem: _selectedIncomeSource,
              onChanged: (item) {
                setState(() {
                  _selectedIncomeSource = item;
                });
              },
              labelBuilder: (item) => item,
            ),
          ],
        ),
      ),
    );
  }
}
