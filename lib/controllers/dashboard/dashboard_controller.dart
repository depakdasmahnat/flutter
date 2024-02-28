import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/services/database/local_database.dart';

import '../../core/config/app_assets.dart';
import '../../core/constant/enums.dart';
import '../../models/dashboard/dashboard_data.dart';
import '../../screens/guest/guestProfile/guest_profile.dart';
import '../../screens/guest/home/home_screen.dart';
import '../../screens/guest/product/guest_product.dart';
import '../../screens/guest/resource&Demo/mainresource.dart';
import '../../screens/member/home/member_home_screen.dart';
import '../../screens/member/lead/lead.dart';
import '../../screens/member/members/member_screen.dart';
import '../../screens/member/network/network_screen.dart';
import '../../utils/widgets/no_data_found.dart';

class DashboardController extends ChangeNotifier {
  /// 1) Dashboard Index
  final int _defaultDashBoardIndex = 0;
  late int _dashBoardIndex = _defaultDashBoardIndex;

  int get dashBoardIndex => _dashBoardIndex;

  changeDashBoardIndex({int? index}) {
    if (userRole == UserRoles.member.value && index == 2) {
      showMoreMenuPopUp = !showMoreMenuPopUp;
    } else {
      showMoreMenuPopUp = false;
      _dashBoardIndex = index ?? _dashBoardIndex;
    }

    notifyListeners();
  }

  bool showMoreMenuPopUp = false;

  ///2) Dashboard User Role

  String? _userRole = LocalDatabase().userRole;

  String? get userRole => _userRole;

  changeUserRole({String? role}) {
    if (role != null) {
      _userRole = role;

      widgets = _userRole == UserRoles.guest.value ? guestWidgets : membersWidgets;
      _dashBoardIndex = 0;
      notifyListeners();
    }
  }

  /// 3) Dashboard Index

  late List widgets = userRole == UserRoles.guest.value ? guestWidgets : membersWidgets;

  // Guest Widgets
  final List<DashboardData> guestWidgets = [
    DashboardData(
      title: 'Feed',
      activeImage: AppAssets.guestHomeIcon,
      inActiveImage: AppAssets.guestHomeIcon,
      widget: const HomeScreen(),
    ),
    DashboardData(
      title: 'Products',
      activeImage: AppAssets.productIcon,
      inActiveImage: AppAssets.productIcon,
      widget: const GuestPoduct(),
    ),
    DashboardData(
      title: 'Library',
      activeImage: AppAssets.more,
      inActiveImage: AppAssets.more,
      widget: const MainResource(),
    ),
    DashboardData(
      title: 'Profile',
      activeImage: AppAssets.userIcon,
      inActiveImage: AppAssets.userIcon,
      widget: const GuestProfile(),
    ),

  ];

  // Member Widgets
  final List<DashboardData> membersWidgets = [
    DashboardData(
      title: 'Home',
      activeImage: AppAssets.homeFilledIcon,
      inActiveImage: AppAssets.homeIcon,
      widget: const MemberHomeScreen(),
    ),
    DashboardData(
      title: 'Network',
      activeImage: AppAssets.networkFilledIcon,
      inActiveImage: AppAssets.networkIcon,
      widget: const NetworkScreen(),
    ),
    DashboardData(
      activeImage: AppAssets.addIcon,
      inActiveImage: AppAssets.addIcon,
      widget: const NoDataFound(),
    ),
    DashboardData(
      title: 'LMS',
      activeImage: AppAssets.leadsFilledIcon,
      inActiveImage: AppAssets.leadsIcon,
      widget: const Lead(),
    ),
    DashboardData(
      title: 'Partners',
      activeImage: AppAssets.membersFilledIcon,
      inActiveImage: AppAssets.membersIcon,
      widget: const MemberScreen(),
    ),
  ];
}
