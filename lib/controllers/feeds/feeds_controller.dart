import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/services/api/exception_handler.dart';
import 'package:mrwebbeast/models/default/default_model.dart';
import 'package:mrwebbeast/models/feeds/feed_details_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../app.dart';
import '../../core/config/api_config.dart';
import '../../core/services/api/api_service.dart';
import '../../models/feeds/comments_model.dart';
import '../../models/feeds/feed_details_model.dart';
import '../../models/feeds/feed_details_model.dart';
import '../../models/feeds/feeds_data.dart';
import '../../models/feeds/feeds_model.dart';
import '../../utils/widgets/widgets.dart';

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
    String? categoryId,
    String? limit,
  }) async {
    String modelingData = 'FeedsData';
    debugPrint('Fetching $modelingData Data...');
    debugPrint('Fetching $categoryId Data...');
    debugPrint('searchKey $searchKey Data...');
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
      'category_id': categoryId ?? '',
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

  /// 2) Feeds Details API...

  bool loadingFeedsDetails = true;
  FeedDetailsModel? _feedDetailsModel;

  FeedDetailsModel? get feedDetailsModel => _feedDetailsModel;

  List<FeedsData>? _feedsDetails;

  List<FeedsData>? get feedsDetails => _feedsDetails;
  num feedsDetailsIndex = 1;
  num feedsDetailsTotal = 1;
  num? haveMoreFeedsDetails;

  RefreshController feedsDetailsController = RefreshController(initialRefresh: false);

  Future<List<FeedsData>?> fetchFeedsDetails({
    required BuildContext context,
    required num? feedId,
    bool isRefresh = false,
    bool loadingNext = false,
    String? searchKey,
    num? categoryId,
    String? limit,
  }) async {
    String modelingData = 'FeedsData';
    debugPrint('Fetching $modelingData Data...');

    onRefresh() {
      feedsDetailsIndex = 1;
      feedsDetailsTotal = 1;
      haveMoreFeedsDetails = null;
      loadingFeedsDetails = true;
      feedsDetailsController.resetNoData();
      _feedDetailsModel = null;
      _feedsDetails = null;
      notifyListeners();
      debugPrint('Cleared $modelingData');
    }

    onComplete() {
      loadingFeedsDetails = false;
      notifyListeners();
    }

    if (isRefresh) {
      onRefresh();
    }

    Map<String, String> body = {
      'page': '$feedsDetailsIndex',
      'feed_id': '$feedId',
      'limit': limit ?? '10',
    };

    debugPrint('Body $body');

    try {
      if ((feedsDetailsIndex <= 1) ? true : haveMoreFeedsDetails != null) {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.viewFeed,
          queryParameters: body,
        );
        FeedDetailsModel? responseData;
        if (response != null) {
          Map<String, dynamic> json = response;
          responseData = FeedDetailsModel.fromJson(json);
          _feedDetailsModel = responseData;
        }

        if (responseData?.status == true) {
          debugPrint('Current Page $feedsDetailsTotal');
          debugPrint(responseData?.message);
          if (responseData?.data?.haveData == true) {
            for (int i = 0; i < (responseData?.data?.length ?? 0); i++) {
              var data = responseData?.data?.elementAt(i);
              if (_feedsDetails == null) {
                debugPrint('$modelingData Added');
                if (data != null) {
                  _feedsDetails = [data];
                }
              } else {
                if (_feedsDetails?.contains(data) == true) {
                  debugPrint('$modelingData Already exist');
                } else {
                  if (data != null) {
                    _feedsDetails?.add(data);
                    debugPrint('$modelingData Updated');
                  }
                }
              }
            }
            notifyListeners();
          }

          if (loadingNext) {
            feedsDetailsController.loadComplete();
          } else {
            feedsDetailsController.refreshCompleted();
          }
          haveMoreFeedsDetails = responseData?.moreDataAvailable;
          feedsDetailsIndex++;
          notifyListeners();
          debugPrint('$modelingData Total Pages $feedsDetailsTotal');
          debugPrint('Updated $modelingData Current Page $feedsDetailsIndex');
          return _feedsDetails;
        } else {
          debugPrint(responseData?.message);
          if (loadingNext) {
            feedsDetailsController.loadFailed();
          } else {
            feedsDetailsController.refreshFailed();
          }
          notifyListeners();
        }
      } else {
        feedsDetailsController.loadNoData();
        loadingFeedsDetails = false;
        notifyListeners();
        debugPrint('Load no More data in $modelingData');
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    } finally {
      onComplete();
    }

    return _feedsDetails;
  }

  /// 2) Like Feed...

  Future<bool> feedLike({
    required BuildContext context,
    required num? feedId,
  }) async {
    bool isLiked = false;
    FocusScope.of(context).unfocus();

    Map<String, String> body = {'feed_id': '$feedId'};

    debugPrint('Sent Data is $body');
    try {
      var response = await ApiService().post(
        endPoint: ApiEndpoints.feedLike,
        body: body,
      );

      if (response != null && context.mounted) {
        Map<String, dynamic> json = response;
        DefaultModel responseData = DefaultModel.fromJson(json);

        if (responseData.status == true) {
          isLiked == true;
        } else {
          showError(context: context, message: responseData.message ?? 'Something Went Wrong');
        }
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    }

    return isLiked;
  }

  Future<bool> feedUnLike({
    required BuildContext context,
    required num? feedId,
  }) async {
    bool isLiked = true;
    FocusScope.of(context).unfocus();

    Map<String, String> body = {'feed_id': '$feedId'};

    debugPrint('Sent Data is $body');
    try {
      var response = await ApiService().post(
        endPoint: ApiEndpoints.feedUnLike,
        body: body,
      );

      if (response != null && context.mounted) {
        Map<String, dynamic> json = response;
        DefaultModel responseData = DefaultModel.fromJson(json);

        if (responseData.status == true) {
          isLiked == false;
        } else {
          showError(context: context, message: responseData.message ?? 'Something Went Wrong');
        }
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    }

    return isLiked;
  }

  Future manageWishList({
    num? feedId,
    required bool? inWishList,
    bool? wishListScreen,
  }) async {
    BuildContext? context = MyApp.navigatorKey.currentContext;

    List<FeedsData>? thisProducts = _feeds?.where((element) => element.id == feedId).toList();
    FeedsData? product;
    if (thisProducts.haveData) {
      product = thisProducts?.first;
    }

    List<FeedsData>? thisFeedDetails = _feedsDetails?.where((element) => element.id == feedId).toList();
    FeedsData? feedDetail;
    if (thisFeedDetails.haveData) {
      feedDetail = thisFeedDetails?.first;
    }

    ///Set Wishlist to null
    product?.isLiked = null;
    feedDetail?.isLiked = null;

    onSuccess({bool success = true}) {
      bool newStatus = inWishList == true ? false : true;
      bool finalStatus = success ? newStatus : (inWishList ?? false);
      num productLikes = (product?.likes ?? 0);
      num finalLikes = finalStatus == true ? (productLikes + 1) : (productLikes - 1);

      product?.isLiked = finalStatus;
      product?.likes = finalLikes;

      feedDetail?.isLiked = finalStatus;
      feedDetail?.likes = finalLikes;

      debugPrint('finalStatus $finalStatus & $finalLikes Likes');
      notifyListeners();
    }

    notifyListeners();
    if (context != null) {
      if (inWishList == true) {
        bool status = await feedUnLike(context: context, feedId: feedId);
        if (status == false) {
          // wishListIds?.remove(feedId);
          if (wishListScreen == true) {
            // wishLists?.removeWhere((element) => element.id == feedId);
          }
          notifyListeners();
        } else {
          onSuccess(success: true);
          return;
        }
      } else {
        bool status = await feedLike(context: context, feedId: feedId);
        if (status == true) {
          // wishListIds?.add(feedId);
          notifyListeners();
        } else {
          onSuccess(success: true);
          return;
        }
      }

      onSuccess();

      notifyListeners();
    }
  }

  /// 1) Fetch Comments Data...
  bool loadingComments = true;
  CommentsModel? _commentsModel;

  CommentsModel? get commentsModel => _commentsModel;

  List<CommentsData>? _comments;

  List<CommentsData>? get comments => _comments;
  num commentsIndex = 1;
  num commentsTotal = 1;

  RefreshController commentsController = RefreshController(initialRefresh: false);

  Future<List<CommentsData>?> fetchComments({
    required BuildContext context,
    bool isRefresh = false,
    bool loadingNext = false,
    String? searchKey,
    num? feedId,
    String? limit,
  }) async {
    String modelingData = 'CommentsData';
    debugPrint('Fetching $modelingData Data...');

    onRefresh() {
      commentsIndex = 1;
      commentsTotal = 1;
      loadingComments = true;
      commentsController.resetNoData();
      _commentsModel = null;
      _comments = null;
      notifyListeners();
      debugPrint('Cleared $modelingData');
    }

    onComplete() {
      loadingComments = false;
      notifyListeners();
    }

    if (isRefresh) {
      onRefresh();
    }

    Map<String, String> body = {
      'page': '$commentsIndex',
      'feed_id': '$feedId',
      'search_key': searchKey ?? '',
      'limit': limit ?? '10',
    };

    debugPrint('Body $body');

    try {
      if (commentsIndex <= commentsTotal) {
        var response = await ApiService().get(
          endPoint: ApiEndpoints.getComments,
          queryParameters: body,
        );

        CommentsModel? responseData;
        if (response != null) {
          Map<String, dynamic> json = response;
          responseData = CommentsModel.fromJson(json);
          _commentsModel = responseData;
        }

        if (responseData?.status == true) {
          debugPrint('Current Page $commentsTotal');
          debugPrint(responseData?.message);
          if (responseData?.data?.haveData == true) {
            for (int i = 0; i < (responseData?.data?.length ?? 0); i++) {
              var data = responseData?.data?.elementAt(i);
              if (_comments == null) {
                debugPrint('$modelingData Added');
                if (data != null) {
                  _comments = [data];
                }
              } else {
                if (_comments?.contains(data) == true) {
                  debugPrint('$modelingData Already exit');
                } else {
                  if (data != null) {
                    _comments?.add(data);
                    debugPrint('$modelingData  Updated');
                  }
                }
              }
            }
            notifyListeners();
          }

          if (loadingNext) {
            commentsController.loadComplete();
          } else {
            commentsController.refreshCompleted();
          }
          commentsTotal = responseData?.dataRecords?.totalPage ?? 1;
          commentsIndex++;
          notifyListeners();
          debugPrint('$modelingData Total Pages $commentsTotal');
          debugPrint('Updated $modelingData Current Page $commentsIndex');
          return _comments;
        } else {
          debugPrint(responseData?.message);
          if (loadingNext) {
            commentsController.loadFailed();
          } else {
            commentsController.refreshFailed();
          }
          notifyListeners();
        }
      } else {
        commentsController.loadNoData();
        loadingComments = false;
        notifyListeners();
        debugPrint('Load no More data in $modelingData');
      }
    } catch (e, s) {
      ErrorHandler.catchError(e, s, true);
    } finally {
      onComplete();
    }

    return _comments;
  }

  /// 2) Default Model. API...
  Future<DefaultModel?> addComment({
    required BuildContext context,
    required num? feedId,
    required String? comment,
  }) async {
    FocusScope.of(context).unfocus();

    Map<String, String> body = {
      'feed_id': '$feedId',
      'comment': '$comment',
    };

    debugPrint('Sent Data is $body');

    var response = ApiService().post(endPoint: ApiEndpoints.feedComment, body: body);
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
          fetchComments(context: context, isRefresh: true, feedId: feedId);
        } else {
          showSnackBar(
              context: context, text: responseData?.message ?? 'Something went wong', color: Colors.red);
        }
      }
    });
    return responseData;
  }
}
