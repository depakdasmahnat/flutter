import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/constant/enums.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:mrwebbeast/screens/guest/product/guest_product_details.dart';
import 'package:mrwebbeast/screens/member/archievers/achievers.dart';
import 'package:mrwebbeast/screens/member/demo/create_demo.dart';
import 'package:mrwebbeast/screens/member/demo/demos_screen.dart';
import 'package:mrwebbeast/screens/member/goal/partner_goals_screen.dart';
import 'package:mrwebbeast/utils/widgets/pdf_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app.dart';
import '../../screens/auth/member/change_password.dart';
import '../../screens/auth/member/reset_password.dart';
import '../../screens/auth/connect_with_us.dart';
import '../../screens/auth/gtp_video.dart';
import '../../screens/auth/interest_screen.dart';
import '../../screens/auth/login.dart';
import '../../screens/auth/member/member_login.dart';
import '../../screens/auth/member/verify_reset_password_otp.dart';
import '../../screens/auth/question_screen.dart';
import '../../screens/auth/verify_otp.dart';
import '../../screens/auth/why_are_you_here.dart';
import '../../screens/dashboard/dashboard.dart';
import '../../screens/guest/check_demo/check_demo.dart';
import '../../screens/guest/guestProfile/feedback_rating.dart';
import '../../screens/guest/guestProfile/guest_edit_profile.dart';
import '../../screens/guest/guestProfile/guest_faq.dart';
import '../../screens/guest/guestProfile/guest_hall_of_fam.dart';
import '../../screens/guest/guestProfile/guest_profile.dart';
import '../../screens/guest/guest_check_demo/guestDemoVideosAfterComplete.dart';
import '../../screens/guest/guest_check_demo/guest_check_demo.dart';
import '../../screens/guest/guest_notification/guest_notification.dart';
import '../../screens/guest/help&support/help&support.dart';
import '../../screens/guest/home/home_screen.dart';
import '../../screens/guest/pricavy_policy/privacy_policy.dart';
import '../../screens/guest/product/guest_product.dart';
import '../../screens/guest/profile/about_us.dart';
import '../../screens/guest/profile/permission_screen.dart';
import '../../screens/guest/resource&Demo/mainresource.dart';
import '../../screens/guest/resource&Demo/resource_and_demo.dart';
import '../../screens/guest/web_view/faq.dart';
import '../../screens/member/events/create_event.dart';
import '../../screens/member/events/events_screen.dart';
import '../../screens/member/feeds/feed_detail.dart';
import '../../screens/member/feeds/member_feeds.dart';
import '../../screens/member/goal/create_goal.dart';
import '../../screens/member/goal/goals_screen.dart';
import '../../screens/member/home/member_dashboard.dart';
import '../../screens/member/home/member_profile.dart';
import '../../screens/member/home/member_profile_details.dart';
import '../../screens/member/lead/get_contact.dart';
import '../../screens/member/lead/lead.dart';
import '../../screens/member/lead/scheduled_demo_form.dart';
import '../../screens/member/members/add_member_form.dart';
import '../../screens/member/members/add_member_list.dart';
import '../../screens/member/members/calendar.dart';
import '../../screens/member/report/network_report.dart';
import '../../screens/member/performance_chart/performance_chart.dart';
import '../../screens/member/profile/account_settings.dart';
import '../../screens/member/profile/member_edit_profile.dart';
import '../../screens/member/profile/profile.dart';
import '../../screens/member/profile/watch_video_count.dart';
import '../../screens/member/resources/resources.dart';
import '../../screens/member/services/services_screen.dart';
import '../../screens/member/target/create_target.dart';
import '../../screens/member/target/target_screen.dart';
import '../../screens/member/todo/todo_screen.dart';
import '../../screens/member/training/chapter_details.dart';
import '../../screens/member/training/chapters_screen.dart';
import '../../screens/member/training/exam_quiz.dart';
import '../../screens/member/training/exam_report.dart';
import '../../screens/member/training/training_screen.dart';
import '../../screens/notifications/notifications.dart';
import '../../screens/welcome_screen.dart';
import '../../select_lead/select_lead.dart';
import '../../utils/widgets/image_opener.dart';
import '../../utils/widgets/multiple_image_opener.dart';
import '../../utils/widgets/ppt_viewer.dart';
import '../../utils/widgets/web_view_screen.dart';
import '../services/analytics/analytic_service.dart';
import '../services/database/local_database.dart';
import 'route_paths.dart';

