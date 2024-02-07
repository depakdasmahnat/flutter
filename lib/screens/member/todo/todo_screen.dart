import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrwebbeast/controllers/member/events/events_controller.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/models/dashboard/custom_tab_data.dart';
import 'package:mrwebbeast/screens/member/members/calender/animated_horizontal_calendar.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_assets.dart';
import '../../../models/member/todo/to_do_model.dart';
import '../../../utils/widgets/gradient_progress_bar.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../home/member_dashboard.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  double? trainingProgress = 0;

  List<String> tabs = [
    'Today',
    'This Week',
    'Month',
  ];

  late String? filter = tabs.first;

  ToDoData? toDos;
  TextEditingController searchController = TextEditingController();

  Future fetchToDos() async {
    toDos = await context.read<EventsControllers>().fetchToDos(
          search: searchController.text,
          filter: filter ?? (dateTime != null ? dateTime.toString() : ''),
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      dateTime = DateTime.now();
      setState(() {});
      fetchToDos();
    });
  }

  DateTime? dateTime;
  String? formattedDate;

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsControllers>(builder: (context, controller, child) {
      toDos = controller.toDos;

      double getTrainingProgress() {
        double val = double.tryParse(
              '${toDos?.myAchievedTarget ?? 0}',
            ) ??
            0;
        return val;
      }

      trainingProgress = getTrainingProgress();

      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'To Do List',
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 80,
              child: AnimatedHorizontalCalendar(
                date: dateTime ?? DateTime.now(),
                tableCalenderIcon: const Icon(Icons.calendar_month),
                onDateSelected: (val) {
                  dateTime = val;
                  filter = null;
                  if (dateTime != null) {
                    formattedDate = DateFormat(dayFormat).format(dateTime!);
                  }
                  debugPrint('dateTime $dateTime');
                  setState(() {});
                  fetchToDos();
                },
                selectedDate: dateTime,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
              decoration: BoxDecoration(
                gradient: inActiveGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: tabs.map(
                  (e) {
                    bool isSelected = filter == e;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          filter = e;

                          if (filter == tabs.first) {
                            dateTime = DateTime.now();
                            formattedDate = null;
                          } else {
                            dateTime = null;
                            formattedDate = null;
                          }

                          setState(() {});
                          fetchToDos();
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: isSelected ? primaryGradient : null,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              e,
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected ? Colors.black : Colors.white,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
            if (controller.loadingToDos)
              const LoadingScreen(
                heightFactor: 0.7,
                message: 'Loading Report View',
              )
            else if (toDos != null)
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Pending task',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${filter ?? formattedDate}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TaskCard(
                      sales: '${toDos?.myPendingTarget ?? 0}',
                      title: 'My sales target',
                      value: '${toDos?.myAchievedTarget ?? 0}',
                      status: 'Complete',
                      gradient: limeGradient,
                      darkMode: false,
                      onTap: () {},
                    ),
                    TaskCard(
                      sales: '${toDos?.teamPendingTarget ?? 0}',
                      title: 'Team sales target',
                      value: '${toDos?.teamAchievedTarget ?? 0}',
                      status: 'Complete',
                      gradient: inActiveGradient,
                      darkMode: true,
                      onTap: () {},
                    ),
                    GestureDetector(
                      onTap: () {
                        // context.pushNamed(Routs.demoVideos);
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8, left: kPadding, right: kPadding, bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: inActiveGradient,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Complete Your Training',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ImageView(
                                      height: 40,
                                      width: 40,
                                      borderRadiusValue: 50,
                                      backgroundColor: Colors.grey.shade100,
                                      assetImage: AppAssets.arrowForwardIcon,
                                      padding: const EdgeInsets.all(12),
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                                GradientProgressBar(
                                  value: (trainingProgress ?? 0) > 0 ? (trainingProgress! / 100) : 0,
                                  backgroundColor: Colors.grey.shade300,
                                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${toDos?.chapterNumber ?? 0}',
                                      style: TextStyle(
                                          color: Colors.grey.shade200,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '${(trainingProgress ?? 0).toStringAsFixed(0)}%',
                                      style: TextStyle(
                                          color: Colors.grey.shade200,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
                      child: Row(
                        children: [
                          AnalyticsCard(
                            title: 'Your Events',
                            value: '${toDos?.events ?? 0}',
                            gradient: whiteGradient,
                            onTap: () {},
                          ),
                          AnalyticsCard(
                            title: 'Demo\nScheduled',
                            value: '${toDos?.demoScheduled ?? 0}',
                            textColor: Colors.white,
                            gradient: inActiveGradient,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              const NoDataFound(
                heightFactor: 0.7,
                message: 'No Todo Found',
              ),
          ],
        ),
      );
    });
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.gradient,
    this.flex,
    this.showArrow = true,
    this.minHeight,
    this.status,
    this.sales,
    this.darkMode,
  });

  final String? title;

  final String? value;
  final String? status;
  final String? sales;
  final Gradient? gradient;

  final int? flex;

  final GestureTapCallback? onTap;
  final bool? showArrow;
  final double? minHeight;
  final bool? darkMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: kPadding, left: kPadding, bottom: kPadding),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 16),
              decoration: BoxDecoration(
                gradient: gradient ?? inActiveGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        '${sales ?? 0}',
                        style: TextStyle(
                          color: darkMode == true ? Colors.white : Colors.black,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$title',
                        style: TextStyle(
                            color: darkMode == true ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Text(
                              '($value) $status',
                              style: TextStyle(
                                  color: darkMode == true ? Colors.grey : Colors.grey.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            GradientButton(
                              backgroundGradient: primaryGradient,
                              margin: const EdgeInsets.only(left: 8),
                              child: ImageView(
                                height: 4,
                                width: 4,
                                borderRadiusValue: 0,
                                margin: const EdgeInsets.all(6),
                                assetImage: AppAssets.arrowForwardIcon,
                                padding: const EdgeInsets.only(),
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            if (showArrow == true)
              Positioned(
                right: 4,
                top: 8,
                child: ImageView(
                  height: 40,
                  width: 40,
                  borderRadiusValue: 50,
                  backgroundColor: Colors.grey.shade100,
                  assetImage: AppAssets.arrowForwardIcon,
                  padding: const EdgeInsets.all(12),
                  onTap: () {},
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomTabData {
  CustomTabData({
    required this.id,
    required this.title,
  });

  int id;
  String title;
}
