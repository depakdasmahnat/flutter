import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/route/route_config.dart';
import 'package:mrwebbeast/core/services/notifications/notification_controller.dart';
import 'package:mrwebbeast/core/services/theme/theme_controller.dart';
import 'package:provider/provider.dart';
import 'core/config/app_config.dart';
import 'core/services/localization/localization_controller.dart';
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startNotificationListeners();
      LocalizationController localization = Provider.of<LocalizationController>(context, listen: false);
      localization.getDeviceLocals(setDefault: true);
    });
  }

  Future startNotificationListeners() async {
    await NotificationController.setFirebaseMessagingListeners(context: context);
    await NotificationController.setAwesomeNotificationsListeners(context: context);
  }

  @override
  Widget build(BuildContext context) {
    ThemeController theme = Provider.of<ThemeController>(context);
    LocalizationController localization = Provider.of<LocalizationController>(context);

    return MaterialApp.router(
      title: AppConfig.name,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.darkTheme(context),
      darkTheme: AppThemes.darkTheme(context),
      themeMode: theme.themeMode,
      locale: localization.locale,
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates(),
      routeInformationParser: RoutesConfig.router.routeInformationParser,
      routerDelegate: RoutesConfig.router.routerDelegate,
      routeInformationProvider: RoutesConfig.router.routeInformationProvider,
    );
  }
}
