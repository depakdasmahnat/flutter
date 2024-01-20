import 'package:animated_horizontal_calendar/animated_horizontal_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';

import '../../../core/constant/colors.dart';

class CallenderForm extends StatefulWidget {
  const CallenderForm({super.key});

  @override
  State<CallenderForm> createState() => _CallenderFormState();
}

class _CallenderFormState extends State<CallenderForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView(
        children:  [
          Container(
            height: 100,
            child: AnimatedHorizontalCalendar(
                tableCalenderIcon: const Icon(Icons.calendar_today, color: Colors.white,),
                date: DateTime.now(),
                textColor: Colors.black45,
                backgroundColor: Colors.white,
                gradient: primaryGradient,
                tableCalenderThemeData:  ThemeData.light().copyWith(

                ),
                selectedColor: Colors.redAccent,
                onDateSelected: (date){
                  // selectedDate = date;
                }
            ),
          ),
        ],
      ),
    );
  }
}
