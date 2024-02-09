import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';

class LocationRadiusPicker extends StatefulWidget {
  const LocationRadiusPicker({
    super.key,
    required this.selectedItem,
    required this.items,
    required this.onChanged,
  });

  final num? selectedItem;
  final List<num?>? items;
  final Function(num?) onChanged;

  @override
  LocationRadiusPickerState createState() => LocationRadiusPickerState();
}

class LocationRadiusPickerState extends State<LocationRadiusPicker> {
  late num? selectedItem = widget.selectedItem;
  late List<num?>? items = widget.items;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85,
      child: DropdownButtonFormField<num?>(
        value: selectedItem,
        isDense: true,
        isExpanded: true,
        hint: const Text("Select Radius"),
        padding: const EdgeInsets.only(left: 12, right: 12),
        style: const TextStyle(fontSize: 14, color: Colors.black),
        dropdownColor: Colors.white,
        iconEnabledColor: primaryColor,
        onChanged: (num? newValue) {
          selectedItem = newValue;
          widget.onChanged(selectedItem);
          setState(() {});
        },
        items: items?.map((num? date) {
          return DropdownMenuItem<num>(
            value: date,
            child: Text("$date Mi"),
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
