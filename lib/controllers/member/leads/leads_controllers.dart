import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/app.dart';
import 'package:mrwebbeast/core/config/api_config.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/services/api/exception_handler.dart';
import 'package:mrwebbeast/models/default/default_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/services/api/api_service.dart';

import '../../../models/guestProfileDetailsFor/guestProfileDetailFor.dart';
import '../../../models/member/dashboard/achievement_badges_model.dart';
import '../../../models/member/leads/fetchGuestData.dart';
import '../../../models/member/leads/fetchObjectModel.dart';
import '../../../models/member/leads/leads_member_details.dart';
import '../../../models/member/leads/leads_model.dart';
import '../../../models/member/todo/to_do_model.dart';
import '../../../utils/widgets/widgets.dart';

class ListsControllers extends ChangeNotifier {
  /// 1) Leads API...
  bool loadingLeads = true;
  LeadsModel? _leadsModel;
  int? tabIndex =-1;
  addIndex(index){
    tabIndex=index;
    notifyListeners();
  }

  LeadsModel? get leadsModel => _leadsModel;

  List<LeadsData>? _leads; // Changed from List<EventsData> to List<LeadsData>

  List<LeadsData>? get leads =>
      _leads; // Changed from List<EventsData> to List<LeadsData>

  num leadsIndex = 1;
  num leadsTotal = 1;

  RefreshController leadsController = RefreshController(initialRefresh: false);

  Future<List<LeadsData>?> fetchLeads({
    required BuildContext context,
    bool isRefresh = false,
    bool loadingNext = false,
    String? searchKey,
    String? status,
    String? priority,
    String? limit,
    String? filter,
  }) async {
    String modelingData = 'LeadsData';
    debugPrint('Fetching $modelingData Data...');

    onRefresh() {
      leadsIndex = 1;
      leadsTotal = 1;
      loadingLeads = true;
      leadsController.resetNoData();
      _leadsModel = null;
      _leads = null;
      notifyListeners();
      debugPrint('Cleared $modelingData');
    }

    onComplete() {
      loadingLeads = false;
      notifyListeners();
    }

    if (isRefresh) {
      onRefresh();
    }

    Map<String, String> body = {
      'page': '$leadsIndex',
      'status': status ?? '',
      'priority': priority ?? '',
      'search_key': searchKey ?? '',
      'filter': filter ?? '',
      'limit': limit ?? '10',
    };

    debugPrint('Body $body');

    try {
      if (leadsIndex <= leadsTotal) {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchLead,
          queryParameters: body,
        );

        LeadsModel? responseData;
        if (response != null) {
          Map<String, dynamic> json = response;
          responseData = LeadsModel.fromJson(json);
          _leadsModel = responseData;
        }

        if (responseData?.status == true) {
          debugPrint('Current Page $leadsTotal');
          debugPrint(responseData?.message);

          if (responseData?.data?.haveData == true) {
            for (int i = 0; i < (responseData?.data?.length ?? 0); i++) {
              var data = responseData?.data?.elementAt(i);
              if (_leads == null) {
                debugPrint('$modelingData Added');
                if (data != null) {
                  _leads = [data];
                }
              } else {
                if (_leads?.contains(data) == true) {
                  debugPrint('$modelingData Already exist');
                } else {
                  if (data != null) {
                    _leads?.add(data);
                    debugPrint('$modelingData Updated');
                  }
                }
              }
            }
            notifyListeners();
          }

          if (loadingNext) {
            leadsController.loadComplete();
          } else {
            leadsController.refreshCompleted();
          }
          leadsTotal = responseData?.dataRecords?.totalPage ?? 1;
          leadsIndex++;
          notifyListeners();
          debugPrint('$modelingData Total Pages $leadsTotal');
          debugPrint('Updated $modelingData Current Page $leadsIndex');
          return _leads;
        } else {
          debugPrint(responseData?.message);
          if (loadingNext) {
            leadsController.loadFailed();
          } else {
            leadsController.refreshFailed();
          }
          notifyListeners();
        }
      } else {
        leadsController.loadNoData();
        loadingLeads = false;
        notifyListeners();
        debugPrint('Load no More data in $modelingData');
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    } finally {
      onComplete();
    }

    return _leads;
  }

  /// 2) ToDo API...
  bool loadingToDos = true;
  ToDoModel? toDoModel;
  ToDoData? toDos;

