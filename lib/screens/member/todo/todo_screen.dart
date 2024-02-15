import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrwebbeast/controllers/member/events/events_controller.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/models/dashboard/custom_tab_data.dart';
import 'package:mrwebbeast/screens/member/events/events_screen.dart';
import 'package:mrwebbeast/screens/member/members/calender/animated_horizontal_calendar.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_assets.dart';
import '../../../models/member/events/events_model.dart';
import '../../../models/member/todo/to_do_model.dart';
import '../../../utils/widgets/gradient_progress_bar.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../../utils/widgets/training_progress.dart';
import '../home/member_dashboard.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  double? trainingProgress = 0;

  List<String> tabs = [
    'This Week',
    'This Month',
    'This Year',
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

  List<EventsData>? events;

  Future fetchEvents({bool? loadingNext}) async {
    return await context.read<EventsControllers>().fetchEvents(
          context: context,
          isRefresh: loadingNext == true ? false : true,
          loadingNext: loadingNext ?? false,
          searchKey: searchController.text,
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchToDos();
      fetchEvents();
    });
  }

  DateTime? dateTime;
  String? formattedDate;

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsControllers>(builder: (context, controller, child) {
      toDos = controller.toDos;
      events = controller.events;

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
          leading: const Column(
            children: [
              CustomBackButton(),
            ],
          ),
          title: const Text(
            'To Do List',
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
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
            Padding(
              padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All tasks',
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
            const TrainingProgress(),
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

                          dateTime = null;
                          formattedDate = null;

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
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
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
                SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      TaskCard(
                        sales: '${toDos?.events ?? 0}',
                        title: 'Your\nEvents',
                        gradient: limeGradient,
                        darkMode: false,
                        showArrow: false,
                        onTap: () {},
                      ),
                      TaskCard(
                        sales: '${toDos?.demoScheduled ?? 0}',
                        title: 'Demo\nScheduled',
                        gradient: lightSkyBlueGradient,
                        darkMode: false,
                        showArrow: false,
                        onTap: () {},
                      ),
                      TaskCard(
                        sales: '${toDos?.teamAchievedTarget ?? 0}',
                        title: 'Invitation\nCall',
                        gradient: blackGradient,
                        darkMode: true,
                        showArrow: false,
                        onTap: () {},
                      ),
                      TaskCard(
                        sales: '${toDos?.teamAchievedTarget ?? 0}',
                        title: 'Follow\nUp',
                        gradient: inActiveGradient,
                        darkMode: true,
                        showArrow: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Events',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (controller.loadingEvents)
                  const LoadingScreen(
                    heightFactor: 0.3,
                    message: 'Loading Events...',
                  )
                else if (events.haveData)
                  SizedBox(
                    height: 360,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: events?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(bottom: bottomNavbarSize),
                      // physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var data = events?.elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            // context.pushNamed(Routs.productDetail);
                          },
                          child: EventCard(
                            index: index,
                            data: data,
                          ),
                        );
                      },
                    ),
                  )
                else
                  NoDataFound(
                    heightFactor: 0.3,
                    message: controller.eventsModel?.message ?? 'No Events Found',
                  ),
              ],
            )
          ],
        ),
      );
    });
  }
}

class EventCard extends StatelessWidget {
  final double? imageHeight;
  final BoxFit? fit;

  final int index;

  final EventsData? data;

  const EventCard({super.key, this.imageHeight, this.fit, required this.index, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      margin: const EdgeInsets.only(left: kPadding, bottom: kPadding),
      decoration: BoxDecoration(
        gradient: feedsCardGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ImageView(
              width: 190,
              borderRadiusValue: 16,
              margin: const EdgeInsets.all(12),
              fit: BoxFit.cover,
              networkImage: '${data?.image}',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data?.name ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FeedMenu(
                        icon: AppAssets.eventIcon,
                        value: data?.startDate ?? '',
                      ),
                      FeedMenu(
                        icon: AppAssets.clockIcon,
                        value: data?.startTime ?? '',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: kPadding),
                  child: Text(
                    'Type of Events: ${data?.type ?? ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.onTap,
    this.gradient,
    this.flex,
    this.showArrow = true,
    this.minHeight,
    this.sales,
    this.darkMode,
  });

  final String? title;
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
      padding: const EdgeInsets.only(left: kPadding, bottom: kPadding),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 135),
              padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 12),
              decoration: BoxDecoration(
                gradient: gradient ?? inActiveGradient,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
