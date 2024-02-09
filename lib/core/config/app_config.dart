import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../services/database/local_database.dart';

class AppConfig {
  ///APP Configurations..

  static const String apkName = "GaaS";
  static const String apkVersion = "1.0";

  static const String androidPackageName = "gaas.us.com";
  static const String iOSBundleId = "gaas.us.com";
  static const String appStoreId = "6467422541";

  static String apkLink() {
    String url;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      url = "https://apps.apple.com/us/app/gaas/id6467422541";
    } else {
      url = "https://play.google.com/store/apps/details?id=$androidPackageName";
    }
    return url;
  }

  static const String fcmServerKey =
      "AAAAEUxy0c0:APA91bE-z9e6DQFYjVIS02TteLRUZeG8fRDs8vsbE41hBT3-dgfd23p7BLz9L5ZYYDcuY2DJBSljuWSFyDLQ9-mEEECsdc0AspG9jhj6oMVWsGniQEkeQa2axcyQqGZs2OraYCYM9vJZ";
  static const String countryCode = "+1";
  static const String currency = "USD";
  static const String chanelName = "GaaS";
  static const String mapAddressesApiKey = "AIzaSyAaq-CLNOFfMMtll9c3LV2wpFTITExbud4";

  ///Stripe Configurations..
  static const String stripePublishableKey =
      "pk_test_51NpjiYL7ptlgNox4YVUI2L4siqqdKwpDqdW0JMNf0I1jJaIcet77yJr0OixRVKEPpJfPWU20BvmXWSY2Jam3HfIk00bWP2UXVG";

  ///Local Database Configurations..
  static const String databaseName = "database";

  ///API Configurations..

  static const domainName = "https://api.gaas.proapp.in";
  static const String version = "/api/v1";
  static const String baseUrl = "$domainName$version";
  static const String mapsBaseUrl = "https://maps.googleapis.com/maps/api";
  static const String privacyPolicyUrl = "$baseUrl/privacy_policy";
  static const String termsAndConditionsUrl = "$baseUrl/terms_and_conditions";
  static const String aboutUsUrl = "$baseUrl/about_us";
  static const String helpUrl = "$baseUrl/help";
  static const String contactUsUrl = "$baseUrl/contact_us";

  static const String supportUrl = "$baseUrl/support";
  static const String agreementUrl = "$baseUrl/agreement";
  static const String refundPolicyUrl = "$baseUrl/refund_policy";
  static const String cookiesPolicyUrl = "$baseUrl/cookies_policy";

  static generateDeviceToken() async {
    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken(vapidKey: fcmServerKey);
      if (deviceToken != null) {
        LocalDatabase().setDeviceToken(deviceToken);
      }
      debugPrint("Device Token is $deviceToken");
    } catch (e) {
      debugPrint("Device Token Not Found Error");
      debugPrint("Error is $e");
    }
  }
}
