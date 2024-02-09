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
    DashboardController controller = Provider.of<DashboardController>(context);
    dashBoardIndex = controller.dashBoardIndex;
    double imageSize = deviceSpecificValue(context: context, device: 24, tablet: 36).toDouble();
    return WillPopScope(
      onWillPop: onAppExit,
      child: Scaffold(
        body: Builder(builder: (BuildContext context) {
          return dashboardScreens.elementAt(dashBoardIndex).widget!;
        }),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: BottomNavigationBar(
            currentIndex: dashBoardIndex,
            backgroundColor: Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey.shade400,
            showUnselectedLabels: false,
            selectedFontSize: 0,
            items: List.generate(
              dashboardScreens.length,
              (index) {
                bool selected = index == dashBoardIndex;
                var data = dashboardScreens.elementAt(index);
                Color color = selected ? primaryColor : Colors.grey.shade400;
                return BottomNavigationBarItem(
                  tooltip: "${data.title}",
                  label: "",
                  icon: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
