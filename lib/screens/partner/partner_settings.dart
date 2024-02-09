import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/partner/partner_controller.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/functions.dart';
import 'package:gaas/screens/partner/fresh/offers/offers_screen.dart';
import 'package:gaas/screens/partner/setup/select_delivery_zone.dart';
import 'package:gaas/screens/partner/setup/select_order_types.dart';
import 'package:gaas/screens/partner/utils/partner_app_bar.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/partner/membership_controller.dart';
import '../../core/config/app_images.dart';
import '../../core/constant/shadows.dart';
import '../../core/enums/enums.dart';
import '../../core/services/database/local_database.dart';
import '../../models/partner/auth/partner_model.dart';
import '../../models/partner/membership/check_membership_model.dart';
import '../../models/partner/partner_live_status.dart';
import '../../route/route_paths.dart';
import '../../utils/widgets/image_view.dart';
import 'setup/select_timeslots.dart';
import 'signup/join_as_partner.dart';

class PartnerSettings extends StatefulWidget {
  const PartnerSettings({Key? key}) : super(key: key);

  @override
  State<PartnerSettings> createState() => _PartnerSettingsState();
}

class _PartnerSettingsState extends State<PartnerSettings> {
  LocalDatabase localDatabase = LocalDatabase();
  double imageRadius = 70;

  late ServiceType? type;

  PartnerData? partnerData;

  bool isAuthenticated = LocalDatabase().accessToken != null;
  bool isLive = false;

  Color statusColor() => isLive ? primaryColor : Colors.red;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      PartnerController partnerController = Provider.of<PartnerController>(context, listen: false);
      partnerController.checkPartnerLiveStatus(context: context);
      partnerLiveStatusData = partnerController.partnerLiveStatusData;
      // isLive = partnerLiveStatusData?.isLive == "Yes" ? true : false;
      // setState(() {})  ;
    });

    super.initState();
  }

  PartnerLiveStatusData? partnerLiveStatusData;
  Set<OrderTypes?>? partnerOrderTypes;
  CheckMembershipModel? checkMembership;

  @override
  Widget build(BuildContext context) {
    MembershipController membershipController = Provider.of<MembershipController>(context);
    partnerOrderTypes = membershipController.partnerOrderTypes;
    checkMembership = membershipController.checkMembership;
    PartnerController partnerController = Provider.of<PartnerController>(context);
    partnerData = partnerController.partnerData;
    type = partnerController.serviceType;
    partnerLiveStatusData = partnerController.partnerLiveStatusData;
    isLive = partnerLiveStatusData?.isLive == "Yes" ? true : false;
    return Scaffold(
      appBar: partnerAppBar(context: context, title: "${type?.value} Profile"),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: defaultBoxShadow(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            partnerData?.name ?? "",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (checkMembership?.data?.subscriptionTitle != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: Text(
                                "${checkMembership?.data?.subscriptionTitle} (${checkMembership?.data?.days ?? 0} Days)",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: Text(
                                type?.value ?? "",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          if (checkMembership?.expiredAt != null)
                            Text(
                              "Expire At :- ${checkMembership?.expiredAt}",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    ImageView(
                      height: imageRadius,
                      width: imageRadius,
                      borderRadiusValue: imageRadius,
                      networkImage: partnerData?.profilePhoto ?? "",
                      isAvatar: true,
                      fit: BoxFit.cover,
                      margin: const EdgeInsets.only(left: 16),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: defaultBoxShadow(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundColor: statusColor().withOpacity(0.2),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: statusColor(),
                    ),
                  ),
                  title: Text(
                    "${type?.value} Status",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    partnerLiveStatusData?.status ?? "",
                    style: TextStyle(color: statusColor()),
                  ),
                  trailing: CupertinoSwitch(
                    value: isLive,
                    activeColor: primaryColor,
                    onChanged: (val) {
                      PartnerController partnerController =
                          Provider.of<PartnerController>(context, listen: false);
                      partnerController
                          .updatePartnerLiveStatus(context: context, status: val)
                          .then((value) {});
                    },
                  ),
                ),
              ),
            ],
          ),
          GridView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: deviceSpecificValue(
                context: context,
                device: 1.2,
                tablet: 2,
              ).toDouble(),
            ),
            children: [
              // profileGridButton(
              //   icon: Icons.person,
              //   text: "Edit Profile",
              //   onClick: () {
              //     context.pushNamed(
              //       Routs.joinAsPartner,
              //       extra: JoinAsPartner(editMode: true, type: type),
              //     );
              //   },
              // ),
              if (type != ServiceType.serviceProvider)
                profileGridButton(
                  image: AppImages.offerIcon,
                  text: "My Offers",
                  onClick: () {
                    context.pushNamed(
                      Routs.partnerOffers,
                      extra: const PartnerOffersScreen(),
                    );
                  },
                ),
              if (type != ServiceType.serviceProvider)
                profileGridButton(
                  image: AppImages.offerIcon,
                  text: "Add Offer",
                  onClick: () {
                    context.pushNamed(Routs.addOffer);
                  },
                ),
              if (type == ServiceType.serviceProvider)
                profileGridButton(
                  icon: Icons.category_outlined,
                  text: "Manage Services",
                  onClick: () {
                    context.pushNamed(Routs.manageServices);
                  },
                ),
              if (type != ServiceType.serviceProvider)
                profileGridButton(
                  icon: Icons.category_outlined,
                  text: "Edit Order Types",
                  onClick: () {
                    context.pushNamed(Routs.selectOrderTypes,
                        extra: SelectOrderTypes(
                          editMode: true,
                          type: type,
                        ));
                  },
                ),
              if (type != ServiceType.serviceProvider)
                profileGridButton(
                  icon: Icons.timer_sharp,
                  text: "Edit Timeslots",
                  onClick: () {
                    context.pushNamed(Routs.selectTimeSlots,
                        extra: SelectTimeSlots(
                          editMode: true,
                          type: type,
                          selectedOrderTypes: membershipController.partnerOrderTypes,
                        ));
                  },
                ),
              if (partnerOrderTypes?.contains(OrderTypes.delivery) == true &&
                  type != ServiceType.serviceProvider)
                profileGridButton(
                  icon: Icons.location_pin,
                  text: "Edit Delivery Zones",
                  onClick: () {
                    context.pushNamed(Routs.selectDeliveryZones,
                        extra: SelectDeliveryZones(
                          editMode: true,
                          type: type,
                        ));
                  },
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget profileGridButton({
    String? image,
    IconData? icon,
    required String text,
    required GestureTapCallback onClick,
  }) {
    Size size = MediaQuery.of(context).size;
    double imageSize = deviceSpecificValue(
      context: context,
      device: 32,
      tablet: 48,
    ).toDouble();
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onClick,
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: defaultBoxShadow(),
          border: Border.all(color: Colors.grey.shade100),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Icon(
                    icon,
                    size: imageSize,
                    color: primaryColor,
                  )
                : ImageView(
                    height: imageSize,
                    width: imageSize,
                    fit: BoxFit.cover,
                    borderRadiusValue: 0,
                    color: primaryColor,
                    margin: EdgeInsets.zero,
                    assetImage: image,
                    onTap: null,
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 14),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.grey.shade900,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
