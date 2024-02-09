import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/partner/partner_controller.dart';
import 'package:gaas/core/config/app_config.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/screens/partner/utils/membership_card.dart';
import 'package:provider/provider.dart';

import '../../../controllers/payments/stripe_controller.dart';
import '../../../core/constant/colors.dart';
import '../../../models/partner/dummy_membership_data.dart';
import '../../../models/partner/membership/subscriptions_model.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/data_widget_builder.dart';

class PartnerMembership extends StatefulWidget {
  const PartnerMembership(
      {Key? key, required this.type, required this.route, this.showLogoutBtn, this.showBackBtn})
      : super(key: key);
  final String? route;
  final ServiceType? type;
  final bool? showLogoutBtn;
  final bool? showBackBtn;

  @override
  State<PartnerMembership> createState() => _PartnerMembershipState();
}

class _PartnerMembershipState extends State<PartnerMembership> {
  late bool? showLogoutBtn = widget.showLogoutBtn ?? false;
  late bool? showBackBtn = widget.showBackBtn ?? false;
  late String? route = widget.route;
  late ServiceType? type = widget.type;

  List<PerksData> perks = [
    PerksData(
        title: "Free Delivery",
        description: "Reference site about Lorem Ipsum, giving information on its origins",
        image: AppImages.fastDelivery),
    PerksData(
        title: "Up to 60% extra off",
        description: "Reference site about Lorem Ipsum, giving information on its origins",
        image: AppImages.tag),
    PerksData(
        title: "VIP access during rush hours",
        description:
            "Reference site about Lorem Ipsum, giving information on its originsReference site about Lorem Ipsum, giving information on its origins",
        image: AppImages.vip),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchSubscriptions();
    });

    super.initState();
  }

  SubscriptionsModel? subscriptionsModel;
  List<SubscriptionsData>? subscriptionsData;
  TextEditingController couponCodeCtrl = TextEditingController();

  fetchSubscriptions() {
    FocusScope.of(context).unfocus();
    PartnerController controller = Provider.of<PartnerController>(context, listen: false);
    controller.fetchSubscriptions(context: context, couponCode: couponCodeCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    PartnerController controller = Provider.of<PartnerController>(context);
    subscriptionsModel = controller.subscriptionsModel;
    subscriptionsData = controller.subscriptionsData;
    return Scaffold(
      appBar: AppBar(
        title: Text("Gaas ${type?.value}"),
      ),
      body: DataWidgetBuilder(
        isLoading: controller.loadingSubscriptions,
        haveData: subscriptionsData.haveData,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: subscriptionsData?.length,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          itemBuilder: (context, index) {
            var data = subscriptionsData?.elementAt(index);
            return MembershipCard(
              showMore: index == 0 ? true : false,
              data: data,
              route: route,
              type: type,
              perks: perks,
            );
          },
        ),
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.white,
            child: CustomTextField(
              controller: couponCodeCtrl,
              autofocus: false,
              prefixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: primaryColor.withOpacity(0.3),
                    child: const Icon(
                      CupertinoIcons.gift_fill,
                      size: 16,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              onChanged: (val) {
                setState(() {});
              },
              suffixIcon: subscriptionsModel?.isCouponApplied == true
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          couponCodeCtrl.clear();
                        });
                        fetchSubscriptions();
                      },
                      icon: const Icon(
                        CupertinoIcons.multiply_circle_fill,
                        color: secondaryColor,
                      ),
                    )
                  : TextButton(
                      onPressed: () {
                        fetchSubscriptions();
                      },
                      child: const Text("Apply"),
                    ),
              labelText: "Coupon Code ",
              hintText: "Coupon Code ",
              margin: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 36),
            ),
          ),
        ],
      ),
    );
  }
}
