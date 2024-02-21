import 'package:flutter/cupertino.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../app.dart';
import '../../../core/config/api_config.dart';
import '../../../core/services/api/api_service.dart';
import '../../../core/services/api/exception_handler.dart';
import '../../../core/services/database/local_database.dart';
import '../../../models/member/auth/member_data.dart';
import '../../../models/member/dashboard/target_model.dart';
import '../../../models/member/demo/demo_model.dart';

class DemoController extends ChangeNotifier {
  bool loadingDemos = true;
  DemosModel? _demosModel;

  DemosModel? get demosModel => _demosModel;

  List<DemosData>? _demos;

  List<DemosData>? get demos => _demos;
  num demosIndex = 1;
  num demosTotal = 1;

  RefreshController demosController = RefreshController(initialRefresh: false);

  Future<List<DemosData>?> fetchDemos({
    required BuildContext context,
    bool isRefresh = false,
    bool loadingNext = false,
    String? searchKey,
    String? filter,
    String? limit,
    bool? type
  }) async {
    String modelingData = 'DemosData';
    debugPrint('Fetching $modelingData Data...');

    onRefresh() {
      demosIndex = 1;
      demosTotal = 1;
      loadingDemos = true;
      demosController.resetNoData();
      _demosModel = null;
      _demos = null;
      notifyListeners();
      debugPrint('Cleared $modelingData');
    }

    onComplete() {
      loadingDemos = false;
      notifyListeners();
    }
    if (isRefresh) {
      onRefresh();
    }

    Map<String, String> body = {
      'page': '$demosIndex',
      'search_key': searchKey ?? '',
      'limit': limit ?? '10',
      'filter': filter ?? '',
    };

    debugPrint('Body $body');

    try {
      if (demosIndex <= demosTotal) {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchAllDemos,
          // endPoint: ApiEndpoints.fetchAllDemos,
          queryParameters: body,
        );
        DemosModel? responseData;
        if (response != null) {
          Map<String, dynamic> json = response;
          responseData = DemosModel.fromJson(json);
          _demosModel = responseData;
        }
        if (responseData?.status == true) {
          debugPrint('Current Page $demosTotal');
          debugPrint(responseData?.message);
          if (responseData?.data?.haveData == true) {
            for (int i = 0; i < (responseData?.data?.length ?? 0); i++) {
              DemosData? data = responseData?.data?.elementAt(i);
              if (_demos == null) {
                debugPrint('$modelingData Added');
                if (data != null) {
                  _demos = [data];
                }
              } else {
                if (_demos?.contains(data) == true) {
                  debugPrint('$modelingData Already exist');
                } else {
                  if (data != null) {
                    _demos?.add(data);
                    debugPrint('$modelingData Updated');
                  }
                }
              }
            }
            notifyListeners();
          }

          if (loadingNext) {
            demosController.loadComplete();
          } else {
            demosController.refreshCompleted();
          }
          demosTotal = responseData?.dataRecords?.totalPage ?? 1;
          demosIndex++;
          notifyListeners();
          debugPrint('$modelingData Total Pages $demosTotal');
          debugPrint('Updated $modelingData Current Page $demosIndex');
          return _demos;
        } else {
          debugPrint(responseData?.message);
          if (loadingNext) {
            demosController.loadFailed();
          } else {
            demosController.refreshFailed();
          }
          notifyListeners();
        }
      } else {
        demosController.loadNoData();
        loadingDemos = false;
        notifyListeners();
        debugPrint('Load no More data in $modelingData');
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    } finally {
      onComplete();
    }

    return _demos;
  }

  /// 2) Target API...

  bool loadingTarget = true;
  TargetModel? targetModel;
  TargetData? targetData;

  Future<TargetData?> fetchTarget({
    num? memberId,
    String? filter,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    if (context != null) {
      onRefresh() {
        loadingTarget = true;
        targetModel = null;
        targetData = null;
        notifyListeners();
      }

      onComplete() {
        loadingTarget = false;
        notifyListeners();
      }

      onRefresh();

      try {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchTarget, // Update the endpoint
          queryParameters: {
            'filter': '$filter',
          },
        );

        if (response != null) {
          Map<String, dynamic> json = response;
          TargetModel responseData = TargetModel.fromJson(json);
          if (responseData.status == true) {
            targetData = responseData.data;
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

    return targetData;
  }
}
