import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:provider/provider.dart';

import '../../core/config/api_config.dart';
import '../../core/route/route_paths.dart';
import '../../core/services/api/api_service.dart';
import '../../core/services/database/local_database.dart';
import '../../models/auth_model/sendotp.dart';
import '../../models/auth_model/validatemobile.dart';
import '../../models/auth_model/verifyotp.dart';
import '../../screens/auth/verify_otp.dart';
import '../../utils/widgets/widgets.dart';

class AuthControllers extends ChangeNotifier {
  /// 0)  SignOut User....

  Future clearUserData(BuildContext context) async {
    LocalDatabase localDatabase = Provider.of<LocalDatabase>(context, listen: false);
    // return await localDatabase.clearDatabase();
  }

  logOut({
    required BuildContext context,
    String? message,
    Color? color,
  }) async {
    try {
      await clearUserData(context).then((val) {
        notifyListeners();
        context.firstRoute();
        // context.pushReplacementNamed(Routs.introScreen);
      }).then((value) {
        showSnackBar(context: context, text: message ?? 'Successfully Logout', color: color ?? Colors.green);
      });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
  /// 1) Validate Mobile No. API...
  Future<Validatemobile?> validateMobile({
    required BuildContext context,
    required String? mobile,

  }) async {
    FocusScope.of(context).unfocus();

    Map<String, String> body = {
      'mobile': '$mobile',
    };

    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.validateMobile,
      body: body,
    );
//Processing API...
    Validatemobile? responseData;
   await loadingDialog(
      context: context,
      future: response,
    ).then((response) async {
      if (response != null) {
        Map<String, dynamic> json = response;
         responseData = Validatemobile.fromJson(json);
        if (responseData?.status == true) {
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.green);
          // context.pushNamed(Routs., extra: VerifyOTP(mobileNo: mobile, countryCode: countryCode));
        } else {
          showSnackBar(context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
        }

      }
    });
    return responseData;
  }

  /// 1) Send Otp login...
  Future<Sendotp?> sendOtp({
    required BuildContext context,
    required bool? isMobileValidated,
    required String? mobile,
    required String? firstName,
    required String? lastName,
    required String? referralCode,

  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'is_mobile_validated': '$isMobileValidated',
      'mobile': '$mobile',
      'first_name': '$firstName',
      'last_name': '$lastName',
      'referral_code': '$referralCode',
    };

    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.sendOtp,
      body: body,
    );
//Processing API...
    Sendotp? responseData;
    await loadingDialog(
      context: context,
      future: response,
    ).then((response) async {
      if (response != null) {
        Map<String, dynamic> json = response;
        responseData = Sendotp.fromJson(json);
        print('is validate ${responseData?.data?.toJson()}');
        print('is validate ${responseData?.status}');
        if (responseData?.status == true) {
          showSnackBar(context: context, text: responseData?.message ?? 'Something went wong', color: Colors.green);
         await context.pushNamed(Routs.verifyOTP, extra:  VerifyOTP(
            firstName: responseData?.data?.firstName,
            isMobileValidated: '${responseData?.data?.isMobileValidated}',
             lastName: responseData?.data?.lastName,
             mobileNo: responseData?.data?.mobile,
            referralCode: responseData?.data?.referralCode,
          ));
        } else {
          showSnackBar(context: context, text: 'Something went wong', color: Colors.red);
        }
      }
    });
    // return responseData;
  }

  /// 1) verify Otp login...
  Future<Verifyotp?> verifyOtp({
    required BuildContext context,
    required String? isMobileValidated,
    required String? mobile,
    required String? firstName,
    required String? lastName,
    required String? referralCode,
    required String? otp,

  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'is_mobile_validated': '$isMobileValidated',
      'mobile': '$mobile',
      'first_name': '$firstName',
      'last_name': '$lastName',
      'referral_code': '$referralCode',
      'otp': '$otp',
    };

    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.verifyOtp,
      body: body,
    );
//Processing API...
    Verifyotp? responseData;
    await loadingDialog(
      context: context,
      future: response,
    ).then((response) async {
      if (response != null) {
        Map<String, dynamic> json = response;
        responseData = Verifyotp.fromJson(json);
        if (responseData?.status == true) {
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.green);
          context.pushNamed(Routs.interests,);
        } else {
          showSnackBar(context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
    return responseData;
  }
}