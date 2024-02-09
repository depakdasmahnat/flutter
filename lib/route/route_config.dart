import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:gaas/screens/auth/phone_signin.dart';
import 'package:gaas/screens/camera/capture_image.dart';
import 'package:gaas/screens/map/map_view_home.dart';
import 'package:gaas/screens/partner/fresh/offers/add_offer.dart';
import 'package:gaas/screens/services/all_services.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import '../../screens/dashboard/dashboard.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/notifications/notifications.dart';
import '../core/constant/colors.dart';
import '../core/services/analytics/analytic_service.dart';
import '../core/services/database/local_database.dart';
import '../screens/auth/email_signin.dart';
import '../screens/auth/forget_password.dart';
import '../screens/auth/get_started.dart';
import '../screens/auth/signup.dart';
import '../screens/auth/verify_otp.dart';
import '../screens/dashboard/account_settings.dart';
import '../screens/dashboard/coin_transactions.dart';
import '../screens/dashboard/edit_profile.dart';
import '../screens/dashboard/global_search.dart';
import '../screens/dashboard/profile_screen.dart';
import '../screens/dashboard/wishlist_screen.dart';
import '../screens/feeds/feeds_screen.dart';
import '../screens/feeds/view_feed.dart';
import '../screens/home/all_producers.dart';
import '../screens/home/view_producer.dart';
import '../screens/map/change_map_location.dart';
import '../screens/map/service_map_view.dart';
import '../screens/orders/apply_coupon.dart';
import '../screens/orders/cart.dart';
import '../screens/orders/checkout.dart';
import '../screens/orders/delivery_zone_picker.dart';
import '../screens/orders/order_address_picker.dart';
import '../screens/orders/order_detail.dart';
import '../screens/orders/order_status.dart';
import '../screens/partner/fresh/add_product.dart';
import '../screens/partner/fresh/inventory_screen.dart';
import '../screens/partner/fresh/offers/offers_screen.dart';
import '../screens/partner/fresh/partner_products.dart';
import '../screens/partner/partner_dashboard.dart';
import '../screens/partner/partner_order_detail.dart';
import '../screens/partner/service/leads/leads_detail.dart';
import '../screens/partner/service/leads/leads_screen.dart';
import '../screens/partner/service/manage_services.dart';
import '../screens/partner/setup/select_delivery_zone.dart';
import '../screens/partner/setup/select_order_types.dart';
import '../screens/partner/setup/select_timeslots.dart';
import '../screens/partner/signup/join_as_partner.dart';
import '../screens/partner/signup/partner_membership.dart';
import '../screens/permission_screen.dart';
import '../screens/report_bug.dart';
import '../screens/services/request_quote.dart';

import '../screens/services/review_screen.dart';
import '../screens/services/service_provider_detail.dart';
import '../utils/widgets/image_opener.dart';
import '../utils/widgets/multiple_image_opener.dart';
import '../utils/widgets/web_view_screen.dart';
import 'route_paths.dart';

class RoutesConfig {
  /// Initial Route...
  static Widget initialScreen() {
    LocalDatabase localDatabase = LocalDatabase();
    late bool isAuthenticated = localDatabase.accessToken != null;
    return isAuthenticated ? const DashBoard() : const GetStarted();
  }

  ///1)  Route Config...

