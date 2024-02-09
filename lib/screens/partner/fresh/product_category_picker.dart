import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';

import '../../../models/partner/category_model.dart';

class ProductCategoryPicker extends StatefulWidget {
  const ProductCategoryPicker({
    super.key,
    required this.selectedItem,
    required this.items,
    required this.onChanged,
  });

  final CategoryData? selectedItem;
  final List<CategoryData?>? items;
  final Function(CategoryData?) onChanged;

  @override
  ProductCategoryPickerState createState() => ProductCategoryPickerState();
}

class ProductCategoryPickerState extends State<ProductCategoryPicker> {
  late CategoryData? selectedItem = widget.selectedItem;
  late List<CategoryData?>? items = widget.items;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      items ??= [];

      if (items?.any((element) => element?.name != "All") == true) {
        items?.insert(0, CategoryData(name: "All"));
      }
      selectedItem ??= items?.first;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: DropdownButtonFormField<CategoryData?>(
        value: selectedItem,
        isDense: true,
        isExpanded: true,
        hint: const Text("Category"),
        padding: const EdgeInsets.only(left: 12, right: 12),
        style: const TextStyle(color: Colors.black),
        dropdownColor: Colors.white,
        iconEnabledColor: primaryColor,
        onChanged: (CategoryData? newValue) {
          selectedItem = newValue;
          widget.onChanged(selectedItem);
          setState(() {});
        },
        items: items?.map((CategoryData? date) {
          return DropdownMenuItem<CategoryData>(
            value: date,
            child: FittedBox(child: Text("${date?.name}")),
          );
        }).toList(),
        decoration: const InputDecoration(
          isDense: true,
          isCollapsed: true,

          border: InputBorder.none, // Remove the underline
        ),
      ),
    );
  }
}
