import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/models/default/default_model.dart';

import '../../core/config/api_config.dart';
import '../../core/services/api/api_service.dart';
import '../../core/services/api/exception_handler.dart';
import '../../models/guest_Model/fetchDemoVideosAfter.dart';
import '../../models/guest_Model/fetchGuestDemoAns.dart';
import '../../models/guest_Model/getStep.dart';
import '../../models/guest_Model/guestCheckDemoVideoAndStep.dart';
import '../../models/guest_Model/guestDemoQuestion.dart';
import '../../utils/widgets/widgets.dart';


class CheckDemoController extends ChangeNotifier{
  final PageController pageController = PageController();
  int stepIndex =0;
  int tabIndex =-1;
  String checkVideoSkip ='';
  List<Questions>  ansQues =[];
  addTabIndex(i){
    tabIndex =i;
    notifyListeners();
  }
  nextPage(index){
    pageController.jumpToPage(index);
    notifyListeners();
  }
  addIndex(int? index, String? skip){
    if(skip=='No'){
      checkVideoSkip =skip??'';
      // nextPage(4);
    }
    stepIndex =index??-1;
    notifyListeners();
  }
 ///  check demo videos
  GuestCheckDemoVideoAndStep? guestCheckDemoVideoAndStep;
  bool guestCheckDemoLoader = false;
  Future<GuestCheckDemoVideoAndStep?> guestCheckDemoStep1({
    required BuildContext context,
  }) async {
    refresh() {
      guestCheckDemoLoader = false;
      guestCheckDemoVideoAndStep = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      guestCheckDemoLoader = true;
      notifyListeners();
    }

    refresh();
    try {
      await ApiService()
          .get(
        endPoint: ApiEndpoints.checkDemo +checkVideoSkip,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          GuestCheckDemoVideoAndStep responseData = GuestCheckDemoVideoAndStep.fromJson(json);
          if (responseData.status == true) {
            guestCheckDemoVideoAndStep = responseData;
            notifyListeners();
          }
        }
        apiResponseCompleted();
      });
    } catch (e, s) {
      apiResponseCompleted();
      debugPrint('Error is $e & $s');
    }

    return guestCheckDemoVideoAndStep;
  }


///  step
  GetStep? getStep;
  bool getStepLoader=false;
  Future<GetStep?> getStepCheckDemo({
    required BuildContext context,
  }) async {
    refresh() {
      getStepLoader = false;
      getStep = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      getStepLoader = true;
      notifyListeners();
    }

    refresh();
    try {
      await ApiService()
          .get(
        endPoint: ApiEndpoints.getDemoStep ,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          GetStep responseData = GetStep.fromJson(json);
          if (responseData.status == true) {
            getStep = responseData;
            notifyListeners();
          }
        }
        apiResponseCompleted();
      });
    } catch (e, s) {
      apiResponseCompleted();
      debugPrint('Error is $e & $s');
    }

    return getStep;
  }

  ///  fetch demo questions
  GuestDemoQuestion?  guestDemoQuestions;
  bool guestDemoLoader = false;
  Future<GuestDemoQuestion?> getDemoQuestions({
    required BuildContext context,
  }) async {
    refresh() {
      guestDemoLoader = false;
      guestDemoQuestions = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      guestDemoLoader = true;
      notifyListeners();
    }

    refresh();
    try {
      await ApiService()
          .get(
        endPoint: ApiEndpoints.fetchDemoQuestion ,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          GuestDemoQuestion responseData = GuestDemoQuestion.fromJson(json);
          if (responseData.status == true) {
            guestDemoQuestions = responseData;
            notifyListeners();
          }
        }
        apiResponseCompleted();
      });
    } catch (e, s) {
      apiResponseCompleted();
      debugPrint('Error is $e & $s');
    }
    return guestDemoQuestions;
  }


  /// 1) guset submit ans ques...
  Future<DefaultModel?> submitAns({
    required BuildContext context,
    // required List<Map<String, dynamic>>? ans,
    required List<Questions>? ans,

  }) async {
    List<Map<String, dynamic>> transformedAns = ans?.map((item) {
      return {
        'id': item.id,
        'answer': item.ans,
      };
    }).toList() ?? [];

    FocusScope.of(context).unfocus();

    Map<String, dynamic> body = {
      'answer':jsonEncode(transformedAns),
      // 'answer':jsonEncode(d),
    };
    var response;
 try{
   debugPrint('Sent Data is $body');
   response  = ApiService().post(
     endPoint: ApiEndpoints.submitDemoAns,
     body: body,
   );
 }catch(a,c){
   print(a);
   print(c);
 }
    DefaultModel? responseData;
    await loadingDialog(
      context: context,
      future: response,
    ).then((response) async {

      if (response != null) {
        Map<String, dynamic> json = response;
        responseData = DefaultModel.fromJson(json);
        if (responseData?.status == true) {
          showSnackBar(context: context, text: responseData?.message ?? 'Something went wong', color: Colors.green);
        } else {
          showSnackBar(context: context, text: '${responseData?.message}', color: Colors.red);
        }
      }
    });
    return responseData;
  }


  ///  fetch demo ans
  FetchGuestDemoAns?  fetchGuestDemoAns;
  bool demoAnsLoader = false;
  Future<FetchGuestDemoAns?> fetchDemoAns({
    required BuildContext context,
  }) async {
    refresh() {
      demoAnsLoader = false;
      fetchGuestDemoAns = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      demoAnsLoader = true;
      notifyListeners();
    }

    refresh();
    try {
      await ApiService()
          .get(
        endPoint: ApiEndpoints.fetchDemoAns ,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          FetchGuestDemoAns responseData = FetchGuestDemoAns.fromJson(json);
          if (responseData.status == true) {
            fetchGuestDemoAns = responseData;
            notifyListeners();
          }
        }
        apiResponseCompleted();
      });
    } catch (e, s) {
      apiResponseCompleted();
      debugPrint('Error is $e & $s');
    }
    return fetchGuestDemoAns;
  }


  ///  fetch demo videos
  FetchDemoVideosAfter?  fetchDemoVideosAfter;
  bool demoVideosLoader = false;
  Future<FetchDemoVideosAfter?> fetchDemoVideos({
    required BuildContext context,
  }) async {
    refresh() {
      demoVideosLoader = false;
      fetchDemoVideosAfter = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      demoVideosLoader = true;
      notifyListeners();
    }

    refresh();
    try {
      await ApiService()
          .get(
        endPoint: ApiEndpoints.fetchDemoVideos ,
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          FetchDemoVideosAfter responseData = FetchDemoVideosAfter.fromJson(json);
          if (responseData.status == true) {
            fetchDemoVideosAfter = responseData;
            notifyListeners();
          }
        }
        apiResponseCompleted();
      });
    } catch (e, s) {
      apiResponseCompleted();
      debugPrint('Error is $e & $s');
    }
    return fetchDemoVideosAfter;
  }

  /// 1) guest demo video count...
  String userName ='';
  Future<DefaultModel?> videoCount({
    required BuildContext context,
    required String demoId

  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'demo_id': demoId,
    };
    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.demoWatchCount,
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

        } else {
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
    return responseData;
  }

}
class Questions{
  String? ans;
  String? id;
  Questions({ this.ans,this.id});
}