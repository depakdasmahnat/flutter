import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/services/api/exception_handler.dart';

import '../../core/config/api_config.dart';
import '../../core/services/api/api_service.dart';
import '../../models/feeds/feeds_data.dart';
import '../../models/feeds/feeds_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FeedsController extends ChangeNotifier {
  /// 1) Fetch Feeds  Data...
  bool loadingFeeds = true;
  FeedsModel? _feedsModel;

  FeedsModel? get feedsModel => _feedsModel;

  List<FeedsData>? _feeds;

  List<FeedsData>? get feeds => _feeds;
  num feedsIndex = 1;
  num feedsTotal = 1;

  RefreshController feedsController = RefreshController(initialRefresh: false);

  Future<List<FeedsData>?> fetchFeeds({
    required BuildContext context,
    bool isRefresh = false,
    bool loadingNext = false,
    String? searchKey,
    num? categoryId,
    String? limit,
  }) async {
    String modelingData = 'FeedsData';
    debugPrint('Fetching $modelingData Data...');

    onRefresh() {
      feedsIndex = 1;
      feedsTotal = 1;
      loadingFeeds = true;
      feedsController.resetNoData();
      _feedsModel = null;
      _feeds = null;
      notifyListeners();
      debugPrint('Cleared $modelingData');
    }

    onComplete() {
      loadingFeeds = false;
      notifyListeners();
    }

    if (isRefresh) {
      onRefresh();
    }

    Map<String, String> body = {
      'page': '$feedsIndex',
      'category_id': '${categoryId??''}',
      'search_key': searchKey ?? '',
      'limit': limit ?? '10',
    };

    debugPrint('Body $body');

    try {
      if (feedsIndex <= feedsTotal) {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.fetchFeeds,
          queryParameters: body,
        );
        FeedsModel? responseData;
        if (response != null) {
          Map<String, dynamic> json = response;
          responseData = FeedsModel.fromJson(json);
          _feedsModel = responseData;
        }

        if (responseData?.status == true) {
          debugPrint('Current Page $feedsTotal');
          debugPrint(responseData?.message);
          if (responseData?.data?.haveData == true) {
            for (int i = 0; i < (responseData?.data?.length ?? 0); i++) {
              var data = responseData?.data?.elementAt(i);
              if (_feeds == null) {
                debugPrint('$modelingData Added');
                if (data != null) {
                  _feeds = [data];
                }
              } else {
                if (_feeds?.contains(data) == true) {
                  debugPrint('$modelingData Already exit');
                } else {
                  if (data != null) {
                    _feeds?.add(data);
                    debugPrint('$modelingData  Updated');
                  }
                }
              }
            }
            notifyListeners();
          }

          if (loadingNext) {
            feedsController.loadComplete();
          } else {
            feedsController.refreshCompleted();
          }
          feedsTotal = responseData?.dataRecords?.totalPage ?? 1;
          feedsIndex++;
          notifyListeners();
          debugPrint('$modelingData Total Pages $feedsTotal');
          debugPrint('Updated $modelingData Current Page $feedsIndex');
          return _feeds;
        } else {
          debugPrint(responseData?.message);
          if (loadingNext) {
            feedsController.loadFailed();
          } else {
            feedsController.refreshFailed();
          }
          notifyListeners();
        }
      } else {
        feedsController.loadNoData();
        loadingFeeds = false;
        notifyListeners();
        debugPrint('Load no More data in $modelingData');
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    } finally {
      onComplete();
    }

    return _feeds;
  }
}
