import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'app.dart';
import 'controllers/dashboard_controller.dart';
import 'core/services/database/local_database.dart';
import 'core/services/localization/localization_controller.dart';
import 'core/services/location/location_controller.dart';
import 'core/services/notifications/notification_controller.dart';
import 'core/services/theme/theme_controller.dart';
import 'firebase_options.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalDatabase.initialize();
  await NotificationController.initialize();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DashboardController()),
        ChangeNotifierProvider(create: (context) => LocationController()),
        ChangeNotifierProvider(create: (context) => ThemeController()),
        ChangeNotifierProvider(create: (context) => LocalizationController()),
      ],
      child: const MyApp(),
    ),
  );
}
