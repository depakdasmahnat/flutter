import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/app.dart';

import 'package:mrwebbeast/core/config/api_config.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/services/api/exception_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/api/api_service.dart';

import '../../../models/default/default_model.dart';
import '../../../models/feeds/demos_model.dart';
import '../../../models/feeds/feeds_data.dart';
import '../../../models/guest_Model/fetchResouresDetailModel.dart';
import '../../../models/member/leads/fetchLeads.dart';
import '../../../models/member/network/tree_graph_model.dart';
import '../../../utils/widgets/widgets.dart';

class MembersController extends ChangeNotifier {
  /// 1) Tree View API...

  bool loadingTreeView = true;
  TreeGraphModel? networkTreeViewModel;
  List<TreeGraphData>? networkTreeViewNodes;

  Future<List<TreeGraphData>?> fetchTreeView() async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingTreeView = true;
        networkTreeViewModel = null;
        networkTreeViewNodes = null;
        notifyListeners();
      }

      onComplete() {
        loadingTreeView = false;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService().get(endPoint: ApiEndpoints.treeView);

        if (response != null) {
          Map<String, dynamic> json = response;
          TreeGraphModel responseData = TreeGraphModel.fromJson(json);
          if (responseData.status == true) {
            networkTreeViewNodes = responseData.data;
            debugPrint('networkTreeView ${networkTreeViewNodes?.length}');
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

    return networkTreeViewNodes;
  }

  /// lead Apis

  ///  fetch leads
  FetchLeads? fetchLeadsModel;
  bool leadsLoader = false;

  Future<FetchLeads?> fetchLeads({
    String? status,
    String? priority,
    String? page,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        leadsLoader = false;
        fetchLeadsModel = null;

        notifyListeners();
      }

      onComplete() {
        leadsLoader = true;
        notifyListeners();
      }

      onRefresh();
      try {
        var response = await ApiService()
            .get(endPoint: '${ApiEndpoints.fetchLead}status=$status&priority=$priority&page=$page');

        if (response != null) {
          Map<String, dynamic> json = response;
          FetchLeads responseData = FetchLeads.fromJson(json);
          if (responseData.status == true) {
            fetchLeadsModel = responseData;
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

    return fetchLeadsModel;
  }

  ///  add lead priority

  Future<DefaultModel?> updateLeadPriority({
    required BuildContext context,
    required String? guestId,
    required String? feedback,
    required String? priority,
    required String? remark,
  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'guest_id': '$guestId',
      'priority': '$priority',
      'feedback': '$feedback',
      'remark': '$remark',
    };

    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.updateLeadPriority,
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
          context?.pop();
        } else {
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
    return responseData;
  }

  bool showItem = false;

  changeStatus() {
    if (showItem == false) {
      showItem = true;
    } else {
      showItem = false;
    }
  }

  ///  add lead status
  Future<DefaultModel?> updateLeadStatus({
    required BuildContext context,
    required String? guestId,
    required String? status,
  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'guest_id': '$guestId',
      'status': '$status',
      'remark': '',
    };

    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.updateLeadStatus,
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
          context?.pop();
        } else {
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
    return responseData;
  }

  /// call log
  Future<void> callUser({String? mobileNo}) async {
    final call = Uri.parse('tel:+91 $mobileNo');
    if (await canLaunchUrl(call)) {
      launchUrl(call);
    } else {
      throw 'Could not launch $call';
    }
  }

  /// scheduledDemo....
  Future<DefaultModel?> scheduledDemo({
    required BuildContext context,
    required String? guestId,
    required String? demoType,
    required String? date,
    required String? time,
    required String? remarks,
    required String? priority,
  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'guest_id': '$guestId',
      'demo_type': '$demoType',
      'date': '$date',
      'time': '$time',
      'priority': '$priority',
    };

    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.scheduledDemo,
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
          context?.pop();
        } else {
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
    return responseData;
  }

  /// demo done

  Future<DefaultModel?> demoDoneForm({
    required BuildContext context,
    required String? demoId,
    required String? feedback,
    required String? remark,
    required String? priority,
  }) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> body = {
      'demo_id': '$demoId',
      'feedback': '$feedback',
      'remark': '$remark',
      'priority': '$priority',
    };

    debugPrint('Sent Data is $body');
    var response = ApiService().post(
      endPoint: ApiEndpoints.demoDone,
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
          context?.pop();
        } else {
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
    return responseData;
  }

  /// 1) fetch demo details...

  bool loadingDemo = true;
  DemosModel? _demoModel;

  DemosModel? get demoModel => _demoModel;

  List<FeedsData>? _demo;

  List<FeedsData>? get demo => _demo;
  num demoIndex = 1;
  num demoTotal = 1;

  RefreshController demoController = RefreshController(initialRefresh: false);

  Future<List<FeedsData>?> fetchDemoDetail({
    required BuildContext context,
    bool isRefresh = false,
    bool loadingNext = false,
    String? searchKey,
    String? limit,
  }) async {
    String modelingData = 'FeedsData';
    debugPrint('Fetching $modelingData Data...');

    onRefresh() {
      demoIndex = 1;
      demoTotal = 1;
      loadingDemo = true;
      demoController.resetNoData();
      _demoModel = null;
      _demo = null;
      notifyListeners();
      debugPrint('Cleared $modelingData');
    }

    onComplete() {
      loadingDemo = false;
      notifyListeners();
    }

    if (isRefresh) {
      onRefresh();
    }

    Map<String, String> body = {
      'page': '$demoIndex',
      'search_key': searchKey ?? '',
      'limit': limit ?? '10',
    };

    debugPrint('Body $body');

    try {
      if (demoIndex <= demoTotal) {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchDemos,
          queryParameters: body,
        );

        DemosModel? responseData;
        if (response != null) {
          Map<String, dynamic> json = response;
          responseData = DemosModel.fromJson(json);
          _demoModel = responseData;
        }

        if (responseData?.status == true) {
          debugPrint('Current Page $demoTotal');
          debugPrint(responseData?.message);
          if (responseData?.data?.haveData == true) {
            for (int i = 0; i < (responseData?.data?.length ?? 0); i++) {
              var data = responseData?.data?.elementAt(i);
              if (_demo == null) {
                debugPrint('$modelingData Added');
                if (data != null) {
                  _demo = [data];
                }
              } else {
                if (_demo?.contains(data) == true) {
                  debugPrint('$modelingData Already exit');
                } else {
                  if (data != null) {
                    _demo?.add(data);
                    debugPrint('$modelingData  Updated');
                  }
                }
              }
            }
            notifyListeners();
          }

          if (loadingNext) {
            demoController.loadComplete();
          } else {
            demoController.refreshCompleted();
          }
          demoTotal = responseData?.dataRecords?.totalPage ?? 1;
          demoIndex++;
          notifyListeners();
          debugPrint('$modelingData Total Pages $demoTotal');
          debugPrint('Updated $modelingData Current Page $demoIndex');
          return _demo;
        } else {
          debugPrint(responseData?.message);
          if (loadingNext) {
            demoController.loadFailed();
          } else {
            demoController.refreshFailed();
          }
          notifyListeners();
        }
      } else {
        demoController.loadNoData();
        loadingDemo = false;
        notifyListeners();
        debugPrint('Load no More data in $modelingData');
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    } finally {
      onComplete();
    }

    return _demo;
  }
}
