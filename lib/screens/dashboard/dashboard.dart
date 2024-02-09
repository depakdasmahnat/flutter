import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/screens/dashboard/profile_screen.dart';
import 'package:gaas/utils/widgets/image_view.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../controllers/dashboard_controller.dart';
import '../../controllers/location/location_controller.dart';
import '../../controllers/orders/cart_controller.dart';
import '../../core/functions.dart';
import '../../core/services/database/local_database.dart';
import '../../models/bottom_navbar_data.dart';
import '../feeds/feeds_screen.dart';
import '../home/home_screen.dart';
import '../orders/orders_screen.dart';
import '../services/services_screen.dart';
import 'nursery_screen.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key, this.dashBoardIndex}) : super(key: key);
  final int? dashBoardIndex;

  @override
  DashBoardState createState() => DashBoardState();
}

class DashBoardState extends State<DashBoard> {
  late int dashBoardIndex = widget.dashBoardIndex ?? 0;
  LocalDatabase localDatabase = LocalDatabase();
  late bool isAuthenticated = localDatabase.accessToken != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<DashboardController>().setDashBoardIndex(index: dashBoardIndex, context: context);
      if (isAuthenticated) {
        context.read<CartController>().fetchFreshProduceUnReviewedOrders(context: context);
        context.read<CartController>().fetchNurseryUnReviewedOrders(context: context);
      }
      context.read<LocationController>().getLocalAddress();
      context
          .read<LocationController>()
          .determinePosition(context: context, showPopup: true, updateLocation: true);
    });
  }

  List<BottomNavBarData> dashboardScreens = [
    BottomNavBarData(title: "Fresh Produce", image: AppImages.shop, widget: const HomeScreen()),
    BottomNavBarData(title: "Nursery", image: AppImages.vegan, widget: const NurseryScreen()),
    BottomNavBarData(title: "Services", image: AppImages.services, widget: const ServicesScreen()),
    BottomNavBarData(title: "Knowledge", image: AppImages.category, widget: const FeedsScreen()),
    BottomNavBarData(title: "Order", image: AppImages.bag, widget: const OrdersScreen()),
    BottomNavBarData(title: "Profile", image: AppImages.profile, widget: const ProfileScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    LocalDatabase localDatabase = Provider.of<LocalDatabase>(context);
    debugPrint('deviceToken ${localDatabase.deviceToken}');
    // DashboardController dashboardController = Provider.of<DashboardController>(context);
    Size size = MediaQuery.sizeOf(context);
    return Consumer<DashboardController>(
      builder: (context, controller, child) {
        dashBoardIndex = controller.dashBoardIndex;
        userRole = controller.userRole;
        return WillPopScope(
          onWillPop: onAppExit,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            drawer: const CustomDrawer(),
            onDrawerChanged: (val) {},
            appBar: (userRole == UserRoles.member.value && dashBoardIndex == 0)
                ? AppBar(
                    elevation: 0,
                    leadingWidth: 0,
                    leading: const SizedBox(),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Builder(builder: (context) {
                          return ImageView(
                            height: 40,
                            width: 40,
                            assetImage: AppAssets.drawerIcon,
                            margin: const EdgeInsets.only(right: kPadding),
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        }),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width:180,
                              child: GradientText(
                                'Welcome ${localDatabase.member?.firstName ?? 'Member'}',
                                gradient: primaryGradient,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: GoogleFonts.urbanist().fontFamily,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: GoogleFonts.urbanist().fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    actions: [
                      ImageView(
                        height: imageSize,
                        width: imageSize,
                        color: color,
                        assetImage: "${data.image}",
                        margin: const EdgeInsets.only(bottom: 6, top: 6),
                      ),
                      FittedBox(
                        child: Text(
                          "${data.title}",
                          style: TextStyle(color: color, fontSize: selected ? 12 : 11),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            onTap: (index) {
              context.read<DashboardController>().setDashBoardIndex(index: index, context: context);
            },
          ),
        ),
      ),
    );
  }
}
