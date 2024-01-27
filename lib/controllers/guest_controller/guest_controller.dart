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
import '../../models/auth_model/sendotp.dart';
import '../../models/auth_model/validatemobile.dart';
import '../../models/auth_model/verifyotp.dart';
import '../../models/common_apis/commonbanner.dart';
import '../../models/default/default_model.dart';
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
    LocalDatabase localDatabase = Provider.of<LocalDatabase>(context, listen: false);
    // return await localDatabase.clearDatabase();
  }

  /// 1) fetch new joiners...
  bool isLoading =false;
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
            isLoading =true;
            fetchnewjoiners =responseData;
          }else{
            isLoading =true;
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
            banner =responseData;
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

  Fetchinterestcategory?  fetchInterestCategory;
  bool fetchCategoryLoader =false;
  int? tabIndex =0;
  Future<Fetchinterestcategory?> fetchInterestCategories({
    required BuildContext context,
    required String type,
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
        endPoint: ApiEndpoints.fetchCategories+type,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          Fetchinterestcategory responseData = Fetchinterestcategory.fromJson(json);
          if (responseData.status == true) {
            // isLoading=true;
            fetchCategoryLoader=true;
            fetchInterestCategory = responseData;
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

    return fetchInterestCategory;
  }

/// 1) fetch Product...
  Fetchguestproduct? fetchguestProduct;
  bool guestProductLoader=false;
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
        endPoint: ApiEndpoints.fetchProduct+page,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          Fetchguestproduct responseData = Fetchguestproduct.fromJson(json);
          if (responseData.status == true) {
            // isLoading=true;
            fetchguestProduct = responseData;
            guestProductLoader=true;
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
  bool productLoader=false;
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
        endPoint: ApiEndpoints.fetchProductDetail+productId,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          Fetchproductdetail responseData = Fetchproductdetail.fromJson(json);
          if (responseData.status == true) {
            productLoader=true;
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
  bool resourcesLoader=false;
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
        endPoint: ApiEndpoints.fetchResources+page,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          ResourceModel responseData = ResourceModel.fromJson(json);
          if (responseData.status == true) {
            resourcesLoader=true;
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

  FetchFeedCategoriesModel?  fetchFeedCategoriesModel;
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
          FetchFeedCategoriesModel responseData = FetchFeedCategoriesModel.fromJson(json);
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
  FetchResourcesDetailModel? fetchResourcesDetailModel ;
   bool resourcesDetailLoader =false;
  Future<FetchResourcesDetailModel?> fetchResourcesDetail({
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
        endPoint: ApiEndpoints.fetchResourceDetails+page,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          FetchResourcesDetailModel responseData = FetchResourcesDetailModel.fromJson(json);
          if (responseData.status == true) {
            // isLoading=true;
            resourcesDetailLoader =true;
            fetchResourcesDetailModel = responseData;
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

}