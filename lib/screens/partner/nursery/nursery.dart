import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/models/dashboard/banners_model.dart';
import 'package:gaas/screens/partner/utils/dashoard_order_card.dart';
import 'package:gaas/utils/widgets/image_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/partner/partner_controller.dart';
import '../../../core/constant/colors.dart';
import '../../../core/enums/enums.dart';
import '../../../core/services/database/local_database.dart';
import '../../../models/fresh_produce_data.dart';
import '../../../models/partner/auth/partner_model.dart';
import '../../../route/route_paths.dart';
import '../../home/utils/offer_banners.dart';
import '../signup/join_as_partner.dart';
import '../utils/order_info_card.dart';
import '../utils/partner_app_bar.dart';
import '../utils/partner_notifications.dart';

class Nursery extends StatefulWidget {
  const Nursery({
    super.key,
  });

  @override
  State<Nursery> createState() => _NurseryState();
}

class _NurseryState extends State<Nursery> {
  LocalDatabase localDatabase = LocalDatabase();

  @override
  void initState() {
    super.initState();
  }

  double imageRadius = 55;

  String? photoUrl =
      "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlciUyMHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60";

  List<BannersData?>? banners = [
    BannersData(),
    BannersData(),
  ];
  late List<FreshProduceData?>? categories = [
    FreshProduceData(id: "1", name: "Nursery", image: AppImages.nursery1),
    FreshProduceData(id: "2", name: "Nursery", image: AppImages.nursery2),
    FreshProduceData(id: "3", name: "Nursery", image: AppImages.nursery3),
    FreshProduceData(id: "4", name: "Nursery", image: AppImages.nursery2),
    FreshProduceData(id: "5", name: "Nursery", image: AppImages.nursery1),
    FreshProduceData(id: "6", name: "Nursery", image: AppImages.nursery3),
  ];
  PartnerData? partnerData;
  ServiceType? serviceType;

  @override
  Widget build(BuildContext context) {
    PartnerController partnerController = Provider.of<PartnerController>(context);
    partnerData = partnerController.partnerData;
    serviceType = partnerController.serviceType;
    return Scaffold(
      appBar: partnerAppBar(context: context, title: "Nursery Service"),
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              context.pushNamed(
                Routs.joinAsPartner,
                extra: JoinAsPartner(editMode: true, type: serviceType),
              );
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
                  fit: BoxFit.cover,
                  margin: EdgeInsets.zero,
                ),
                title: Text(
                  "Hi ${partnerData?.name}",
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
                  value: "5",
                  hike: "3",
                  onTap: () {},
                ),
                DashboardOrderCard(
                  title: "Today Earn",
                  value: "\$230",
                  hike: "5",
                  onTap: () {},
                ),
                DashboardOrderCard(
                  title: "Total Settled this year",
                  value: "\$450",
                  hike: "7",
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
                  onTap: () {},
                ),
                PartnerNotification(
                  title: "New Orders",
                  value: 2,
                  onTap: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 16),
            child: Text(
              "New Schemes",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          OfferBanners(banners: banners),
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
                  description: "Reference site about Lorem Ipsum",
                  orders: 8,
                  onTap: () {},
                ),
                OrdersInfoCard(
                  title: "Order On Process",
                  image: AppImages.pending,
                  description: "Reference site about Lorem Ipsum",
                  orders: 5,
                  onTap: () {},
                ),
                OrdersInfoCard(
                  title: "Completed",
                  image: AppImages.completed,
                  description: "Reference site about Lorem Ipsum",
                  orders: 2,
                  onTap: () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
