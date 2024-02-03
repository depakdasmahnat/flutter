import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef OnDateSelected(date);

class AnimatedHorizontalCalendar extends StatefulWidget {
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
  final Color primaryColor = const Color(0xffF16A46);
  final Color secondaryColor = const Color(0xff092B47);
  final Color primaryTextColor = const Color(0xff0D2145);
  final Color secondaryTextColor = const Color(0xff768791);
  final Color white = const Color(0xffFFFFFF);
  final Color black = const Color(0xff45597A);
  final Color grey = const Color(0xffC4C4C4);
  final Color backgroundColor = const Color(0xffF3F5F8);
  DateTime? _startDate;
  var selectedCalenderDate;
  ScrollController _scrollController = new ScrollController();

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
      child: Container(
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 10,
            ),
            ListView.builder(
              itemCount: 7,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                DateTime? _date = _startDate?.add(Duration(days: index));
                int? diffDays = _date?.difference(selectedCalenderDate).inDays;
                return Container(
                  padding: const EdgeInsets.only(bottom: 20, left: 0.0),
                  child: Container(
                    width: (width - 10) * 0.1428,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: diffDays != 0
                            ? widget.backgroundColor ?? Colors.white
                            : widget.selectedColor ?? Colors.blue,
                        border: diffDays == 0
                            ? Border.all(color: white.withOpacity(0.95), width: 2)
                            : Border.all(color: black.withOpacity(0.25), width: 1),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          diffDays != 0
                              ? widget.selectedBoxShadow ??
                                  BoxShadow(
                                    color: black.withOpacity(0.25),
                                    spreadRadius: 0.0,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4), // changes position of shadow
                                  )
                              : widget.unSelectedBoxShadow ??
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.35),
                                    spreadRadius: 2.0,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4), // changes position of shadow
                                  )
                        ]),
                    margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    // ignore: deprecated_member_use
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onDateSelected!(Utils.getDate(_date));
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
                                color:
                                    diffDays != 0 ? widget.colorOfWeek ?? secondaryTextColor : Colors.white,
                                fontSize: widget.fontSizeOfWeek ?? 12.0,
                                fontWeight: widget.fontWeightWeek ?? FontWeight.w600),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            Utils.getDayOfMonth(_date),
                            style: TextStyle(
                              color: diffDays != 0 ? widget.colorOfMonth ?? primaryTextColor : Colors.white,
                              fontSize: widget.fontSizeOfMonth ?? 20.0,
                              fontWeight: widget.fontWeightMonth ?? FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 20, top: 8),
              color: backgroundColor,
              child: InkWell(
                onTap: () async {
                  DateTime? date = await selectDate();
                  widget.onDateSelected!(Utils.getDate(date!));
                  setState(() => selectedCalenderDate = date);
                },
                child: Container(
                  height: double.infinity,
                  width: (width - 10) * 0.1428,
                  decoration: BoxDecoration(
                      color: widget.tableCalenderButtonColor ?? primaryColor,
                      border: Border.all(color: grey, width: 1),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: widget.tableCalenderIcon,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            )
          ],
        ),
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
                colorScheme: ColorScheme.light(primary: secondaryColor).copyWith(secondary: secondaryColor),
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
