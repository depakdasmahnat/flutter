import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/screens/partner/service/service_partner.dart';
import 'package:gaas/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../controllers/partner/membership_controller.dart';
import '../../controllers/partner/partner_controller.dart';
import '../../core/enums/enums.dart';
import '../../models/bottom_navbar_data.dart';
import '../../utils/widgets/widgets.dart';
import 'fresh/fresh_produce.dart';
import 'fresh/partner_earnings.dart';
import 'fresh/partner_orders.dart';
import 'fresh/partner_products.dart';
import 'partner_settings.dart';
import 'service/leads/leads_screen.dart';

class PartnerDashBoard extends StatefulWidget {
  const PartnerDashBoard({Key? key, this.dashBoardIndex, this.type}) : super(key: key);
  final int? dashBoardIndex;
  final ServiceType? type;

  @override
  PartnerDashBoardState createState() => PartnerDashBoardState();
}

class PartnerDashBoardState extends State<PartnerDashBoard> {
  late int dashBoardIndex = widget.dashBoardIndex ?? 0;
  late ServiceType type = widget.type ?? ServiceType.freshProduce;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      PartnerController controllers = Provider.of(context, listen: false);
      controllers.setServiceType(serviceType: type);
      context.read<PartnerController>().setDashBoardIndex(dashBoardIndex);
      if (type != ServiceType.serviceProvider) {
        controllers.checkTimelineStatus(context: context);
      }
      MembershipController membershipController = Provider.of(context, listen: false);
      membershipController.showMembershipPopupAPI(context: context);
      controllers.fetchPartnerProfile(context: context);
    });
  }

  late List<BottomNavBarData> dashboardScreens = (type == ServiceType.freshProduce ||
          type == ServiceType.nursery)
      ? [
          BottomNavBarData(title: "Dashboard", image: AppImages.dashboard, widget: const FreshProduce()),
          BottomNavBarData(title: "Order", image: AppImages.bag, widget: const PartnerOrders()),
          BottomNavBarData(title: "Earning", image: AppImages.earnings, widget: const PartnerEarning()),
          BottomNavBarData(title: "Products", image: AppImages.package, widget: const PartnerProducts()),
          BottomNavBarData(title: "Profile", image: AppImages.profile, widget: const PartnerSettings()),
        ]
      : [
          BottomNavBarData(title: "Dashboard", image: AppImages.dashboard, widget: const ServicePartner()),
          BottomNavBarData(
              title: "Leads", image: AppImages.leads, widget: const LeadsScreen(partnerLeads: true)),
          BottomNavBarData(title: "Profile", image: AppImages.profile, widget: const PartnerSettings()),
        ];

  @override
  Widget build(BuildContext context) {
    PartnerController partnerController = Provider.of<PartnerController>(context);
    dashBoardIndex = partnerController.dashBoardIndex;

    return WillPopScope(
      onWillPop: dashBoardIndex == 0
          ? onPartnerDashboardBack
          : () async {
              context.read<PartnerController>().setDashBoardIndex(0);
              return false;
            },
      child: Scaffold(
        body: Builder(builder: (BuildContext context) {
          return dashboardScreens.elementAt(dashBoardIndex).widget!;
        }),
        bottomNavigationBar: BottomNavigationBar(
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
                      height: 24,
                      width: 24,
                      color: color,
                      assetImage: "${data.image}",
                      margin: const EdgeInsets.only(bottom: 6),
                    ),
                    Text(
                      "${data.title}",
                      style: TextStyle(color: color, fontSize: selected ? 13 : 12),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              );
            },
          ),
          onTap: (index) {
            context.read<PartnerController>().setDashBoardIndex(index);
            context.read<PartnerController>().setOrdersTabIndex(0);
          },
        ),
      ),
    );
  }
}
