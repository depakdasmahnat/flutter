import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/models/dashboard/target_analytics_model.dart';
import 'package:mrwebbeast/screens/member/home/duration_popup.dart';
import 'package:mrwebbeast/screens/member/home/performance_graph.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';

import '../../../models/dashboard/dashboard_data.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/gradient_progress_bar.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../dashboard/dashboard.dart';
import '../../guest/home/home_screen.dart';

class MemberProfileDetails extends StatefulWidget {
  const MemberProfileDetails({super.key});

  @override
  State<MemberProfileDetails> createState() => _MemberProfileDetailsState();
}

class _MemberProfileDetailsState extends State<MemberProfileDetails> {
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
  double? trainingProgress = 75;
  String? selectedDuration = DurationFilterMenu.monthly.label;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          Row(
            children: [
              ImageView(
                height: 100,
                width: 100,
                border: Border.all(color: Colors.white),
                borderRadiusValue: 50,
                isAvatar: true,
                margin: const EdgeInsets.only(left: 8, right: 16),
                fit: BoxFit.contain,
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ayaan Sha',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 8),
                    child: Text(
                      'ID: 655847A',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 2),
                    child: Text(
                      '+91 62656 84212',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Text(
                    'Civil lines, Raipur, C.G.',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: kPadding, right: kPadding),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: kPadding, bottom: 8),
                      child: Text(
                        'Achievement',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: inActiveGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Text(
                                  '6A2',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                ),
                              ),
                              ImageView(
                                height: 18,
                                assetImage: AppAssets.achievementIcon,
                                margin: EdgeInsets.only(),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: kPadding),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: inActiveGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              ImageView(
                                height: 18,
                                assetImage: AppAssets.membersFilledIcon,
                                margin: EdgeInsets.only(),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  'Members 54',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: kPadding, left: kPadding, right: kPadding),
            padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Training Progress',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GradientProgressBar(
                  value: (trainingProgress ?? 0) > 0 ? (trainingProgress! / 100) : 0,
                  backgroundColor: Colors.grey.shade300,
                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Steps 35/60',
                      style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${(trainingProgress ?? 0).toStringAsFixed(0)}%',
                      style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Compete your training',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
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
                  'Members Target',
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
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding, top: kPadding),
                child: Text(
                  'Dashboard',
                  style: headingTextStyle(),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: kPadding),
            child: SizedBox(
              height: 140,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  AnalyticsCard(
                    title: 'Leads Added',
                    value: '08',
                    gradient: limeGradient,
                    onTap: () {},
                  ),
                  AnalyticsCard(
                    title: 'Demo Scheduled',
                    value: '02',
                    gradient: targetGradient,
                    onTap: () {},
                  ),
                  AnalyticsCard(
                    title: 'Demo Competed',
                    value: '02',
                    gradient: targetGradient,
                    onTap: () {},
                  ),
                  AnalyticsCard(
                    title: 'Leads Closed',
                    value: '06',
                    flex: 2,
                    gradient: primaryGradient,
                    onTap: () {},
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
                  AnalyticsCard(
                    title: 'Hot Leads',
                    value: '08',
                    minHeight: 100,
                    gradient: primaryGradient,
                    onTap: () {},
                  ),
                  AnalyticsCard(
                    title: 'Cold Leads',
                    value: '02',
                    gradient: blueGradient,
                    minHeight: 100,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: 8),
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
            padding: const EdgeInsets.symmetric(vertical: kPadding, horizontal: 8),
            child: PerformanceGraph(
              analytics: dummyAnalyticsList,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle headingTextStyle() => const TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
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
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
        padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
        decoration: BoxDecoration(
          gradient: targetGradient,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My sales target',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
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
                      style: const TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Pending',
                      style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
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
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Text(
                        'Target',
                        style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
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
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Text(
                        'Achieved',
                        style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
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
  });

  final String? title;
  final String? value;
  final Gradient? gradient;
  final Color? textColor;
  final int? flex;

  final GestureTapCallback? onTap;
  final bool? showArrow;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: kPadding, bottom: kPadding),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              constraints: BoxConstraints(minHeight: minHeight ?? 120, maxWidth: 120),
              padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 16),
              decoration: BoxDecoration(
                gradient: gradient ?? inActiveGradient,
                borderRadius: BorderRadius.circular(32),
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
                            color: textColor ?? Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
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
    );
  }
}
