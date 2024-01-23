import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:mrwebbeast/screens/guest/product/guest_product_details.dart';
import 'package:mrwebbeast/screens/member/archievers/achievers.dart';
import 'package:mrwebbeast/screens/member/demo/create_demo.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../app.dart';

import '../../screens/auth/connect_with_us.dart';
import '../../screens/auth/first_Screen.dart';

import '../../screens/auth/interest_screen.dart';
import '../../screens/auth/member_login.dart';
import '../../screens/auth/question_screen.dart';
import '../../screens/auth/verify_otp.dart';
import '../../screens/guest/home/home_screen.dart';
import '../../screens/guest/guestProfile/guest_edit_profile.dart';
import '../../screens/guest/guestProfile/guest_faq.dart';
import '../../screens/guest/guestProfile/guest_profile.dart';
import '../../screens/guest/product/guest_product.dart';
import '../../screens/guest/productDetail/product_detail.dart';
import '../../screens/guest/profile/about_us.dart';
import '../../screens/guest/profile/edit_profile.dart';
import '../../screens/guest/profile/permission_screen.dart';
import '../../screens/guest/profile/settings.dart';

import '../../screens/member/home/member_dashboard.dart';
import '../../screens/member/home/member_profile_details.dart';

import '../../screens/member/members/add_member_form.dart';
import '../../screens/member/members/add_member_list.dart';
import '../../screens/member/members/calendar.dart';
import '../../screens/member/profile/member_edit_profile.dart';
import '../../screens/member/target/target_screen.dart';
import '../../screens/guest/resource&Demo/resource_and_demo.dart';
import '../../screens/member/events/create_event.dart';
import '../../screens/member/events/events_screen.dart';
import '../../screens/member/exam/exam_quiz.dart';
import '../../screens/member/feeds/demo_videos.dart';
import '../../screens/member/feeds/member_feeds.dart';
import '../../screens/member/goal/create_goal.dart';
import '../../screens/member/goal/goals_screen.dart';
import '../../screens/member/home/member_profile.dart';
import '../../screens/member/home/training_screen.dart';
import '../../screens/member/network/network_report.dart';
import '../../screens/member/resources/resources.dart';
import '../../screens/member/target/create_target.dart';
import '../../screens/member/todo/todo_screen.dart';
import '../../screens/welcome_screen.dart';
import '../../select_lead/select_lead.dart';
import '../../utils/widgets/image_opener.dart';
import '../../utils/widgets/multiple_image_opener.dart';
import '../../utils/widgets/web_view_screen.dart';
import '../../screens/auth/login.dart';
import '../../screens/dashboard/dashboard.dart';

import '../../screens/notifications/notifications.dart';

import '../services/analytics/analytic_service.dart';
import '../services/database/local_database.dart';

import 'route_paths.dart';

class RoutesConfig {
  /// Initial Route...
  static final _settingsNavigatorKey = GlobalKey<NavigatorState>();

