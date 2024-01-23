import 'package:flutter/material.dart';

import 'calender/animated_horizontal_calendar.dart';

class CalendarForm extends StatefulWidget {
  const CalendarForm({super.key});

  @override
  State<CalendarForm> createState() => _CalendarFormState();
}

class _CalendarFormState extends State<CalendarForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 100,
            child: AnimatedHorizontalCalendar(
                tableCalenderIcon: const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                ),
                date: DateTime.now(),
                textColor: Colors.black45,
                backgroundColor: Colors.white,
                // gradient: primaryGradient,
                tableCalenderThemeData: ThemeData.light().copyWith(),
                selectedColor: Colors.redAccent,
                onDateSelected: (date) {
                  // selectedDate = date;
                }),
          ),
        ],
      ),
    );
  }
}
