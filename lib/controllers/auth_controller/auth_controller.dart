import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:provider/provider.dart';

import '../../core/config/api_config.dart';
import '../../core/route/route_paths.dart';
import '../../core/services/api/api_service.dart';
import '../../core/services/database/local_database.dart';
import '../../models/auth_model/validatemobile.dart';
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
  Future validateMobile({
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
    loadingDialog(
      context: context,
      future: response,
    ).then((response) async {
      if (response != null) {
        Map<String, dynamic> json = response;
        Validatemobile responseData = Validatemobile.fromJson(json);
        if (responseData.status == true) {
          print('check validate phone number ${responseData.status}');
          // context.pushNamed(Routs., extra: VerifyOTP(mobileNo: mobile, countryCode: countryCode));
        } else {
          showSnackBar(context: context, text: responseData.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
  }














}