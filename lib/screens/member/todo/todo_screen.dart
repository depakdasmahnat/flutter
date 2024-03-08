import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mrwebbeast/controllers/member/events/events_controller.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/screens/member/events/events_screen.dart';
import 'package:mrwebbeast/screens/member/members/calender/animated_horizontal_calendar.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:mrwebbeast/utils/widgets/custom_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/enums.dart';
import '../../../models/member/events/events_model.dart';
import '../../../models/member/todo/to_do_model.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../../utils/widgets/training_progress.dart';
import '../lead/leads_popup.dart';

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

  String? filter;

  ToDoData? toDos;
  TextEditingController searchController = TextEditingController();

  Future fetchToDos() async {
    toDos = await context.read<EventsControllers>().fetchToDos(
          search: searchController.text,
          filter: filter ?? (dateTime != null ? dateTime.toString() : ''),
        );
    formattedDate = DateFormat(dayFormat).format(dateTime!);
  }

  List<EventsData>? events;

  Future fetchEvents({bool? loadingNext}) async {
    return await context.read<EventsControllers>().fetchEvents(
          context: context,
          isRefresh: loadingNext == true ? false : true,
          loadingNext: loadingNext ?? false,
          searchKey: searchController.text,
          dateFilter: dateTime != null ? dateTime.toString().substring(0, 10) : '',
          filter: filter != null ? filter?.replaceAll(' ', '') : '',
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

  DateTime? dateTime = DateTime.now();
  String? formattedDate;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
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
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: SizedBox(
                height: 80,
                child: AnimatedHorizontalCalendar(
                  date: dateTime ?? DateTime.now(),
                  selectedDate: dateTime,
                  tableCalenderIcon: const Icon(Icons.calendar_month),
                  onDateSelected: (val) {
                    dateTime = val;
                    // filter = null;
                    filter = 'Custom_date';
                    if (dateTime != null) {
                      formattedDate = DateFormat(dayFormat).format(dateTime!);
                    }

                    debugPrint('dateTime $dateTime');
                    setState(() {});
                    fetchToDos();
                    fetchEvents();
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'All tasks',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Text(
                  //   '${filter ?? formattedDate}',
                  //   style: const TextStyle(
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
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
                          fetchEvents();
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
                                fontSize: 12,
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${filter ?? formattedDate}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 130,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      TaskCard(
                        sales: '${toDos?.events ?? 0}',
                        title: 'Your\nEvents',
                        gradient: limeGradient,
                        darkMode: false,
                        showArrow: true,
                        onTap: () {
                          context.pushNamed(Routs.events);
                        },
                      ),
                      TaskCard(
                        sales: '${toDos?.demoScheduled ?? 0}',
                        title: 'Demo\nScheduled',
                        gradient: lightSkyBlueGradient,
                        darkMode: false,
                        showArrow: true,
                        onTap: () {
                          CustomBottomSheet.show(
                            context: context,
                            body: LeadsPopup(
                              title: 'Demo Scheduled',
                              filter: filter ?? (dateTime != null ? dateTime.toString() : ''),
                              status: LeadsStatus.demoScheduled.value,
                            ),
                          );
                        },
                      ),
                      TaskCard(
                        sales: '${toDos?.invitationCall ?? 0}',
                        title: 'Invitation Call',
                        gradient: blackGradient,
                        darkMode: true,
                        showArrow: true,
                        onTap: () {
                          CustomBottomSheet.show(
                            context: context,
                            body: LeadsPopup(
                              title: 'Invitation Call',
                              filter: filter ?? (dateTime != null ? dateTime.toString() : ''),
                              status: LeadsStatus.demoScheduled.value,
                            ),
                          );
                        },
                      ),
                      TaskCard(
                        sales: '${toDos?.followUp ?? 0}',
                        title: 'Follow Up',
                        gradient: inActiveGradient,
                        darkMode: true,
                        showArrow: true,
                        onTap: () {
                          CustomBottomSheet.show(
                            context: context,
                            body: LeadsPopup(
                              title: 'Follow Up',
                              filter: filter ?? (dateTime != null ? dateTime.toString() : ''),
                              status: LeadsStatus.followUp.value,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Events',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(Routs.events);
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
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
                    height: 300,
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
      width: 160,
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
                    fontSize: 12,
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
                        fontSize: 8,
                        value: data?.startDate ?? '',
                      ),
                      FeedMenu(
                        icon: AppAssets.clockIcon,
                        fontSize: 8,
                        lastMenu: true,
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
              constraints: const BoxConstraints(maxWidth: 115),
              padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 16),
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
                          fontSize: 32,
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
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
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
                  height: 24,
                  width: 24,
                  borderRadiusValue: 50,
                  backgroundColor: Colors.grey.shade100,
                  assetImage: AppAssets.arrowForwardIcon,
                  padding: const EdgeInsets.all(8),
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
