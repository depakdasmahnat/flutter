import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/models/dashboard/target_analytics_model.dart';
import 'package:mrwebbeast/screens/member/home/duration_popup.dart';
import 'package:mrwebbeast/screens/member/home/performance_graph.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';

import '../../../models/dashboard/dashboard_data.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/custom_bottemsheet.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../dashboard/dashboard.dart';
import '../../guest/home/home_screen.dart';

class MemberDashBoard extends StatefulWidget {
  const MemberDashBoard({super.key});

  @override
  State<MemberDashBoard> createState() => _MemberDashBoardState();
}

class _MemberDashBoardState extends State<MemberDashBoard> {
  List<TargetAnalyticsData> dummyAnalyticsList = [
    TargetAnalyticsData(xAxis: 'Jan', performance: 0),
    TargetAnalyticsData(xAxis: 'Feb', performance: 24),
    TargetAnalyticsData(xAxis: 'Mar', performance: 16),
    TargetAnalyticsData(xAxis: 'Apr', performance: 38),
    TargetAnalyticsData(xAxis: 'May', performance: 54),
    TargetAnalyticsData(xAxis: 'Jun', performance: 36),
    TargetAnalyticsData(xAxis: 'Jul', performance: 42),
    TargetAnalyticsData(xAxis: 'Aug', performance: 35),
    TargetAnalyticsData(xAxis: 'Sep', performance: 38),
    TargetAnalyticsData(xAxis: 'Oct', performance: 54),
    TargetAnalyticsData(xAxis: 'Nov', performance: 38),
    TargetAnalyticsData(xAxis: 'Dec', performance: 54),
  ];

  // Create dummy data

  late TargetAnalyticsModel dummyData = TargetAnalyticsModel(
    success: true,
    message: 'Dummy Message',
    data: TargetData(
      title: 'Dummy Title',
      sales: 100,
      salesTarget: 100,
      pendingSales: 100,
      rank: 'Dummy Rank',
      nextRank: 'Next Dummy Rank',
      pendingRankSales: 100,
      leadsAdded: 100,
      leadsClosed: 100,
      leadsConversion: 100,
      demoScheduled: 100,
      demoCompleted: 100,
      hotLeads: 100,
      coldLeads: 100,
      analytics: dummyAnalyticsList,
    ),
  );

  final List<DashboardData> bottomNabBarItems = [
    DashboardData(
      title: 'My Dashboard',
      activeImage: AppAssets.feedsIcon,
      inActiveImage: AppAssets.feedsIcon,
      widget: const HomeScreen(),
    ),
    DashboardData(
      title: 'My Members',
      activeImage: AppAssets.membersFilledIcon,
      inActiveImage: AppAssets.membersIcon,
      widget: const NoDataFound(),
    ),
  ];

