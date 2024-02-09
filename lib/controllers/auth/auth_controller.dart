import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/orders/cart_controller.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/extensions/normal/build_context_extension.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/models/auth/authentication.dart';
import 'package:gaas/models/auth/user_data.dart';
import 'package:gaas/route/route_paths.dart';
import 'package:gaas/screens/auth/verify_otp.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../core/enums/enums.dart';
import '../../core/services/api/api_service.dart';
import '../../core/services/database/local_database.dart';
import '../../firebase_options.dart';
import '../../models/auth/send_otp_model.dart';
import '../../models/default_model.dart';
import '../../models/orders/partner_time_slots_model.dart';
import '../../models/partner/partner_status_model.dart';
import '../../screens/auth/forget_password.dart';
import '../../screens/auth/signup.dart';
import '../../screens/partner/signup/select_partner_service.dart';
import '../../utils/validators.dart';
import '../../utils/widgets/custom_bottom_sheet.dart';
import '../dashboard_controller.dart';
import '../location/location_controller.dart';

class AuthControllers extends ChangeNotifier {
  static FirebaseAuth auth = FirebaseAuth.instance;

  clearAuth() {
    partnerStatusData = null;
    isFreshProducer = null;
    isNursery = null;
    isServiceProvider = null;
    notifyListeners();
  }

  authRequired({
    required BuildContext context,
     String? message,
  }) {
    if (LocalDatabase().accessToken == null) {
      showSnackBar(context: context, text: message??"Please log in to proceed.", color: Colors.red);
      context.pushNamed(Routs.getStarted);

      return true;
    }
  }

  cleanData({
    required BuildContext context,
    String? message,
  }) async {
    // try {
    //   await GoogleSignIn().signOut();
    //   await FirebaseAuth.instance.signOut();
    // } catch (e, s) {
    //   debugPrint("Error is $e & $s");
    //   return null;
    // }

    await LocalDatabase().database.clear().then((value) {
      showSnackBar(context: context, text: message ?? "Successfully Logout");
      clearAuth();
      context.read<CartController>().clearData(context);
      Navigator.popUntil(context, (route) => route.isFirst);
      context.pushReplacement(Routs.getStarted);
    });
  }

  /// 0) SignOut User....

