import 'package:flutter/material.dart';
import 'package:gaas/core/services/api/api_service.dart';
import 'package:gaas/models/default_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/services/database/local_database.dart';
import '../../utils/widgets/widgets.dart';
import '../models/dashboard/favorites_model.dart';
import 'dashboard_controller.dart';

class WishListController extends ChangeNotifier {
  /// 1) Fetch Favorites API...

  bool loadingFavorites = true;

  FavoritesModel? _favoritesModel;

  FavoritesModel? get favoritesModel => _favoritesModel;
  List<FavoritesData>? _favoritesData;

  List<FavoritesData>? get favoritesData => _favoritesData;
  num favoritesIndex = 1;
  num favoritesTotal = 1;

  RefreshController favoritesController = RefreshController(initialRefresh: false);

  Future<List<FavoritesData>?> fetchFavorites({
    required BuildContext context,
    String? searchKey,
    String? type,
    String? serviceType,
    bool? isRefresh = false,
    bool? loadingNext = false,
  }) async {
    debugPrint("Fetching ${_favoritesData.runtimeType}...");

    refresh() {
      favoritesIndex = 1;
      favoritesTotal = 1;
      loadingFavorites = true;

      favoritesController.resetNoData();
      _favoritesModel = null;
      _favoritesData = null;

      notifyListeners();
      debugPrint("cleared");
    }

    apiResponseCompleted() {
      loadingFavorites = false;
      notifyListeners();
    }

    onError() {
      if (loadingNext == true) {
        favoritesController.loadFailed();
      } else {
        favoritesController.refreshFailed();
      }
      notifyListeners();
    }

    if (isRefresh == true) {
      refresh();
    }

    if (favoritesIndex <= favoritesTotal) {
      Map<String, String> body = {
        "page": "$favoritesIndex",
        "search_key": searchKey ?? "",
        "type": type ?? "",
        "service_type": serviceType ?? "",
      };

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      try {
        var response = await ApiService().get(
          context: context,
          endPoint: "/fetch_favorites${queryParameter(body: body)}",
          headers: defaultHeaders,
        );

        Map<String, dynamic> json = response;

        FavoritesModel? responseData = FavoritesModel.fromJson(json);
        _favoritesModel = responseData;
        if (responseData.status == true) {
          debugPrint("Current Page $favoritesTotal");
          debugPrint(responseData.message);

          for (int index = 0; index < (responseData.data?.length ?? 0); index++) {
            if (_favoritesData == null) {
              debugPrint("Initialized Empty Array in ${_favoritesData.runtimeType}...");
              _favoritesData = [];
              notifyListeners();
            }

            if (_favoritesData?.contains(responseData.data!.elementAt(index)) == false) {
              _favoritesData?.add(responseData.data!.elementAt(index));
            }
          }

          favoritesTotal = responseData.totalPage ?? 1;
          favoritesIndex++;
          if (loadingNext == true) {
            favoritesController.loadComplete();
          } else {
            favoritesController.refreshCompleted();
          }

          if (favoritesTotal <= favoritesIndex) {
            favoritesController.loadComplete();
          }
          notifyListeners();
          debugPrint("Total Pages $favoritesTotal");
          debugPrint("Updated Current Page $favoritesIndex");
          return _favoritesData;
        } else {
          debugPrint(responseData.message);
          onError();
        }
      } catch (e, s) {
        apiResponseCompleted();
        debugPrint(e.toString());
        debugPrint(s.toString());
      } finally {
        apiResponseCompleted();
      }
    } else {
      favoritesController.loadNoData();
      apiResponseCompleted();
      debugPrint("Load no More data ");
    }
    notifyListeners();
    return _favoritesData;
  }

  removeFromWishList({required int? index}) {
    if (index != null) {
      _favoritesData?.removeAt(index);
    }

    notifyListeners();
  }

  /// 2) Apply Coupon API...

  Future addFavorite({
    required BuildContext context,
    required String? type,
    required num? targetId,
  }) async {
    debugPrint("Add to Wishlist is $type");

    context.read<DashboardController>().setProducerDetailsWishList(inWishlist: null);
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    try {
      Map<String, dynamic> body = {
        'target_id': "$targetId",
        'type': "$type",
      };

      debugPrint("$body");

      ApiService()
          .post(
        context: context,
        endPoint: "/add_favorite",
        body: body,
        headers: defaultHeaders,
      )
          .then(
        (response) {
          Map<String, dynamic> json = response;

          DefaultModel? responseData = DefaultModel.fromJson(json);

          if (responseData.status == true) {
            notifyListeners();
            context
                .read<DashboardController>()
                .setProducerDetailsWishList(wishlistId: responseData.id, inWishlist: true);
          } else {
            showSnackBar(
                context: context, text: responseData.message ?? "Failed to Add into Wishlist", color: Colors.red);
          }
        },
      );
    } catch (e, s) {
      debugPrint("$e $s");
    } finally {
      notifyListeners();
    }
  }

  Future removeFavorite({
    required BuildContext context,
    int? index,
    required String? wishlistId,
    bool? wishlistScreen = false,
  }) async {
    debugPrint("Removing from Wishlist is");
    if (wishlistScreen == true) {
      if (index != null) {
        _favoritesData?.elementAt(index).inWishlist = false;
      }
    } else {
      context.read<DashboardController>().setProducerDetailsWishList(inWishlist: null);
    }
    notifyListeners();
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    try {
      await ApiService()
          .get(
        context: context,
        endPoint: "/remove_favorite?wishlist_id=${wishlistId ?? ""}",
        headers: defaultHeaders,
      )
          .then(
        (response) {
          Map<String, dynamic> json = response;

          DefaultModel? responseData = DefaultModel.fromJson(json);

          if (responseData.status == true) {
            notifyListeners();

            if (wishlistScreen == true) {
              removeFromWishList(index: index);
            } else {
              context.read<DashboardController>().setProducerDetailsWishList(inWishlist: false);
            }
          } else {
            showSnackBar(
                context: context, text: responseData.message ?? "Failed to Add into Wishlist", color: Colors.red);
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
