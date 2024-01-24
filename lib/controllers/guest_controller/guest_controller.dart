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
import '../../models/guest_Model/fetchnewjoiners.dart';
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
  Future<Fetchnewjoiners?> fetchNewJoiners({
    required BuildContext context,
  }) async {
    Fetchnewjoiners? fetchnewjoiners;
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

  Future<Commonbanner?> fetchBanner({
    required BuildContext context,
  }) async {
    Commonbanner? banner;
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
}