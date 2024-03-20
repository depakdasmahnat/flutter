import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/controllers/dashboard/dashboard_controller.dart';
import 'package:mrwebbeast/core/config/api_config.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/core/services/api/exception_handler.dart';
import 'package:mrwebbeast/screens/auth/member/change_password.dart';
import 'package:provider/provider.dart';
import '../../core/services/api/api_service.dart';
import '../../core/services/database/local_database.dart';
import '../../models/default_model.dart';
import '../../models/member/auth/member_auth_model.dart';
import '../../screens/auth/member/verify_reset_password_otp.dart';
import '../../screens/dashboard/dashboard.dart';
import '../../utils/widgets/widgets.dart';

class MemberAuthControllers extends ChangeNotifier {
  /// 0)  SignOut User....

  Future clearUserData(BuildContext context) async {
    LocalDatabase localDatabase = Provider.of<LocalDatabase>(context, listen: false);

    return await localDatabase.clearDatabase();
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
        context.pushReplacementNamed(Routs.welcome);
      }).then((value) {
        showSnackBar(context: context, text: message ?? 'Successfully Logout', color: color ?? Colors.green);
      });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future logOutPopup(context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Logout'),
            content: const Text('Do you want to logout?'),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  logOut(context: context, message: 'Successfully Logged out');
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          );
        });
  }

  Future confirmationPopup({context, String? title, String? content, void Function()? onPressed}) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title ?? ''),
            content: Text(content ?? ''),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: onPressed,
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          );
        });
  }

  Future cancelRegistration({
    required BuildContext context,
    GestureTapCallback? onSuccess,
    String? message,
  }) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Cancel registration'),
            content: const Text('Do you want to cancel registration'),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (onSuccess == null) {
                    logOut(context: context, message: message);
                  } else {
                    onSuccess.call();
                  }
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          );
        });
  }

  Future deleteAccount(context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Delete Account'),
            content: const Text('Do you want to delete your account ?'),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  deleteAccountAPI(context: context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          );
        });
  }

  Future deleteAccountAPI({
    required BuildContext context,
  }) async {
//Processing API...

    loadingDialog(
      context: context,
      future: ApiService().get(
        endPoint: ApiEndpoints.deleteUser,
      ),
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
         print("check responce $response");
        DefaultModel? responseData = DefaultModel.fromJson(json);
        if (responseData.status == true) {
          logOut(context: context, message: responseData.message ?? 'User Successfully Deactivated');
        } else {
          context.pop();
          showSnackBar(
              context: context, text: responseData.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
  }

  /// 1) Login API...

  Future memberLogin({
    required BuildContext context,
    required String? enagicId,
    required String? password,
  }) async {
    FocusScope.of(context).unfocus();
    LocalDatabase localDatabase = LocalDatabase();
    debugPrint('deviceToken ${localDatabase.deviceToken}');
    Map<String, String> body = {
      'enagic_id': '$enagicId',
      'password': '$password',
      'deviceToken': localDatabase.deviceToken ?? '',
    };

    debugPrint('Sent Data is $body');
    try {
      var response = await loadingDialog(
        context: context,
        future: ApiService().post(
          endPoint: ApiEndpoints.login,
          body: body,
        ),
      );

      if (response != null && context.mounted) {
        Map<String, dynamic> json = response;
        MemberAuthModel responseData = MemberAuthModel.fromJson(json);

        if (responseData.status == true) {
          context.read<LocalDatabase>().saveMemberData(member: responseData.data);
          String route = responseData.data?.url ?? Routs.login;
          authNavigation(context: context, route: route);
          notifyListeners();
        } else {
          showError(context: context, message: responseData.message ?? 'Something Went Wrong');
        }
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    }
  }

  /// 2) Forget Password API...
  Future forgotPassword({
    required BuildContext context,
    required String? enagicId,
    required String? contact,
  }) async {
    FocusScope.of(context).unfocus();

    Map<String, String> body = {
      'enagic_id': '$enagicId',
      'contact': '$contact',
    };

    debugPrint('Sent Data is $body');
    try {
      var response = await loadingDialog(
        context: context,
        future: ApiService().post(
          endPoint: ApiEndpoints.forgotPassword,
          body: body,
        ),
      );

      if (response != null && context.mounted) {
        Map<String, dynamic> json = response;
        MemberAuthModel responseData = MemberAuthModel.fromJson(json);
        if (responseData.status == true) {
          // context.read<LocalDatabase>().saveMemberData(member: responseData.data);

          context.firstRoute();
          context.pushReplacementNamed(Routs.verifyForgotPasswordOtp,
              extra: VerifyResetPasswordOTP(
                enagicId: enagicId,
                contact: contact,
              ));
        } else {
          showError(context: context, message: responseData.message ?? 'Something Went Wrong');
        }
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    }
  }

  /// 3) Reset Password API...
  Future changePassword({
    required BuildContext context,
    required String? enagicId,
    required String? password,
  }) async {
    FocusScope.of(context).unfocus();

    Map<String, String> body = {
      'enagic_id': '$enagicId',
      'password': '$password',
    };

    debugPrint('Sent Data is $body');
    try {
      var response = await loadingDialog(
        context: context,
        future: ApiService().post(
          endPoint: ApiEndpoints.resetPassword,
          body: body,
        ),
      );
      if (response != null && context.mounted) {
        Map<String, dynamic> json = response;
        MemberAuthModel responseData = MemberAuthModel.fromJson(json);
        if (responseData.status == true) {
          // context.read<LocalDatabase>().saveMemberData(member: responseData.data);
          // String route = responseData.data?.url ?? Routs.login;
          context.firstRoute();
          context.pushReplacementNamed('/memberLogin');
          // authNavigation(context: context, route: "");
        } else {
          showError(context: context, message: responseData.message ?? 'Something Went Wrong');
        }
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    }
  }
  /// 2) Get Profile API...
  Future getProfile({required BuildContext context}) async {
    FocusScope.of(context).unfocus();

//Processing API...
    try {
      var response = await ApiService().get(
        endPoint: ApiEndpoints.fetchProfile,
      );
      if (response != null && context.mounted) {
        Map<String, dynamic> json = response;
        MemberAuthModel responseData = MemberAuthModel.fromJson(json);
        if (responseData.status == true) {
          context.read<LocalDatabase>().saveMemberData(member: responseData.data);
        }
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, false);
    }
  }

  Future verifyResetPasswordOtp({
    required BuildContext context,
    required String? enagicId,
    required String? contact,
    required String? otp,
  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'enagic_id': '$enagicId',
      'contact': '$contact',
      'otp': '$otp',
    };
    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.verifyForgotPasswordOtp,
      body: body,
    );

//Processing API...
    DefaultModel? responseData;
    await loadingDialog(
      context: context,
      future: response,
    ).then((response) async {
      if (response != null) {
        Map<String, dynamic> json = response;
        responseData = DefaultModel.fromJson(json);

        if (responseData?.status == true) {
          context.pushReplacementNamed(Routs.changePassword, extra: ChangePassword(enagicId: enagicId));
        } else {
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
    return responseData;
  }

  Future authNavigation({required BuildContext context, required String route}) async {
    print("check route $route");
    if (route == Routs.dashboard) {

      context.read<DashboardController>().changeDashBoardIndex(index: 0);
      context.firstRoute();
      context.pushReplacementNamed(Routs.dashboard, extra: const DashBoard(dashBoardIndex: 0));
    } else {
      context.firstRoute();
      context.pushReplacementNamed(route);
    }
  }
}