  static final GoRouter _router = GoRouter(
    observers: [
      AnalyticService.observer,
    ],
    navigatorKey: MyApp.navigatorKey,
    routes: [
      GoRoute(
        name: Routs.initialRoute,
        path: Routs.initialRoute,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: initialScreen());
        },
      ),
      GoRoute(
        name: Routs.getStarted,
        path: Routs.getStarted,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const GetStarted());
        },
      ),
      GoRoute(
        name: Routs.emailSignIn,
        path: Routs.emailSignIn,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const EmailSignIn());
        },
      ),
      GoRoute(
        name: Routs.phoneSignIn,
        path: Routs.phoneSignIn,
        pageBuilder: (context, state) {
          PhoneSignIn? data = state.extra as PhoneSignIn?;
          return materialPage(
              state: state,
              child: PhoneSignIn(
                forgetPasswordMode: data?.forgetPasswordMode,
                joinAsPartner: data?.joinAsPartner,
              ));
        },
      ),
      GoRoute(
        name: Routs.verifyOTP,
        path: Routs.verifyOTP,
        pageBuilder: (context, state) {
          VerifyOtp? data = state.extra as VerifyOtp?;
          return materialPage(
              state: state,
              child: VerifyOtp(
                mobile: data?.mobile,
                countryCode: data?.countryCode,
                joinAsPartner: data?.joinAsPartner,
                forgetPasswordMode: data?.forgetPasswordMode,
              ));
        },
      ),
      GoRoute(
        name: Routs.register,
        path: Routs.register,
        pageBuilder: (context, state) {
          SignUp? data = state.extra as SignUp?;
          return materialPage(
              state: state,
              child: SignUp(
                name: data?.name,
                email: data?.email,
                mobile: data?.mobile,
                isVerified: data?.isVerified,
                profilePic: data?.profilePic,
                countryCode: data?.countryCode,
              ));
        },
      ),
      GoRoute(
        name: Routs.dashboard,
        path: Routs.dashboard,
        pageBuilder: (context, state) {
          return customTransitionPage(state: state, child: const DashBoard(dashBoardIndex: 0));
        },
      ),
      GoRoute(
        name: Routs.globalSearch,
        path: Routs.globalSearch,
        pageBuilder: (context, state) {
          return customTransitionPage(state: state, child: const GlobalSearch());
        },
      ),
      GoRoute(
        name: Routs.wishlist,
        path: Routs.wishlist,
        pageBuilder: (context, state) {
          return customTransitionPage(state: state, child: const WishlistScreen());
        },
      ),
      GoRoute(
        name: Routs.editProfile,
        path: Routs.editProfile,
        pageBuilder: (context, state) {
          return customTransitionPage(state: state, child: const EditProfile());
        },
      ),
      GoRoute(
        name: Routs.viewProducer,
        path: Routs.viewProducer,
        pageBuilder: (context, state) {
          ViewProducer? data = state.extra as ViewProducer?;
          return materialPage(
              state: state,
              child: ViewProducer(
                partnerId: data?.partnerId,
                orderType: data?.orderType,
                product: data?.product,
              ));
        },
      ),
      GoRoute(
        name: Routs.allServices,
        path: Routs.allServices,
        pageBuilder: (context, state) {
          AllServices? data = state.extra as AllServices?;
          return materialPage(
              state: state,
              child: AllServices(
                categoryId: data?.categoryId,
                subCategoryId: data?.subCategoryId,
                bannerId: data?.bannerId,
                partnerIds: data?.partnerIds,
              ));
        },
      ),
      GoRoute(
        name: Routs.forgetPassword,
        path: Routs.forgetPassword,
        pageBuilder: (context, state) {
          ForgetPassword? data = state.extra as ForgetPassword?;
          return materialPage(state: state, child: ForgetPassword(email: data?.email));
        },
      ),
      GoRoute(
        name: Routs.serviceProviderDetail,
        path: Routs.serviceProviderDetail,
        pageBuilder: (context, state) {
          ServiceProviderDetailScreen? data = state.extra as ServiceProviderDetailScreen?;
          return materialPage(state: state, child: ServiceProviderDetailScreen(id: data?.id));
        },
      ),
      GoRoute(
        name: Routs.reviewScreen,
        path: Routs.reviewScreen,
        pageBuilder: (context, state) {
          ReviewScreen? data = state.extra as ReviewScreen?;
          return materialPage(state: state, child: ReviewScreen(id: data?.id));
        },
      ),
      GoRoute(
        name: Routs.applyCoupon,
        path: Routs.applyCoupon,
        pageBuilder: (context, state) {
          ApplyCoupon? data = state.extra as ApplyCoupon?;
          return materialPage(state: state, child: ApplyCoupon(id: data?.id));
        },
      ),
      GoRoute(
        name: Routs.feedsScreen,
        path: Routs.feedsScreen,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const FeedsScreen());
        },
      ),
      GoRoute(
        name: Routs.viewFeed,
        path: Routs.viewFeed,
        pageBuilder: (context, state) {
          ViewFeed? data = state.extra as ViewFeed?;
          return materialPage(state: state, child: ViewFeed(id: data?.id));
        },
      ),
      GoRoute(
        name: Routs.requestQuote,
        path: Routs.requestQuote,
        pageBuilder: (context, state) {
          RequestQuote? data = state.extra as RequestQuote?;

          return materialPage(
              state: state,
              child: RequestQuote(
                selectedService: data?.selectedService,
                serviceProvider: data?.serviceProvider,
                onSuccess: data?.onSuccess,
              ));
        },
      ),
      GoRoute(
        name: Routs.cart,
        path: Routs.cart,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const Cart());
        },
        redirect: (BuildContext context, GoRouterState state) {
          return authRequired(
              context: context, state: state, message: 'Please login to proceed to your cart.');
        },
      ),
      GoRoute(
        name: Routs.checkout,
        path: Routs.checkout,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const Checkout());
        },
        redirect: (BuildContext context, GoRouterState state) {
          return authRequired(
              context: context, state: state, message: 'Please login to proceed to checkout.');
        },
      ),
      GoRoute(
        name: Routs.partnerMembership,
        path: Routs.partnerMembership,
        pageBuilder: (context, state) {
          PartnerMembership? data = state.extra as PartnerMembership?;

          return materialPage(
              state: state,
              child: PartnerMembership(
                route: data?.route,
                type: data?.type,
                showBackBtn: data?.showBackBtn,
                showLogoutBtn: data?.showLogoutBtn,
              ));
        },
      ),
      GoRoute(
        name: Routs.orderStatus,
        path: Routs.orderStatus,
        pageBuilder: (context, state) {
          OrderStatus? data = state.extra as OrderStatus?;

          return materialPage(state: state, child: OrderStatus(placeOrderData: data?.placeOrderData));
        },
      ),
      GoRoute(
        name: Routs.orderDetail,
        path: Routs.orderDetail,
        pageBuilder: (context, state) {
          OrderDetail? data = state.extra as OrderDetail?;

          return materialPage(
              state: state,
              child: OrderDetail(
                orderId: data?.orderId,
                partnerId: data?.partnerId,
                refreshOrders: data?.refreshOrders,
              ));
        },
      ),
      GoRoute(
        name: Routs.partnerOffers,
        path: Routs.partnerOffers,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const PartnerOffersScreen());
        },
      ),
      GoRoute(
        name: Routs.addOffer,
        path: Routs.addOffer,
        pageBuilder: (context, state) {
          AddOffer? data = state.extra as AddOffer?;

          return materialPage(
              state: state,
              child: AddOffer(
                index: data?.index,
                offersData: data?.offersData,
              ));
        },
      ),
      GoRoute(
        name: Routs.manageServices,
        path: Routs.manageServices,
        pageBuilder: (context, state) {
          ManageService? data = state.extra as ManageService?;

          return materialPage(state: state, child: ManageService(registerMode: data?.registerMode));
        },
      ),
      GoRoute(
        name: Routs.partnerProducts,
        path: Routs.partnerProducts,
        pageBuilder: (context, state) {
          PartnerProducts? data = state.extra as PartnerProducts?;

          return materialPage(state: state, child: PartnerProducts(bannerId: data?.bannerId));
        },
      ),
      GoRoute(
        name: Routs.partnerOrderDetail,
        path: Routs.partnerOrderDetail,
        pageBuilder: (context, state) {
          PartnerOrderDetail? data = state.extra as PartnerOrderDetail?;

          return materialPage(
              state: state, child: PartnerOrderDetail(orderId: data?.orderId, partnerId: data?.partnerId));
        },
      ),
      GoRoute(
        name: Routs.profileScreen,
        path: Routs.profileScreen,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const ProfileScreen());
        },
      ),
      GoRoute(
        name: Routs.partnerInventory,
        path: Routs.partnerInventory,
        pageBuilder: (context, state) {
          PartnerInventory? data = state.extra as PartnerInventory?;

          return materialPage(state: state, child: PartnerInventory(id: data?.id));
        },
      ),
      GoRoute(
        name: Routs.allProducers,
        path: Routs.allProducers,
        pageBuilder: (context, state) {
          AllProducersScreen? data = state.extra as AllProducersScreen?;
          return materialPage(
              state: state,
              child: AllProducersScreen(
                categoryId: data?.categoryId,
                subCategoryId: data?.subCategoryId,
                orderType: data?.orderType,
                type: data?.type,
                bannerId: data?.bannerId,
                partnerIds: data?.partnerIds,
              ));
        },
      ),
      GoRoute(
        name: Routs.joinAsPartner,
        path: Routs.joinAsPartner,
        pageBuilder: (context, state) {
          JoinAsPartner? data = state.extra as JoinAsPartner?;
          return materialPage(
              state: state,
              child: JoinAsPartner(
                  editMode: data?.editMode,
                  isDirect: data?.isDirect,
                  type: data?.type,
                  selectedServiceTypes: data?.selectedServiceTypes));
        },
      ),
      GoRoute(
        name: Routs.addProduct,
        path: Routs.addProduct,
        pageBuilder: (context, state) {
          AddProduct? data = state.extra as AddProduct?;
          return materialPage(
              state: state,
              child: AddProduct(productsData: data?.productsData, templateData: data?.templateData));
        },
      ),
      GoRoute(
        name: Routs.selectOrderTypes,
        path: Routs.selectOrderTypes,
        pageBuilder: (context, state) {
          SelectOrderTypes? data = state.extra as SelectOrderTypes?;
          return materialPage(
              state: state,
              child: SelectOrderTypes(
                route: data?.route,
                editMode: data?.editMode,
                type: data?.type,
              ));
        },
      ),
      GoRoute(
        name: Routs.selectTimeSlots,
        path: Routs.selectTimeSlots,
        pageBuilder: (context, state) {
          SelectTimeSlots? data = state.extra as SelectTimeSlots?;
          return materialPage(
              state: state,
              child: SelectTimeSlots(
                route: data?.route,
                editMode: data?.editMode,
                type: data?.type,
                selectedOrderTypes: data?.selectedOrderTypes,
                timeLineStatus: data?.timeLineStatus,
              ));
        },
      ),
      GoRoute(
        name: Routs.selectDeliveryZones,
        path: Routs.selectDeliveryZones,
        pageBuilder: (context, state) {
          SelectDeliveryZones? data = state.extra as SelectDeliveryZones?;
          return materialPage(
              state: state,
              child: SelectDeliveryZones(
                  route: data?.route,
                  type: data?.type,
                  editMode: data?.editMode,
                  selectedOrderTypes: data?.selectedOrderTypes));
        },
      ),
      GoRoute(
        name: Routs.homeScreen,
        path: Routs.homeScreen,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const HomeScreen());
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
      ),
      GoRoute(
        name: Routs.notifications,
        path: Routs.notifications,
        pageBuilder: (context, state) {
          NotificationScreen? data = state.extra as NotificationScreen?;
          return materialPage(state: state, child: NotificationScreen(partnerType: data?.partnerType));
        },
        redirect: (BuildContext context, GoRouterState state) {
          return authRequired(
              context: context, state: state, message: 'Please login to proceed to your notifications.');
        },
      ),
      GoRoute(
        name: Routs.mapViewHome,
        path: Routs.mapViewHome,
        pageBuilder: (context, state) {
          MapViewHome? data = state.extra as MapViewHome?;
          return materialPage(
              state: state,
              child: MapViewHome(
                latitude: data?.latitude,
                longitude: data?.longitude,
                updateLocation: data?.updateLocation,
                categoryId: data?.categoryId,
                subcategoryId: data?.subcategoryId,
                bannerId: data?.bannerId,
                partnerIds: data?.partnerIds,
                sortBy: data?.sortBy,
                selectedFilterIds: data?.selectedFilterIds,
                filterOptions: data?.filterOptions,
                otherFilterBy: data?.otherFilterBy,
                type: data?.type,
              ));
        },
      ),
      GoRoute(
        name: Routs.serviceMapViewHome,
        path: Routs.serviceMapViewHome,
        pageBuilder: (context, state) {
          ServiceMapViewHome? data = state.extra as ServiceMapViewHome?;
          return materialPage(
              state: state,
              child: ServiceMapViewHome(
                latitude: data?.latitude,
                longitude: data?.longitude,
                updateLocation: data?.updateLocation,
                categoryId: data?.categoryId,
                subcategoryId: data?.subcategoryId,
                bannerId: data?.bannerId,
                partnerIds: data?.partnerIds,
                sortBy: data?.sortBy,
                selectedFilterIds: data?.selectedFilterIds,
                filterOptions: data?.filterOptions,
                otherFilterBy: data?.otherFilterBy,
                type: data?.type,
              ));
        },
      ),
      GoRoute(
        name: Routs.freshProduce,
        path: Routs.freshProduce,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const PartnerDashBoard(type: ServiceType.freshProduce));
        },
      ),
      GoRoute(
        name: Routs.nursery,
        path: Routs.nursery,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const PartnerDashBoard(type: ServiceType.nursery));
        },
      ),
      GoRoute(
        name: Routs.leads,
        path: Routs.leads,
        pageBuilder: (context, state) {
          LeadsScreen? data = state.extra as LeadsScreen?;
          return materialPage(state: state, child: LeadsScreen(partnerLeads: data?.partnerLeads ?? false));
        },
      ),
      GoRoute(
        name: Routs.partnerLeadsDetail,
        path: Routs.partnerLeadsDetail,
        pageBuilder: (context, state) {
          LeadsDetail? data = state.extra as LeadsDetail?;
          return materialPage(
              state: state, child: LeadsDetail(id: data?.id, partnerLeads: data?.partnerLeads ?? true));
        },
      ),
      GoRoute(
        name: Routs.leadsDetail,
        path: Routs.leadsDetail,
        pageBuilder: (context, state) {
          LeadsDetail? data = state.extra as LeadsDetail?;

          return materialPage(
              state: state, child: LeadsDetail(id: data?.id, partnerLeads: data?.partnerLeads ?? false));
        },
      ),
      GoRoute(
        name: Routs.coinTransactions,
        path: Routs.coinTransactions,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const CoinTransactionsScreen());
        },
      ),
      GoRoute(
        name: Routs.serviceProvider,
        path: Routs.serviceProvider,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const PartnerDashBoard(type: ServiceType.serviceProvider));
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
        name: Routs.report,
        path: Routs.report,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const ReportBug());
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
                imageUrl: data?.imageUrl,
                networkImage: data?.networkImage,
                file: data?.file,
              ));
        },
      ),
      GoRoute(
        name: Routs.captureImage,
        path: Routs.captureImage,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const CaptureImage());
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
                imageUrls: data?.imageUrls,
                networkImages: data?.networkImages,
                files: data?.files,
              ));
        },
      ),
      GoRoute(
        name: Routs.changeMapLocation,
        path: Routs.changeMapLocation,
        pageBuilder: (context, state) {
          ChangeMapLocation? data = state.extra as ChangeMapLocation?;

          return materialPage(
              state: state,
              child: ChangeMapLocation(
                latitude: data?.latitude,
                longitude: data?.longitude,
                updateLocation: data?.updateLocation,
                radius: data?.radius,
                tempLocation: data?.tempLocation,
              ));
        },
      ),
      GoRoute(
        name: Routs.deliveryZonePicker,
        path: Routs.deliveryZonePicker,
        pageBuilder: (context, state) {
          DeliveryZonePicker? data = state.extra as DeliveryZonePicker?;

          return materialPage(
              state: state,
              child: DeliveryZonePicker(
                partnerId: data?.partnerId,
                latitude: data?.latitude,
                longitude: data?.longitude,
                deliveryZones: data?.deliveryZones,
              ));
        },
      ),
      GoRoute(
        name: Routs.oderAddressPicker,
        path: Routs.oderAddressPicker,
        pageBuilder: (context, state) {
          OderAddressPicker? data = state.extra as OderAddressPicker?;

          return materialPage(
              state: state,
              child: OderAddressPicker(
                partnerId: data?.partnerId,
                latitude: data?.latitude,
                longitude: data?.longitude,
              ));
        },
      ),
      GoRoute(
        name: Routs.accountSettings,
        path: Routs.accountSettings,
        pageBuilder: (context, state) {
          return materialPage(state: state, child: const AccountSettings());
        },
      ),
    ],
    errorPageBuilder: (context, state) {
      return unknownRoute(context: context, state: state);
    },
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
              color: primaryColor,
              child: const Text("Home"),
              onPressed: () {
                context.go(Routs.getStarted);
              },
            ),
          ),
        ],
      ),
    ));
  }

  ///3)  Material Page ...

  static MaterialPage<dynamic> materialPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return MaterialPage(key: state.pageKey, child: child);
  }

  ///4)  Cupertino Page...
  static CupertinoPage<dynamic> cupertinoPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CupertinoPage(key: state.pageKey, child: child);
  }

  ///5)  Cupertino Page...

  static CustomTransitionPage<dynamic> customTransitionPage({
    required GoRouterState state,
    required Widget child,
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
        return FadeTransition(
          opacity: CurveTween(curve: curve ?? Curves.easeInOutCirc).animate(animation),
          child: child,
        );
      },
    );
  }

  static authRequired({
    required BuildContext context,
    GoRouterState? state,
    String? message,
  }) {
    if (LocalDatabase().accessToken == null) {
      showSnackBar(context: context, text: message ?? "Please login to proceed.", color: Colors.red);
      return Routs.getStarted;
    } else {
      return null;
    }
  }
}
