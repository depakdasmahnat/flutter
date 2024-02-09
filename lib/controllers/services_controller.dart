import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gaas/controllers/location/location_controller.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/core/services/api/api_service.dart';
import 'package:gaas/models/dashboard/service/service_providers_map_model.dart';
import 'package:gaas/models/default_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../core/services/database/local_database.dart';
import '../models/dashboard/filters_model.dart';
import '../models/dashboard/service/all_service_providers_model.dart';
import '../models/dashboard/service/nearby_service_providers_model.dart';
import '../models/dashboard/service/service_provider_detail.dart';
import '../models/orders/orders_model.dart';
import '../models/orders/un_reviewed_orders.dart';
import '../models/partner/services/partner_reviews.dart';
import '../utils/widgets/widgets.dart';

class ServicesController extends ChangeNotifier {
  final ServiceType _serviceType = ServiceType.serviceProvider;

  ServiceType get serviceType => _serviceType;

  /// 1) Fetch NearbyServiceProvidersModel API...

  bool loadingNearbyServiceProviders = true;

  NearbyServiceProvidersModel? _nearbyServiceProvidersModel;

  NearbyServiceProvidersModel? get nearbyServiceProvidersModel => _nearbyServiceProvidersModel;
  List<ServiceProviderData>? _nearbyServiceProvidersData;

  List<ServiceProviderData>? get nearbyServiceProvidersData => _nearbyServiceProvidersData;
  num nearbyServiceProvidersIndex = 1;
  num nearbyServiceProvidersTotal = 1;