  static String? initialLocation() {
    bool authenticated = isAuthenticated();
    return authenticated ? Routs.dashboard : Routs.fisrtScreen;
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
      //     return cupertinoPage(state: state, child: initialScreen());
      //   },
      // ),
      GoRoute(
        name: Routs.memberaddForm,
        path: Routs.memberaddForm,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const AddMemberForm());
        },
      ),
      GoRoute(
        name: Routs.memberaddList,
        path: Routs.memberaddList,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const AddMemberList());
        },
      ),
      GoRoute(
        name: Routs.memberEditProfile,
        path: Routs.memberEditProfile,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const MemberEditProfile());
        },
      ),
      GoRoute(
        name: Routs.callender,
        path: Routs.callender,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const CalendarForm());
        },
      ),
      GoRoute(
        name: Routs.fisrtScreen,
        path: Routs.fisrtScreen,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const FirstScreen());
        },
      ),

      GoRoute(
        name: Routs.dashboard,
        path: Routs.dashboard,
        pageBuilder: (context, state) {
          DashBoard? data = state.extra as DashBoard?;
          return cupertinoPage(
              state: state,
              child: DashBoard(
                dashBoardIndex: data?.dashBoardIndex,
                userRole: data?.userRole,
              ),
              authRequired: true);
        },
      ),

      GoRoute(
        name: Routs.welcome,
        path: Routs.welcome,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const WelcomeScreen());
        },
      ),
      GoRoute(
        name: Routs.login,
        path: Routs.login,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const Login());
        },
      ),
      GoRoute(
        name: Routs.memberLogin,
        path: Routs.memberLogin,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const MemberLogin());
        },
      ),
      GoRoute(
        name: Routs.memberDashBoard,
        path: Routs.memberDashBoard,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const MemberDashBoard());
        },
      ),

      GoRoute(
        name: Routs.memberProfileDetails,
        path: Routs.memberProfileDetails,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const MemberProfileDetails());
        },
      ),

      GoRoute(
        name: Routs.targetScreen,
        path: Routs.targetScreen,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const TargetScreen());
        },
      ),
      GoRoute(
        name: Routs.interests,
        path: Routs.interests,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const InterestScreen());
        },
      ),

      GoRoute(
        name: Routs.questions,
        path: Routs.questions,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const QuestionsScreen());
        },
      ),
      GoRoute(
        name: Routs.connectWithUs,
        path: Routs.connectWithUs,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const ConnectWithUs());
        },
      ),

      GoRoute(
        name: Routs.verifyOTP,
        path: Routs.verifyOTP,
        pageBuilder: (context, state) {
          VerifyOTP? data = state.extra as VerifyOTP?;
          return cupertinoPage(
              state: state,
              child: VerifyOTP(
                mobileNo: data?.mobileNo,
                lastName: data?.lastName,
                referralCode: data?.referralCode,
                isMobileValidated: data?.isMobileValidated,
                firstName: data?.firstName,
                goBack: data?.goBack,
              ));
        },
      ),
      GoRoute(
        name: Routs.homeScreen,
        path: Routs.homeScreen,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const HomeScreen());
        },
        redirect: authRequired,
      ),
      GoRoute(
        name: Routs.notifications,
        path: Routs.notifications,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const NotificationScreen());
        },
      ),
      GoRoute(
        name: Routs.settings,
        path: Routs.settings,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const SettingsScreen());
        },
      ),

      GoRoute(
        name: Routs.aboutUs,
        path: Routs.aboutUs,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const AboutUsScreen());
        },
      ),

      GoRoute(
        name: Routs.editProfile,
        path: Routs.editProfile,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const EditProfile());
        },
      ),

      GoRoute(
        name: Routs.permissions,
        path: Routs.permissions,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const PermissionsScreen());
        },
      ),
      GoRoute(
        name: Routs.guestProductDetail,
        path: Routs.guestProductDetail,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const GusetProductDetails());
        },
      ),
      GoRoute(
        name: Routs.guestProduct,
        path: Routs.guestProduct,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const GuestPoduct());
        },
      ),
      GoRoute(
        name: Routs.guestProfile,
        path: Routs.guestProfile,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const GuestProfile());
        },
      ),

      GoRoute(
        name: Routs.guestEditProfile,
        path: Routs.guestEditProfile,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const GuestEditProfile());
        },
      ),
      GoRoute(
        name: Routs.guestFaq,
        path: Routs.guestFaq,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const GuestFaq());
        },
      ),
      GoRoute(
        name: Routs.selectLead,
        path: Routs.selectLead,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const SelectLead());
        },
      ),

      GoRoute(
        name: Routs.demoVideos,
        path: Routs.demoVideos,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const DemoVideos());
        },
      ),
      GoRoute(
        name: Routs.trainingScreen,
        path: Routs.trainingScreen,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const TrainingScreen());
        },
      ),
      GoRoute(
        name: Routs.memberFeeds,
        path: Routs.memberFeeds,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const MemberFeeds());
        },
      ),
      GoRoute(
        name: Routs.resourceAndDemo,
        path: Routs.resourceAndDemo,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: RecourceAndDemo(type: state.extra.toString()));
        },
      ),

      GoRoute(
        name: Routs.productDetail,
        path: Routs.productDetail,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const ProductDetail());
        },
      ),
      GoRoute(
        name: Routs.examQuiz,
        path: Routs.examQuiz,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const ExamQuiz());
        },
      ),
      GoRoute(
        name: Routs.toDoScreen,
        path: Routs.toDoScreen,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const ToDoScreen());
        },
      ),
      GoRoute(
        name: Routs.goals,
        path: Routs.goals,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const GoalsScreen());
        },
      ),
      GoRoute(
        name: Routs.createGoal,
        path: Routs.createGoal,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const CreateGoal());
        },
      ),

      GoRoute(
        name: Routs.achievers,
        path: Routs.achievers,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const Achievers());
        },
      ),

      GoRoute(
        name: Routs.createTarget,
        path: Routs.createTarget,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const CreateTarget());
        },
      ),
      GoRoute(
        name: Routs.createEvent,
        path: Routs.createEvent,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const CreateEvent());
        },
      ),
      GoRoute(
        name: Routs.memberProfile,
        path: Routs.memberProfile,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const MemberProfile());
        },
      ),

      GoRoute(
        name: Routs.events,
        path: Routs.events,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const EventScreen());
        },
      ),
      GoRoute(
        name: Routs.createDemo,
        path: Routs.createDemo,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const CreateDemo());
        },
      ),
      GoRoute(
        name: Routs.networkReport,
        path: Routs.networkReport,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const NetworkReport());
        },
      ),
      GoRoute(
        name: Routs.resources,
        path: Routs.resources,
        pageBuilder: (context, state) {
          return cupertinoPage(state: state, child: const ResourcesScreen());
        },
      ),
      GoRoute(
        name: Routs.imageOpener,
        path: Routs.imageOpener,
        pageBuilder: (context, state) {
          ImageOpener? data = state.extra as ImageOpener?;

          return cupertinoPage(
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

          return cupertinoPage(
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

          return cupertinoPage(
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
          CupertinoButton(
            color: context.colorScheme.primary,
            child: const Text('Home'),
            onPressed: () {
              context.go(Routs.login);
            },
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
}
