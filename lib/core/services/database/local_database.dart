import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mrwebbeast/app.dart';
import 'package:mrwebbeast/core/config/app_config.dart';
import 'package:mrwebbeast/core/constant/enums.dart';
import 'package:mrwebbeast/models/member/auth/member_data.dart';
import 'package:provider/provider.dart';

import '../../../controllers/dashboard/dashboard_controller.dart';
import '../../../models/auth_model/guest_data.dart';

class LocalDatabase extends ChangeNotifier {
  ///Hive Database Initialization....

  static Future initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GuestDataAdapter());
    Hive.registerAdapter(MemberDataAdapter());
    await Hive.openBox(AppConfig.databaseName);
  }

  ///Hive Database Box....
  Box database = Hive.box(AppConfig.databaseName);

  ///Access Local Database data...

  late String? deviceToken = database.get('deviceToken');

  late String? themeMode = database.get('themeMode');
  late double? latitude = database.get('latitude');
  late double? longitude = database.get('themeMode');

  late String? userRole = database.get('userRole');

  late GuestData? guest = database.get('guest');
  late MemberData? member = database.get('member');

  setDeviceToken(String? token) {
    deviceToken = token;
    database.put('deviceToken', token ?? '');
    notifyListeners();
  }

  setThemeMode({required ThemeMode mode}) {
    themeMode = mode.name;
    database.put('themeMode', themeMode ?? '');
    notifyListeners();
  }

  setLatLong(
    double? latitude,
    double? longitude,
  ) {
    latitude = latitude;
    longitude = longitude;
    database.put('latitude', latitude);
    database.put('longitude', longitude);
    notifyListeners();
  }

  Future clearDatabase() async {
    await database.clear().then((value) {
      guest = null;
      member = null;
      notifyListeners();
    });
  }

  _setUserRole(String? userRole) {
    if (userRole != null) {
      this.userRole = userRole;
      database.put('userRole', userRole ?? '');
      notifyListeners();
    }
  }

  Future saveGuestData({required GuestData? guest}) async {
    this.guest = guest;
    database.put('guest', guest);
    _setUserRole(guest?.role);
    debugPrint('user fullName ${guest?.firstName}');
    notifyListeners();
    BuildContext? context = MyApp.navigatorKey.currentContext;
    if (context != null) {
      context.read<DashboardController>().changeUserRole(role: UserRoles.guest.value);
    }
  }

  Future saveMemberData({required MemberData? member}) async {
    this.member = member;
    database.put('member', member);
    _setUserRole(member?.role);
    debugPrint('user fullName ${member?.role}');
    notifyListeners();
    BuildContext? context = MyApp.navigatorKey.currentContext;
    if (context != null) {
      context.read<DashboardController>().changeUserRole(role: UserRoles.member.value);
    }
  }
}
