import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:provider/provider.dart';

import '../../core/config/api_config.dart';
import '../../core/route/route_paths.dart';
import '../../core/services/api/api_service.dart';
import '../../core/services/database/local_database.dart';
import '../../models/auth_model/fetchinterestcategory.dart';
import '../../models/auth_model/fetchinterestquestions.dart';
import '../../models/auth_model/guest_data.dart';
import '../../models/auth_model/sendotp.dart';
import '../../models/auth_model/validatemobile.dart';
import '../../models/auth_model/verifyotp.dart';
import '../../models/common_apis/cityModel.dart';
import '../../models/common_apis/commonbanner.dart';
import '../../models/common_apis/stateModel.dart';
import '../../models/default/default_model.dart';
import '../../models/guest_Model/editProfileModel.dart';
import '../../models/guest_Model/fetchResouresDetailModel.dart';
import '../../models/guest_Model/fetchResouresDetailModel.dart';
import '../../models/guest_Model/fetchResouresDetailModel.dart';
import '../../models/guest_Model/fetchfeedcategoriesmodel.dart';
import '../../models/guest_Model/fetchguestproduct.dart';
import '../../models/guest_Model/fetchnewjoiners.dart';
import '../../models/guest_Model/fetchproductdetail.dart';
import '../../models/guest_Model/resourceModel.dart';
import '../../screens/auth/verify_otp.dart';
import '../../utils/widgets/widgets.dart';

class GuestControllers extends ChangeNotifier {
  /// 0)  SignOut User....

  Future clearUserData(BuildContext context) async {
    LocalDatabase localDatabase =
        Provider.of<LocalDatabase>(context, listen: false);
    // return await localDatabase.clearDatabase();
  }