  Future<List<ServiceProviderData>?> fetchNearbyServiceProviders({
    required BuildContext context,
    bool isRefresh = false,
    bool loadingNext = false,
    required RefreshController controller,
  }) async {
    debugPrint("Fetching ${_nearbyServiceProvidersData.runtimeType}...");

    refresh() {
      nearbyServiceProvidersIndex = 1;
      nearbyServiceProvidersTotal = 1;
      loadingNearbyServiceProviders = true;

      controller.resetNoData();
      _nearbyServiceProvidersModel = null;
      _nearbyServiceProvidersData = null;

      notifyListeners();
      debugPrint("cleared");
    }

    apiResponseCompleted() {
      loadingNearbyServiceProviders = false;
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

    if (nearbyServiceProvidersIndex <= nearbyServiceProvidersTotal) {
      Map<String, String> body = {
        "page": "$nearbyServiceProvidersIndex",
        "latitude": "${location.latitude}",
        "longitude": "${location.longitude}",
      };

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      try {
        var response = await ApiService().get(
          context: context,
          endPoint: "/fetch_nearby_providers${queryParameter(body: body)}",
          headers: defaultHeaders,
        );

        if (response != null) {
          Map<String, dynamic> json = response;

          NearbyServiceProvidersModel? responseData = NearbyServiceProvidersModel.fromJson(json);
          _nearbyServiceProvidersModel = responseData;
          if (responseData.status == true) {
            debugPrint("Current Page $nearbyServiceProvidersTotal");
            debugPrint(responseData.message);

            for (int index = 0; index < (responseData.data?.length ?? 0); index++) {
              if (_nearbyServiceProvidersData == null) {
                _nearbyServiceProvidersData = [];
                notifyListeners();
              }

              if (_nearbyServiceProvidersData?.contains(responseData.data!.elementAt(index)) == false) {
                _nearbyServiceProvidersData?.add(responseData.data!.elementAt(index));
              }
            }

            nearbyServiceProvidersTotal = responseData.totalPage ?? 1;
            nearbyServiceProvidersIndex++;
            if (loadingNext) {
              controller.loadComplete();
            } else {
              controller.refreshCompleted();
            }

            if (nearbyServiceProvidersTotal <= nearbyServiceProvidersIndex) {
              controller.loadComplete();
            }
            notifyListeners();
            debugPrint("Total Pages $nearbyServiceProvidersTotal");
            debugPrint("Updated Current Page $nearbyServiceProvidersIndex");
            return _nearbyServiceProvidersData;
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
    return _nearbyServiceProvidersData;
  }

  /// Producer WishList

  manageProducerWishList({
    required num? id,
    int? wishlistId,
    required bool? inWishlist,
  }) {
    ///ServiceProvider Wishlist...
    ServiceProviderData? nearbyServiceProvider;
    List<ServiceProviderData?>? nearbyServiceProviders =
        _nearbyServiceProvidersData?.where((element) => element.id == id).toList();
    if (nearbyServiceProviders.haveData) {
      nearbyServiceProvider = nearbyServiceProviders?.first;
    }

    ///AllService Providers Wishlist...
    ServiceProviderData? allServiceProvider;
    List<ServiceProviderData?>? allServiceProviders =
        _allServiceProvidersData?.where((element) => element.id == id).toList();
    if (allServiceProviders.haveData) {
      allServiceProvider = allServiceProviders?.first;
    }

    ///WishList Management...
    if (wishlistId != null) {
      nearbyServiceProvider?.wishlistId = wishlistId;
      allServiceProvider?.wishlistId = wishlistId;
      serviceProviderDetailData?.wishlistId = wishlistId;
    }

    nearbyServiceProvider?.inWishlist = inWishlist;
    allServiceProvider?.inWishlist = inWishlist;
    serviceProviderDetailData?.inWishlist = inWishlist;

    notifyListeners();
  }

  Future addToWishList({
    required BuildContext context,
    required num? id,
    required WishListType? type,
    required num? targetId,
  }) async {
    debugPrint("Add to Wishlist is ${type?.value}");
    if (type == WishListType.partner) {
      manageProducerWishList(id: id, inWishlist: null);
    }
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
            notifyListeners();
            if (type == WishListType.partner) {
              manageProducerWishList(id: id, wishlistId: responseData.id, inWishlist: true);
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
  }

  Future removeProducerWishList({
    required BuildContext context,
    required num? id,
    required String? wishlistId,
    required WishListType? type,
  }) async {
    debugPrint("Removing from Wishlist is");

    if (type == WishListType.partner) {
      manageProducerWishList(id: id, inWishlist: null);
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
            if (type == WishListType.partner) {
              manageProducerWishList(id: id, inWishlist: false);
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
  }

  /// 5) Fetch AllServiceProvidersModel API...

  bool loadingAllServiceProviders = true;

  AllServiceProvidersModel? _allServiceProviders;

  AllServiceProvidersModel? get allServiceProviders => _allServiceProviders;
  List<ServiceProviderData>? _allServiceProvidersData;

  List<ServiceProviderData>? get allServiceProvidersData => _allServiceProvidersData;
  num allServiceProvidersIndex = 1;
  num allServiceProvidersTotal = 1;

  RefreshController allServiceProvidersController = RefreshController(initialRefresh: false);

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

  Future<List<ServiceProviderData>?> fetchAllServiceProviders({
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
    debugPrint("Fetching ${_allServiceProvidersData.runtimeType}...");

    refresh() {
      allServiceProvidersIndex = 1;
      allServiceProvidersTotal = 1;
      loadingAllServiceProviders = true;

      allServiceProvidersController.resetNoData();
      _allServiceProviders = null;
      _allServiceProvidersData = null;

      notifyListeners();
      debugPrint("cleared");
    }

    apiResponseCompleted() {
      loadingAllServiceProviders = false;
      notifyListeners();
    }

    onError() {
      if (loadingNext == true) {
        allServiceProvidersController.loadFailed();
      } else {
        allServiceProvidersController.refreshFailed();
      }
      notifyListeners();
    }

    if (isRefresh == true) {
      refresh();
    }

    LocationController location = Provider.of<LocationController>(context, listen: false);

    String? otherFilters = otherFilterBy?.haveData == true ? otherFilterBy?.join(",") : "";
    String? filterIds = selectedFilterIds?.haveData == true ? selectedFilterIds?.join(",") : "";

    if (allServiceProvidersIndex <= allServiceProvidersTotal) {
      Map<String, String> body = {
        "page": "$allServiceProvidersIndex",
        "type": type.value,
        "category_id": "${categoryId ?? ""}",
        "subcategory_id": "${subcategoryId ?? ""}",
        "sort_key": sortBy ?? "",
        "banner_id": "${bannerId ?? ""}",
        "partner_ids": partnerIds ?? "",
        "other_keys": otherFilters ?? "",
        "search_key": searchKey ?? "",
        "latitude": "${location.latitude}",
        "longitude": "${location.longitude}",
        "filter_ids": "$filterIds",
        "filter_options": getFilterOptionsIds(filterOptions: filterOptions),
      };

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      try {
        var response = await ApiService().get(
          context: context,
          endPoint: "/fetch_all_providers${queryParameter(body: body)}",
          headers: defaultHeaders,
        );

        Map<String, dynamic> json = response;

        AllServiceProvidersModel? responseData = AllServiceProvidersModel.fromJson(json);
        _allServiceProviders = responseData;
        if (responseData.status == true) {
          debugPrint("Current Page $allServiceProvidersTotal");
          debugPrint(responseData.message);

          for (int index = 0; index < (responseData.data?.length ?? 0); index++) {
            if (_allServiceProvidersData == null) {
              debugPrint("Initialized Empty Array in ${_allServiceProvidersData.runtimeType}...");
              _allServiceProvidersData = [];
              notifyListeners();
            }

            if (_allServiceProvidersData?.contains(responseData.data!.elementAt(index)) == false) {
              _allServiceProvidersData?.add(responseData.data!.elementAt(index));
            }
          }

          allServiceProvidersTotal = responseData.totalPage ?? 1;
          allServiceProvidersIndex++;
          if (loadingNext == true) {
            allServiceProvidersController.loadComplete();
          } else {
            allServiceProvidersController.refreshCompleted();
          }

          if (allServiceProvidersTotal <= allServiceProvidersIndex) {
            allServiceProvidersController.loadComplete();
          }
          notifyListeners();
          debugPrint("Total Pages $allServiceProvidersTotal");
          debugPrint("Updated Current Page $allServiceProvidersIndex");
          return _allServiceProvidersData;
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
      allServiceProvidersController.loadNoData();
      apiResponseCompleted();
      debugPrint("Load no More data ");
    }
    notifyListeners();
    return _allServiceProvidersData;
  }

  /// 3) fetch ServiceProviderDetail API...

  bool loadingServiceProviderDetail = true;
  ServiceProviderDetail? serviceProviderDetail;
  ServiceProviderData? serviceProviderDetailData;

//
  List<Services>? selectedServices() {
    List<Services>? subServices = [];

    serviceProviderDetailData?.services?.forEach((service) {
      if (service.selected == true) {
        subServices.add(service);
      }
    });

    return subServices;
  }

  num? selectedServicesPrice() {
    num total = 0;
    serviceProviderDetailData?.services?.forEach((service) {
      if (service.selected == true) {
        num? price = num.tryParse("${service.amount}") ?? 0;
        total = total + price;
      }
    });

    return total;
  }

//
  updateServicesStatus({
    required String? serviceId,
    required bool selected,
  }) {
    serviceProviderDetailData?.services?.forEach((service) {
      if (service.id == serviceId) {
        service.selected = !selected;
        notifyListeners();
      }
    });
  }

  Future<ServiceProviderData?> fetchServiceProviderDetail({
    required BuildContext context,
    num? id,
  }) async {
    refresh() {
      loadingServiceProviderDetail = true;
      serviceProviderDetail = null;
      serviceProviderDetailData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingServiceProviderDetail = false;
      notifyListeners();
    }

    refresh();
    LocationController location = Provider.of<LocationController>(context, listen: false);

    Map<String, String> body = {
      "partner_id": "${id ?? ""}",
      "latitude": "${location.latitude ?? ""}",
      "longitude": "${location.longitude ?? ""}",
    };

    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_provider_details${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        ServiceProviderDetail responseData = ServiceProviderDetail.fromJson(json);

        if (responseData.status == true) {
          serviceProviderDetail = responseData;
          serviceProviderDetailData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return serviceProviderDetailData;
  }

  /// 5) fetch Nearby Map Producers API...

  bool loadingMapServiceProviders = true;
  ServiceProvidersMapModel? mapServiceProvidersModel;
  List<ServiceProviderData>? mapServiceProvidersData;

  Future<List<ServiceProviderData>?> fetchMapServiceProducers({
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
      loadingMapServiceProviders = true;
      mapServiceProvidersModel = null;
      mapServiceProvidersData = null;
      location.clearMarkers();
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingMapServiceProviders = false;
      notifyListeners();
    }

    refresh();

    String? otherFilters = otherFilterBy?.haveData == true ? otherFilterBy?.join(",") : "";
    String? filterIds = selectedFilterIds?.haveData == true ? selectedFilterIds?.join(",") : "";

    Map<String, String> body = {
      "page": "$allServiceProvidersIndex",
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
      "filter_ids": "$filterIds",
      "filter_options": getFilterOptionsIds(filterOptions: filterOptions),
    };

    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

//Processing API...
    await ApiService()
        .post(
      context: context,
      endPoint: "/fetch_map_providers",
      body: body,
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        ServiceProvidersMapModel responseData = ServiceProvidersMapModel.fromJson(json);

        if (responseData.status == true) {
          mapServiceProvidersModel = responseData;
          mapServiceProvidersData = responseData.data;
          notifyListeners();
          if (mapServiceProvidersData.haveData) {
            for (int index = 0; index < (mapServiceProvidersData?.length ?? 0); index++) {
              var data = mapServiceProvidersData?.elementAt(index);

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

    return mapServiceProvidersData;
  }

  /// 5) requestQuote  API...
  Future requestQuote({
    required BuildContext context,
    required num? partnerId,
    required String? name,
    required String? email,
    required String? mobile,
    required String? comment,
    required String? serviceDateType,
    required String? serviceDate,
    required bool? publicContactInfo,
    required GestureTapCallback? onSuccess,
  }) async {
    Map<String, String> body = {
      "partner_id": "${partnerId ?? ""}",
      "name": name ?? "",
      "email": email ?? "",
      "mobile": mobile ?? "",
      "comment": comment ?? "",
      "public_contact_info": publicContactInfo == true ? "Yes" : "No",
      "service_date_type": serviceDateType ?? "",
      "service_date": serviceDate ?? "",
      "service_ids":
          selectedServices().haveData ? (selectedServices()?.map((e) => e.id).toList().join(",") ?? "") : "",
    };

    debugPrint("Sent Data is ${jsonEncode(body)}");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    var response = ApiService().post(
      context: context,
      endPoint: "/request_a_quote",
      body: body,
      headers: headers,
    );
//Processing API...
    loadingDialog(
      context: context,
      future: response,
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        DefaultModel responseData = DefaultModel.fromJson(json);
        if (responseData.status == true) {
          showSnackBar(
              context: context,
              text: responseData.message ?? "Your request sent successfully to service provider");
          onSuccess?.call();
        } else {
          showBanner(text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
    });
  }

  /// 7) Fetch PartnerReviews API...

  bool loadingPartnerReviews = true;

  PartnerReviews? _partnerReviews;

  PartnerReviews? get partnerReviews => _partnerReviews;
  List<ReviewList>? _reviewList;

  List<ReviewList>? get reviewList => _reviewList;
  num partnerReviewsIndex = 1;
  num partnerReviewsTotal = 1;

  Future<List<ReviewList>?> fetchPartnerReviews({
    required BuildContext context,
    required num? partnerId,
    bool? isRefresh = false,
    bool? loadingNext = false,
    required RefreshController controller,
  }) async {
    debugPrint("Fetching ${_reviewList.runtimeType}...");

    refresh() {
      partnerReviewsIndex = 1;
      partnerReviewsTotal = 1;
      loadingPartnerReviews = true;

      controller.resetNoData();
      _partnerReviews = null;
      _reviewList = null;

      notifyListeners();
      debugPrint("cleared");
    }

    apiResponseCompleted() {
      loadingPartnerReviews = false;
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

    if (partnerReviewsIndex <= partnerReviewsTotal) {
      Map<String, String> body = {
        "partner_id": "$partnerId",
        "page": "$partnerReviewsIndex",
      };

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      try {
        var response = await ApiService().get(
          context: context,
          endPoint: "/fetch_partner_reviews${queryParameter(body: body)}",
          headers: defaultHeaders,
        );

        if (response != null) {
          Map<String, dynamic> json = response;

          PartnerReviews? responseData = PartnerReviews.fromJson(json);
          _partnerReviews = responseData;
          if (responseData.status == true) {
            debugPrint("Current Page $partnerReviewsTotal");
            debugPrint(responseData.message);

            for (int index = 0; index < (responseData.data?.reviewList?.length ?? 0); index++) {
              if (_reviewList == null) {
                _reviewList = [];
                notifyListeners();
              }

              if (_reviewList?.contains(responseData.data!.reviewList?.elementAt(index)) == false) {
                _reviewList?.add(responseData.data!.reviewList!.elementAt(index));
              }
            }

            partnerReviewsTotal = responseData.totalPage ?? 1;
            partnerReviewsIndex++;

            if (loadingNext == true) {
              controller.loadComplete();
            } else {
              controller.refreshCompleted();
            }

            if (partnerReviewsTotal <= partnerReviewsIndex) {
              controller.loadComplete();
            }
            notifyListeners();
            debugPrint("Total Pages $partnerReviewsTotal");
            debugPrint("Updated Current Page $partnerReviewsIndex");
            return _reviewList;
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
    return _reviewList;
  }

  /// 8) fetch FreshProduce UnReviewed Orders API...

  bool loadingServicesUnReviewedOrders = true;
  UnReviewedOrders? servicesUnReviewedOrdersModel;
  List<OrdersData>? servicesUnReviewedOrders;

  clearServicesUnReviewedOrders({int? index}) {
    if (index != null) {
      servicesUnReviewedOrders?.removeAt(index);
    } else {
      servicesUnReviewedOrders = null;
    }
    notifyListeners();
  }

  Future<List<OrdersData>?> fetchServicesUnReviewedOrders({required BuildContext context}) async {
    refresh() {
      loadingServicesUnReviewedOrders = true;
      servicesUnReviewedOrdersModel = null;
      servicesUnReviewedOrders = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingServicesUnReviewedOrders = false;
      notifyListeners();
    }

    refresh();
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    Map<String, String> body = {
      "type": ServiceType.serviceProvider.value,
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_unreviewed_orders${queryParameter(body: body)}",
      headers: defaultHeaders,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        UnReviewedOrders responseData = UnReviewedOrders.fromJson(json);

        if (responseData.status == true) {
          servicesUnReviewedOrdersModel = responseData;
          servicesUnReviewedOrders = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return servicesUnReviewedOrders;
  }
}
