import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/constant/enums.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:mrwebbeast/models/auth_model/guest_data.dart';
import 'package:provider/provider.dart';

import '../../core/config/api_config.dart';
import '../../core/route/route_paths.dart';
import '../../core/services/api/api_service.dart';
import '../../core/services/database/local_database.dart';
import '../../models/auth_model/validatemobile.dart';
import '../../models/auth_model/fetchinterestcategory.dart';
import '../../models/auth_model/fetchinterestquestions.dart';
import '../../models/auth_model/sendotp.dart';
import '../../models/auth_model/validatemobile.dart';
import '../../models/auth_model/verifyotp.dart';
import '../../models/default/default_model.dart';
import '../../screens/auth/verify_otp.dart';
import '../../utils/widgets/widgets.dart';
import '../dashboard/dashboard_controller.dart';

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
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
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
    required String? address,
    required String? referralCode,
  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'is_mobile_validated': '$isMobileValidated',
      'mobile': '$mobile',
      'first_name': '$firstName',
      'last_name': '$lastName',
      'address': '$address',
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

        if (responseData?.status == true) {
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.green);
          await context.pushNamed(Routs.verifyOTP,
              extra: VerifyOTP(
                firstName: responseData?.data?.firstName,
                isMobileValidated: '${responseData?.data?.isMobileValidated}',
                lastName: responseData?.data?.lastName,
                mobileNo: responseData?.data?.mobile,
                address: responseData?.data?.address,
                referralCode: responseData?.data?.referralCode,
              ));
        } else {
          showSnackBar(context: context, text: '${responseData?.message}', color: Colors.red);
        }
      }
    });
    // return responseData;
  }

  /// 1) verify Otp login...
   String userName ='';
  Future<Verifyotp?> verifyOtp({
    required BuildContext context,
    required String? isMobileValidated,
    required String? mobile,
    required String? firstName,
    required String? lastName,
    required String? referralCode,
    required String? address,
    required String? otp,
  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'is_mobile_validated': '$isMobileValidated',
      'mobile': '$mobile',
      'first_name': '$firstName',
      'last_name': '$lastName',
      'referral_code': '$referralCode',
      'address': '$address',
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
          context.read<LocalDatabase>().saveGuestData(guest: responseData?.data);
          GuestData? guest = context.read<LocalDatabase>().guest;
          showSnackBar(context: context, text: responseData?.message ?? 'Something went wong', color: Colors.green);
          context.pushReplacementNamed(responseData?.url??Routs.interests,);
        } else {
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
    return responseData;
  }

  bool isLoading = false;

  /// 1) fetch interest category...
  // Fetchinterestcategory?  fetchInterestCategory;
  //
  // Future<Fetchinterestcategory?> fetchInterestCategories({
  //   required BuildContext context,
  //   required String type,
  // }) async {
  //   // refresh() {
  //   //   loadingExerciseDetail = true;
  //   //   exerciseDetailModel = null;
  //   //   exerciseData = null;
  //   //   exerciseDetail?.clear();
  //   //   notifyListeners();
  //   // }
  //   //
  //   // apiResponseCompleted() {
  //   //   loadingExerciseDetail = false;
  //   //   notifyListeners();
  //   // }
  //
  //   // refresh();
  //   try {
  //     await ApiService()
  //         .get(
  //       endPoint: ApiEndpoints.fetchCategories+type,
  //     )
  //         .then((response) {
  //       if (response != null) {
  //         Map<String, dynamic> json = response;
  //         Fetchinterestcategory responseData = Fetchinterestcategory.fromJson(json);
  //         if (responseData.status == true) {
  //           isLoading=true;
  //           fetchInterestCategory = responseData;
  //           // assignExercise(refresh: true);
  //
  //           notifyListeners();
  //         }
  //       }
  //
  //       // apiResponseCompleted();
  //     });
  //   } catch (e, s) {
  //     // apiResponseCompleted();
  //     debugPrint('Error is $e & $s');
  //   }
  //
  //   return fetchInterestCategory;
  // }

  /// 1) fetch interest questions...
  Fetchinterestquestions? fetchinterestquestions;
  String question1 = '';
  String questionId = '';
  String question2 = '';
  String questionId2 = '';
  List itme = [];

  Future<Fetchinterestquestions?> fetchInterestQuestions({
    required BuildContext context,
    required String categoryId,
  }) async {
    // refresh() {
    //   loadingExerciseDetail = true;
    //   exerciseDetailModel = null;
    //   exerciseData = null;
    //   exerciseDetail?.clear();
    //   notifyListeners();
    // }
    //
    // apiResponseCompleted() {
    //   loadingExerciseDetail = false;
    //   notifyListeners();
    // }

    // refresh();
    try {
      await ApiService()
          .get(
        endPoint: ApiEndpoints.fetchQuestions + categoryId,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          Fetchinterestquestions responseData = Fetchinterestquestions.fromJson(json);
          if (responseData.status == true) {
            fetchinterestquestions = responseData;
            if (fetchinterestquestions?.data?.isNotEmpty == true) {
              question1 = fetchinterestquestions?.data?[0].question ?? '';
              questionId = fetchinterestquestions?.data?[0].id.toString() ?? '';
              question2 = fetchinterestquestions?.data?[1].question ?? '';
              questionId2 = fetchinterestquestions?.data?[1].id.toString() ?? '';
              fetchinterestquestions?.data?[1].answers?.forEach((element) {
                itme.add(element);
              });
            }
            // assignExercise(refresh: true);

            notifyListeners();
          }
        }

        // apiResponseCompleted();
      });
    } catch (e, s) {
      // apiResponseCompleted();
      debugPrint('Error is $e & $s');
    }

    return fetchinterestquestions;
  }

  /// 1) question...
  Future<DefaultModel?> questions({
    required BuildContext context,
    required String? questionId,
    required String? answer,
  }) async {
    DefaultModel? responseData;
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'question_id': '$questionId',
      'answer': '$answer',
    };
    debugPrint('Sent Data is $body');
    try {
      var response = ApiService().post(
        endPoint: ApiEndpoints.submitGuestInterest,
        body: body,
      );

      await loadingDialog(
        context: context,
        future: response,
      ).then((response) async {
        if (response != null) {
          Map<String, dynamic> json = response;
          responseData = DefaultModel.fromJson(json);
          if (responseData?.status == true) {
            showSnackBar(
                context: context, text: responseData?.message ?? 'Something went wong', color: Colors.green);
          } else {
            showSnackBar(context: context, text: 'Something went wong', color: Colors.red);
          }
        }
      });
    } catch (a) {
      debugPrint('>> $a');
    }
    return responseData;
  }

//
// /// 1) fetch new joiners...
// Future<Fetchinterestcategory?> fetchNewJoiners({
//   required BuildContext context,
//   required String type,
// }) async {
//   // refresh() {
//   //   loadingExerciseDetail = true;
//   //   exerciseDetailModel = null;
//   //   exerciseData = null;
//   //   exerciseDetail?.clear();
//   //   notifyListeners();
//   // }
//   //
//   // apiResponseCompleted() {
//   //   loadingExerciseDetail = false;
//   //   notifyListeners();
//   // }
//
//   // refresh();
//   try {
//     await ApiService()
//         .get(
//       endPoint: ApiEndpoints.fetchCategories+type,
//     )
//         .then((response) {
//       if (response != null) {
//         Map<String, dynamic> json = response;
//         Fetchinterestcategory responseData = Fetchinterestcategory.fromJson(json);
//         if (responseData.status == true) {
//           isLoading=true;
//           fetchInterestCategory = responseData;
//           // assignExercise(refresh: true);
//
//           notifyListeners();
//         }
//       }
//
//       // apiResponseCompleted();
//     });
//   } catch (e, s) {
//     // apiResponseCompleted();
//     debugPrint('Error is $e & $s');
//   }
//
//   return fetchInterestCategory;
// }





}
