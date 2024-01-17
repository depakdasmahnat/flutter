import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';

import '../../core/config/app_assets.dart';
import '../../core/constant/enums.dart';
import '../../models/dashboard/dashboard_data.dart';
import '../../screens/guest/guestProfile/guest_profile.dart';
import '../../screens/guest/home/home_screen.dart';

import '../../screens/guest/product/guest_product.dart';
import '../../screens/guest/resource&Demo/mainresource.dart';
import '../../utils/widgets/no_data_found.dart';

class DashboardController extends ChangeNotifier {
  /// 1) Dashboard Index
  final int _defaultDashBoardIndex = 0;

  late int _dashBoardIndex = _defaultDashBoardIndex;

  int get dashBoardIndex => _dashBoardIndex;

  changeDashBoardIndex({int? index}) {
    _dashBoardIndex = index ?? _dashBoardIndex;

    notifyListeners();
  }

  ///2) Dashboard User Role
  UserRoles defaultUserRole = UserRoles.guest;
  late UserRoles _userRole = defaultUserRole;

  UserRoles get userRole => _userRole;

  changeUserRole({UserRoles? role}) {
    _userRole = role ?? defaultUserRole;

    notifyListeners();
  }

  changeUserRoleFromString({String? role}) {
    List<UserRoles> userRoles = UserRoles.values.where((element) => element.value == role).toList();
    if (userRoles.haveData) {
      _userRole = userRoles.first;
      notifyListeners();
    }
  }

  /// 3) Dashboard Index
  late List widgets = userRole == UserRoles.guest ? _guestWidgets : _membersWidgets;

  // Guest Widgets
  final List<DashboardData> _guestWidgets = [
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
      title: 'Profile',
      activeImage: AppAssets.userIcon,
      inActiveImage: AppAssets.userIcon,
      widget: const GuestProfile(),
    ),
    DashboardData(
      title: 'More',
      activeImage: AppAssets.more,
      inActiveImage: AppAssets.more,
      widget: const Mainresource(),
    ),
  ];

  // Member Widgets
  final List<DashboardData> _membersWidgets = [
    DashboardData(
      title: 'Home',
      activeImage: AppAssets.homeFilledIcon,
      inActiveImage: AppAssets.homeIcon,
      widget: const HomeScreen(),
    ),
    DashboardData(
      title: 'Network',
      activeImage: AppAssets.networkFilledIcon,
      inActiveImage: AppAssets.networkIcon,
      widget: const NoDataFound(),
    ),
    DashboardData(
      activeImage: AppAssets.addIcon,
      inActiveImage: AppAssets.addIcon,
      widget: const NoDataFound(),
    ),
    DashboardData(
      title: 'Leads',
      activeImage: AppAssets.leadsFilledIcon,
      inActiveImage: AppAssets.leadsIcon,
      widget: const NoDataFound(),
    ),
    DashboardData(
      title: 'Members',
      activeImage: AppAssets.membersFilledIcon,
      inActiveImage: AppAssets.membersIcon,
      widget: const NoDataFound(),
    ),
  ];
}
