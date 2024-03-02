import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'controllers/auth_controller/auth_controller.dart';
import 'controllers/check_demo_controller/check_demo_controller.dart';
import 'controllers/dashboard/dashboard_controller.dart';
import 'controllers/dashboard/download_controller.dart';
import 'controllers/feeds/feeds_controller.dart';
import 'controllers/guest_controller/guest_controller.dart';
import 'controllers/member/events/events_controller.dart';
import 'controllers/member/leads/leads_controllers.dart';
import 'controllers/member/member_auth_controller.dart';
import 'controllers/member/member_controller/demo_controller.dart';
import 'controllers/member/member_controller/member_controller.dart';
import 'controllers/member/network/network_controller.dart';
import 'controllers/member/training/training_controller.dart';
import 'core/services/database/local_database.dart';
import 'core/services/localization/localization_controller.dart';
import 'core/services/notifications/notification_controller.dart';
import 'core/services/theme/theme_controller.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalDatabase.initialize();
  await NotificationController.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Change to desired orientation
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => MultiProvider(
    //     providers: [
    //       ChangeNotifierProvider(create: (context) => DashboardController()),
    //       ChangeNotifierProvider(create: (context) => LocationController()),
    //       ChangeNotifierProvider(create: (context) => ThemeController()),
    //       ChangeNotifierProvider(create: (context) => LocalizationController()),
    //       ChangeNotifierProvider(create: (context) => LocalDatabase()),
    //       ChangeNotifierProvider(create: (context) => MemberAuthControllers()),
    //       ChangeNotifierProvider(create: (context) => NetworkControllers()),
    //       ChangeNotifierProvider(create: (context) => AuthControllers()),
    //       ChangeNotifierProvider(create: (context) => GuestControllers()),
    //       ChangeNotifierProvider(create: (context) => FeedsController()),
    //       ChangeNotifierProvider(create: (context) => MembersController()),
    //     ],
    //     child: const MyApp(),
    //   ), // Wrap your app
    // ),);

    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DashboardController()),
        ChangeNotifierProvider(create: (context) => ThemeController()),
        ChangeNotifierProvider(create: (context) => LocalizationController()),
        ChangeNotifierProvider(create: (context) => LocalDatabase()),
        ChangeNotifierProvider(create: (context) => MemberAuthControllers()),
        ChangeNotifierProvider(create: (context) => NetworkControllers()),
        ChangeNotifierProvider(create: (context) => AuthControllers()),
        ChangeNotifierProvider(create: (context) => GuestControllers()),
        ChangeNotifierProvider(create: (context) => FeedsController()),
        ChangeNotifierProvider(create: (context) => MembersController()),
        ChangeNotifierProvider(create: (context) => TrainingControllers()),
        ChangeNotifierProvider(create: (context) => EventsControllers()),
        ChangeNotifierProvider(create: (context) => DemoController()),
        ChangeNotifierProvider(create: (context) => ListsControllers()),
        ChangeNotifierProvider(create: (context) => CheckDemoController()),
        ChangeNotifierProvider(create: (context) => DownloadState()),
      ],
      child: const MyApp(),
    ),
  );
}
