import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/constant.dart';

import 'package:mrwebbeast/core/constant/enums.dart';

import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';

import 'package:provider/provider.dart';

import '../../../utils/widgets/image_view.dart';
import '../../controllers/dashboard/dashboard_controller.dart';

import '../../core/services/database/local_database.dart';

import '../../models/dashboard/dashboard_data.dart';
import '../../utils/widgets/widgets.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key, this.dashBoardIndex, this.userRole});

  final int? dashBoardIndex;
  final UserRoles? userRole;

  @override
  DashBoardState createState() => DashBoardState();
}

class DashBoardState extends State<DashBoard> {
  late int dashBoardIndex = widget.dashBoardIndex ?? 0;
  late UserRoles userRole = widget.userRole ?? UserRoles.guest;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DashboardController>().changeDashBoardIndex(index: dashBoardIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('deviceToken ${LocalDatabase().deviceToken}');
    // DashboardController dashboardController = Provider.of<DashboardController>(context);
    // Size size = MediaQuery.sizeOf(context);
    return Consumer<DashboardController>(
      builder: (context, controller, child) {
        dashBoardIndex = controller.dashBoardIndex;
        userRole = controller.userRole;
        return WillPopScope(
          onWillPop: onAppExit,
          child: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return controller.widgets.elementAt(dashBoardIndex).widget;
              },
            ),
            bottomSheet: GradientButton(
              margin: const EdgeInsets.only(left: 24, right: 24, bottom: kPadding),
              borderRadius: 50,
              blur: 15,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              // backgroundGradient: inActiveGradientTransparent,
              backgroundColor: Colors.white.withOpacity(0.15),
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
          ),
        );
      },
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int index;
  final int dashBoardIndex;
  final DashboardData data;

  const CustomBottomNavBar({
    super.key,
    required this.index,
    required this.dashBoardIndex,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    bool selected = dashBoardIndex == index;
    return GestureDetector(
      onTap: () {
        context.read<DashboardController>().changeDashBoardIndex(index: index);
      },
      child: GradientButton(
        padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 8),
        borderRadius: 50,
        blur: 10,
        height: 50,
        width: selected == true ? null : 50,
        backgroundGradient: selected == true ? primaryGradient : null,
        backgroundColor: selected == true ? null : Colors.grey.withOpacity(0.3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ImageView(
              height: 18,
              width: 18,
              borderRadiusValue: 0,
              color: selected ? Colors.black : Colors.white,
              margin: EdgeInsets.zero,
              fit: BoxFit.contain,
              assetImage: selected ? data.activeImage : data.inActiveImage,
            ),
            if (selected == true && data.title != null)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  '${data.title}',
                  style: TextStyle(
                    fontSize: 12,
                    color: selected ? Colors.black : Colors.white,
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
