import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/utils/widgets/custom_bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../core/config/app_config.dart';
import '../../core/constant/shadows.dart';
import '../../core/services/database/local_database.dart';
import '../../models/partner/partner_status_model.dart';
import '../../route/route_paths.dart';
import '../../utils/widgets/image_view.dart';
import '../../utils/widgets/web_view_screen.dart';
import '../camera/capture_image.dart';
import '../partner/service/leads/leads_screen.dart';
import '../partner/signup/select_partner_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  LocalDatabase localDatabase = LocalDatabase();
  double imageRadius = 70;

  late String? name = localDatabase.name;
  late String? mobile = localDatabase.mobile;
  late String? profilePhoto = localDatabase.profilePhoto;
  late num gaasCoin = localDatabase.balanceCoins ?? 0;

  late bool? isFreshProducer = localDatabase.isFreshProducer;
  late bool? isNursery = localDatabase.isNursery;
  late bool? isServiceProvider = localDatabase.isServiceProvider;

  late bool? showJoinPartner =
      ((isFreshProducer == true) || (isNursery == true) || (isServiceProvider == true));
  PartnerStatusModel? partnerRequestData;

  bool isAuthenticated = LocalDatabase().accessToken != null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthControllers authControllers = Provider.of<AuthControllers>(context);
    partnerRequestData = authControllers.partnerStatusData;
    isFreshProducer = authControllers.isFreshProducer;
    isNursery = authControllers.isNursery;
    isServiceProvider = authControllers.isServiceProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          if (isAuthenticated)
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
                  child: InkWell(
                    onTap: () {
                      context.push(Routs.editProfile);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name ?? "",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  "+1  ${mobile ?? ""}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ImageView(
                          height: imageRadius,
                          width: imageRadius,
                          borderRadiusValue: imageRadius,
                          networkImage: profilePhoto,
                          assetImage: profilePhoto == null ? AppImages.avatarImage : null,
                          fit: BoxFit.cover,
                          margin: const EdgeInsets.only(left: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                if (partnerRequestData?.showSection == true)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      CustomBottomSheet.show(
                        context: context,
                        body: const SelectPartnerService(requestedMode: true),
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
                        leading: const CircleAvatar(
                          radius: 20,
                          backgroundColor: primaryColor,
                          child: Center(
                            child: Icon(
                              CupertinoIcons.person_add,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        title: Text(
                          "${partnerRequestData?.sectionMsg?.title}",
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        subtitle: Text(
                          "${partnerRequestData?.sectionMsg?.description}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
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
                InkWell(
                  onTap: () {
                    context.pushNamed(Routs.coinTransactions);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: defaultBoxShadow(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const ImageView(
                        height: 45,
                        width: 45,
                        borderRadiusValue: 40,
                        assetImage: AppImages.dollar,
                        fit: BoxFit.cover,
                        margin: EdgeInsets.zero,
                      ),
                      title: Text(
                        "${AppConfig.apkName} Coin",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "\$$gaasCoin",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      trailing: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey.shade300.withOpacity(0.3),
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.grey.shade700,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: defaultBoxShadow(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                if (isAuthenticated)
                  profileButton(
                    icon: Icons.person_outline_rounded,
                    text: "Edit Profile",
                    onClick: () {
                      context.push(Routs.editProfile);
                    },
                    showDivider: true,
                  ),
                if (isAuthenticated)
                  profileButton(
                    icon: Icons.text_rotation_angleup_rounded,
                    text: "Enquires",
                    onClick: () {
                      context.pushNamed(Routs.leads, extra: const LeadsScreen(partnerLeads: false));
                    },
                    showDivider: true,
                  ),
                // if (isAuthenticated)
                //   profileButton(
                //     icon: Icons.attach_money_rounded,
                //     text: "Transactions",
                //     onClick: () {
                //       context.pushNamed(Routs.coinTransactions);
                //     },
                //     showDivider: true,
                //   ),
                if (isAuthenticated)
                  profileButton(
                    icon: CupertinoIcons.heart,
                    text: "Favourite",
                    onClick: () {
                      context.push(Routs.wishlist);
                    },
                    showDivider: true,
                  ),

                profileButton(
                  icon: Icons.category_outlined,
                  text: "Preference",
                  onClick: () {
                    context.pushNamed(Routs.permissions);
                  },
                  showDivider: true,
                ),

                profileButton(
                  icon: Icons.info_outline,
                  text: "Report & Feedback",
                  onClick: () {
                    context.pushNamed(Routs.report);
                  },
                  showDivider: true,
                ),
                profileButton(
                  image: AppImages.appIcon,
                  text: "About Us",
                  onClick: () {
                    context.pushNamed(Routs.webView,
                        extra: const WebViewScreen(
                          title: "About US",
                          url: AppConfig.aboutUsUrl,
                        ));
                  },
                  showDivider: true,
                ),
                // profileButton(
                //   icon: Icons.help_outline,
                //   text: "Help",
                //   onClick: () {
                //     context.pushNamed(Routs.webView,
                //         extra: const WebViewScreen(
                //           title: "Help",
                //           url: AppConfig.helpUrl,
                //         ));
                //   },
                // ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: defaultBoxShadow(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                profileButton(
                  icon: Icons.policy_outlined,
                  text: "Privacy Policy",
                  onClick: () {
                    context.pushNamed(Routs.webView,
                        extra: const WebViewScreen(
                          title: "Privacy Policy",
                          url: AppConfig.privacyPolicyUrl,
                        ));
                  },
                  showDivider: true,
                ),
                profileButton(
                  icon: Icons.handshake_rounded,
                  text: "End-User License Agreement",
                  onClick: () {
                    context.pushNamed(Routs.webView,
                        extra: const WebViewScreen(
                          title: "End-User License Agreement",
                          url: AppConfig.agreementUrl,
                        ));
                  },
                  showDivider: true,
                ),
                profileButton(
                  icon: Icons.monetization_on_outlined,
                  text: "Return and Refund Policy",
                  onClick: () {
                    context.pushNamed(Routs.webView,
                        extra: const WebViewScreen(
                          title: "Return and Refund Policy",
                          url: AppConfig.refundPolicyUrl,
                        ));
                  },
                  showDivider: true,
                ),
                profileButton(
                  icon: Icons.cookie_outlined,
                  text: "Cookies Policy",
                  onClick: () {
                    context.pushNamed(Routs.webView,
                        extra: const WebViewScreen(
                          title: "Cookies Policy",
                          url: AppConfig.cookiesPolicyUrl,
                        ));
                  },
                  showDivider: true,
                ),
              ],
            ),
          ),
          if (localDatabase.accessToken != null)
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: defaultBoxShadow(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: profileButton(
                icon: Icons.settings,
                text: "Settings",
                onClick: () {
                  context.pushNamed(Routs.accountSettings);
                },
                showDivider: true,
              ),
            )
          else
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: defaultBoxShadow(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: profileButton(
                icon: Icons.login,
                text: "Sign In",
                onClick: () {
                  LocalDatabase().database.clear().then((value) {
                    context.read<DashboardController>().setDashBoardIndex(index: 0, context: context);
                    context.pushReplacement(Routs.getStarted);
                  });
                },
                showDivider: true,
              ),
            ),
        ],
      ),
    );
  }

  Widget profileButton({
    String? image,
    IconData? icon,
    required String text,
    bool? showDivider = true,
    double? dividerThickness,
    double? dividerPadding,
    required GestureTapCallback onClick,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onClick,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    icon != null
                        ? Icon(
                            icon,
                            size: 20,
                            color: primaryColor,
                          )
                        : ImageView(
                            height: 20,
                            width: 20,
                            fit: BoxFit.cover,
                            borderRadiusValue: 0,
                            color: primaryColor,
                            margin: EdgeInsets.zero,
                            assetImage: image,
                            onTap: null,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: Colors.grey.shade900,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: primaryColor,
                  size: 16,
                )
              ],
            ),
            if (showDivider == true)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Divider(
                  height: 0,
                  color: Colors.grey.shade300,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
