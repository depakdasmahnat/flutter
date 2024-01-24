// import 'dart:convert';
//
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// import 'package:mrwebbeast/core/config/api_config.dart';
// import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
// import 'package:mrwebbeast/core/route/route_paths.dart';
//
// import 'package:provider/provider.dart';
//
// import '../../core/services/database/local_database.dart';
// import '../../utils/widgets/widgets.dart';
//
// class AuthControllers extends ChangeNotifier {
//   /// 0)  SignOut User....
//
//   Future clearUserData(BuildContext context) async {
//     LocalDatabase localDatabase = Provider.of<LocalDatabase>(context, listen: false);
//
//
//
//     return await localDatabase.clearDatabase();
//   }
//
//   logOut({
//     required BuildContext context,
//     String? message,
//     Color? color,
//   }) async {
//     try {
//       await clearUserData(context).then((val) {
//         notifyListeners();
//         context.firstRoute();
//         context.pushReplacementNamed(Routs.fisrtScreen);
//       }).then((value) {
//         showSnackBar(context: context, text: message ?? 'Successfully Logout', color: color ?? Colors.green);
//       });
//     } catch (e) {
//       debugPrint(e.toString());
//       return null;
//     }
//   }
//
//   Future logOutPopup(context) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return CupertinoAlertDialog(
//             title: const Text('Logout'),
//             content: const Text('Do you want To logout'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   context.pop();
//                 },
//                 child: const Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   logoutAccountAPI(context: context);
//                 },
//                 child: const Text(
//                   'Logout',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               )
//             ],
//           );
//         });
//   }
//
//   Future cancelRegistration({
//     required BuildContext context,
//     GestureTapCallback? onSuccess,
//     String? message,
//   }) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return CupertinoAlertDialog(
//             title: const Text('Cancel registration'),
//             content: const Text('Do you want to cancel registration'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   context.pop();
//                 },
//                 child: const Text(
//                   'No',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   if (onSuccess == null) {
//                     logoutAccountAPI(context: context, message: message);
//                   } else {
//                     onSuccess.call();
//                   }
//                 },
//                 child: const Text(
//                   'Yes',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               )
//             ],
//           );
//         });
//   }
//
//   Future logoutAccountAPI({
//     required BuildContext context,
//     String? message,
//   }) async {
// //Processing API...
//
//     loadingDialog(
//       context: context,
//       future: ApiService().post(
//         endPoint: ApiEndpoints.logout,
//       ),
//     ).then((response) {
//       if (response != null) {
//         Map<String, dynamic> json = response;
//
//         DefaultModel? responseData = DefaultModel.fromJson(json);
//
//         if (responseData.success == true) {
//           showSnackBar(
//               context: context, text: responseData.message ?? 'Something went wong', color: Colors.green);
//         } else {
//           showSnackBar(
//               context: context, text: responseData.message ?? 'Something went wong', color: Colors.red);
//         }
//         logOut(context: context, message: message);
//       }
//     });
//   }
//
//   Future deleteAccount(context) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return CupertinoAlertDialog(
//             title: const Text('Delete Account'),
//             content: const Text('Do you want to delete your account ?'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   context.pop();
//                 },
//                 child: const Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   deleteAccountAPI(context: context);
//                 },
//                 child: const Text(
//                   'Delete',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               )
//             ],
//           );
//         });
//   }
//
//   Future deleteAccountAPI({
//     required BuildContext context,
//   }) async {
// //Processing API...
//
//     loadingDialog(
//       context: context,
//       future: ApiService().post(
//         endPoint: ApiEndpoints.deleteUser,
//       ),
//     ).then((response) {
//       if (response != null) {
//         Map<String, dynamic> json = response;
//
//         DefaultModel? responseData = DefaultModel.fromJson(json);
//         if (responseData.success == true) {
//           logOut(context: context, message: responseData.message ?? 'User Successfully Deactivated');
//         } else {
//           context.pop();
//           showSnackBar(
//               context: context, text: responseData.message ?? 'Something went wong', color: Colors.red);
//         }
//       }
//     });
//   }
//
//   /// 1) Login API...
//   Future sendOtp({
//     required BuildContext context,
//     required String? mobile,
//     required String? countryCode,
//   }) async {
//     FocusScope.of(context).unfocus();
//
//     Map<String, String> body = {
//       'mobile': '$mobile',
//       'countryCode': '$countryCode',
//     };
//
//     debugPrint('Sent Data is $body');
//     var response = ApiService().post(
//       endPoint: ApiEndpoints.sendOtp,
//       body: body,
//     );
// //Processing API...
//
//     loadingDialog(
//       context: context,
//       future: response,
//     ).then((response) async {
//       if (response != null) {
//         Map<String, dynamic> json = response;
//         DefaultModel responseData = DefaultModel.fromJson(json);
//         if (responseData.success == true) {
//           bool existingUser = responseData.userType == 'existed';
//
//           context.pushNamed(Routs.verifyOtp,
//               extra: VerifyOTP(
//                 mobileNo: mobile,
//                 countryCode: countryCode,
//                 existingUser: existingUser,
//               ));
//         } else {
//           showSnackBar(
//               context: context, text: responseData.message ?? 'Something went wong', color: Colors.red);
//         }
//       }
//     });
//   }
//
//   Future<DefaultModel?> reSendOTP({
//     required BuildContext context,
//     required String? mobile,
//     required String? countryCode,
//   }) async {
//     FocusScope.of(context).unfocus();
//
//     Map<String, String> body = {
//       'mobile': '$mobile',
//       'countryCode': '$countryCode',
//     };
//
//     debugPrint('Sent Data is $body');
//     var response = ApiService().post(
//       endPoint: ApiEndpoints.reSendOtp,
//       body: body,
//     );
// //Processing API...
//     DefaultModel? responseData;
//
//     await loadingDialog(
//       context: context,
//       future: response,
//     ).then((response) async {
//       if (response != null) {
//         Map<String, dynamic> json = response;
//         responseData = DefaultModel.fromJson(json);
//         if (responseData?.success == true) {
//           showSnackBar(
//               context: context, text: responseData?.message ?? 'Something went wong', color: Colors.green);
//         } else {
//           showSnackBar(
//               context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
//         }
//       }
//     });
//
//     return responseData;
//   }
//
//   /// 2)Verify Otp API...
//   Future verifyOTP({
//     required BuildContext context,
//     required String? mobileNo,
//     required String? countryCode,
//     required String? otp,
//   }) async {
//     FocusScope.of(context).unfocus();
//     LocalDatabase localDatabase = LocalDatabase();
//     debugPrint('deviceToken ${localDatabase.deviceToken}');
//     Map<String, String> body = {
//       'otp': '$otp',
//       'mobile': '$mobileNo',
//       'countryCode': '$countryCode',
//       'deviceToken': localDatabase.deviceToken ?? '',
//     };
//
//     debugPrint('Sent Data is $body');
//     var response = ApiService().post(
//       endPoint: ApiEndpoints.verifyOtp,
//       body: body,
//     );
//
// //Processing API...
//     loadingDialog(
//       context: context,
//       future: response,
//     ).then((response) async {
//       if (response != null) {
//         Map<String, dynamic> json = response;
//         AuthModel responseData = AuthModel.fromJson(json);
//         var database = LocalDatabase();
//
//         if (responseData.success == true) {
//           context.read<LocalDatabase>().saveUserData(member: responseData.data);
//
//           database.setAccessToken(responseData.accessToken);
//           String route = responseData.route ?? Routs.login;
//           authNavigation(
//             context: context,
//             route: route,
//             mobileNo: mobileNo,
//             countryCode: countryCode,
//           );
//         } else {
//           showSnackBar(
//               context: context, text: responseData.message ?? 'Something went wong', color: Colors.red);
//         }
//       }
//     });
//   }
//
//   /// 3) Register API...
//   Future register({
//     required BuildContext context,
//     required String? mobileNo,
//     required String? countryCode,
//     required String? fullName,
//     required String? email,
//     required String? gender,
//     required String? joinReason,
//     required String? referralCode,
//   }) async {
//     FocusScope.of(context).unfocus();
//
//     Map<String, String> body = {
//       'name': fullName ?? '',
//       'email': email ?? '',
//       'gender': gender ?? '',
//       'join_reason': joinReason ?? '',
//       'referral_code': referralCode ?? '',
//     };
//
//     debugPrint('Sent Data is $body');
//     var response = ApiService().post(
//       endPoint: ApiEndpoints.register,
//       body: body,
//     );
//
// //Processing API...
//     loadingDialog(
//       context: context,
//       future: response,
//     ).then((response) async {
//       if (response != null) {
//         Map<String, dynamic> json = response;
//         AuthModel responseData = AuthModel.fromJson(json);
//         if (responseData.success == true) {
//           String route = responseData.route ?? Routs.login;
//           context.read<LocalDatabase>().saveUserData(member: responseData.data);
//           authNavigation(
//             context: context,
//             route: route,
//             mobileNo: mobileNo,
//             countryCode: countryCode,
//           );
//         } else {
//           showSnackBar(
//               context: context, text: responseData.message ?? 'Something went wong', color: Colors.red);
//         }
//       }
//     });
//   }
//
//   /// 4) Edit Profile API...
//   Future editProfile({
//     required BuildContext context,
//     required String? fullName,
//     required String? email,
//     required File? profilePic,
//     required String? joinReason,
//   }) async {
//     FocusScope.of(context).unfocus();
//     Map<String, String> body = {
//       'fullName': fullName ?? '',
//       'email': email ?? '',
//       'join_reason': joinReason ?? '',
//     };
//
//     debugPrint('Sent Data is $body');
//
//     var response = ApiService().multiPart(
//       endPoint: ApiEndpoints.editProfile,
//       body: body,
//       multipartFile: [if (profilePic != null) MultiPartData(field: 'profilePic', filePath: profilePic.path)],
//     );
//
//     //Processing API...
//     loadingDialog(
//       context: context,
//       future: response,
//     ).then((response) async {
//       if (response != null) {
//         Map<String, dynamic> json = response;
//         DefaultModel responseData = DefaultModel.fromJson(json);
//         if (responseData.success == true) {
//           context.read<AuthControllers>().getProfile(context: context).then((value) {
//             context.pop();
//             showSnackBar(
//                 context: context, text: responseData.message ?? 'Profile Updated', color: Colors.green);
//           });
//         } else {
//           showSnackBar(
//               context: context, text: responseData.message ?? 'Something went wong', color: Colors.red);
//         }
//       }
//     });
//   }
//
//   /// 5) Get Profile API...
//   Future getProfile({required BuildContext context}) async {
//     FocusScope.of(context).unfocus();
//
// //Processing API...
//     await ApiService()
//         .get(
//       endPoint: ApiEndpoints.profileDetail,
//     )
//         .then((response) async {
//       if (response != null) {
//         Map<String, dynamic> json = response;
//         AuthModel responseData = AuthModel.fromJson(json);
//         if (responseData.success == true) {
//           context.read<LocalDatabase>().saveUserData(member: responseData.data);
//         } else {}
//       }
//     });
//   }
//
//   Future authNavigation({
//     required BuildContext context,
//     required String route,
//     String? mobileNo,
//     String? countryCode,
//   }) async {
//     context.read<LocalDatabase>().setRoute(route: route);
//     if (route == Routs.signUp) {
//       context.firstRoute();
//       context.pushReplacementNamed(Routs.signUp, extra: SignUp(mobileNo: mobileNo, countryCode: countryCode));
//     } else if (route == Routs.bmiCalculator) {
//       context.firstRoute();
//       context.pushReplacementNamed(Routs.bmiCalculator, extra: const BMICalculator(editMode: false));
//     } else if (route == Routs.dashboard) {
//       context.firstRoute();
//       context.read<DashboardController>().changeDashBoardIndex(index: 0);
//       context.pushReplacementNamed(Routs.dashboard, extra: const DashBoard(dashBoardIndex: 0));
//     } else {
//       context.firstRoute();
//       context.pushNamed(route);
//     }
//   }
// }