  /// 1) fetch new joiners...
  bool isLoading = false;
  Fetchnewjoiners? fetchnewjoiners;
  Future<Fetchnewjoiners?> fetchNewJoiners({
    required BuildContext context,
  }) async {
    try {
      await ApiService()
          .get(
        endPoint: ApiEndpoints.fetchJoiners,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          Fetchnewjoiners responseData = Fetchnewjoiners.fromJson(json);
          if (responseData.status == true) {
            isLoading = true;
            fetchnewjoiners = responseData;
          } else {
            isLoading = true;
          }
        }
        notifyListeners();

        // apiResponseCompleted();
      });
    } catch (e, s) {
      // apiResponseCompleted();
      debugPrint('Error is $e & $s');
    }

    return fetchnewjoiners;
  }

  /// 1) fetch banner...
  Commonbanner? banner;
  Future<Commonbanner?> fetchBanner({
    required BuildContext context,
  }) async {
    try {
      await ApiService()
          .get(
        endPoint: ApiEndpoints.fetchBanner,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          Commonbanner responseData = Commonbanner.fromJson(json);
          if (responseData.status == true) {
            banner = responseData;
          }
        }
        notifyListeners();

        // apiResponseCompleted();
      });
    } catch (e, s) {
      // apiResponseCompleted();
      debugPrint('Error is $e & $s');
    }

    return banner;
  }

  Fetchinterestcategory? fetchInterestCategory;
  bool fetchCategoryLoader = false;
  int? tabIndex = 0;
  Future<Fetchinterestcategory?> fetchInterestCategories({
    required BuildContext context,
    required String type,
  }) async {
    refresh() {
      fetchCategoryLoader = false;
      // exerciseDetailModel = null;
      // exerciseData = null;
      // exerciseDetail?.clear();
      notifyListeners();
    }

    //
    apiResponseCompleted() {
      fetchCategoryLoader = true;
      notifyListeners();
    }

    // refresh();
    try {
      await ApiService()
          .get(
        endPoint: ApiEndpoints.fetchCategories + type,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          Fetchinterestcategory responseData =
              Fetchinterestcategory.fromJson(json);
          if (responseData.status == true) {
            // isLoading=true;
            fetchCategoryLoader = true;
            fetchInterestCategory = responseData;
            // assignExercise(refresh: true);

            notifyListeners();
          }
        }

        apiResponseCompleted();
      });
    } catch (e, s) {
      apiResponseCompleted();
      debugPrint('Error is $e & $s');
    }

    return fetchInterestCategory;
  }

  /// 1) fetch Product...
  Fetchguestproduct? fetchguestProduct;
  bool guestProductLoader = false;
  Future<Fetchguestproduct?> fetchProduct({
    required BuildContext context,
    required String page,
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
        endPoint: ApiEndpoints.fetchProduct + page,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          Fetchguestproduct responseData = Fetchguestproduct.fromJson(json);
          if (responseData.status == true) {
            // isLoading=true;
            fetchguestProduct = responseData;
            guestProductLoader = true;
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

    return fetchguestProduct;
  }

  /// 1) fetch Product Detail...
  Fetchproductdetail? fetchproductDetail;
  bool productLoader = false;
  Future<Fetchproductdetail?> fetchProductDetail({
    required BuildContext context,
    required String productId,
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
        endPoint: ApiEndpoints.fetchProductDetail + productId,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          Fetchproductdetail responseData = Fetchproductdetail.fromJson(json);
          if (responseData.status == true) {
            productLoader = true;
            fetchproductDetail = responseData;
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

    return fetchproductDetail;
  }

  /// 1) fetch resources...
  ResourceModel? resourceModel;
  bool resourcesLoader = false;
  Future<ResourceModel?> fetchResources({
    required BuildContext context,
    required String page,
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
        endPoint: ApiEndpoints.fetchResources + page,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          ResourceModel responseData = ResourceModel.fromJson(json);
          if (responseData.status == true) {
            resourcesLoader = true;
            resourceModel = responseData;
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

    return resourceModel;
  }

  /// 1) fetch feed categories...

  FetchFeedCategoriesModel? fetchFeedCategoriesModel;
  // bool fetchCategoryLoader =false;
  // int? tabIndex =0;
  Future<FetchFeedCategoriesModel?> fetchFeedCategories({
    required BuildContext context,
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
        endPoint: ApiEndpoints.fetchFeedCategories,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          FetchFeedCategoriesModel responseData =
              FetchFeedCategoriesModel.fromJson(json);
          if (responseData.status == true) {
            fetchFeedCategoriesModel = responseData;
            notifyListeners();
          }
        }

        // apiResponseCompleted();
      });
    } catch (e, s) {
      // apiResponseCompleted();
      debugPrint('Error is $e & $s');
    }

    return fetchFeedCategoriesModel;
  }

  /// 1) fetch resources details...
  FetchResourcesDetailModel? fetchResourcesDetailModel;
  bool resourcesDetailLoader = false;
  Future<FetchResourcesDetailModel?> fetchResourcesDetail({
    required BuildContext context,
    required String page,
    required String categoryId,
  }) async {
    refresh() {
      resourcesDetailLoader = false;

      notifyListeners();
    }

    //
    apiResponseCompleted() {
      resourcesDetailLoader = true;
      notifyListeners();
    }

    refresh();
    try {
      await ApiService()
          .get(
        endPoint: ApiEndpoints.fetchResourceDetails + categoryId,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          FetchResourcesDetailModel responseData =
              FetchResourcesDetailModel.fromJson(json);
          if (responseData.status == true) {
            // isLoading=true;
            resourcesDetailLoader = true;
            fetchResourcesDetailModel = responseData;
            // assignExercise(refresh: true);

            notifyListeners();
          }
        }

        apiResponseCompleted();
      });
    } catch (e, s) {
      apiResponseCompleted();
      debugPrint('Error is $e & $s');
    }

    return fetchResourcesDetailModel;
  }

  /// 1) FAQs..
  // // FetchResourcesDetailModel? fetchResourcesDetailModel ;
  // bool resourcesDetailLoader =false;
  // Future<FetchResourcesDetailModel?> fetchResourcesDetail({
  //   required BuildContext context,
  //   required String page,
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
  //       endPoint: ApiEndpoints.fetchResourceDetails+page,
  //     )
  //         .then((response) {
  //       if (response != null) {
  //         Map<String, dynamic> json = response;
  //         FetchResourcesDetailModel responseData = FetchResourcesDetailModel.fromJson(json);
  //         if (responseData.status == true) {
  //           // isLoading=true;
  //           resourcesDetailLoader =true;
  //           fetchResourcesDetailModel = responseData;
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
  //   return fetchResourcesDetailModel;
  // }

  /// 1) fetch state..
  StateModel? satesModel;
  Future<StateModel?> fetchState({
    required BuildContext context,
    // required String page,
    // required String categoryId,
  }) async {
    // refresh() {
    //   resourcesDetailLoader = false;
    //
    //   notifyListeners();
    // }
    // //
    // apiResponseCompleted() {
    //   resourcesDetailLoader = true;
    //   notifyListeners();
    // }
    //
    // refresh();
    try {
      await ApiService()
          .get(
        endPoint: ApiEndpoints.state,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          StateModel responseData = StateModel.fromJson(json);
          if (responseData.status == true) {
            satesModel = responseData;
            notifyListeners();
          }
        }

        // apiResponseCompleted();
      });
    } catch (e, s) {
      // apiResponseCompleted();
      debugPrint('Error is $e & $s');
    }

    return satesModel;
  }

  /// 1) fetch city..
  CityModel? cityModel;
  Future<CityModel?> fetchCity({
    required BuildContext context,
    required String stateId,
    // required String categoryId,
  }) async {
    // refresh() {
    //   resourcesDetailLoader = false;
    //
    //   notifyListeners();
    // }
    // //
    // apiResponseCompleted() {
    //   resourcesDetailLoader = true;
    //   notifyListeners();
    // }
    //
    // refresh();
    try {
      var response =  ApiService().get(
        endPoint: ApiEndpoints.city+stateId,
      );
      await loadingDialog(
        context: context,
        future: response,
      ).then((response) async {
        if (response != null) {
          Map<String, dynamic> json = response;
          CityModel responseData = CityModel.fromJson(json);
          if (responseData.status == true) {
            cityModel = responseData;
            notifyListeners();
          }
        }
      });
    } catch (e, s) {
      // apiResponseCompleted();
      debugPrint('Error is $e & $s');
    }

    return cityModel;
  }


  /// 1) update profile ..
  // EditProfileModel? editProfileModel;
  Future<EditProfileModel?> editProfile({
    required BuildContext context,
    required String? firstName,
    required String? lastName,
    required String? email,
    required String? gender,
    required String? leadRefType,
    required String? occupation,
    required String? dob,
    required String? familyMembers,
    required String? stateId,
    required String? cityId,
    required String? pincode,
    required String? address,
    required String? illnessInFamily,

  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'first_name': '$firstName',
      'last_name': '$lastName',
      'email': '$email',
      'gender': '$gender',
      'lead_ref_type': '$leadRefType',
      'occupation': '$occupation',
      'dob': '$dob',
      'no_of_family_members': '$familyMembers',
      'state_id': '$stateId',
      'city_id': '$cityId',
      'pincode': '$pincode',
      'address': '$address',
      'illness_in_family': '$illnessInFamily',
    };

    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.editProfile,
      body: body,
    );
//Processing API...
    EditProfileModel? editProfileModel;
    await loadingDialog(
      context: context,
      future: response,
    ).then((response) async {
      if (response != null) {
        Map<String, dynamic> json = response;
        editProfileModel = EditProfileModel.fromJson(json);

        if (editProfileModel?.status == true) {
          // // context.read<LocalDatabase>().saveGuestData(guest: editProfileModel!.data);
          // GuestData? guest = context.read<LocalDatabase>().guest;
          // debugPrint('guest ${guest?.firstName}');
          showSnackBar(context: context, text: editProfileModel?.message ?? 'Something went wong', color: Colors.green);
          context.pop(context);
          // context.pushNamed(
          //   Routs.interests,
          // );
        } else {
          showSnackBar(
              context: context, text: editProfileModel?.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
    return editProfileModel;
  }
}
