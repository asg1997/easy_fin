import 'package:easy_fin/view/widgets/date_picker_field.dart';
import 'package:easy_fin/view/widgets/dropdown_widget.dart';
import 'package:easy_fin/view/widgets/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddRentAccrualPage extends ConsumerStatefulWidget {
  const AddRentAccrualPage({super.key});

  static Future<void> navigate(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const AddRentAccrualPage()),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddRentAccrualPageState();
}

class _AddRentAccrualPageState extends ConsumerState<AddRentAccrualPage> {
  String? _selectedBase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TemplatePage(
        hasBackButton: true,
        title: 'Начисление по аренде',
        child: Column(
          children: [
            DropdownWidget(
              items: const [
                'Арендатор',
                'Другое',
              ],
              hint: 'Выбор базы',
              selectedItem: _selectedBase,
              onChanged: (item) {
                setState(() {
                  _selectedBase = item;
                });
              },
              labelBuilder: (item) => item,
            ),
            DatePickerField(
              selectedDate: DateTime.now(),
              onChanged: (date) {},
            ),
          ],
        ),
      ),
    );
  }
}