  Future<ToDoData?> fetchToDos({
    String? search,
    String? filter,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingToDos = true;
        toDoModel = null;
        toDos = null;
        notifyListeners();
      }

      onComplete() {
        loadingToDos = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService()
            .get(endPoint: ApiEndpoints.fetchToDo, queryParameters: {
          'search_key': search ?? '',
          'date': filter ?? '',
        });

        if (response != null) {
          Map<String, dynamic> json = response;

          ToDoModel responseData = ToDoModel.fromJson(json);
          if (responseData.status == true) {
            toDos = responseData.data;

            notifyListeners();
          }
        }
      } catch (e, s) {
        onComplete();
        ErrorHandler.catchError(e, s, true);
      } finally {
        onComplete();
      }
    }

    return toDos;
  }

  bool loadingGuestProfileDetails = true;
  GuestProfileDetails? guestProfileDetailsModel;
  GuestProfileDetailFor? guestProfileDetails;

  /// 1) Delete lead...
  Future<DefaultModel?> deleteLead({
    required BuildContext context,
    required String guestId,
  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'guest_id': guestId,
    };
    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.deleteLead,
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
          showSnackBar(
              context: context,
              text: responseData?.message ?? 'Something went wong',
              color: Colors.green);
        } else {
          showSnackBar(
              context: context,
              text: '${responseData?.message}',
              color: Colors.red);
        }
      }
    });
    // return responseData;
  }

  /// 1) lead invitation call rescheduled call...
  Future<DefaultModel?> rescheduledCall({
    required BuildContext context,
    required String guestId,
    required String reason,
    required String date,
    required String time,
    required String LMSStep,
    required String priority,
    required String demoRescheduleRemark,
  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'guest_id': guestId,
      'reason': reason,
      'date': date,
      'time': time,
      'LMS_step': LMSStep,
      'priority': priority,
      'demo_reschedule_remark': demoRescheduleRemark,
    };
    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.rescheduleCall,
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
          showSnackBar(
              context: context,
              text: responseData?.message ?? 'Something went wong',
              color: Colors.green);
          // context.pop();
        } else {
          showSnackBar(
              context: context,
              text: '${responseData?.message}',
              color: Colors.red);
        }
      }
    });
    return responseData;
  }

  Future<GuestProfileDetailFor?> fetchGuestProfileDetails({
    String? guestId,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      // Define these functions outside the conditional block to avoid redefining them every time
      void onRefresh() {
        loadingGuestProfileDetails = true;
        guestProfileDetailsModel = null;
        guestProfileDetails = null;
        notifyListeners();
      }

      void onComplete() {
        loadingGuestProfileDetails = false;
        notifyListeners();
      }

      onRefresh(); // Call onRefresh to set loading state

      try {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchGuestProfile,
          queryParameters: {
            'guest_id': guestId ?? '',
          },
        );

        if (response != null) {
          Map<String, dynamic> json = response;

          GuestProfileDetailFor responseData = GuestProfileDetailFor.fromJson(json);
          if (responseData.status == true) {
            guestProfileDetails = responseData;
            notifyListeners();
          }
        }
      } catch (e, s) {
        onComplete(); // Handle loading state changes even in case of errors
        ErrorHandler.catchError(e, s, true);
      } finally {
        onComplete(); // Make sure loading state changes are reflected
      }
    }

    return guestProfileDetails;
  }

/// fetch objects
  FetchObjectModel? fetchObjectModel;
 bool? fetchObjectLoader =false;
  Future<FetchObjectModel?> fetchObject({
    required BuildContext context,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        fetchObjectLoader =false;
        fetchObjectModel =null;
        notifyListeners();
      }

      onComplete() {
        fetchObjectLoader = true;
        notifyListeners();
      }

      onRefresh();

      try {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchObject,

        );

        if (response != null) {
          Map<String, dynamic> json = response;
          FetchObjectModel responseData = FetchObjectModel.fromJson(json);
          if (responseData.status == true) {
            fetchObjectModel = responseData;
            notifyListeners();
          }
        }
      } catch (e, s) {
        onComplete();
        ErrorHandler.catchError(e, s, true);
      } finally {
        onComplete();
      }
    }
    return fetchObjectModel;
  }

  /// 1) fetch state..
  FetchGuestData? fetchGuestDataModel;

  Future<FetchGuestData?> fetchGuestData({
    required BuildContext context,
    required String guestId,

  }) async {

    try {
      await ApiService()
          .get(
        endPoint: ApiEndpoints.fetchGuestData,
        queryParameters: {
          'guest_id':guestId
        }
      )
          .then((response) {
        if (response != null) {
          Map<String, dynamic> json = response;
          FetchGuestData responseData = FetchGuestData.fromJson(json);
          if (responseData.status == true) {
            fetchGuestDataModel = responseData;
            notifyListeners();
          }
        }

        // apiResponseCompleted();
      });
    } catch (e, s) {
      // apiResponseCompleted();
      debugPrint('Error is $e & $s');
    }

    return fetchGuestDataModel;
  }
}
