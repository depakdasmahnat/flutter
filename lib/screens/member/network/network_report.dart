import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/screens/member/network/pinnacle_list_table.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:mrwebbeast/utils/widgets/custom_text_field.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/network/network_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../models/dashboard/dashboard_data.dart';
import '../../../models/member/network/pinnacle_list_model.dart';
import '../../../utils/custom_menu_popup.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../guest/home/home_screen.dart';
import '../home/member_dashboard.dart';

class NetworkReport extends StatefulWidget {
  const NetworkReport({super.key});

  @override
  State<NetworkReport> createState() => _NetworkReportState();
}

class _NetworkReportState extends State<NetworkReport> {
  List<PinnacleListData>? pinnacleList;
  TextEditingController searchController = TextEditingController();

  Future fetchPinnacleList() async {
    pinnacleList = await context.read<NetworkControllers>().fetchNetworkReports(
          search: searchController.text,
          filter: filter,
        );
  }

  String? filter;

  final List<String> bottomNabBarItems = [
    'Partners',
    'Guests',
  ];

  late String selectedTab = bottomNabBarItems.first;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchPinnacleList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<NetworkControllers>(builder: (context, controller, child) {
      pinnacleList = controller.networkReports;
      return Scaffold(
        appBar: AppBar(
          leading: const CustomBackButton(),
          title: const Text('Report'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
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
                      margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
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
            if (controller.loadingNetworkReports)
              const Expanded(
                child: LoadingScreen(
                  message: 'Loading Report View',
                ),
              )
            else if (pinnacleList.haveData)
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding),
                child: NetworkPinnacleTable(
                  pinnacleList: pinnacleList,
                ),
              ))
            else
              const Expanded(
                child: NoDataFound(
                  message: 'No Report Found',
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
                        child: CustomTabBar(
                          tab: data,
                          selectedTab: selectedTab,
                          height: 60,
                          alwaysShowLabel: true,
                          width: size.width,
                          onTap: () {
                            selectedTab = data;
                            fetchPinnacleList();
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
}

class CustomTabBar extends StatelessWidget {
  final String tab;
  final String selectedTab;
  final double? height;
  final double? width;
  final bool? alwaysShowLabel;

  final GestureTapCallback? onTap;
  final EdgeInsets? imageMargin;

  const CustomTabBar({
    super.key,
    required this.tab,
    required this.selectedTab,
    this.height,
    this.width,
    this.alwaysShowLabel = false,
    this.onTap,
    this.imageMargin,
  });

  @override
  Widget build(BuildContext context) {
    bool selected = selectedTab == tab;
    return GestureDetector(
      onTap: onTap ?? () {},
      child: GradientButton(
        padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 8),
        borderRadius: 50,
        blur: 10,
        height: height ?? 50,
        width: width ?? (selected == true ? null : 50),
        backgroundGradient: selected == true ? primaryGradient : null,
        backgroundColor: selected == true ? null : Colors.grey.withOpacity(0.3),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text(
              '$tab Report',
              style: TextStyle(
                fontSize: 12,
                color: selected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
