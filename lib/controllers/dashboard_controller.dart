import 'package:flutter/material.dart';
import 'package:gaas/controllers/location/location_controller.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/core/services/api/api_service.dart';
import 'package:gaas/route/route_paths.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../core/services/database/local_database.dart';
import '../models/dashboard/all_producers.dart';
import '../models/dashboard/banners_model.dart';
import '../models/dashboard/coin_transactions.dart';
import '../models/dashboard/filters_model.dart';
import '../models/dashboard/fresh_produce_recent.dart';
import '../models/dashboard/global_search_model.dart';
import '../models/dashboard/near_by_map_producers.dart';
import '../models/dashboard/nearby_producers_model.dart';
import '../models/dashboard/partner_service_states.dart';
import '../models/dashboard/producer_details_model.dart';
import '../models/default_model.dart';
import '../models/partner/category_model.dart';
import 'orders/cart_controller.dart';

class DashboardController extends ChangeNotifier {
  int _dashBoardIndex = 0;

  int get dashBoardIndex => _dashBoardIndex;

  setDashBoardIndex({required int index, required BuildContext context}) {
    bool isAuthenticated = LocalDatabase().accessToken != null;

    if ((index == 4) && isAuthenticated == false) {
      context.pushNamed(Routs.getStarted);
      showSnackBar(context: context, text: "Please login to proceed to your cart.");
    } else {
      _dashBoardIndex = index;
      notifyListeners();
    }

    if (_dashBoardIndex == 0) {
      _serviceType = ServiceType.freshProduce;
    } else if (_dashBoardIndex == 1) {
      _serviceType = ServiceType.nursery;
    } else if (_dashBoardIndex == 2) {
      _serviceType = ServiceType.serviceProvider;
    }

    notifyListeners();
    if (index <= 2) {
      context.read<CartController>().loadCart(context);
    }
  }

  bool _fullScreenVideo = false;

  bool get fullScreenVideo => _fullScreenVideo;

  changFullScreenVideo({bool? value}) {
    _fullScreenVideo = value ?? !_fullScreenVideo;
    notifyListeners();
  }

  ServiceType _serviceType = ServiceType.freshProduce;

  ServiceType get serviceType => _serviceType;

  setServiceType({required ServiceType serviceType}) {
    _serviceType = serviceType;

    debugPrint("Current Service Type ${_serviceType.value}");
    notifyListeners();
  }

  /// 1) fetch Categories API...

  bool loadingCategories = true;
  CategoryModel? categoryModel;
  List<CategoryData>? categoryData;