  int dashBoardIndex = 0;
  String? selectedDuration = DurationFilterMenu.monthly.label;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    bool myDashboard = dashBoardIndex == 0;

    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
            child: Container(
              height: 200,
              decoration: BoxDecoration(gradient: primaryGradient),
              child: Stack(
                children: [
                  const Positioned(
                    left: 0,
                    right: -14,
                    bottom: -14,
                    child: ImageView(
                      assetImage: AppAssets.dashboardRings,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppBar(
                        leading: const CustomBackButton(),
                        title: Text(
                          myDashboard ? 'Dashboard' : 'Members',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: kPadding),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'Total Turnover',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Text(
                              '₹ 19,00,000',
                              style: TextStyle(
                                fontSize: 32,
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  myDashboard ? 'My Target' : 'Members Target',
                  style: headingTextStyle(),
                ),
                GraphDurationFilter(
                  value: selectedDuration,
                  onChange: (String? val) {
                    selectedDuration = val;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: kPadding, left: 8, right: 8),
            child: Row(
              children: [
                MySalesTarget(
                  pending: '06',
                  target: '60',
                  archived: '54',
                ),
                MyRankTarget(
                  level: '6A',
                  rank: '6A2',
                  target: '92',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monthly Performance Graph',
                  style: headingTextStyle(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: inActiveGradient,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Text(
                          '6A2',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded, size: 18)
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
<<<<<<< HEAD
            padding: const EdgeInsets.symmetric(vertical: kPadding, horizontal: 8),
=======
            padding:
                const EdgeInsets.symmetric(vertical: kPadding, horizontal: 8),
>>>>>>> guestUI
            child: PerformanceGraph(
              analytics: dummyAnalyticsList,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: kPadding),
            child: Row(
              children: [
                AnalyticsCard(
                  title: 'List',
                  value: '08',
                  gradient: limeGradient,
                  onTap: () async {
                    await showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        clipBehavior: Clip.antiAlias,
                        isScrollControlled: true,
                        shape: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
<<<<<<< HEAD
                                topLeft: Radius.circular(18), topRight: Radius.circular(18))),
=======
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18))),
>>>>>>> guestUI
                        builder: (context) => CustomModelBottomSheet(
                              title: 'New Lists',
                              tabIndex: myDashboard ? 7 : 4,
                              listItem: 14,
                            ));
                  },
                ),
                AnalyticsCard(
                  title: 'Demo Scheduled',
                  value: '02',
                  gradient: targetGradient,
                  onTap: () async {
                    await showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        clipBehavior: Clip.antiAlias,
                        isScrollControlled: true,
                        shape: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
<<<<<<< HEAD
                                topLeft: Radius.circular(18), topRight: Radius.circular(18))),
=======
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18))),
>>>>>>> guestUI
                        builder: (context) => CustomModelBottomSheet(
                              title: 'Demo Scheduled',
                              tabIndex: myDashboard ? 8 : 5,
                              listItem: 14,
                            ));
                  },
                ),
                AnalyticsCard(
                  title: 'Demo Competed',
                  value: '02',
                  gradient: targetGradient,
                  onTap: () async {
                    await showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        clipBehavior: Clip.antiAlias,
                        isScrollControlled: true,
                        shape: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
<<<<<<< HEAD
                                topLeft: Radius.circular(18), topRight: Radius.circular(18))),
=======
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18))),
>>>>>>> guestUI
                        builder: (context) => CustomModelBottomSheet(
                              title: 'Demo Done',
                              tabIndex: myDashboard ? 9 : 4,
                              listItem: 14,
                            ));
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: kPadding),
            child: Row(
              children: [
                AnalyticsCard(
                  title: 'Leads Closed',
                  value: '06',
                  flex: 2,
                  gradient: primaryGradient,
                  onTap: () async {
                    await showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        clipBehavior: Clip.antiAlias,
                        isScrollControlled: true,
                        shape: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
<<<<<<< HEAD
                                topLeft: Radius.circular(18), topRight: Radius.circular(18))),
=======
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18))),
>>>>>>> guestUI
                        builder: (context) => CustomModelBottomSheet(
                              title: 'Demo Done',
                              tabIndex: myDashboard ? 10 : 6,
                              listItem: 14,
                            ));
                  },
                ),
                AnalyticsCard(
                  title: 'Leads\nConversion',
                  value: '75%',
                  gradient: inActiveGradient,
                  textColor: Colors.white,
                  showArrow: false,
                  flex: 4,
                  onTap: () {},
                ),
              ],
            ),
          ),
          Padding(
<<<<<<< HEAD
            padding: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
=======
            padding: const EdgeInsets.only(
                left: kPadding, right: kPadding, bottom: kPadding),
>>>>>>> guestUI
            child: Text(
              'Leads Type',
              style: headingTextStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: kPadding),
            child: Row(
              children: [
                AnalyticsCard(
                  title: 'Hot Leads',
                  value: '08',
                  minHeight: 100,
<<<<<<< HEAD
                  borderRadius: 24,
                  titleFontSize: 14,
                  textColor: Colors.white,
                  gradient: redGradient,
                  onTap: () {},
                ),
                AnalyticsCard(
                  title: 'Warm Leads',
                  value: '02',
                  borderRadius: 24,
                  titleFontSize: 14,
                  textColor: Colors.white,
                  gradient: primaryGradient,
                  minHeight: 100,
=======
                  gradient: primaryGradient,
>>>>>>> guestUI
                  onTap: () {},
                ),
                AnalyticsCard(
                  title: 'Cold Leads',
<<<<<<< HEAD
                  value: '06',
                  titleFontSize: 14,
                  textColor: Colors.white,
                  gradient: blueGradient,
                  borderRadius: 24,
=======
                  value: '02',
                  gradient: blueGradient,
>>>>>>> guestUI
                  minHeight: 100,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GradientButton(
            width: size.width * 0.85,
            borderRadius: 50,
            blur: 15,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            // backgroundGradient: inActiveGradientTransparent,
            backgroundColor: Colors.white.withOpacity(0.15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                bottomNabBarItems.length,
                (index) {
                  var data = bottomNabBarItems.elementAt(index);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CustomBottomNavBar(
                        index: index,
                        dashBoardIndex: dashBoardIndex,
                        data: data,
                        height: 60,
                        alwaysShowLabel: true,
                        width: size.width,
                        onTap: () {
                          dashBoardIndex = index;
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  TextStyle headingTextStyle() => const TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
=======
  TextStyle headingTextStyle() =>
      const TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
>>>>>>> guestUI
}

class MyRankTarget extends StatelessWidget {
  const MyRankTarget({
    super.key,
    this.level,
    this.rank,
    this.target,
  });

  final String? level;
  final String? rank;
  final String? target;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(minHeight: 140),
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 24),
        decoration: BoxDecoration(
          gradient: inActiveGradient,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '$level',
<<<<<<< HEAD
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
=======
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
>>>>>>> guestUI
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                      child: Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: Colors.black,
                    size: 18,
                  )),
                ),
                Text(
                  '$rank',
<<<<<<< HEAD
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
=======
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
>>>>>>> guestUI
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My rank target',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '(${target ?? 0}) Sale Pending to achieve',
<<<<<<< HEAD
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
=======
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
>>>>>>> guestUI
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MySalesTarget extends StatelessWidget {
  const MySalesTarget({
    super.key,
    required this.pending,
    required this.target,
    required this.archived,
  });

  final String? pending;
  final String? target;
  final String? archived;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(minHeight: 140),
        margin: const EdgeInsets.only(right: 8),
<<<<<<< HEAD
        padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
=======
        padding: const EdgeInsets.symmetric(
            horizontal: kPadding, vertical: kPadding),
>>>>>>> guestUI
        decoration: BoxDecoration(
          gradient: targetGradient,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My sales target',
<<<<<<< HEAD
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
=======
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
>>>>>>> guestUI
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      '${pending ?? 0}',
<<<<<<< HEAD
                      style: const TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
=======
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
>>>>>>> guestUI
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Pending',
<<<<<<< HEAD
                      style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
=======
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
>>>>>>> guestUI
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        '${target ?? 0}',
<<<<<<< HEAD
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
=======
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
>>>>>>> guestUI
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Text(
                        'Target',
<<<<<<< HEAD
                        style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
=======
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
>>>>>>> guestUI
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      color: Colors.black,
                      thickness: 1,
                    )),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        '${archived ?? 0}',
<<<<<<< HEAD
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
=======
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
>>>>>>> guestUI
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Text(
                        'Achieved',
<<<<<<< HEAD
                        style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
=======
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
>>>>>>> guestUI
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.gradient,
    this.textColor,
    this.flex,
    this.showArrow = true,
    this.minHeight,
<<<<<<< HEAD
    this.borderRadius,
    this.titleFontSize,
=======
>>>>>>> guestUI
  });

  final String? title;
  final String? value;
  final Gradient? gradient;
  final Color? textColor;
  final int? flex;

  final GestureTapCallback? onTap;
  final bool? showArrow;
  final double? minHeight;
<<<<<<< HEAD
  final double? borderRadius;
  final double? titleFontSize;
=======
>>>>>>> guestUI

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex ?? 1,
      child: Padding(
        padding: const EdgeInsets.only(right: kPadding, bottom: kPadding),
        child: GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                constraints: BoxConstraints(minHeight: minHeight ?? 120),
<<<<<<< HEAD
                padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 16),
                decoration: BoxDecoration(
                  gradient: gradient ?? inActiveGradient,
                  borderRadius: BorderRadius.circular(borderRadius ?? 32),
=======
                padding: const EdgeInsets.symmetric(
                    horizontal: kPadding, vertical: 16),
                decoration: BoxDecoration(
                  gradient: gradient ?? inActiveGradient,
                  borderRadius: BorderRadius.circular(32),
>>>>>>> guestUI
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${value ?? 0}',
                          style: TextStyle(
                            color: textColor ?? Colors.black,
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
                              color: textColor ?? Colors.black,
<<<<<<< HEAD
                              fontSize: titleFontSize ?? 16,
=======
                              fontSize: 16,
>>>>>>> guestUI
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
                    height: 30,
                    width: 30,
                    borderRadiusValue: 50,
                    backgroundColor: Colors.grey.shade100,
                    assetImage: AppAssets.arrowForwardIcon,
                    padding: const EdgeInsets.all(10),
                    onTap: () {},
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
