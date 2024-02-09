import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';

class TimeslotDatePicker extends StatefulWidget {
  const TimeslotDatePicker({
    super.key,
    required this.date,
    required this.dates,
    required this.onChanged,
  });

  final String? date;
  final List<String>? dates;
  final Function(String?) onChanged;

  @override
  TimeslotDatePickerState createState() => TimeslotDatePickerState();
}

class TimeslotDatePickerState extends State<TimeslotDatePicker> {
  late String? selectedDate = widget.date;
  late List<String>? dates = widget.dates;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: DropdownButtonFormField<String?>(
        value: selectedDate,
        hint: const Text("Select Date"),
        style: const TextStyle(fontSize: 14, color: Colors.black),
        dropdownColor: Colors.white,
        onChanged: (String? newValue) {
          selectedDate = newValue;
          widget.onChanged(selectedDate);
          setState(() {});
        },
        items: dates?.map((String? date) {
          return DropdownMenuItem<String>(
            value: date,
            child: Text("$date"),
          );
        }).toList(),
        decoration: const InputDecoration(
          border: InputBorder.none, // Remove the underline
        ),
      ),
    );
  }
}
