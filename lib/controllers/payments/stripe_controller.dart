import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gaas/core/config/app_config.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/services/api/api_service.dart';
import 'package:gaas/main.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../core/services/database/local_database.dart';
import '../../models/partner/membership/subscriptions_model.dart';
import '../../models/payments/payment_intent_model.dart';
import '../partner/membership_controller.dart';

class StripeController extends ChangeNotifier {
  Stripe stripe = Stripe.instance;

  /// 1) fetch PaymentIntent API...

  bool loadingPaymentIntent = true;
  PaymentIntentModel? paymentIntentModel;
  PaymentIntentData? paymentIntentData;

  Future<PaymentIntentData?> _createPaymentIntent({
    required BuildContext context,
    required SubscriptionsData? data,
    required String? route,
    required String? currency,
  }) async {
    refresh() {
      loadingPaymentIntent = true;
      paymentIntentModel = null;
      paymentIntentData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingPaymentIntent = false;
      notifyListeners();
    }

    refresh();
    num amount = (num.tryParse("${data?.amount}") ?? 0) * 100;
    Map<String, String> body = {
      "amount": "$amount",
      "currency": currency ?? AppConfig.currency,
    };

    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

//Processing API...

    await loadingDialog(
      context: context,
      future: ApiService().post(
        context: context,
        endPoint: "/create_payment_intent",
        body: body,
        headers: headers,
      ),
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response as Map<String, dynamic>;
        PaymentIntentModel responseData = PaymentIntentModel.fromJson(json);

        if (responseData.status == true) {
          paymentIntentModel = responseData;
          paymentIntentData = responseData.data;
          notifyListeners();
        }
      }
    });

    apiResponseCompleted();

    return paymentIntentData;
  }

  ///1) Init Payment Sheet

  Future<void> initPaymentSheet({
    required BuildContext context,
    required SubscriptionsData? data,
    required String? route,
    required String? currency,
  }) async {
    try {
      // 1. create payment intent on the server
      paymentIntentData = await _createPaymentIntent(
        context: context,
        data: data,
        route: route,
        currency: currency,
      );

      LocalDatabase localDatabase = LocalDatabase();
      // 1) Create some billing-details
      BillingDetails billingDetails = BillingDetails(
        name: localDatabase.name ?? "",
        email: localDatabase.email ?? "",
        phone: localDatabase.mobile ?? "",
      );

      debugPrint("clientSecret :- ${paymentIntentData?.clientSecret}");

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: paymentIntentData?.clientSecret,
          merchantDisplayName: AppConfig.apkName,
          // Customer params
          customerId: "${LocalDatabase().id}",
          // customerEphemeralKeySecret: paymentIntentData?.clientSecret,
          primaryButtonLabel: 'Pay now',
          style: ThemeMode.light,

          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              background: Colors.white,
              primary: primaryColor,
            ),
            shapes: PaymentSheetShape(
              borderWidth: 4,
              shadow: PaymentSheetShadowParams(color: primaryColor),
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: primaryColor,
                  text: Colors.white,
                ),
              ),
            ),
          ),
          billingDetails: billingDetails,
        ),
      );

      confirmPayment(
        data: data,
        route: route,
        paymentOrderId: paymentIntentData?.clientSecret,
      );
    } catch (e) {
      String error = "$e";
      if (e is StripeException) {
        error = "${e.error.localizedMessage}";
      }
      debugPrint("Error :- $error");
      showSnackBar(context: context, text: error, color: Colors.red, icon: Icons.error);
      rethrow;
    }
  }

  Future<void> confirmPayment({
    required SubscriptionsData? data,
    required String? route,
    required String? paymentOrderId,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;
    if (context != null) {
      try {
        // 3. display the payment sheet.
        await stripe.presentPaymentSheet();

        paymentIntentModel = null;
        paymentIntentData = null;
        notifyListeners();
        if (context.mounted) {
          showSnackBar(context: context, text: 'Payment successfully completed', color: primaryColor);
          joinMemberShip(data: data, route: route, paymentOrderId: paymentOrderId);
        }
      } on Exception catch (e, s) {
        String error = "$e";

        if (e is StripeException) {
          error = "${e.error.localizedMessage}";
        }
        debugPrint("Error :- $error\n\n$s");
        showSnackBar(context: context, text: error, color: Colors.red, icon: Icons.error);
      }
    }
  }

  Future joinMemberShip({
    required SubscriptionsData? data,
    required String? route,
    required String? paymentOrderId,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;
    if (context != null && data != null) {
      await context.read<MembershipController>().createMembership(
            context: context,
            paymentOrderId: paymentOrderId,
            route: route,
            data: data,
          );
    }
  }

}
