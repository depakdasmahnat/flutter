import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';

import '../../../../core/constant/colors.dart';

typedef OnDateSelected(date);

class AnimatedHorizontalCalendar extends StatefulWidget {
  final DateTime? selectedDate;
  final DateTime date;
  final DateTime? initialDate;
  final DateTime? lastDate;
  final Color? textColor;
  final Color? colorOfWeek;
  final Color? colorOfMonth;
  final double? fontSizeOfWeek;
  final FontWeight? fontWeightWeek;
  final double? fontSizeOfMonth;
  final FontWeight? fontWeightMonth;
  final Color? backgroundColor;
  final Color? selectedColor;
  final int? duration;
  final Curve? curve;
  final BoxShadow? selectedBoxShadow;
  final BoxShadow? unSelectedBoxShadow;
  final OnDateSelected? onDateSelected;
  final Widget tableCalenderIcon;
  final Color? tableCalenderButtonColor;
  final ThemeData? tableCalenderThemeData;

  AnimatedHorizontalCalendar({
    Key? key,
    required this.date,
    required this.tableCalenderIcon,
    this.selectedDate,
    this.initialDate,
    this.lastDate,
    this.textColor,
    this.curve,
    this.tableCalenderThemeData,
    this.selectedBoxShadow,
    this.unSelectedBoxShadow,
    this.duration,
    this.tableCalenderButtonColor,
    this.colorOfMonth,
    this.colorOfWeek,
    this.fontSizeOfWeek,
    this.fontWeightWeek,
    this.fontSizeOfMonth,
    this.fontWeightMonth,
    this.backgroundColor,
    this.selectedColor,
    @required this.onDateSelected,
  }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<AnimatedHorizontalCalendar> {
  DateTime? _startDate;
  var selectedCalenderDate;
  final ScrollController _scrollController = ScrollController();

  calenderAnimation() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: widget.duration ?? 1),
      curve: widget.curve ?? Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    super.initState();
    selectedCalenderDate = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    DateTime findFirstDateOfTheWeek(DateTime dateTime) {
      if (dateTime.weekday == 7) {
        if (_scrollController.hasClients) {
          calenderAnimation();
        }
        return dateTime;
      } else {
        if (dateTime.weekday == 1 || dateTime.weekday == 2) {
          if (_scrollController.hasClients) {
            calenderAnimation();
          }
        }
        return dateTime.subtract(Duration(days: dateTime.weekday));
      }
    }

    _startDate = findFirstDateOfTheWeek(selectedCalenderDate);

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              DateTime? _date = _startDate?.add(Duration(days: index));
              int? diffDays = _date?.difference(selectedCalenderDate).inDays;
              bool isSelected = widget.selectedDate?.day == _date?.day;

              return Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  gradient: isSelected ? primaryGradient : inActiveGradient,
                  borderRadius: BorderRadius.circular(22),
                ),

                padding: const EdgeInsets.symmetric(horizontal: 6),
                margin: const EdgeInsets.only(left: 4, right: 4, top: 8),
                // ignore: deprecated_member_use
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    widget.onDateSelected!(_date);
                    setState(() {
                      selectedCalenderDate = _startDate?.add(Duration(days: index));
                      _startDate = _startDate?.add(Duration(days: index));
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        Utils.getDayOfWeek(_date!),
                        style: TextStyle(
                            color: isSelected ? widget.colorOfWeek ?? Colors.black : Colors.white,
                            fontSize: widget.fontSizeOfWeek ?? 14.0,
                            fontWeight: widget.fontWeightWeek ?? FontWeight.w400),
                      ),
                      const SizedBox(height: 2.0),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          Utils.getDayOfMonth(_date),
                          style: TextStyle(
                            color: isSelected ? widget.colorOfWeek ?? Colors.black : Colors.white,
                            fontSize: widget.fontSizeOfMonth ?? 14.0,
                            fontWeight: widget.fontWeightMonth ?? FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.only(top: 8),
            child: InkWell(
              onTap: () async {
                DateTime? date = await selectDate();
                if (date != null) {
                  widget.onDateSelected!(date);
                  setState(() => selectedCalenderDate = date);
                }
              },
              child: Container(
                height: double.infinity,
                width: 58,
                decoration:
                    BoxDecoration(gradient: inActiveGradient, borderRadius: BorderRadius.circular(18)),
                child: widget.tableCalenderIcon,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
    );
  }

  Future<DateTime?> selectDate() async {
    return await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      initialDate: selectedCalenderDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: widget.tableCalenderThemeData ??
              ThemeData.light().copyWith(
                primaryColor: secondaryColor,
                buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                colorScheme:
                    const ColorScheme.light(primary: secondaryColor).copyWith(secondary: secondaryColor),
              ),
          child: child ?? const SizedBox(),
        );
      },
      firstDate: widget.initialDate ?? DateTime.now().subtract(const Duration(days: 30)),
      lastDate: widget.lastDate ?? DateTime.now().add(const Duration(days: 30)),
    );
  }
}

class Utils {
  static String getDayOfWeek(DateTime date) => DateFormat('EEE').format(date);

  static String getDayOfMonth(DateTime date) => DateFormat('dd').format(date);

  static String getDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
}
