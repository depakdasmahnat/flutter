import 'package:app_settings/app_settings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_config.dart';
import '../../core/constant/colors.dart';
import '../../core/functions.dart';
import '../../main.dart';
import '../../route/route_paths.dart';
import '../dashboard_controller.dart';

class NotificationController with ChangeNotifier {
  /// 1) Call To Initialize Awesome Notification Plugin...
  static Future initialize() async {
    await AwesomeNotifications().initialize(
      "resource://drawable/ic_launcher",
      [
        NotificationChannel(
          channelKey: AppConfig.chanelName,
          channelName: AppConfig.apkName,
          channelDescription: '${AppConfig.apkName} Notifications',
          defaultColor: primaryColor,
          ledColor: Colors.white,
          playSound: true,
          enableLights: true,
          channelShowBadge: true,
          criticalAlerts: true,
          importance: NotificationImportance.Max,
          enableVibration: true,
        ),
      ],
      debug: true,
    );
  }

  static Future<void> requestNotificationPermission() async {
    // Check the current status of notification permission
    PermissionStatus status = await Permission.notification.status;

    // If permission is already granted, return
    if (status.isGranted) {
      return;
    } else {
      status = await Permission.notification.request();
    }

    debugPrint("Notification Permission Status : $status... from requestNotificationPermission");
    // If permission is not granted, request it

    // You can handle different permission statuses here if needed
    if (status.isDenied) {
      // The user has denied notification permission
      // You may display a message or prompt the user to manually enable it in settings
    } else if (status.isPermanentlyDenied) {
      // The user has permanently denied notification permission
      // You may display a message and guide the user to app settings to enable it manually
    }
  }

