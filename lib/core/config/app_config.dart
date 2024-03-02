import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../services/database/local_database.dart';

class AppConfig {
  ///APP Configurations..
  static const String name = 'GTP';
  static const String version = '1.0';

  static const String packageName = 'app.gtp.com';

  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=$packageName';
  static const String appStoreUrl = 'https://apps.apple.com/us/app/emuvv/id6462873844';
  static const String deeplinkUrl = 'https://mrwebbeast.page.link/downlaod';

  static String apkLink() {
    String url;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      url = appStoreUrl;
    } else {
      url = playStoreUrl;
    }
    return url;
  }

  static const String fcmServerKey = '';
  static const String mapAddressesApiKey = 'AIzaSyAaq-CLNOFfMMtll9c3LV2wpFTITExbud4';
  static const String contactEmail = 'mrwebbeast@gmail.com';
  static const String contactNumber = '+91 7559721016';
  static const String shareApp = '';

  ///Notification Channel Id...
  static const String chanelName = 'GTP';

  ///Local Database Configurations..
  static const String databaseName = 'database';

  static generateDeviceToken() async {
    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken(vapidKey: fcmServerKey);
      if (deviceToken != null) {
        LocalDatabase().setDeviceToken(deviceToken);
      }

      debugPrint('Device Token is $deviceToken');
    } catch (e, s) {
      debugPrint('Device Token Not Found Error');
      debugPrint('Error is $e & Stack is $s');
    }
  }
}