  Future signOut({required BuildContext context}) {
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Logout"),
            content: const Text("Do you want To Logout"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  cleanData(context: context);
                },
                child: const Text(
                  "Logout",
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
            title: const Text("Delete Account"),
            content: const Text("Do You Want To Delete Account"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  deleteAccountAPI(context: context);
                },
                child: const Text(
                  "Delete",
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
    LocalDatabase localDatabase = LocalDatabase();

    Map<String, String> headers = {"Authorization": "Bearer ${localDatabase.accessToken}"};
//Processing API...

    loadingDialog(
      context: context,
      future: ApiService().get(
        context: context,
        endPoint: "/delete_account",
        headers: headers,
      ),
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        DefaultModel? responseData = DefaultModel.fromJson(json);
        if (responseData.status == true) {
          cleanData(context: context, message: responseData.message ?? "Account Successfully Deleted");
        } else {
          Navigator.of(context).pop();
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
    });
  }

  authNavigation({
    required BuildContext context,
    final String? name,
    final String? email,
    final String? mobile,
    final String? countryCode,
    final String? profilePic,
    final String? joinAsPartner,
    final bool? isVerified,
    required AuthenticationModel? responseData,
  }) async {
    String? route = responseData?.url;
    debugPrint("Go to Route => $route");
    LocalDatabase localDatabase = Provider.of<LocalDatabase>(context, listen: false);

    await localDatabase.saveUser(user: responseData?.data).whenComplete(() {
      context.firstRoute();
      if (route == Routs.dashboard) {
        context.read<DashboardController>().setDashBoardIndex(index: 0, context: context);
        context.pushReplacementNamed(Routs.dashboard);
      } else if (route == Routs.verifyOTP) {
        context.pushReplacementNamed(Routs.verifyOTP,
            extra: VerifyOtp(mobile: mobile, countryCode: countryCode, joinAsPartner: joinAsPartner));
      } else if (route == Routs.forgetPassword) {
        context.pushReplacementNamed(Routs.forgetPassword, extra: ForgetPassword(email: email));
      } else if (route == Routs.register) {
        context.pushReplacementNamed(Routs.register,
            extra: SignUp(
                name: name,
                email: email,
                mobile: mobile,
                profilePic: profilePic,
                countryCode: countryCode,
                isVerified: isVerified));
      } else if (route == Routs.joinAsPartner) {
        CustomBottomSheet.show(
          context: context,
          isDismissible: false,
          isScrollControlled: true,
          body: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: const SelectPartnerService(isDirect: true),
          ),
        );
      } else {
        showSnackBar(context: context, text: "Unknown Route $route");
      }
    });
  }

  /// 1) Firebase SignIn With Google Authentication...

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: DefaultFirebaseOptions.currentPlatform.iosClientId,
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        await auth.signInWithCredential(credential).then((userCredential) async {
          UserInfo? userInfo;
          if (userCredential.user?.providerData.haveData == true) {
            userInfo = userCredential.user?.providerData.first;
          }
          debugPrint("User Credentials Are ${userCredential.user?.providerData.first}");
          user = userCredential.user;
          String? name = userInfo?.displayName ?? user?.displayName;
          String? email = userInfo?.email ?? user?.email;
          String? uid = user?.uid;
          String? profilePic = userInfo?.photoURL ?? user?.photoURL;

          String? accessToken = userCredential.credential?.accessToken;
          String? phoneNumber = userInfo?.phoneNumber ?? user?.phoneNumber;
          debugPrint("isNewUser ${userCredential.additionalUserInfo?.isNewUser}");

          return await socialLogin(
            context: context,
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            deviceToken: LocalDatabase().deviceToken,
            profilePic: profilePic,
            authType: "Gmail",
            authProviderId: uid,
            accessToken: accessToken,
          );
        });

        debugPrint("Successfully SignIn");
      } on FirebaseAuthException catch (e, s) {
        String error = "Something Went Wrong";
        if (e.code == 'account-exists-with-different-credential') {
          error = "Account exists with different credential";
        } else if (e.code == 'invalid-credential') {
          error = "Invalid Credential";
        }
        if (context.mounted) {
          showSnackBar(context: context, text: error, color: Colors.red);
        }
        debugPrint("FirebaseAuthException is $e & $s");
      } catch (e, s) {
        debugPrint("Error is $e & $s");
      }
    }

    return user;
  }

  /// 2) Firebase SignIn With Apple Authentication...

  Future<User?> signInWithApple({required BuildContext context}) async {
    User? user;

    try {
      UserCredential? userCredential;
      try {
        AppleAuthProvider appleProvider = AppleAuthProvider();
        appleProvider.addScope('name');
        appleProvider.addScope('email');
        debugPrint("Scopes are :-${appleProvider.scopes.join(",")}");
        userCredential = await FirebaseAuth.instance.signInWithProvider(appleProvider);
      } catch (e, s) {
        debugPrint("Error :- SignInWithApple $e $s ");
      }

      if (userCredential != null) {
        UserInfo? userInfo;
        if (userCredential.user?.providerData.haveData == true) {
          userInfo = userCredential.user?.providerData.first;
        }

        debugPrint("User Credentials Are ${userCredential.user?.providerData.first}");
        user = userCredential.user;
        String? name = userInfo?.displayName ?? user?.displayName;
        String? email = userInfo?.email ?? user?.email;
        String? uid = user?.uid;
        String? profilePic = userInfo?.photoURL ?? user?.photoURL;

        String? accessToken = userCredential.credential?.accessToken;
        String? phoneNumber = userInfo?.phoneNumber ?? user?.phoneNumber;

        if (context.mounted) {
          return await socialLogin(
            context: context,
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            deviceToken: LocalDatabase().deviceToken,
            profilePic: profilePic,
            authType: "Apple",
            authProviderId: uid,
            accessToken: accessToken,
          );
        }
      }
    } on FirebaseAuthException catch (e, s) {
      if (e.code == 'account-exists-with-different-credential') {
        showSnackBar(context: context, text: "Account Exists With Different Credential", color: Colors.red);
      } else if (e.code == 'invalid-credential') {
        showSnackBar(context: context, text: "Invalid Credential", color: Colors.red);
      }
      debugPrint("FirebaseAuthException is $e & $s");
    } catch (e, s) {
      debugPrint("Error is $e & $s");
    }

    return user;
  }

  ///8)Social Login API...
  Future socialLogin({
    required BuildContext context,
    required String? name,
    required String? email,
    required String? profilePic,
    required String? authType,
    required String? authProviderId,
    String? phoneNumber,
    required String? deviceToken,
    required String? accessToken,
  }) async {
    if (email?.isEmpty == true) {
      showSnackBar(context: context, text: "Email Address is required", color: Colors.red);
      return;
    }
    Map<String, String> body = {
      "name": name ?? "",
      "email": email ?? "",
      "profile_pic": profilePic ?? "",
      "provider": authType ?? "",
      "auth_provider_id": authProviderId ?? "",
      "device_token": deviceToken ?? "",
      "access_token": accessToken ?? "",
    };
    debugPrint("Sent Data is $body");

//Processing API...
    return loadingDialog(
      context: context,
      future: ApiService().post(endPoint: "/social_login", body: (body), context: context),
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        AuthenticationModel responseData = AuthenticationModel.fromJson(json);
        if (responseData.status == true) {
          return authNavigation(
            context: context,
            name: name,
            email: email,
            profilePic: profilePic,
            responseData: responseData,
          );
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      } else {
        debugPrint("Response is $response");
      }
    });
  }

  /// 3) Login With Mobile API...
  Future sendOtp({
    required BuildContext context,
    required String? mobile,
    required String? countryCode,
    required String? joinAsPartner,
    required bool? forgetPasswordMode,
  }) async {
    Map<String, String> body = {
      "mobile": Validator.extractNumbersFromString(mobile) ?? "",
      "country_code": countryCode ?? "",
      "forget_password_mode": forgetPasswordMode == true ? "Yes" : "No",
      "join_as_partner": joinAsPartner ?? "",
    };

    debugPrint("Sent Data is $body");

    var response = ApiService().post(context: context, endPoint: "/send_otp", body: body);
//Processing API...
    await loadingDialog(
      context: context,
      future: response,
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        SendOtpModel responseData = SendOtpModel.fromJson(json);
        if (responseData.status == true) {
          context.pushNamed(Routs.verifyOTP,
              extra: VerifyOtp(
                mobile: mobile,
                countryCode: countryCode,
                joinAsPartner: joinAsPartner,
                forgetPasswordMode: forgetPasswordMode,
              ));
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
    });
  }

  Future reSendOtp({
    required BuildContext context,
    required String? mobile,
    required String? countryCode,
    required String? joinAsPartner,
    required bool? forgetPasswordMode,
  }) async {
    Map<String, String> body = {
      "mobile": Validator.extractNumbersFromString(mobile) ?? "",
      "country_code": countryCode ?? "",
      "forget_password_mode": forgetPasswordMode == true ? "Yes" : "No",
      "join_as_partner": joinAsPartner ?? "",
    };

    debugPrint("Sent Data is $body");

    var response = ApiService().post(context: context, endPoint: "/send_otp", body: body);
//Processing API...
    await loadingDialog(
      context: context,
      future: response,
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        SendOtpModel responseData = SendOtpModel.fromJson(json);
        if (responseData.status == true) {
          showSnackBar(context: context, text: "OTP Resend Successfully!");
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
    });
  }

  /// 4)Verify Otp API...
  Future verifyOtp({
    required BuildContext context,
    required String? phoneNo,
    required String? otp,
    required String? countryCode,
    required bool? forgetPasswordMode,
    required String? joinAsPartner,
  }) async {
    Map<String, String> body = {
      "mobile": Validator.extractNumbersFromString(phoneNo) ?? "",
      "otp": otp ?? "",
      "country_code": countryCode ?? "",
      "join_as_partner": joinAsPartner ?? "No",
      "forget_password_mode": forgetPasswordMode == true ? "Yes" : "No",
      "device_token": LocalDatabase().deviceToken ?? "",
    };

    debugPrint("Sent Data is $body");

    var response = ApiService().post(context: context, endPoint: "/verify_otp", body: body);
//Processing API...
    loadingDialog(
      context: context,
      future: response,
    ).then((response) {
      Map<String, dynamic> json = response;
      if (response != null) {
        AuthenticationModel responseData = AuthenticationModel.fromJson(json);
        if (responseData.status == true) {
          authNavigation(
            context: context,
            responseData: responseData,
            mobile: phoneNo,
            countryCode: countryCode,
            joinAsPartner: joinAsPartner,
            isVerified: true,
          );
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
    });
  }

  /// 5) Login With Mobile API...
  Future emailLogin({
    required BuildContext context,
    required String email,
    required String? password,
  }) async {
    Map<String, String> body = {
      "email": email,
      "password": password ?? "",
      "device_token": LocalDatabase().deviceToken ?? "",
    };
    debugPrint("Sent Data is ${jsonEncode(body)}");

    var response = ApiService().post(context: context, endPoint: "/login_using_email", body: body);
//Processing API...
    loadingDialog(
      context: context,
      future: response,
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        AuthenticationModel responseData = AuthenticationModel.fromJson(json);
        if (responseData.status == true) {
          authNavigation(context: context, responseData: responseData, email: email);
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
    });
  }

  /// 6)  Forget Password  API...

  Future forgetPassword({
    required BuildContext context,
    required String password,
  }) async {
    Map<String, String> body = {
      "password": password,
    };
    debugPrint("Sent Data is ${jsonEncode(body)}");
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    var response = ApiService().post(
      context: context,
      endPoint: "/forget_password",
      body: body,
      headers: defaultHeaders,
    );
//Processing API...
    loadingDialog(
      context: context,
      future: response,
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        DefaultModel? responseData;

        responseData = DefaultModel.fromJson(json);

        if (responseData.status == true) {
          context.firstRoute();
          context.read<DashboardController>().setDashBoardIndex(index: 0, context: context);
          context.pushReplacementNamed(Routs.dashboard);
          showSnackBar(
              context: context, text: responseData.message ?? "Email Sent Successfully", color: primaryColor);
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
    });
  }

  /// 7) Register API...
  Future register({
    required BuildContext context,
    required String? name,
    required String? email,
    required String? countryCode,
    required String? mobile,
    required String? password,
    required String? profilePic,
    required String? referralCode,
    required bool? isVerified,
  }) async {
    Map<String, String> body = {
      "name": name ?? "",
      "mobile": Validator.extractNumbersFromString(mobile) ?? "",
      "country_code": countryCode ?? "",
      "email": email ?? "",
      "password": password ?? "",
      "profile_pic": profilePic ?? "",
      "referral_code": referralCode ?? "",
      "is_verified": isVerified == true ? "Yes" : "No",
      "device_token": LocalDatabase().deviceToken ?? "",
    };

    debugPrint("Sent Data is $body");
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    var response =
        ApiService().post(context: context, endPoint: "/register_user", headers: defaultHeaders, body: body);
//Processing API...
    loadingDialog(
      context: context,
      future: response,
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        AuthenticationModel responseData = AuthenticationModel.fromJson(json);

        if (responseData.status == true) {
          authNavigation(
            context: context,
            responseData: responseData,
            name: name,
            email: email,
            mobile: mobile,
            countryCode: countryCode,
          );
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wrong", color: Colors.red);
        }
      }
    });
  }

  /// 8) fetch UserData API...

  UserData? userData;

  Future<UserData?> fetchProfile({
    required BuildContext context,
  }) async {
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_profile",
      headers: defaultHeaders,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        AuthenticationModel responseData = AuthenticationModel.fromJson(json);

        LocalDatabase localDatabase = LocalDatabase();
        if (responseData.status == true) {
          userData = responseData.data;
          localDatabase.saveUser(user: userData);
          notifyListeners();
          context.read<LocationController>().getLocalAddress();
        }
      }
    }).catchError((e, s) {
      debugPrint("Error is $e & $s");
    });

    return userData;
  }

  /// 10) Edit Profile API...
  Future editProfile({
    required BuildContext context,
    required String? name,
    required String? email,
    required File? profilePhoto,
  }) async {
    Map<String, String> body = {
      "name": name ?? "",
      "email": email ?? "",
    };
    debugPrint("Sent Data is $body");
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    var response = ApiService().multiPart(
      context: context,
      endPoint: "/edit_profile",
      headers: defaultHeaders,
      body: body,
      multipartFile: [
        if (profilePhoto != null) MultiPartData(field: "profile_photo", filePath: profilePhoto.path),
      ],
    );

    //Processing API...
    await loadingDialog(
      context: context,
      future: response,
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = jsonDecode(response);
        AuthenticationModel responseData = AuthenticationModel.fromJson(json);
        LocalDatabase localDatabase = LocalDatabase();

        if (responseData.status == true) {
          userData = responseData.data;
          localDatabase.saveUser(user: userData);
          notifyListeners();
          context.firstRoute();
          context.pushReplacementNamed(Routs.dashboard);
          showSnackBar(context: context, text: responseData.message ?? "User Profile Updated");
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wrong", color: Colors.red);
        }
      }
    });
  }

  /// 11) Check Partner Request API...
  ///
  PartnerStatusModel? partnerStatusData;
  bool? isFreshProducer = LocalDatabase().isFreshProducer;
  bool? isNursery = LocalDatabase().isNursery;
  bool? isServiceProvider = LocalDatabase().isServiceProvider;

  Future<PartnerStatusModel?> checkPartnerRequest({required BuildContext context}) async {
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    LocalDatabase localDatabase = LocalDatabase();

    await ApiService()
        .get(
      context: context,
      endPoint: "/check_partner_request",
      headers: defaultHeaders,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;

        PartnerStatusModel? responseData = PartnerStatusModel.fromJson(json);
        isFreshProducer = responseData.freshProduce?.status == PartnerRequests.accepted.value;
        isNursery = responseData.nursery?.status == PartnerRequests.accepted.value;
        isServiceProvider = responseData.serviceProvider?.status == PartnerRequests.accepted.value;
        notifyListeners();
        localDatabase.setIsFreshProducer(isFreshProducer);
        localDatabase.setIsNursery(isNursery);
        localDatabase.setIsServiceProvider(isServiceProvider);

        partnerStatusData = responseData;
        notifyListeners();
      }
    }).catchError((e, s) {
      debugPrint("Error is $e & $s");
    });

    return partnerStatusData;
  }

  /// 7) fetch PartnerService API...

  bool loadingPartnerService = true;
  PartnerServiceModel? partnerServiceModel;
  List<PartnerServicesData>? partnerServiceData;

  Future<List<PartnerServicesData>?> fetchPartnerServices({
    required BuildContext context,
    required num? partnerId,
    required DateTime? date,
  }) async {
    refresh() {
      loadingPartnerService = true;
      partnerServiceModel = null;
      partnerServiceData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingPartnerService = false;
      notifyListeners();
    }

    ServiceType type = context.read<DashboardController>().serviceType;
    refresh();
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": type.value,
      "partner_id": "$partnerId",
      "date": date != null ? date.toString() : "",
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_cart_timeslots${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        PartnerServiceModel responseData = PartnerServiceModel.fromJson(json);

        if (responseData.status == true) {
          partnerServiceModel = responseData;
          partnerServiceData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return partnerServiceData;
  }
}
