import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mrwebbeast/core/constant/colors.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/enums.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:provider/provider.dart';

import '../../../utils/widgets/image_view.dart';
import '../../controllers/dashboard/dashboard_controller.dart';
import '../../core/config/app_assets.dart';
import '../../core/route/route_paths.dart';
import '../../core/services/database/local_database.dart';
import '../../models/auth_model/guest_data.dart';
import '../../models/dashboard/dashboard_data.dart';
import '../../utils/widgets/gradient_text.dart';
import '../../utils/widgets/widgets.dart';

import 'drawer.dart';
import 'more_menu.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key, this.dashBoardIndex, this.userRole});

  final int? dashBoardIndex;
  final String? userRole;

  @override
  DashBoardState createState() => DashBoardState();
}

class DashBoardState extends State<DashBoard> {
  late int dashBoardIndex = widget.dashBoardIndex ?? 0;
  late String? userRole = widget.userRole ?? UserRoles.guest.value;
  DateTime currentDate = DateTime.now();

  late String formattedDate = DateFormat(dayFormat).format(currentDate);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DashboardController>().changeDashBoardIndex(index: dashBoardIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    LocalDatabase localDatabase = Provider.of<LocalDatabase>(context);
    GuestData? guest = context.read<LocalDatabase>().guest;

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
                              width: size.width * 0.5,
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
                        height: 24,
                        width: 24,
                        borderRadiusValue: 0,
                        color: Colors.white,
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        fit: BoxFit.contain,
                        assetImage: AppAssets.notificationsIcon,
                        onTap: () {
                          context.pushNamed(Routs.guestNotification);
                        },
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageView(
                            height: 36,
                            width: 36,
                            border: Border.all(color: Colors.grey),
                            borderRadiusValue: 50,
                            isAvatar: true,
                            margin: const EdgeInsets.only(left: 8, right: 8),
                            fit: BoxFit.cover,
                            networkImage: '${localDatabase.member?.profilePhoto}',
                            onTap: () {
                              context.pushNamed(Routs.memberProfile,);
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                : null,
            body: Builder(
              builder: (BuildContext context) {
                return controller.widgets.elementAt(dashBoardIndex).widget;
              },
            ),
            bottomSheet: GestureDetector(
              onTap: () {
                if (controller.showMoreMenuPopUp) {
                  context.read<DashboardController>().changeDashBoardIndex(index: 2);
                }
              },
              child: Container(
                decoration:
                    controller.showMoreMenuPopUp ? BoxDecoration(color: Colors.grey.withOpacity(0.1)) : null,
                child: Column(
                  mainAxisSize: controller.showMoreMenuPopUp ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (controller.showMoreMenuPopUp) DashboardMoreMenu(),
                    GradientButton(
                      margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                      borderRadius: 50,
                      blur: 15,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      backgroundGradient:guest?.role=='Guest'?null: inActiveGradientTransparent,
                      backgroundColor:guest?.role=='Guest'? Colors.grey.withOpacity(0.8):Colors.white.withOpacity(0.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          controller.widgets.length,
                          (index) {
                            var data = controller.widgets.elementAt(index);
                            return CustomBottomNavBar(
                              index: index,
                              dashBoardIndex: dashBoardIndex,
                              data: data,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int index;
  final int dashBoardIndex;
  final double? height;
  final double? width;
  final bool? alwaysShowLabel;
  final DashboardData data;
  final GestureTapCallback? onTap;
  final EdgeInsets? imageMargin;

  const CustomBottomNavBar({
    super.key,
    required this.index,
    required this.dashBoardIndex,
    required this.data,
    this.height,
    this.width,
    this.alwaysShowLabel = false,
    this.onTap,
    this.imageMargin,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    bool selected = dashBoardIndex == index;
    return GestureDetector(
      onTap: onTap ??
          () {
            context.read<DashboardController>().changeDashBoardIndex(index: index);
          },
      child: GradientButton(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        borderRadius: 50,
        blur: 0,
        height: data.title == null ? 55 : null,
        width: data.title == null ? 55 : null,
        backgroundGradient: data.title == null ? primaryGradient : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ImageView(
              height: size.height*0.03,
              width: size.height*0.03,
              // height: 24,
              // width: 24,
              borderRadiusValue: 0,
              color: data.title == null ? Colors.black : (selected ? primaryColor : Colors.white),
              margin: imageMargin ?? EdgeInsets.zero,
              fit: BoxFit.contain,
              assetImage: selected ? data.activeImage : data.inActiveImage,
            ),
            if (data.title != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${data.title}'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: (selected ? primaryColor : Colors.white),
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              )
          ],
        ),
      ),
    );
  }
}