  ///2)Call To Initialize Firebase Notification Handling...
  static Future getInitialMessage({required BuildContext context}) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        )
        .then((value) => debugPrint("setForegroundNotificationPresentationOptions"));

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    debugPrint("FirebaseMessaging.instance.getInitialMessage");
    RemoteMessage? message = await messaging.getInitialMessage();

    if (message != null) {
      debugPrint("FirebaseMessaging getInitialMessage");
      if (defaultTargetPlatform == TargetPlatform.android) {
        // showFirebaseNotification(message: message);
      }

      Map<String, String?>? data;
      try {
        data = message.data.cast<String, String?>();
      } catch (e, s) {
        debugPrint("Error $e & $s");
      }
      debugPrint("FirebaseMessaging data $data");
      if (message.notification != null) {
        redirectToScreen(payload: data);
      }
    }

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint("Notification Permission Status : ${settings.authorizationStatus}");
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  static Future onMessageOpenedApp({required BuildContext context}) async {
    return FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        debugPrint("FirebaseMessaging.onMessageOpenedApp.listen");
        debugPrint("FirebaseMessaging message $message");
        debugPrint("FirebaseMessaging notification ${message.notification}");
        Map<String, String?>? data;
        try {
          data = message.data.cast<String, String?>();
        } catch (e, s) {
          debugPrint("Error $e & $s");
        }
        debugPrint("FirebaseMessaging data $data");
        if (message.notification != null) {
          redirectToScreen(payload: data);
        }
      },
    );
  }

  static onMessage({required BuildContext context}) async {
    FirebaseMessaging.onMessage.listen(
      (message) async {
        debugPrint("FirebaseMessaging.onMessage.listen");
        if (defaultTargetPlatform == TargetPlatform.android) {
          showFirebaseNotification(message: message);
        }
      },
    );
  }

  static Future onBackgroundMessage({required BuildContext context}) async {
    FirebaseMessaging.onBackgroundMessage(firebaseBGHandler);
  }

  static Future firebaseBGHandler(RemoteMessage message) async {
    debugPrint("FirebaseMessaging onBackgroundMessage");
    Map<String, String?>? data;
    try {
      data = message.data.cast<String, String?>();
    } catch (e, s) {
      debugPrint("Error $e & $s");
    }
    debugPrint("FirebaseMessaging data $data");
    if (message.notification != null) {
      redirectToScreen(payload: data);
    }
    // showFirebaseNotification(message: message);
  }

  static Future setFirebaseMessagingListeners({required BuildContext context})async {
    getInitialMessage(context: context);
    onMessage(context: context);
    onMessageOpenedApp(context: context);
    onBackgroundMessage(context: context);
  }

  ///4) Start Notification Services after Setting Listener...
  static Future startServices({required BuildContext context}) async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        requestNotificationPermission();

        // AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  bool? haveNotificationPermission;

  Future<bool?> manageNotificationPermission({
    required BuildContext context,
    bool removePermission = false,
    bool forceRequest = false,
    bool checkOnly = false,
  }) async {
    if (!removePermission) {
      await AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
        haveNotificationPermission = isAllowed;
        notifyListeners();
        if (!isAllowed) {
          debugPrint("Checking AwesomeNotifications isAllowed $isAllowed....");
          if (forceRequest) {
            haveNotificationPermission = await AwesomeNotifications().requestPermissionToSendNotifications();
            notifyListeners();
          }
        }
      });
    } else {
      if (context.mounted) {
        showConfirmationDialog(
          context: context,
          title: "Remove Notification Access !",
          color: Colors.red,
          description:
              "Are you sure you want to remove notification permission. you will not receive important updates",
          proceedButton: TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (defaultTargetPlatform == TargetPlatform.android) {
                AppSettings.openAppSettings(type: AppSettingsType.notification);
              } else {
                openAppSettings();
              }
            },
            child: const Text(
              "Open Settings",
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
      }
    }
    debugPrint("Notification Permission $haveNotificationPermission....");

    return haveNotificationPermission;
  }

  ///Awesome Notifications Listeners...

  ///5) Set Listener Before Start Service...
  static Future setAwesomeNotificationsListeners({required BuildContext context}) async {
    return await AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
    debugPrint("onNotificationCreatedMethod");
    debugPrint("ReceivedNotification is $receivedNotification");
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
    debugPrint("onNotificationDisplayedMethod");
    debugPrint("ReceivedNotification is $receivedNotification");
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
    debugPrint("onDismissActionReceivedMethod");
    debugPrint("ReceivedAction is $receivedAction");
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    debugPrint("onActionReceivedMethod");
    debugPrint("ReceivedAction is $receivedAction");

    redirectToScreen(
      payload: receivedAction.payload,
    );
  }

  /// Notifications Handling...
  static Future redirectToScreen({
    Map<String, String?>? payload,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    debugPrint("Payload Data is $payload");
    String? id = payload?["id"];
    String? redirectTo = payload?["redirect_to"];
    debugPrint("On Notification Click Redirecting to $redirectTo with Id $id");
    debugPrint("Redirecting to $redirectTo");
    if (context != null) {
      openScreen(
        context: context,
        route: redirectTo,
        payload: payload,
      );
    }
  }

  ///Open Screen
  static openScreen({
    required BuildContext context,
    required String? route,
    required Map<String, String?>? payload,
  }) {
    if (route == "posts") {
      context.read<DashboardController>().setDashBoardIndex(index: 3, context: context);
    } else if (route == "orders") {
      context.read<DashboardController>().setDashBoardIndex(index: 4, context: context);
    } else {
      // return MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      //   routeName,
      //       (route) => (route.settings.name != routeName) || route.isFirst,
      //   arguments: receivedAction,
      // );
      return context.pushNamed(route != null ? "/$route" : Routs.notifications);
    }
  }

  /// 1) BigPicture Notification

  Future<void> createBigPictureNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    // if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1,
            channelKey: AppConfig.chanelName,
            title: 'Huston! The eagle has landed!',
            body:
                "A small step for a man, but a giant leap to Flutter's community! A small step for a man, but a giant leap to Flutter's community! A small step for a man, but a giant leap to Flutter's community!",
            bigPicture: 'https://play-lh.googleusercontent.com/OBNmM8sTh46LrvpH4Z1mZMxY_VNFaH1SPZn2rJv12SdoHO_myz5u7DjvqDdoHtOWQPk=w416-h235-rw',
            largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'REPLY',
              label: 'Reply Message',
              requireInputText: true,
              actionType: ActionType.SilentAction),
          NotificationActionButton(
              key: 'DISMISS', label: 'Dismiss', actionType: ActionType.DismissAction, isDangerousOption: true)
        ]);
  }

  /// 2) Firebase Notification

  static Future<void> showFirebaseNotification({
    required RemoteMessage? message,
  }) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    // if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;
    if (message != null) {
      debugPrint("Showing AwesomeNotifications from FirebaseMessaging....");
      debugPrint("FirebaseMessaging message Id ${message.messageId} & $message ");
      debugPrint("FirebaseMessaging notification ${message.notification}");
      Map<String, String?>? data;
      try {
        data = message.data.cast<String, String?>();
      } catch (e, s) {
        debugPrint("Error $e & $s");
      }
      debugPrint("FirebaseMessaging data $data");

      DateTime time = DateTime.now();
      int id = (int.tryParse("${time.day}${time.month}${time.microsecond}") ?? 0).toInt();

      String? bigPicture;
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        bigPicture = message.notification?.apple?.imageUrl;
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        bigPicture = message.notification?.android?.imageUrl;
      } else {
        bigPicture = message.notification?.web?.image;
      }

      debugPrint("FirebaseMessaging id $id");
      debugPrint("FirebaseMessaging bigPicture $bigPicture");
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: AppConfig.chanelName,
          title: message.notification?.title,
          body: message.notification?.body,
          bigPicture: bigPicture,
          notificationLayout: bigPicture != null ? NotificationLayout.BigPicture : NotificationLayout.Default,
          payload: data,
        ),
      );
    }
  }
}