class RoutesConfig {
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
        name: Routs.memberaddForm,
        path: Routs.memberaddForm,
        pageBuilder: (context, state) {
          AddMemberForm? data = state.extra as AddMemberForm?;
          return materialPage(state: state, child:  AddMemberForm(guestId: data?.guestId??'',));
        },
      ),
      GoRoute(
        name: Routs.memberaddList,
        path: Routs.memberaddList,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const AddMemberList());
        },
      ),
      GoRoute(
        name: Routs.memberEditProfile,
        path: Routs.memberEditProfile,
        pageBuilder: (context, state) {
          MemberEditProfile? data = state.extra as MemberEditProfile?;
          return materialPage(state: state, child:  MemberEditProfile(loginType: data?.loginType??false,));
        },
      ),
      GoRoute(
        name: Routs.callender,
        path: Routs.callender,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const CalendarForm());
        },
      ),
      GoRoute(
        name: Routs.welcome,
        path: Routs.welcome,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const WelcomeScreen());
        },
      ),

      GoRoute(
        name: Routs.dashboard,
        path: Routs.dashboard,
        pageBuilder: (context, state) {
          DashBoard? data = state.extra as DashBoard?;

          return materialPage(
              state: state,
              child: DashBoard(
                dashBoardIndex: data?.dashBoardIndex,
                userRole: data?.userRole,
              ),
              authRequired: true);
        },
      ),     GoRoute(
        name: Routs.watchVideoCount,
        path: Routs.watchVideoCount,
        pageBuilder: (context, state) {
          WatchVideoCount? data = state.extra as WatchVideoCount?;

          return materialPage(
              state: state,
              child: WatchVideoCount(
                guestProfileDetails:data?.guestProfileDetails ,
              ),
              authRequired: true);
        },
      ),

      GoRoute(
        name: Routs.login,
        path: Routs.login,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const Login());
        },
      ),
      GoRoute(
        name: Routs.memberLogin,
        path: Routs.memberLogin,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const MemberSignIn());
        },
      ),
      GoRoute(
        name: Routs.memberDashBoard,
        path: Routs.memberDashBoard,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const MemberDashBoard());
        },
      ),
      GoRoute(
        name: Routs.leads,
        path: Routs.leads,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const Lead());
        },
      ), GoRoute(
        name: Routs.mainResource,
        path: Routs.mainResource,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const MainResource());
        },
      ),

      GoRoute(
        name: Routs.memberProfileDetails,
        path: Routs.memberProfileDetails,
        pageBuilder: (context, state) {
          MemberProfileDetails? data = state.extra as MemberProfileDetails?;
          return materialPage(
              state: state,
              child: MemberProfileDetails(
                memberId: data?.memberId ?? '',
              ));
        },
      ),

      GoRoute(
        name: Routs.targetScreen,
        path: Routs.targetScreen,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const TargetScreen());
        },
      ),
      GoRoute(
        name: Routs.interests,
        path: Routs.interests,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const InterestScreen());
        },
      ),

      GoRoute(
        name: Routs.questions,
        path: Routs.questions,
        pageBuilder: (context, state) {
          QuestionsScreen? data = state.extra as QuestionsScreen?;
          return materialPage(
              state: state,
              child: QuestionsScreen(
                categoryId: data?.categoryId ?? '',
              ));
        },
      ),

      GoRoute(
        name: Routs.connectWithUs,
        path: Routs.connectWithUs,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const ConnectWithUs());
        },
      ),
      GoRoute(
        name: Routs.gtpVideo,
        path: Routs.gtpVideo,
        pageBuilder: (context, state) {
          GtpVideo? data = state.extra as GtpVideo?;
          return materialPage(
              state: state,
              child: GtpVideo(
                videoLink: data?.videoLink ?? '',
              ));
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
                lastName: data?.lastName,
                referralCode: data?.referralCode,
                isMobileValidated: data?.isMobileValidated,
                firstName: data?.firstName,
                stateID: data?.stateID,
                cityId: data?.cityId,
                goBack: data?.goBack,
              ));
        },
      ),

      GoRoute(
        name: Routs.verifyForgotPasswordOtp,
        path: Routs.verifyForgotPasswordOtp,
        pageBuilder: (context, state) {
          VerifyResetPasswordOTP? data = state.extra as VerifyResetPasswordOTP?;
          return materialPage(
              state: state,
              child: VerifyResetPasswordOTP(
                enagicId: data?.enagicId,
                contact: data?.contact,
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
          return materialPage(state: state, child: const AccountSettings());
        },
      ),
      GoRoute(
        name: Routs.performanceChart,
        path: Routs.performanceChart,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const PerformanceChart());
        },
      ),
      GoRoute(
        name: Routs.services,
        path: Routs.services,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const ServicesScreen());
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
        name: Routs.permissions,
        path: Routs.permissions,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const PermissionsScreen());
        },
      ),
      GoRoute(
        name: Routs.guestProductDetail,
        path: Routs.guestProductDetail,
        pageBuilder: (context, state) {
          GusetProductDetails? data = state.extra as GusetProductDetails?;
          return materialPage(
              state: state,
              child: GusetProductDetails(
                productId: data?.productId,
              ));
        },
      ),
      GoRoute(
        name: Routs.guestProduct,
        path: Routs.guestProduct,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const GuestPoduct());
        },
      ),
      GoRoute(
        name: Routs.guestProfile,
        path: Routs.guestProfile,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const GuestProfile());
        },
      ),

      GoRoute(
        name: Routs.guestEditProfile,
        path: Routs.guestEditProfile,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const GuestEditProfile());
        },
      ),
      GoRoute(
        name: Routs.guestFaq,
        path: Routs.guestFaq,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const GuestFaq());
        },
      ),
      GoRoute(
        name: Routs.selectLead,
        path: Routs.selectLead,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const SelectLead());
        },
      ),

      GoRoute(
        name: Routs.chapters,
        path: Routs.chapters,
        pageBuilder: (context, state) {
          ChaptersScreen? data = state.extra as ChaptersScreen?;

          return materialPage(
              state: state,
              child: ChaptersScreen(
                category: data?.category,
              ));
        },
      ),
      GoRoute(
        name: Routs.chaptersDetails,
        path: Routs.chaptersDetails,
        pageBuilder: (context, state) {
          ChaptersDetails? data = state.extra as ChaptersDetails?;

          return materialPage(state: state, child: ChaptersDetails(chapter: data?.chapter));
        },
      ),
      GoRoute(
        name: Routs.trainingScreen,
        path: Routs.trainingScreen,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const TrainingScreen());
        },
      ), GoRoute(
        name: Routs.getContact,
        path: Routs.getContact,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const ContactsPage());
        },
      ),
      GoRoute(
        name: Routs.memberFeeds,
        path: Routs.memberFeeds,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const MemberFeeds());
        },
      ),
      GoRoute(
        name: Routs.resourceAndDemo,
        path: Routs.resourceAndDemo,
        pageBuilder: (context, state) {
          ResourceAndDemo? data = state.extra as ResourceAndDemo?;

          return materialPage(state: state, child: ResourceAndDemo(category: data?.category));
        },
      ),

      GoRoute(
        name: Routs.feedDetail,
        path: Routs.feedDetail,
        pageBuilder: (context, state) {
          FeedDetail? data = state.extra as FeedDetail?;
          return materialPage(
              state: state,
              child: FeedDetail(
                id: data?.id,
              ));
        },
      ),

      GoRoute(
        name: Routs.examQuiz,
        path: Routs.examQuiz,
        pageBuilder: (context, state) {
          ExamQuiz? data = state.extra as ExamQuiz?;
          return materialPage(state: state, child: ExamQuiz(chapterId: data?.chapterId));
        },
      ),

      GoRoute(
        name: Routs.leadMemberProfile,
        path: Routs.leadMemberProfile,
        pageBuilder: (context, state) {
          GuestProfileDetails? data = state.extra as GuestProfileDetails?;
          return materialPage(
              state: state,
              child: GuestProfileDetails(
                guestId: data?.guestId,
              ));
        },
      ),

      GoRoute(
        name: Routs.toDoScreen,
        path: Routs.toDoScreen,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const ToDoScreen());
        },
      ),

      GoRoute(
        name: Routs.examReport,
        path: Routs.examReport,
        pageBuilder: (context, state) {
          ExamReport? data = state.extra as ExamReport?;

          return materialPage(state: state, child: ExamReport(report: data?.report));
        },
      ),
      GoRoute(
        name: Routs.goals,
        path: Routs.goals,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const GoalsScreen());
        },
      ),
      GoRoute(
        name: Routs.partnerGoals,
        path: Routs.partnerGoals,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const PartnerGoalsScreen());
        },
      ),
      GoRoute(
        name: Routs.createGoal,
        path: Routs.createGoal,
        pageBuilder: (context, state) {
          CreateGoal? data = state.extra as CreateGoal?;
          return materialPage(
              state: state,
              child: CreateGoal(
                type: data?.type ?? '',
                goalId: data?.goalId ?? '',
              ));
        },
      ),

      GoRoute(
        name: Routs.achievers,
        path: Routs.achievers,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const Achievers());
        },
      ),

      GoRoute(
        name: Routs.createTarget,
        path: Routs.createTarget,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const CreateTarget());
        },
      ),
      GoRoute(
        name: Routs.createEvent,
        path: Routs.createEvent,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const CreateEvent());
        },
      ),
      GoRoute(
        name: Routs.memberProfile,
        path: Routs.memberProfile,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const MemberProfile());
        },
      ),

      GoRoute(
        name: Routs.events,
        path: Routs.events,
        pageBuilder: (context, state) {
          EventScreen? data = state.extra as EventScreen?;
          return materialPage(
              state: state,
              child: EventScreen(
                eventId: data?.eventId,
                filter: data?.filter,
                viewAll: data?.viewAll,
              ));
        },
      ),

      GoRoute(
        name: Routs.shceduledDemoForm,
        path: Routs.shceduledDemoForm,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const ScheduledDemoForm());
        },
      ),
      GoRoute(
        name: Routs.guestCheckDemo,
        path: Routs.guestCheckDemo,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const GuestNewCheckDemo());
        },
      ),
      GoRoute(
        name: Routs.guestDemoVideos,
        path: Routs.guestDemoVideos,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const GuestCheckDemoVideos());
        },
      ),
      GoRoute(
        name: Routs.createDemo,
        path: Routs.createDemo,
        pageBuilder: (context, state) {
          CreateDemo? data = state.extra as CreateDemo?;
          return materialPage(
              state: state,
              child: CreateDemo(
                guestId: data?.guestId ?? '',
                name: data?.name,
                image: data?.image,
                showLeadList: data?.showLeadList,
              ));
        },
      ),

      GoRoute(
        name: Routs.viewPdf,
        path: Routs.viewPdf,
        pageBuilder: (context, state) {
          PDFViewer? data = state.extra as PDFViewer?;
          return materialPage(state: state, child: PDFViewer(pdfUrl: data?.pdfUrl ?? ''));
        },
      ),
      GoRoute(
        name: Routs.demos,
        path: Routs.demos,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const DemosScreen());
        },
      ),
      GoRoute(
        name: Routs.guestDemo,
        path: Routs.guestDemo,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const GuestCheckDemo());
        },
      ),
      GoRoute(
        name: Routs.guestNotification,
        path: Routs.guestNotification,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const GuestNotification());
        },
      ),
      GoRoute(
        name: Routs.hallOfFame,
        path: Routs.hallOfFame,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const HallOfFam());
        },
      ),
      GoRoute(
        name: Routs.feedbackAndRating,
        path: Routs.feedbackAndRating,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const FeedbackAndRating());
        },
      ),
      GoRoute(
        name: Routs.privacyPolicy,
        path: Routs.privacyPolicy,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const PrivacyPolicy());
        },
      ),
      GoRoute(
        name: Routs.helpAndSupport,
        path: Routs.helpAndSupport,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const HelpAndSupport());
        },
      ),

      GoRoute(
        name: Routs.pptViewer,
        path: Routs.pptViewer,
        pageBuilder: (context, state) {
          PPTViewer? data = state.extra as PPTViewer?;
          return materialPage(state: state, child: PPTViewer(url: data?.url ?? ''));
        },
      ),
      GoRoute(
        name: Routs.networkReport,
        path: Routs.networkReport,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const NetworkReport());
        },
      ),
      GoRoute(
        name: Routs.resources,
        path: Routs.resources,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const ResourcesScreen());
        },
      ),
      GoRoute(
        name: Routs.resetPassword,
        path: Routs.resetPassword,
        pageBuilder: (context, state) {
          ResetPassword? data = state.extra as ResetPassword?;
          return materialPage(state: state, child: ResetPassword(enagicId: data?.enagicId));
        },
      ),
      GoRoute(
        name: Routs.changePassword,
        path: Routs.changePassword,
        pageBuilder: (context, state) {
          ChangePassword? data = state.extra as ChangePassword?;
          return materialPage(state: state, child: ChangePassword(enagicId: data?.enagicId));
        },
      ),

      GoRoute(
        name: Routs.whyareYou,
        path: Routs.whyareYou,
        pageBuilder: (context, state) {
          WhyAreYouHere? data = state.extra as WhyAreYouHere?;
          return materialPage(
              state: state,
              child: WhyAreYouHere(
                questionId: data?.questionId ?? '',
                item: data?.item ?? [],
                question: data?.question ?? '',
              ));
        },
      ),
      GoRoute(
        name: Routs.webView1,
        path: Routs.webView1,
        pageBuilder: (context, state) {
          WebScreen? data = state.extra as WebScreen?;

          return materialPage(
              state: state,
              child: WebScreen(
                type: data?.type ?? '',
              ));
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
    bool status = false;
    LocalDatabase localDatabase = LocalDatabase();

    if (localDatabase.userRole == UserRoles.guest.value) {
      status = localDatabase.guest?.accessToken?.isNotEmpty == true;
    } else if (localDatabase.userRole == UserRoles.member.value) {
      status = localDatabase.member?.accessToken?.isNotEmpty == true;
    }

    return status;
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
    bool authRequired = false,
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
