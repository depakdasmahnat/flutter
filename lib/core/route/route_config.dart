import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:mrwebbeast/pages/profile/about_us.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app.dart';
import '../../pages/auth/interest_screen.dart';
import '../../pages/auth/verify_otp.dart';
import '../../pages/welcome_screen.dart';
import '../../utils/widgets/image_opener.dart';
import '../../utils/widgets/multiple_image_opener.dart';
import '../../utils/widgets/web_view_screen.dart';
import '../../pages/auth/login.dart';
import '../../pages/dashboard/dashboard.dart';
import '../../pages/home/home_screen.dart';
import '../../pages/notifications/notifications.dart';
import '../../pages/profile/edit_profile.dart';
import '../../pages/profile/permission_screen.dart';
import '../../pages/profile/settings.dart';
import '../services/analytics/analytic_service.dart';
import '../services/database/local_database.dart';

import 'route_paths.dart';

class RoutesConfig {
  /// Initial Route...
  static final _settingsNavigatorKey = GlobalKey<NavigatorState>();

  static String? initialLocation() {
    bool authenticated = isAuthenticated();
    return authenticated ? Routs.dashboard : Routs.welcome;
  }

  ///1)  Route Config...

  static final GoRouter _router = GoRouter(
    initialLocation: initialLocation(),
    observers: [
      AnalyticService.observer,
    ],
    navigatorKey: MyApp.navigatorKey,
    routes: [
      // GoRoute(
      //   name: Routs.initialRoute,
      //   path: Routs.initialRoute,
      //   pageBuilder: (context, state) {
      //     return materialPage(state: state, child: initialScreen());
      //   },
      // ),

      GoRoute(
        name: Routs.dashboard,
        path: Routs.dashboard,
        pageBuilder: (context, state) {
          return customTransitionPage(state: state, child: const DashBoard(), authRequired: true);
        },
      ),
      GoRoute(
        name: Routs.welcome,
        path: Routs.welcome,
        pageBuilder: (context, state) {
          return customTransitionPage(state: state, child: const WelcomeScreen());
        },
      ),
      GoRoute(
        name: Routs.login,
        path: Routs.login,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const Login());
        },
      ),      GoRoute(
        name: Routs.interests,
        path: Routs.interests,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const InterestScreen());
        },
      ),

      GoRoute(
        name: Routs.verifyOTP,
        path: Routs.verifyOTP,
        pageBuilder: (context, state) {
          VerifyOTP? data = state.extra as VerifyOTP?;
          return materialPage(
              state: state,
              child: VerifyOTP(
                mobileNo: data?.mobileNo,
                goBack: data?.goBack,
              ));
        },
      ),
      GoRoute(
        name: Routs.homeScreen,
        path: Routs.homeScreen,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const HomeScreen());
        },
        redirect: authRequired,
      ),
      GoRoute(
        name: Routs.notifications,
        path: Routs.notifications,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const NotificationScreen());
        },
      ),
      GoRoute(
        name: Routs.settings,
        path: Routs.settings,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const SettingsScreen());
        },
      ),

      GoRoute(
        name: Routs.aboutUs,
        path: Routs.aboutUs,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const AboutUsScreen());
        },
      ),

      GoRoute(
        name: Routs.editProfile,
        path: Routs.editProfile,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const EditProfile());
        },
      ),
      GoRoute(
        name: Routs.permissions,
        path: Routs.permissions,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const PermissionsScreen());
        },
      ),
      GoRoute(
        name: Routs.imageOpener,
        path: Routs.imageOpener,
        pageBuilder: (context, state) {
          ImageOpener? data = state.extra as ImageOpener?;

          return materialPage(
              state: state,
              child: ImageOpener(
                assetImage: data?.assetImage,
                networkImage: data?.networkImage,
                file: data?.file,
                isAvatar: data?.isAvatar,
              ));
        },
      ),
      GoRoute(
        name: Routs.multipleImageOpener,
        path: Routs.multipleImageOpener,
        pageBuilder: (context, state) {
          MultipleImageOpener? data = state.extra as MultipleImageOpener?;

          return materialPage(
              state: state,
              child: MultipleImageOpener(
                initialIndex: data?.initialIndex,
                assetImages: data?.assetImages,
                networkImages: data?.networkImages,
                files: data?.files,
                isAvatar: data?.isAvatar,
              ));
        },
      ),

      GoRoute(
        name: Routs.webView,
        path: Routs.webView,
        pageBuilder: (context, state) {
          WebViewScreen? data = state.extra as WebViewScreen?;

          return materialPage(
              state: state, child: WebViewScreen(key: data?.key, title: data?.title, url: data?.url));
        },
        redirect: (context, state) {
          if (kIsWeb) {
            WebViewScreen? data = state.extra as WebViewScreen?;
            launchUrl(Uri.parse('${data?.url}'));
            context.pop();
          }
          return null;
        },
      ),
    ],
    errorPageBuilder: (context, state) {
      return unknownRoute(context: context, state: state);
    },
    redirectLimit: 1,
  );

  static GoRouter get router => _router;

  ///2)  Unknown Route...

  static MaterialPage unknownRoute({
    required BuildContext context,
    required GoRouterState state,
  }) {
    return MaterialPage(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('No Route defined for unknown  ${state.path}')),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoButton(
              color: context.colorScheme.primary,
              child: const Text('Home'),
              onPressed: () {
                context.go(Routs.login);
              },
            ),
          ),
        ],
      ),
    ));
  }

  static authRedirect(BuildContext context, GoRouterState state) {}

  static bool isAuthenticated() {
    LocalDatabase localDatabase = LocalDatabase();
    return localDatabase.accessToken?.isNotEmpty == true;
  }

  static String? authRequired(BuildContext context, GoRouterState state) {
    debugPrint('isAuthenticated() ${isAuthenticated()}');
    debugPrint('authRequired');
    if (!isAuthenticated()) {
      debugPrint('authRequired');

      return Routs.login;
    }
    return null;
  }

  ///3)  Material Page ...

  static MaterialPage<dynamic> materialPage({
    required GoRouterState state,
    required Widget child,
  }) {
    AnalyticService.trackScreen(state: state);
    return MaterialPage(key: state.pageKey, child: child);
  }

  ///4)  Cupertino Page...
  static CupertinoPage<dynamic> cupertinoPage({
    required GoRouterState state,
    required Widget child,
    bool authRequired = false,
  }) {
    AnalyticService.trackScreen(state: state);
    return CupertinoPage(key: state.pageKey, child: child);
  }

  ///5)  Cupertino Page...

  static CustomTransitionPage<dynamic> customTransitionPage({
    required GoRouterState state,
    required Widget child,
    bool authRequired = false,
    Curve? curve,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
    bool maintainState = true,
    bool fullscreenDialog = false,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      barrierDismissible: barrierDismissible,
      opaque: opaque,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        AnalyticService.trackScreen(state: state);

        return FadeTransition(
          opacity: CurveTween(curve: curve ?? Curves.easeInOutCirc).animate(animation),
          child: child,
        );
      },
    );
  }
}
