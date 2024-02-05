import 'package:flutter/material.dart';
import 'package:mrwebbeast/controllers/member/member_controller/member_controller.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/screens/member/home/duration_popup.dart';
import 'package:mrwebbeast/screens/member/home/performance_graph.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../../models/dashboard/dashboard_data.dart';
import '../../../models/member/dashboard/dashboard_states_model.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/custom_bottemsheet.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../dashboard/dashboard.dart';
import '../../guest/home/home_screen.dart';

class MemberDashBoard extends StatefulWidget {
  const MemberDashBoard({super.key, this.memberId});

  final num? memberId;

  @override
  State<MemberDashBoard> createState() => _MemberDashBoardState();
}

class _MemberDashBoardState extends State<MemberDashBoard> {
  late num? memberId = widget.memberId;

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
  TextEditingController searchController = TextEditingController();
  DashboardStatesData? dashboardStatesData;
  List<DashboardAnalytics>? analytics;

  Future fetchDashboardStates({bool? loadingNext}) async {
    return await context.read<MembersController>().fetchDashboardStates(
          memberId: memberId,
          filter: selectedDuration,
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchDashboardStates();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    bool myDashboard = dashBoardIndex == 0;

    return Consumer<MembersController>(builder: (context, controller, child) {
      dashboardStatesData = controller.dashboardStatesData;
      analytics = dashboardStatesData?.analytics;

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
                              Text(
                                '₹ ${dashboardStatesData?.salesTarget ?? 0}',
                                style: const TextStyle(
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
            if (controller.loadingDashboardStates)
              const LoadingScreen(
                heightFactor: 0.7,
                message: 'Loading Dashboard...',
              )
            else if (dashboardStatesData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            fetchDashboardStates();
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: kPadding, left: 8, right: 8),
                    child: Row(
                      children: [
                        MySalesTarget(
                          pending: '${dashboardStatesData?.pendingSales ?? ''}',
                          target: '${dashboardStatesData?.salesTarget ?? ''}',
                          archived: '${dashboardStatesData?.achievedSales ?? ''}',
                        ),
                        MyRankTarget(
                          level: '${dashboardStatesData?.pendingRankSales ?? ''}',
                          rank: '${dashboardStatesData?.rank ?? ''}',
                          target: '${dashboardStatesData?.targetRank ?? ''}',
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
                          '$selectedDuration Performance Graph',
                          style: headingTextStyle(),
                        ),

                        GraphDurationFilter(
                          value: selectedDuration,
                          onChange: (String? val) {
                            selectedDuration = val;
                            setState(() {});
                            fetchDashboardStates();
                          },
                        ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        //   decoration: BoxDecoration(
                        //     gradient: inActiveGradient,
                        //     borderRadius: BorderRadius.circular(5),
                        //   ),
                        //   child: const Row(
                        //     children: [
                        //       Padding(
                        //         padding: EdgeInsets.only(right: 4),
                        //         child: Text(
                        //           '6A2',
                        //           style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        //         ),
                        //       ),
                        //       Icon(Icons.keyboard_arrow_down_rounded, size: 18)
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  if (analytics.haveData)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: kPadding, horizontal: 8),
                      child: PerformanceGraph(
                        analytics: analytics,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: kPadding),
                    child: Row(
                      children: [
                        AnalyticsCard(
                          title: 'Lists',
                          value: '${dashboardStatesData?.memberCounts ?? 0}',
                          gradient: limeGradient,
                          onTap: () async {
                            await showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              clipBehavior: Clip.antiAlias,
                              isScrollControlled: true,
                              shape: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(18), topRight: Radius.circular(18))),
                              builder: (context) => CustomModelBottomSheet(
                                title: 'New Lists',
                                tabIndex: myDashboard ? 7 : 4,
                                listItem: 14,
                              ),
                            );
                          },
                        ),
                        AnalyticsCard(
                          title: 'Demo Scheduled',
                          value: '${dashboardStatesData?.demoScheduled ?? 0}',
                          gradient: targetGradient,
                          onTap: () async {
                            await showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                clipBehavior: Clip.antiAlias,
                                isScrollControlled: true,
                                shape: const OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(18), topRight: Radius.circular(18))),
                                builder: (context) => CustomModelBottomSheet(
                                      title: 'Demo Scheduled',
                                      tabIndex: myDashboard ? 8 : 5,
                                      listItem: 14,
                                    ));
                          },
                        ),
                        AnalyticsCard(
                          title: 'Demo Competed',
                          value: '${dashboardStatesData?.demoCompleted ?? 0}',
                          gradient: targetGradient,
                          onTap: () async {
                            await showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                clipBehavior: Clip.antiAlias,
                                isScrollControlled: true,
                                shape: const OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(18), topRight: Radius.circular(18))),
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
                          value: '${dashboardStatesData?.leadsClosed ?? 0}',
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
                                        topLeft: Radius.circular(18), topRight: Radius.circular(18))),
                                builder: (context) => CustomModelBottomSheet(
                                      title: 'Demo Done',
                                      tabIndex: myDashboard ? 10 : 6,
                                      listItem: 14,
                                    ));
                          },
                        ),
                        AnalyticsCard(
                          title: 'Leads\nConversion',
                          value: '${dashboardStatesData?.leadsConversion ?? 0}%',
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
                    padding: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
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
                          value: '${dashboardStatesData?.hotLeads ?? 0}',
                          minHeight: 100,
                          borderRadius: 24,
                          titleFontSize: 14,
                          textColor: Colors.white,
                          gradient: redGradient,
                          onTap: () {},
                        ),
                        AnalyticsCard(
                          title: 'Warm Leads',
                          value: '${dashboardStatesData?.warmLeads ?? 0}',
                          borderRadius: 24,
                          titleFontSize: 14,
                          textColor: Colors.white,
                          gradient: primaryGradient,
                          minHeight: 100,
                          onTap: () {},
                        ),
                        AnalyticsCard(
                          title: 'Cold Leads',
                          value: '${dashboardStatesData?.coldLeads ?? 0}',
                          titleFontSize: 14,
                          textColor: Colors.white,
                          gradient: blueGradient,
                          borderRadius: 24,
                          minHeight: 100,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              NoDataFound(
                heightFactor: 0.7,
                message: controller.dashboardStatesModel?.message ?? 'No Dashboard Found',
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
                            fetchDashboardStates();
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
    });
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
    this.borderRadius,
    this.titleFontSize,
  });

  final String? title;
  final String? value;
  final Gradient? gradient;
  final Color? textColor;
  final int? flex;

  final GestureTapCallback? onTap;
  final bool? showArrow;
  final double? minHeight;
  final double? borderRadius;
  final double? titleFontSize;

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
                padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 16),
                decoration: BoxDecoration(
                  gradient: gradient ?? inActiveGradient,
                  borderRadius: BorderRadius.circular(borderRadius ?? 32),
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
                              fontSize: titleFontSize ?? 16,
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
