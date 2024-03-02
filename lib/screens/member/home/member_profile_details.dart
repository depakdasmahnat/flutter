import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/controllers/member/member_controller/member_controller.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';

import 'package:mrwebbeast/screens/member/home/duration_popup.dart';
import 'package:mrwebbeast/screens/member/home/performance_graph.dart';
import 'package:mrwebbeast/screens/member/lead/leads_popup.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/member/network/network_controller.dart';
import '../../../core/constant/enums.dart';
import '../../../models/dashboard/dashboard_data.dart';
import '../../../models/member/network/pinnacle_list_model.dart';
import '../../../models/member/profile/member_profile_model.dart';
import '../../../utils/custom_menu_popup.dart';
import '../../../utils/widgets/custom_bottom_sheet.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/gradient_progress_bar.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../guest/home/home_screen.dart';
import '../network/pinnacle_list_table.dart';

class MemberProfileDetails extends StatefulWidget {
  final String memberId;

  const MemberProfileDetails({super.key, required this.memberId});

  @override
  State<MemberProfileDetails> createState() => _MemberProfileDetailsState();
}

class _MemberProfileDetailsState extends State<MemberProfileDetails> {
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
  double? trainingProgress;

  String? selectedDuration = DurationFilterMenu.monthly.label;
  MemberProfileData? memberProfile;

  Future fetchMemberProfileDetails({bool? loadingNext}) async {
    return await context.read<MembersController>().fetchMemberProfileDetails(
          memberId: widget.memberId,
        );
  }

  List<PinnacleListData>? pinnacleList;
  TextEditingController searchController = TextEditingController();

  Future fetchPinnacleList() async {
    pinnacleList = await context.read<NetworkControllers>().fetchNetworkReports(
          search: searchController.text,
          filter: filter,
          memberId: widget.memberId,
        );
  }

  String? filter;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        fetchMemberProfileDetails();
        fetchPinnacleList();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    NetworkControllers networkControllers = Provider.of<NetworkControllers>(context);
    pinnacleList = networkControllers.networkReports;

