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

class GuestReport extends StatefulWidget {
  const GuestReport({super.key});

  @override
  State<GuestReport> createState() => _GuestReportState();
}

class _GuestReportState extends State<GuestReport> {
  List<PinnacleListData>? pinnacleList;
  TextEditingController searchController = TextEditingController();

  Future fetchPinnacleList() async {
    // pinnacleList = await context.read<NetworkControllers>().fetchPartnerReport(
    //       search: searchController.text,
    //     );
  }

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
      return Column(
        children: [
          CustomTextField(
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
            margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding, top: kPadding),
          ),
          if (controller.loadingNetworkReports)
            const Expanded(
              child: LoadingScreen(
                message: 'Loading Guest Report View',
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
                message: 'No Guest Report Found',
              ),
            ),
        ],
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
