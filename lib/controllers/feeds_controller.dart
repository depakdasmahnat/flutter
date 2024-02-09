
import 'package:flutter/material.dart';
import 'package:gaas/controllers/location/location_controller.dart';
import 'package:gaas/core/config/app_config.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/core/services/api/api_service.dart';
import 'package:gaas/models/default_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';

import '../core/services/database/local_database.dart';
import '../models/feeds/feeds_model.dart';
import '../models/feeds/view_feed_model.dart';
import '../models/partner/category_model.dart';
import '../utils/widgets/widgets.dart';

class FeedsController extends ChangeNotifier {
  /// 1) fetch Categories API...

  bool loadingCategories = true;
  CategoryModel? categoryModel;
  List<CategoryData>? categoryData;

  Future<List<CategoryData>?> fetchCategories({required BuildContext context, String? searchKey}) async {
    refresh() {
      loadingCategories = true;
      categoryModel = null;
      categoryData = null;
      loadingFeeds = true;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingCategories = false;
      notifyListeners();
    }

    refresh();

    Map<String, String> body = {
      "type": "Knowledge",
      "search_key": searchKey ?? "",
    };

    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_categories${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        CategoryModel responseData = CategoryModel.fromJson(json);

        if (responseData.status == true) {
          categoryModel = responseData;
          categoryData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return categoryData;
  }

  final ServiceType _serviceType = ServiceType.serviceProvider;

  ServiceType get serviceType => _serviceType;

  /// 2) Fetch FeedsModel API...
  shareFeed({FeedsData? feed}) {
    String description = feed?.description ?? "";
    if (feed?.description != null && feed?.fileType == FeedTypes.article.value) {
      description = parseHtmlToText(htmlString: description);
    }
    String? message = '${feed?.title ?? ""}\n$description\n${AppConfig.apkLink()}';
    return Share.share(message);
  }

  bool loadingFeeds = true;
  FeedsModel? _feedsModel;

  FeedsModel? get feedsModel => _feedsModel;
  List<FeedsData>? _feedsData;

  List<FeedsData>? get feedsData => _feedsData;
  num feedsIndex = 1;
  num feedsTotal = 1;

  Future<List<FeedsData>?> fetchFeeds({
    required BuildContext context,
    String? searchKey,
    bool isRefresh = false,
    num? categoryId,
    bool loadingNext = false,
    required RefreshController controller,
  }) async {
    debugPrint("Fetching ${_feedsData.runtimeType}...");

    refresh() {
      feedsIndex = 1;
      feedsTotal = 1;
      loadingFeeds = true;

      controller.resetNoData();
      _feedsModel = null;
      _feedsData = null;

      notifyListeners();
      debugPrint("cleared");
    }

    apiResponseCompleted() {
      loadingFeeds = false;
      notifyListeners();
    }

    onError() {
      if (loadingNext) {
        controller.loadFailed();
      } else {
        controller.refreshFailed();
      }
      notifyListeners();
    }

    if (isRefresh) {
      refresh();
    }

    LocationController location = Provider.of<LocationController>(context, listen: false);

    if (feedsIndex <= feedsTotal) {
      Map<String, String> body = {
        "page": "$feedsIndex",
        "search_key": searchKey ?? "",
        "category_id": "${categoryId ?? ""}",
        "latitude": "${location.latitude}",
        "longitude": "${location.longitude}",
      };

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      try {
        var response = await ApiService().get(
          context: context,
          endPoint: "/fetch_posts${queryParameter(body: body)}",
          headers: defaultHeaders,
        );

        if (response != null) {
          Map<String, dynamic> json = response;

          FeedsModel? responseData = FeedsModel.fromJson(json);
          _feedsModel = responseData;
          if (responseData.status == true) {
            debugPrint("Current Page $feedsTotal");
            debugPrint(responseData.message);

            for (int index = 0; index < (responseData.data?.length ?? 0); index++) {
              if (_feedsData == null) {
                _feedsData = [];
                notifyListeners();
              }

              if (_feedsData?.contains(responseData.data!.elementAt(index)) == false) {
                _feedsData?.add(responseData.data!.elementAt(index));
              }
            }

            feedsTotal = responseData.totalPage ?? 1;
            feedsIndex++;
            if (loadingNext) {
              controller.loadComplete();
            } else {
              controller.refreshCompleted();
            }

            if (feedsTotal <= feedsIndex) {
              controller.loadComplete();
            }
            notifyListeners();
            debugPrint("Total Pages $feedsTotal");
            debugPrint("Updated Current Page $feedsIndex");
            return _feedsData;
          } else {
            debugPrint(responseData.message);
            onError();
          }
        }
      } catch (e, s) {
        apiResponseCompleted();
        debugPrint(e.toString());
        debugPrint(s.toString());
      } finally {
        apiResponseCompleted();
      }
    } else {
      controller.loadNoData();
      apiResponseCompleted();
      debugPrint("Load no More data ");
    }
    notifyListeners();
    return _feedsData;
  }

  /// 3) fetch ViewFeedModel API...

  bool loadingViewFeed = true;
  ViewFeedModel? viewFeedModel;
  FeedsData? viewFeed;

  Future<FeedsData?> fetchViewFeed({
    required BuildContext context,
    required num? postId,
  }) async {
    refresh() {
      loadingViewFeed = true;
      viewFeedModel = null;
      viewFeed = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingViewFeed = false;
      notifyListeners();
    }

    refresh();

    Map<String, String> body = {
      "post_id": "${postId ?? ""}",
    };

    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/view_post${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        ViewFeedModel responseData = ViewFeedModel.fromJson(json);

        if (responseData.status == true) {
          viewFeedModel = responseData;
          viewFeed = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return viewFeed;
  }

  /// 4) Producer WishList
  bool loadingWishListStatus = true;

  manageProducerWishList({
    required num? postId,
    required bool? isLiked,
  }) {
    ///ServiceProvider Wishlist...
    FeedsData? feed;
    List<FeedsData?>? feeds = feedsData?.where((element) => element.id == postId).toList();
    if (feeds.haveData) {
      feed = feeds?.first;
    }

    ///WishList Management...
    num newLikes = feed?.likes ?? 0;
    if (isLiked == true) {
      newLikes = newLikes + 1;
    } else if (isLiked == false) {
      if (newLikes >= 1) {
        newLikes = newLikes - 1;
      }
    }

    feed?.likes = newLikes;
    viewFeed?.likes = newLikes;
    notifyListeners();

    feed?.isLiked = isLiked;
    viewFeed?.isLiked = isLiked;

    notifyListeners();
  }

  Future addToWishList({
    required BuildContext context,
    required num? postId,
  }) async {
    debugPrint("Add to Wishlist");

    manageProducerWishList(postId: postId, isLiked: null);

    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    try {
      Map<String, dynamic> body = {
        'post_id': "$postId",
      };

      debugPrint("$body");

      ApiService()
          .post(
        context: context,
        endPoint: "/post_like",
        body: body,
        headers: defaultHeaders,
      )
          .then(
        (response) {
          Map<String, dynamic> json = response;

          DefaultModel? responseData = DefaultModel.fromJson(json);

          if (responseData.status == true) {
            notifyListeners();
            manageProducerWishList(postId: postId, isLiked: true);
          } else {
            showSnackBar(
                context: context,
                text: responseData.message ?? "Failed to Add into Wishlist",
                color: Colors.red);
          }
        },
      );
    } catch (e, s) {
      debugPrint("$e $s");
    } finally {
      notifyListeners();
    }
  }

  Future removerWishList({
    required BuildContext context,
    required num? postId,
  }) async {
    debugPrint("Removing from Wishlist is");

    manageProducerWishList(postId: postId, isLiked: null);

    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    try {
      Map<String, dynamic> body = {
        'post_id': "$postId",
      };

      debugPrint("$body");
      await ApiService()
          .post(
        context: context,
        endPoint: "/post_unlike",
        body: body,
        headers: defaultHeaders,
      )
          .then(
        (response) {
          Map<String, dynamic> json = response;
          DefaultModel? responseData = DefaultModel.fromJson(json);
          if (responseData.status == true) {
            manageProducerWishList(postId: postId, isLiked: false);

            notifyListeners();
          } else {
            showSnackBar(
                context: context,
                text: responseData.message ?? "Failed to Add into Wishlist",
                color: Colors.red);
          }
        },
      );
    } catch (e, s) {
      debugPrint("$e $s");
    } finally {
      notifyListeners();
    }
  }
}