  Future<List<CategoryData>?> fetchCategories({
    required BuildContext context,
    String? searchKey,
    required ServiceType? type,
  }) async {
    refresh() {
      loadingCategories = true;
      categoryModel = null;
      categoryData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingCategories = false;
      notifyListeners();
    }

    refresh();

    Map<String, String> body = {
      "type": type?.value ?? "",
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

  /// 2) fetch Sub Categories API...

  bool loadingSubCategories = true;
  CategoryModel? subCategoryModel;
  List<CategoryData>? subCategoryData;

  Future<List<CategoryData>?> fetchSubCategories({
    required BuildContext context,
    required ServiceType? type,
    required String? categoryId,
    bool? isAll,
    String? searchKey,
  }) async {
    refresh() {
      loadingSubCategories = true;
      subCategoryModel = null;
      subCategoryData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingSubCategories = false;
      notifyListeners();
    }

    refresh();

    Map<String, String> body = {
      "type": "${type?.value}",
      "category_id": categoryId ?? "",
      "search_key": searchKey ?? "",
      "is_all": isAll == true ? "Yes" : "No",
    };

    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_subcategories${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        CategoryModel responseData = CategoryModel.fromJson(json);

        if (responseData.status == true) {
          subCategoryModel = responseData;
          subCategoryData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return subCategoryData;
  }

  /// 3) fetch Banners API...

  bool loadingBanners = true;
  BannersModel? bannersModel;
  List<BannersData>? bannersData;

  Future<List<BannersData>?> fetchBanners({
    required BuildContext context,
    required ServiceType type,
  }) async {
    refresh() {
      loadingBanners = true;
      bannersModel = null;
      bannersData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingBanners = false;
      notifyListeners();
    }

    refresh();
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "banner_for": type.value,
    };
    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_banners${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        BannersModel responseData = BannersModel.fromJson(json);

        if (responseData.status == true) {
          bannersModel = responseData;
          bannersData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return bannersData;
  }

  /// 4) Fetch NearbyProducersModel API...

  bool loadingNearbyProducers = true;

  NearbyProducersModel? _nearbyProducersModel;

  NearbyProducersModel? get nearbyProducersModel => _nearbyProducersModel;
  List<NearbyProducersData>? _nearbyProducersData;

  List<NearbyProducersData>? get nearbyProducersData => _nearbyProducersData;
  num nearbyProducersIndex = 1;
  num nearbyProducersTotal = 1;

  Future<List<NearbyProducersData>?> fetchNearbyProducers({
    required BuildContext context,
    required ServiceType type,
    bool isRefresh = false,
    bool loadingNext = false,
    required RefreshController controller,
  }) async {
    debugPrint("Fetching ${_nearbyProducersData.runtimeType}...");

    refresh() {
      nearbyProducersIndex = 1;
      nearbyProducersTotal = 1;
      loadingNearbyProducers = true;

      controller.resetNoData();
      _nearbyProducersModel = null;
      _nearbyProducersData = null;

      notifyListeners();
      debugPrint("cleared");
    }

    apiResponseCompleted() {
      loadingNearbyProducers = false;
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

    if (nearbyProducersIndex <= nearbyProducersTotal) {
      Map<String, String> body = {
        "page": "$nearbyProducersIndex",
        "type": type.value,
        "latitude": "${location.latitude}",
        "longitude": "${location.longitude}",
        "loc_range": "${location.locationRange}",
      };

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      try {
        var response = await ApiService().get(
          context: context,
          endPoint: "/fetch_nearby_producers${queryParameter(body: body)}",
          headers: defaultHeaders,
        );

        if (response != null) {
          Map<String, dynamic> json = response;

          NearbyProducersModel? responseData = NearbyProducersModel.fromJson(json);
          _nearbyProducersModel = responseData;
          if (responseData.status == true) {
            debugPrint("Current Page $nearbyProducersTotal");
            debugPrint(responseData.message);

            for (int index = 0; index < (responseData.data?.length ?? 0); index++) {
              if (_nearbyProducersData == null) {
                debugPrint("Initialized Empty Array in ${_nearbyProducersData.runtimeType}...");
                _nearbyProducersData = [];
                notifyListeners();
              }

              if (_nearbyProducersData?.contains(responseData.data!.elementAt(index)) == false) {
                _nearbyProducersData?.add(responseData.data!.elementAt(index));
              }
            }

            nearbyProducersTotal = responseData.totalPage ?? 1;
            nearbyProducersIndex++;
            if (loadingNext) {
              controller.loadComplete();
            } else {
              controller.refreshCompleted();
            }

            if (nearbyProducersTotal <= nearbyProducersIndex) {
              controller.loadComplete();
            }
            notifyListeners();
            debugPrint("Total Pages $nearbyProducersTotal");
            debugPrint("Updated Current Page $nearbyProducersIndex");
            return _nearbyProducersData;
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
    return _nearbyProducersData;
  }

  /// Producer WishList

  manageProducerWishList({
    required num? id,
    int? wishlistId,
    required bool? inWishlist,
  }) {
    ///Nearby Producers Wishlist...
    NearbyProducersData? nearbyProducer;
    List<NearbyProducersData?>? nearbyProducersData =
        _nearbyProducersData?.where((element) => element.id == id).toList();
    if (nearbyProducersData.haveData) {
      nearbyProducer = nearbyProducersData?.first;
    }

    ///GlobalSearch Producers Wishlist...
    GlobalSearchData? globalSearchProducer;
    List<GlobalSearchData?>? globalSearchData =
        _globalSearchData?.where((element) => element.id == id).toList();
    if (globalSearchData.haveData) {
      globalSearchProducer = globalSearchData?.first;
    }

    ///AllProducers List Wishlist...
    AllProducersData? allProducers;
    List<AllProducersData?>? allProducersData =
        _allProducersData?.where((element) => element.id == id).toList();
    if (allProducersData.haveData) {
      allProducers = allProducersData?.first;
    }

    ///WishList Management...
    if (wishlistId != null) {
      nearbyProducer?.wishlistId = wishlistId;
      globalSearchProducer?.wishlistId = wishlistId;
      allProducers?.wishlistId = wishlistId;
      _producerDetailsData?.wishlistId = wishlistId;
    }

    nearbyProducer?.inWishlist = inWishlist;
    globalSearchProducer?.inWishlist = inWishlist;
    allProducers?.inWishlist = inWishlist;
    _producerDetailsData?.inWishlist = inWishlist;

    notifyListeners();
  }

  manageProductWishList({
    required num? id,
    int? wishlistId,
    required bool? inWishlist,
  }) {
    ///Nearby Producers Wishlist...
    ProducerProducts? producerProduct;
    List<ProducerProducts?>? producerProducts =
        _producerDetailsData?.products?.where((element) => element?.id == id).toList();
    if (producerProducts.haveData) {
      producerProduct = producerProducts?.first;
    }

    ///WishList Management...
    if (wishlistId != null) {
      producerProduct?.wishlistId = wishlistId;
    }

    producerProduct?.inWishlist = inWishlist;

    notifyListeners();
  }

  Future<int?> addToWishList({
    required BuildContext context,
    required num? id,
    required WishListType? type,
    required num? targetId,
  }) async {
    debugPrint("Add to Wishlist is ${type?.value}");
    if (type == WishListType.partner) {
      manageProducerWishList(id: id, inWishlist: null);
    } else {
      manageProductWishList(id: id, inWishlist: null);
    }

    int? newWishlistId;

    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    try {
      Map<String, dynamic> body = {
        'target_id': "$targetId",
        'type': "${type?.value}",
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
            newWishlistId = responseData.id;
            notifyListeners();
            if (type == WishListType.partner) {
              manageProducerWishList(id: id, wishlistId: newWishlistId, inWishlist: true);
            } else {
              manageProductWishList(id: id, wishlistId: newWishlistId, inWishlist: true);
            }
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
    return newWishlistId;
  }

  Future<bool> removeProducerWishList({
    required BuildContext context,
    required num? id,
    required String? wishlistId,
    required WishListType? type,
  }) async {
    bool inWishList = true;
    debugPrint("Removing from Wishlist is");

    if (type == WishListType.partner) {
      manageProducerWishList(id: id, inWishlist: null);
    } else {
      manageProductWishList(id: id, inWishlist: null);
    }
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
            inWishList = false;
            if (type == WishListType.partner) {
              manageProducerWishList(id: id, inWishlist: false);
            } else {
              manageProductWishList(id: id, inWishlist: false);
            }

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
    return inWishList;
  }

  /// 5) Fetch AllProducers API...

  bool loadingAllProducers = true;

  AllProducers? _allProducers;

  AllProducers? get allProducers => _allProducers;
  List<AllProducersData>? _allProducersData;

  List<AllProducersData>? get allProducersData => _allProducersData;
  num allProducersIndex = 1;
  num allProducersTotal = 1;

  RefreshController allProducersController = RefreshController(initialRefresh: false);

  String getFilterIds({
    required List<FiltersData?>? filterOptions,
  }) {
    String value = "";
    List<String>? values = [];
    if (filterOptions.haveData) {
      for (FiltersData? data in filterOptions ?? []) {
        values.add("${data?.selected?.id}");
      }
    }

    if (values.haveData) {
      value = values.join(",");
    }

    return value;
  }

  String getFilterOptionsIds({
    required List<FilterOptions?>? filterOptions,
  }) {
    String value = "";
    List<String>? values = [];
    if (filterOptions.haveData) {
      for (FilterOptions? data in filterOptions ?? []) {
        values.add("${data?.id}");
      }
    }

    if (values.haveData) {
      value = values.join(",");
    }

    return value;
  }

  Future<List<AllProducersData>?> fetchAllProducers({
    required BuildContext context,
    required ServiceType type,
    required AllOrderTypes? allOrderTypes,
    required num? categoryId,
    required num? subcategoryId,
    required String? sortBy,
    required List<num?>? selectedFilterIds,
    required List<FilterOptions?>? filterOptions,
    required List<String>? otherFilterBy,
    required String? searchKey,
    required num? bannerId,
    required String? partnerIds,
    bool? isRefresh = false,
    bool? loadingNext = false,
  }) async {
    debugPrint("Fetching ${_allProducersData.runtimeType}...");

    refresh() {
      allProducersIndex = 1;
      allProducersTotal = 1;
      loadingAllProducers = true;

      allProducersController.resetNoData();
      _allProducers = null;
      _allProducersData = null;

      notifyListeners();
      debugPrint("cleared");
    }

    apiResponseCompleted() {
      loadingAllProducers = false;
      notifyListeners();
    }

    onError() {
      if (loadingNext == true) {
        allProducersController.loadFailed();
      } else {
        allProducersController.refreshFailed();
      }
      notifyListeners();
    }

    if (isRefresh == true) {
      refresh();
    }

    LocationController location = Provider.of<LocationController>(context, listen: false);

    String? otherFilters = otherFilterBy?.haveData == true ? otherFilterBy?.join(",") : "";
    String? filterIds = selectedFilterIds?.haveData == true ? selectedFilterIds?.join(",") : "";

    if (allProducersIndex <= allProducersTotal) {
      Map<String, String> body = {
        "page": "$allProducersIndex",
        "type": type.value,
        "category_id": "${categoryId ?? ""}",
        "subcategory_id": "${subcategoryId ?? ""}",
        "service_type": allOrderTypes?.value ?? AllOrderTypes.all.value,
        "sort_key": sortBy ?? "",
        "banner_id": "${bannerId ?? ""}",
        "partner_ids": partnerIds ?? "",
        "other_keys": otherFilters ?? "",
        "search_key": searchKey ?? "",
        "latitude": "${location.latitude}",
        "longitude": "${location.longitude}",
        "loc_range": "${location.locationRange}",
        "filter_ids": "$filterIds",
        "filter_options": getFilterOptionsIds(filterOptions: filterOptions),
      };

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      try {
        var response = await ApiService().get(
          context: context,
          endPoint: "/fetch_all_producers${queryParameter(body: body)}",
          headers: defaultHeaders,
        );

        Map<String, dynamic> json = response;

        AllProducers? responseData = AllProducers.fromJson(json);
        _allProducers = responseData;
        if (responseData.status == true) {
          debugPrint("Current Page $allProducersTotal");
          debugPrint(responseData.message);

          for (int index = 0; index < (responseData.data?.length ?? 0); index++) {
            if (_allProducersData == null) {
              debugPrint("Initialized Empty Array in ${_allProducersData.runtimeType}...");
              _allProducersData = [];
              notifyListeners();
            }

            if (_allProducersData?.contains(responseData.data!.elementAt(index)) == false) {
              _allProducersData?.add(responseData.data!.elementAt(index));
            }
          }

          allProducersTotal = responseData.totalPage ?? 1;
          allProducersIndex++;
          if (loadingNext == true) {
            allProducersController.loadComplete();
          } else {
            allProducersController.refreshCompleted();
          }

          if (allProducersTotal <= allProducersIndex) {
            allProducersController.loadComplete();
          }
          notifyListeners();
          debugPrint("Total Pages $allProducersTotal");
          debugPrint("Updated Current Page $allProducersIndex");
          return _allProducersData;
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
      allProducersController.loadNoData();
      apiResponseCompleted();
      debugPrint("Load no More data ");
    }
    notifyListeners();
    return _allProducersData;
  }

  /// 6) Fetch ProducerDetailsModel API...

  bool loadingProducerDetails = true;

  ProducerDetailsModel? _producerDetailsModel;

  ProducerDetailsModel? get producerDetailsModel => _producerDetailsModel;

  ProducerDetailsData? _producerDetailsData;

  ProducerDetailsData? get producerDetailsData => _producerDetailsData;

  List<ProducerProducts>? _producerProducts;

  List<ProducerProducts>? get producerProducts => _producerProducts;

  setProducerDetailsWishList({
    int? wishlistId,
    required bool? inWishlist,
  }) {
    if (wishlistId != null) {
      _producerDetailsData?.wishlistId = wishlistId;
    }
    _producerDetailsData?.inWishlist = inWishlist;
    notifyListeners();
  }

  num producerDetailsIndex = 1;
  num producerDetailsTotal = 1;

  Future<ProducerDetailsData?> fetchProducerDetails({
    required BuildContext context,
    required ServiceType type,
    required String? partnerId,
    required num? productId,
    required String? searchKey,
    required String? sortBy,
    required String? orderType,
    required List<num?>? selectedFilterIds,
    required List<FilterOptions?>? filterOptions,
    required List<String>? otherFilterBy,
    bool? isRefresh = false,
    bool? isFullRefresh = false,
    bool? loadingNext = false,
    required RefreshController controller,
  }) async {
    debugPrint("Fetching ${_producerProducts.runtimeType}...");

    refresh() {
      producerDetailsIndex = 1;
      producerDetailsTotal = 1;
      loadingProducerDetails = true;
      controller.resetNoData();
      if (isFullRefresh == true) {
        _producerDetailsModel = null;
        _producerDetailsData = null;
        notifyListeners();
      }
      _producerProducts = null;
      notifyListeners();
      debugPrint("cleared");
    }

    apiResponseCompleted() {
      loadingProducerDetails = false;
      notifyListeners();
    }

    onError() {
      if (loadingNext == true) {
        controller.loadFailed();
      } else {
        controller.refreshFailed();
      }
      notifyListeners();
    }

    if (isRefresh == true) {
      refresh();
    }

    LocationController location = Provider.of<LocationController>(context, listen: false);
    String? otherFilters = otherFilterBy?.haveData == true ? otherFilterBy?.join(",") : "";
    String? filterIds = selectedFilterIds?.haveData == true ? selectedFilterIds?.join(",") : "";

    if (producerDetailsIndex <= producerDetailsTotal) {
      Map<String, String> body = {
        "page": "$producerDetailsIndex",
        "type": type.value,
        "partner_id": partnerId ?? "",
        "product_id": "${productId ?? ""}",
        "search_key": searchKey ?? "",
        "latitude": "${location.latitude}",
        "longitude": "${location.longitude}",
        "loc_range": "${location.locationRange}",
        "sort_key": sortBy ?? "",
        "order_type": orderType ?? "",
        "other_keys": otherFilters ?? "",
        "filter_ids": "$filterIds",
        "filter_options": getFilterOptionsIds(filterOptions: filterOptions),
      };

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      try {
        var response = await ApiService().get(
          context: context,
          endPoint: "/fetch_producer_details${queryParameter(body: body)}",
          headers: defaultHeaders,
        );

        Map<String, dynamic> json = response;

        ProducerDetailsModel? responseData = ProducerDetailsModel.fromJson(json);

        if (responseData.status == true) {
          debugPrint("Current Page $producerDetailsTotal");
          debugPrint(responseData.message);
          _producerDetailsModel = responseData;
          _producerDetailsData = _producerDetailsModel?.data;
          notifyListeners();

          for (int index = 0; index < (responseData.data?.products?.length ?? 0); index++) {
            if (_producerProducts == null) {
              debugPrint("Initialized Empty Array in ${_producerProducts.runtimeType}...");
              _producerProducts = [];
              notifyListeners();
            }

            if (_producerProducts?.contains(responseData.data!.products!.elementAt(index)) == false) {
              _producerProducts?.add(responseData.data!.products!.elementAt(index)!);
            }
          }

          producerDetailsTotal = responseData.totalPage ?? 1;
          producerDetailsIndex++;
          if (loadingNext == true) {
            controller.loadComplete();
          } else {
            controller.refreshCompleted();
          }

          if (producerDetailsTotal <= producerDetailsIndex) {
            controller.loadComplete();
          }
          notifyListeners();
          debugPrint("Total Pages $producerDetailsTotal");
          debugPrint("Updated Current Page $producerDetailsIndex");
          return _producerDetailsData;
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
      controller.loadNoData();
      apiResponseCompleted();
      debugPrint("Load no More data ");
    }
    notifyListeners();
    return _producerDetailsData;
  }

  /// 7) fetch Categories API...

  bool loadingFreshProduceRecent = true;
  FreshProduceRecent? freshProduceRecent;
  List<FreshProduceRecentData>? freshProduceData;

  Future<List<FreshProduceRecentData>?> fetchFreshProduceRecent({
    required BuildContext context,
    String? searchKey,
    required ServiceType? type,
  }) async {
    refresh() {
      loadingFreshProduceRecent = true;
      freshProduceRecent = null;
      freshProduceData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingFreshProduceRecent = false;
      notifyListeners();
    }

    refresh();

    Map<String, String> body = {
      "type": type?.value ?? "",
      "search_key": searchKey ?? "",
    };

    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_recents${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        FreshProduceRecent responseData = FreshProduceRecent.fromJson(json);

        if (responseData.status == true) {
          freshProduceRecent = responseData;
          freshProduceData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return freshProduceData;
  }

  /// 8) fetch Nearby Map Producers API...

  bool loadingNearbyMapProducers = true;
  NearByMapProducers? nearbyMapProducers;
  List<NearByMapProducersData>? nearbyMapProducersData;

  Future<List<NearByMapProducersData>?> fetchNearbyMapProducers({
    required BuildContext context,
    String? searchKey,
    required ServiceType type,
    required AllOrderTypes? allOrderTypes,
    required num? categoryId,
    required num? subcategoryId,
    required String? sortBy,
    required List<num?>? selectedFilterIds,
    required List<FilterOptions?>? filterOptions,
    required List<String>? otherFilterBy,
    required num? bannerId,
    required String? partnerIds,
  }) async {
    LocationController location = Provider.of<LocationController>(context, listen: false);
    refresh() {
      loadingNearbyMapProducers = true;
      nearbyMapProducers = null;
      nearbyMapProducersData = null;
      location.clearMarkers();
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingNearbyMapProducers = false;
      notifyListeners();
    }

    refresh();

    String? otherFilters = otherFilterBy?.haveData == true ? otherFilterBy?.join(",") : "";
    String? filterIds = selectedFilterIds?.haveData == true ? selectedFilterIds?.join(",") : "";

    Map<String, String> body = {
      "page": "$allProducersIndex",
      "type": type.value,
      "category_id": "${categoryId ?? ""}",
      "subcategory_id": "${subcategoryId ?? ""}",
      "service_type": allOrderTypes?.value ?? AllOrderTypes.all.value,
      "sort_key": sortBy ?? "",
      "banner_id": "${bannerId ?? ""}",
      "partner_ids": partnerIds ?? "",
      "other_keys": otherFilters ?? "",
      "search_key": searchKey ?? "",
      "latitude": "${location.latitude}",
      "longitude": "${location.longitude}",
      "loc_range": "${location.locationRange}",
      "filter_ids": "$filterIds",
      "filter_options": getFilterOptionsIds(filterOptions: filterOptions),
    };

    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

//Processing API...
    await ApiService()
        .post(
      context: context,
      endPoint: "/fetch_map_producers",
      body: body,
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        NearByMapProducers responseData = NearByMapProducers.fromJson(json);

        if (responseData.status == true) {
          nearbyMapProducers = responseData;
          nearbyMapProducersData = responseData.data;
          notifyListeners();

          if (nearbyMapProducersData.haveData) {
            for (int index = 0; index < (nearbyMapProducersData?.length ?? 0); index++) {
              var data = nearbyMapProducersData?.elementAt(index);

              double latitude = double.parse("${data?.latitude ?? 0}");
              double longitude = double.parse("${data?.longitude ?? 0}");
              debugPrint("Service Latitude => $latitude");
              debugPrint("Service Longitude => $longitude");
              location.setProducerMarkers(
                lat: latitude,
                long: longitude,
                id: data?.id,
                title: data?.name,
                snippet: data?.address,
                imageUrl: data?.profilePhoto,
                context: context,
              );

              CameraPosition cameraPosition = CameraPosition(target: LatLng(latitude, longitude), zoom: 18);

              if (index == 0) {
                Future.delayed(const Duration(milliseconds: 300)).then((value) {
                  location.animateTo(context: context, cameraPosition: cameraPosition);
                });
              }
            }
          }
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return nearbyMapProducersData;
  }

  /// 9) Fetch AllProducers API...

  bool loadingGlobalSearch = true;

  GlobalSearchModel? _globalSearchModel;

  GlobalSearchModel? get globalSearchModel => _globalSearchModel;
  List<GlobalSearchData>? _globalSearchData;

  List<GlobalSearchData>? get globalSearchData => _globalSearchData;
  num globalSearchIndex = 1;
  num globalSearchTotal = 1;

  RefreshController globalSearchController = RefreshController(initialRefresh: false);

  Future<List<GlobalSearchData>?> fetchGlobalSearch({
    required BuildContext context,
    String? searchKey,
    bool? isRefresh = false,
    bool? loadingNext = false,
  }) async {
    debugPrint("Fetching ${_globalSearchData.runtimeType}...");

    refresh() {
      globalSearchIndex = 1;
      globalSearchTotal = 1;
      loadingGlobalSearch = true;

      globalSearchController.resetNoData();
      _globalSearchModel = null;
      _globalSearchData = null;

      notifyListeners();
      debugPrint("cleared");
    }

    LocationController location = Provider.of<LocationController>(context, listen: false);

    apiResponseCompleted() {
      loadingGlobalSearch = false;
      notifyListeners();
    }

    onError() {
      if (loadingNext == true) {
        globalSearchController.loadFailed();
      } else {
        globalSearchController.refreshFailed();
      }
      notifyListeners();
    }

    if (isRefresh == true) {
      refresh();
    }

    if (globalSearchIndex <= globalSearchTotal) {
      Map<String, String> body = {
        "page": "$globalSearchIndex",
        "search_key": searchKey ?? "",
        "type": serviceType.value,
        "latitude": "${location.latitude}",
        "longitude": "${location.longitude}",
        "loc_range": "${location.locationRange}",
      };

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      try {
        var response = await ApiService().post(
          context: context,
          endPoint: "/global_search",
          body: body,
          headers: defaultHeaders,
        );

        Map<String, dynamic> json = response;

        GlobalSearchModel? responseData = GlobalSearchModel.fromJson(json);
        _globalSearchModel = responseData;
        if (responseData.status == true) {
          debugPrint("Current Page $globalSearchTotal");
          debugPrint(responseData.message);

          for (int index = 0; index < (responseData.data?.length ?? 0); index++) {
            if (_globalSearchData == null) {
              debugPrint("Initialized Empty Array in ${_globalSearchData.runtimeType}...");
              _globalSearchData = [];
              notifyListeners();
            }

            if (_globalSearchData?.contains(responseData.data!.elementAt(index)) == false) {
              _globalSearchData?.add(responseData.data!.elementAt(index));
            }
          }

          globalSearchTotal = responseData.totalPage ?? 1;
          globalSearchIndex++;
          if (loadingNext == true) {
            globalSearchController.loadComplete();
          } else {
            globalSearchController.refreshCompleted();
          }

          if (globalSearchTotal <= globalSearchIndex) {
            globalSearchController.loadComplete();
          }
          notifyListeners();
          debugPrint("Total Pages $globalSearchTotal");
          debugPrint("Updated Current Page $globalSearchIndex");
          return _globalSearchData;
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
      globalSearchController.loadNoData();
      apiResponseCompleted();
      debugPrint("Load no More data ");
    }
    notifyListeners();
    return _globalSearchData;
  }

  /// 10) fetch Filters Model API...

  bool loadingFilters = true;
  FiltersModel? filtersModel;
  List<FiltersData>? filtersData;

  Future<List<FiltersData>?> fetchFilters({
    required BuildContext context,
    required ServiceType? type,
    String? searchKey,
  }) async {
    refresh() {
      loadingFilters = true;
      filtersModel = null;
      filtersData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingFilters = false;
      notifyListeners();
    }

    refresh();

    Map<String, String> body = {
      "type": "${type?.value}",
      "search_key": searchKey ?? "",
    };

    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    debugPrint("Fetching fetch_filters");
//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_filters${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        FiltersModel responseData = FiltersModel.fromJson(json);

        if (responseData.status == true) {
          filtersModel = responseData;
          filtersData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return filtersData;
  }

  /// 10) fetch PartnerServiceStates API...

  bool loadingPartnerServiceStates = true;
  PartnerServiceStates? partnerServiceStates;
  PartnerServiceStatesData? partnerServiceStatesData;

  Future<PartnerServiceStatesData?> fetchPartnerServiceStates({
    required BuildContext context,
  }) async {
    refresh() {
      loadingPartnerServiceStates = true;
      partnerServiceStates = null;
      partnerServiceStatesData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingPartnerServiceStates = false;
      notifyListeners();
    }

    refresh();

    Map<String, String> body = {};

    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    debugPrint("Fetching fetch_service_stats");
//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_service_stats${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        PartnerServiceStates responseData = PartnerServiceStates.fromJson(json);

        if (responseData.status == true) {
          partnerServiceStates = responseData;
          partnerServiceStatesData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return partnerServiceStatesData;
  }

  /// 12) Fetch Favorites API...

  bool loadingCoinTransactions = true;

  CoinTransactionsModel? _coinTransactionsModel;

  CoinTransactionsModel? get coinTransactionsModel => _coinTransactionsModel;
  List<CoinTransactionsData>? _coinTransactions;

  List<CoinTransactionsData>? get coinTransactions => _coinTransactions;
  num coinTransactionsIndex = 1;
  num coinTransactionsTotal = 1;

  RefreshController coinTransactionsController = RefreshController(initialRefresh: false);

  Future<List<CoinTransactionsData>?> fetchCoinTransactions({
    required BuildContext context,
    String? searchKey,
    String? type,
    String? serviceType,
    bool? isRefresh = false,
    bool? loadingNext = false,
  }) async {
    debugPrint("Fetching ${_coinTransactions.runtimeType}...");

    refresh() {
      coinTransactionsIndex = 1;
      coinTransactionsTotal = 1;
      loadingCoinTransactions = true;

      coinTransactionsController.resetNoData();
      _coinTransactionsModel = null;
      _coinTransactions = null;

      notifyListeners();
      debugPrint("cleared");
    }

    apiResponseCompleted() {
      loadingCoinTransactions = false;
      notifyListeners();
    }

    onError() {
      if (loadingNext == true) {
        coinTransactionsController.loadFailed();
      } else {
        coinTransactionsController.refreshFailed();
      }
      notifyListeners();
    }

    if (isRefresh == true) {
      refresh();
    }

    if (coinTransactionsIndex <= coinTransactionsTotal) {
      Map<String, String> body = {
        "page": "$coinTransactionsIndex",
        "search_key": searchKey ?? "",
        "type": type ?? "",
        "service_type": serviceType ?? "",
      };

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      try {
        var response = await ApiService().get(
          context: context,
          endPoint: "/fetch_coin_transactions${queryParameter(body: body)}",
          headers: defaultHeaders,
        );

        Map<String, dynamic> json = response;

        CoinTransactionsModel? responseData = CoinTransactionsModel.fromJson(json);
        _coinTransactionsModel = responseData;
        if (responseData.success == true) {
          debugPrint("Current Page $coinTransactionsTotal");
          debugPrint(responseData.message);

          for (int index = 0; index < (responseData.data?.length ?? 0); index++) {
            if (_coinTransactions == null) {
              debugPrint("Initialized Empty Array in ${_coinTransactions.runtimeType}...");
              _coinTransactions = [];
              notifyListeners();
            }

            if (_coinTransactions?.contains(responseData.data!.elementAt(index)) == false) {
              _coinTransactions?.add(responseData.data!.elementAt(index));
            }
          }

          coinTransactionsTotal = responseData.totalPage ?? 1;
          coinTransactionsIndex++;
          if (loadingNext == true) {
            coinTransactionsController.loadComplete();
          } else {
            coinTransactionsController.refreshCompleted();
          }

          if (coinTransactionsTotal <= coinTransactionsIndex) {
            coinTransactionsController.loadComplete();
          }
          notifyListeners();
          debugPrint("Total Pages $coinTransactionsTotal");
          debugPrint("Updated Current Page $coinTransactionsIndex");
          return _coinTransactions;
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
      coinTransactionsController.loadNoData();
      apiResponseCompleted();
      debugPrint("Load no More data ");
    }
    notifyListeners();
    return _coinTransactions;
  }

  /// 4) addFeedback API...
  Future addFeedback({
    required BuildContext context,
    required String? title,
    required String? description,
  }) async {
    Map<String, String> body = {
      "title": title ?? "",
      "description": description ?? "",
    };

    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    debugPrint("Sent Data is $body");

    var response =
        ApiService().post(context: context, endPoint: "/add_feedback", body: body, headers: headers);
//Processing API...
    loadingDialog(
      context: context,
      future: response,
    ).then((response) {
      Map<String, dynamic> json = response;
      if (response != null) {
        DefaultModel responseData = DefaultModel.fromJson(json);
        if (responseData.status == true) {
          context.pop();
          showSnackBar(
              context: context,
              text: responseData.message ?? "Successfully added Feedback",
              color: primaryColor);
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
    });
  }
}