    return Consumer<MembersController>(
      builder: (context, controller, child) {
        memberProfile = controller.memberProfile;
        trainingProgress = (memberProfile?.training ?? 0).toDouble();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile Details'),
          ),
          body: controller.loadingMemberProfile == true
              ? const LoadingScreen(message: 'Loading Profile...')
              : ListView(
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${memberProfile?.firstName} ${memberProfile?.lastName}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 8),
                              child: Text(
                                'ID: ${memberProfile?.enagicId}',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                '+91 ${memberProfile?.mobile}',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                            Text(
                              memberProfile?.address ?? '',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
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
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8),
                                          child: Text(
                                            memberProfile?.rank ?? '6A',
                                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                        const ImageView(
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
                                    child: Row(
                                      children: [
                                        const ImageView(
                                          height: 18,
                                          assetImage: AppAssets.membersFilledIcon,
                                          margin: EdgeInsets.only(),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8),
                                          child: Text(
                                            'Members ${memberProfile?.memberCounts ?? ''}',
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
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
                              Text(
                                'Steps ${memberProfile?.chapters ?? ''}',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${(trainingProgress ?? 0).toStringAsFixed(0)}%',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
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
                              fetchMemberProfileDetails();
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
                            pending: '${memberProfile?.pendingSales ?? ''}',
                            target: '${memberProfile?.salesTarget ?? ''}',
                            archived: '${memberProfile?.achievedSales ?? ''}',
                          ),
                          MyRankTarget(
                            level: memberProfile?.rank ?? '',
                            rank: memberProfile?.nextRank ?? '',
                            target: '${memberProfile?.rankPendingSales ?? ''}',
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: kPadding, right: kPadding, bottom: kPadding, top: kPadding),
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
                              value: '${memberProfile?.allLists ?? ''}',
                              gradient: limeGradient,
                              onTap: () {
                                CustomBottomSheet.show(
                                  context: context,
                                  body: LeadsPopup(
                                    title: 'Leads Added',
                                    status: LeadsStatus.newLead.value,
                                  ),
                                );
                              },
                            ),
                            AnalyticsCard(
                              title: 'Demo Scheduled',
                              value: '${memberProfile?.demoSchedule ?? ''}',
                              gradient: targetGradient,
                              onTap: () {
                                CustomBottomSheet.show(
                                  context: context,
                                  body: LeadsPopup(
                                    title: 'Demo Scheduled',
                                    status: LeadsStatus.demoScheduled.value,
                                  ),
                                );
                              },
                            ),
                            AnalyticsCard(
                              title: 'Demo Competed',
                              value: '${memberProfile?.demoDone ?? ''}',
                              gradient: targetGradient,
                              onTap: () {
                                CustomBottomSheet.show(
                                  context: context,
                                  body: LeadsPopup(
                                    title: 'Demo Competed',
                                    status: LeadsStatus.followUp.value,
                                  ),
                                );
                              },
                            ),
                            AnalyticsCard(
                              title: 'Leads Closed',
                              value: '${memberProfile?.closingDone ?? ''}',
                              flex: 2,
                              gradient: primaryGradient,
                              onTap: () {
                                CustomBottomSheet.show(
                                  context: context,
                                  body: LeadsPopup(
                                    title: 'Leads Closed',
                                    status: LeadsStatus.closed.value,
                                  ),
                                );
                              },
                            ),
                            AnalyticsCard(
                              title: 'Leads\nConversion',
                              value: '${memberProfile?.conversionRatio ?? ''}',
                              gradient: inActiveGradient,
                              textColor: Colors.white,
                              showArrow: false,
                              flex: 4,
                              onTap: () {},
                            ),
                            AnalyticsCard(
                              title: 'Hot Leads',
                              value: '${memberProfile?.hotLeads ?? '0'}',
                              minHeight: 100,
                              gradient: primaryGradient,
                              showArrow: false,
                              onTap: () {},
                            ),
                            AnalyticsCard(
                              title: 'Cold Leads',
                              value: '${memberProfile?.coldLeads ?? '0'}',
                              gradient: blueGradient,
                              minHeight: 100,
                              showArrow: false,
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
                            '$selectedDuration Performance Graph',
                            style: headingTextStyle(),
                          ),
                          GraphDurationFilter(
                            value: selectedDuration,
                            onChange: (String? val) {
                              selectedDuration = val;
                              setState(() {});
                              fetchMemberProfileDetails();
                            },
                          ),
                        ],
                      ),
                    ),
                    if (memberProfile?.analytics?.haveData == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: kPadding, horizontal: 8),
                        child: PerformanceGraph(
                          analytics: memberProfile?.analytics,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Partners',
                            style: headingTextStyle(),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: kPadding),
                          child: Row(
                            children: [
                              Flexible(
                                child: CustomTextField(
                                  hintText: 'Search',
                                  controller: searchController,
                                  hintStyle: const TextStyle(color: Colors.white),
                                  prefixIcon: ImageView(
                                    height: 20,
                                    width: 20,
                                    borderRadiusValue: 0,
                                    color: Colors.white,
                                    margin: const EdgeInsets.only(left: kPadding, right: kPadding),
                                    fit: BoxFit.contain,
                                    assetImage: AppAssets.searchIcon,
                                    onTap: () {
                                      fetchPinnacleList();
                                    },
                                  ),
                                  onEditingComplete: () {
                                    fetchPinnacleList();
                                  },
                                  margin: const EdgeInsets.only(
                                      left: kPadding, right: kPadding, bottom: kPadding),
                                ),
                              ),
                              CustomPopupMenu(
                                items: [
                                  CustomPopupMenuEntry(
                                    value: '',
                                    label: 'All',
                                    onPressed: () {
                                      filter = null;
                                    },
                                  ),
                                  CustomPopupMenuEntry(
                                    label: 'Level',
                                    onPressed: null,
                                  ),
                                  CustomPopupMenuEntry(
                                    label: 'Achievement',
                                    onPressed: null,
                                  ),
                                  CustomPopupMenuEntry(
                                    label: 'Conversion Ratio',
                                    onPressed: null,
                                  ),
                                  CustomPopupMenuEntry(
                                    label: 'Progress',
                                    onPressed: null,
                                  ),
                                  CustomPopupMenuEntry(
                                    label: 'Training',
                                    onPressed: null,
                                  ),
                                  CustomPopupMenuEntry(
                                    label: 'Demo',
                                    onPressed: null,
                                  ),
                                  CustomPopupMenuEntry(
                                    label: 'Target',
                                    onPressed: null,
                                  ),
                                ],
                                onChange: (String? val) {
                                  filter = val;
                                  setState(() {});
                                  fetchPinnacleList();
                                },
                                child: GradientButton(
                                  height: 60,
                                  width: 60,
                                  margin: const EdgeInsets.only(left: 8, right: kPadding, bottom: kPadding),
                                  backgroundGradient: blackGradient,
                                  child: const ImageView(
                                    height: 28,
                                    width: 28,
                                    assetImage: AppAssets.filterIcons,
                                    margin: EdgeInsets.zero,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        if (networkControllers.loadingNetworkReports)
                          const LoadingScreen(
                            heightFactor: 0.2,
                            message: 'Loading Partners',
                          )
                        else if (pinnacleList.haveData)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: kPadding),
                            child: NetworkPinnacleTable(
                              pinnacleList: pinnacleList,
                            ),
                          )
                        else
                          const NoDataFound(
                            heightFactor: 0.2,
                            message: 'No Partners Found',
                          ),
                      ],
                    )
                  ],
                ),
          bottomSheet: memberProfile?.mobile != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GradientButton(
                      height: 70,
                      borderRadius: 18,
                      blur: 10,
                      backgroundGradient: primaryGradient,
                      backgroundColor: Colors.transparent,
                      boxShadow: const [],
                      margin: const EdgeInsets.only(left: 16, right: 24),
                      onTap: () async {
                        launchUrl(Uri.parse('tel:${memberProfile?.mobile}'));
                        // await context.read<MembersController>().callUser(
                        //       mobileNo: '${memberProfile?.mobile}',
                        //     );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssets.call,
                            height: size.height * 0.04,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Call',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: GoogleFonts.urbanist().fontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : null,
        );
      },
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
                  ),
                ),
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
