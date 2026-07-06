import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_fin/models/base.dart';
import 'package:easy_fin/utils/app_colors.dart';
import 'package:easy_fin/utils/app_sizes.dart';
import 'package:easy_fin/view/providers/renter_debts_report_filters_provider.dart';
import 'package:flutter/material.dart';

class RenterDebtsBaseFilterDropdown extends StatelessWidget {
  const RenterDebtsBaseFilterDropdown({
    required this.bases,
    required this.selectedFilter,
    required this.onChanged,
    super.key,
  });

  final List<Base> bases;
  final RenterDebtsBaseFilter selectedFilter;
  final void Function(RenterDebtsBaseFilter filter) onChanged;

  List<RenterDebtsBaseFilter> get _items => [
        const AllBasesRenterDebtsFilter(),
        ...bases.map(SingleBaseRenterDebtsFilter.new),
      ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: filterFieldHeight,
      width: double.infinity,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<RenterDebtsBaseFilter>(
          isExpanded: true,
          valueListenable: ValueNotifier<RenterDebtsBaseFilter>(selectedFilter),
          items: _items
              .map(
                (item) => DropdownItem<RenterDebtsBaseFilter>(
                  value: item,
                  child: Text(
                    item.label,
                    style: filterFieldTextStyle,
                  ),
                ),
              )
              .toList(),
          buttonStyleData: ButtonStyleData(
            height: filterFieldHeight,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: filterFieldHorizontalPadding,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
          ),
          iconStyleData: const IconStyleData(
            iconSize: 20,
            iconEnabledColor: Colors.grey,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            elevation: 0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
          ),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}
