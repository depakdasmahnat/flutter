import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/screens/partner/fresh/inventory_screen.dart';
import 'package:gaas/screens/partner/utils/dashoard_order_card.dart';
import 'package:gaas/screens/partner/utils/partner_app_bar.dart';
import 'package:gaas/utils/widgets/image_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/partner/partner_controller.dart';
import '../../../core/constant/colors.dart';
import '../../../core/services/database/local_database.dart';
import '../../../models/dashboard/banners_model.dart';
import '../../../models/partner/auth/partner_model.dart';
import '../../../models/partner/partner_dash_board_model.dart';
import '../../../route/route_paths.dart';
import '../../home/utils/offer_banners.dart';
import '../utils/order_info_card.dart';
import '../utils/partner_notifications.dart';

class FreshProduce extends StatefulWidget {
  const FreshProduce({
    super.key,
  });

  @override
  State<FreshProduce> createState() => _FreshProduceState();
}

class _FreshProduceState extends State<FreshProduce> {
  LocalDatabase localDatabase = LocalDatabase();
  PartnerDashBoardData? partnerDashBoardData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      PartnerController partnerController = Provider.of<PartnerController>(context, listen: false);
      partnerController.fetchPartnerDashBoard(context: context);
      partnerController.checkPartnerLiveStatus(context: context);
      partnerController.fetchPartnerBanners(context: context);
    });
  }

  double imageRadius = 55;

  PartnerData? partnerData;
  ServiceType? serviceType;
  List<BannersData>? banners;

  @override
  Widget build(BuildContext context) {
    PartnerController partnerController = Provider.of<PartnerController>(context);
    partnerData = partnerController.partnerData;
    serviceType = partnerController.serviceType;
    partnerDashBoardData = partnerController.partnerDashBoardData;
    banners = partnerController.bannersData;
    return Scaffold(
      appBar: partnerAppBar(context: context, title: "${serviceType?.value} Produce"),
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              context.read<PartnerController>().setDashBoardIndex(4);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.15),
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: ImageView(
                  height: imageRadius,
                  width: imageRadius,
                  borderRadiusValue: imageRadius,
                  networkImage: "${partnerData?.profilePhoto}",
                  border: Border.all(color: primaryColor),
                  isAvatar: true,
                  fit: BoxFit.cover,
                  margin: EdgeInsets.zero,
                ),
                title: Text(
                  "Hi ${partnerData?.name ?? "Partner"}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                subtitle: Text(
                  "${serviceType?.value}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: CircleAvatar(
                  radius: 16,
                  backgroundColor: primaryColor.withOpacity(0.2),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: primaryColor,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 130,
            margin: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DashboardOrderCard(
                  title: "Today New Order",
                  value: "${partnerDashBoardData?.todaysOrders ?? 0}",
                  hike: "${partnerDashBoardData?.totalSettleledHike ?? 0}",
                  onTap: () {},
                ),
                DashboardOrderCard(
                  title: "Today Earn",
                  value: "\$${partnerDashBoardData?.todaysEarn ?? 0}",
                  hike: "${(partnerDashBoardData?.todaysEarnHike ?? 0).toStringAsFixed(1)} %",
                  onTap: () {},
                ),
                DashboardOrderCard(
                  title: "Total Settled this year",
                  value: "\$${partnerDashBoardData?.totalSettleled ?? 0}",
                  hike: "${partnerDashBoardData?.totalSettleledHike ?? 0}",
                  onTap: () {},
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PartnerNotification(
                  title: "Inventory",
                  value: 0,
                  onTap: () {
                    context.pushNamed(Routs.partnerInventory, extra: const PartnerInventory(id: 1));
                  },
                ),
                PartnerNotification(
                  title: "New Orders",
                  value: partnerDashBoardData?.newOrders ?? 0,
                  onTap: () {
                    context.read<PartnerController>().setDashBoardIndex(1);
                    context.read<PartnerController>().setOrdersTabIndex(1);
                  },
                ),
              ],
            ),
          ),
          if (banners.haveData)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 16),
                  child: Text(
                    "New Schemes",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                OfferBanners(
                  banners: banners,
                  schemeMode: true,
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Text(
              "Orders",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: defaultBoxShadow(),
            ),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                OrdersInfoCard(
                  title: "New Order",
                  image: AppImages.newOrder,
                  description: "All New Orders",
                  orders: partnerDashBoardData?.newOrders ?? 0,
                  onTap: () {
                    context.read<PartnerController>().setDashBoardIndex(1);
                    context.read<PartnerController>().setOrdersTabIndex(1);
                  },
                ),
                OrdersInfoCard(
                  title: "Order On Process",
                  image: AppImages.pending,
                  description: "Total Processing Orders",
                  orders: partnerDashBoardData?.pending ?? 0,
                  onTap: () {
                    context.read<PartnerController>().setDashBoardIndex(1);
                    // context.read<PartnerController>().setOrdersTabIndex(2);
                  },
                ),
                OrdersInfoCard(
                  title: "Completed",
                  image: AppImages.completed,
                  description: "Total Completed Orders",
                  orders: partnerDashBoardData?.completed ?? 0,
                  onTap: () {
                    context.read<PartnerController>().setDashBoardIndex(1);
                    context.read<PartnerController>().setOrdersTabIndex(2);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
