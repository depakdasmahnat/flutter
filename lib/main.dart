import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gaas/core/config/app_config.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:provider/provider.dart';

import 'controllers/auth/auth_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'controllers/feeds_controller.dart';
import 'controllers/localization/localization_controller.dart';
import 'controllers/location/location_controller.dart';
import 'controllers/notifications/notification_controller.dart';
import 'controllers/notifications/notifications_api_controller.dart';
import 'controllers/orders/cart_controller.dart';
import 'controllers/partner/membership_controller.dart';
import 'controllers/partner/offers/offers_controller.dart';
import 'controllers/partner/partner_controller.dart';
import 'controllers/partner/product_controller.dart';
import 'controllers/partner/service_provider_controller.dart';
import 'controllers/payments/cart_payment_contrroller.dart';
import 'controllers/payments/stripe_controller.dart';
import 'controllers/services_controller.dart';
import 'controllers/theme/theme_controller.dart';
import 'controllers/wishlist_controller.dart';
import 'core/localization/app_localization.dart';
import 'core/services/database/local_database.dart';
import 'firebase_options.dart';
import 'route/route_config.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalDatabase.initialize();
  await NotificationController.initialize();
  AppConfig.generateDeviceToken();

  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
    mapsImplementation.initializeWithRenderer(AndroidMapRenderer.latest);
  }
  Stripe.publishableKey = AppConfig.stripePublishableKey;
  Stripe.merchantIdentifier = AppConfig.apkName;
  await Stripe.instance.applySettings();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DashboardController()),
        ChangeNotifierProvider(create: (context) => LocalDatabase()),
        ChangeNotifierProvider(create: (context) => LocationController()),
        ChangeNotifierProvider(create: (context) => LocalizationProvider()),
        ChangeNotifierProvider(create: (context) => AuthControllers()),
        ChangeNotifierProvider(create: (context) => PartnerController()),
        ChangeNotifierProvider(create: (context) => CartController()),
        ChangeNotifierProvider(create: (context) => ProductController()),
        ChangeNotifierProvider(create: (context) => MembershipController()),
        ChangeNotifierProvider(create: (context) => WishListController()),
        ChangeNotifierProvider(create: (context) => OffersController()),
        ChangeNotifierProvider(create: (context) => ServiceProviderController()),
        ChangeNotifierProvider(create: (context) => ServicesController()),
        ChangeNotifierProvider(create: (context) => FeedsController()),
        ChangeNotifierProvider(create: (context) => NotificationController()),
        ChangeNotifierProvider(create: (context) => NotificationsAPIController()),
        ChangeNotifierProvider(create: (context) => StripeController()),
        ChangeNotifierProvider(create: (context) => CartPaymentController()),
      ],
      child: const MyApp(),
    ),
  );
}

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
    startNotificationListeners();
  }

  Future startNotificationListeners() async {
    await NotificationController.setFirebaseMessagingListeners(context: context).then((value) {
      return NotificationController.setAwesomeNotificationsListeners(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.apkName,
      debugShowCheckedModeBanner: false,
      theme: ThemeController.lightTheme(),
      routeInformationParser: RoutesConfig.router.routeInformationParser,
      routerDelegate: RoutesConfig.router.routerDelegate,
      routeInformationProvider: RoutesConfig.router.routeInformationProvider,
      supportedLocales: AppLocalization.supportedLocales(),
      localizationsDelegates: AppLocalization.localizationsDelegates(),
    );
  }
}
