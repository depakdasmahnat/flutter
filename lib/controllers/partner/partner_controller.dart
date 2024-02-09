import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:gaas/core/extensions/normal/build_context_extension.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/models/default_model.dart';
import 'package:gaas/models/partner/cities_model.dart';
import 'package:gaas/models/partner/membership/subscriptions_model.dart';
import 'package:gaas/route/route_paths.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/services/api/api_service.dart';
import '../../core/services/database/local_database.dart';
import '../../models/auth/authentication.dart';
import '../../models/dashboard/banners_model.dart';
import '../../models/partner/auth/check_timeline_status.dart';
import '../../models/partner/auth/partner_model.dart';
import '../../models/partner/category_model.dart';
import '../../models/partner/countries_model.dart';
import '../../models/partner/earnings_model.dart';
import '../../models/partner/partner_dash_board_model.dart';
import '../../models/partner/partner_live_status.dart';
import '../../models/partner/setup/day_wise_time_slots.dart';
import '../../models/partner/setup/delivery_zones_model.dart';
import '../../models/partner/setup/partner_timeslots_model.dart';
import '../../models/partner/setup/timeslot_dates.dart';
import '../../models/partner/setup/timeslots_model.dart';
import '../../models/partner/states_model.dart';
import '../../screens/dashboard/dashboard.dart';
import '../../screens/partner/setup/select_delivery_zone.dart';
import '../../screens/partner/setup/select_timeslots.dart';
import '../../screens/partner/signup/join_as_partner.dart';
import '../auth/auth_controller.dart';
import 'membership_controller.dart';
import 'product_controller.dart';

class PartnerController extends ChangeNotifier {
  int dashBoardIndex = 0;
  int ordersTabIndex = 0;

  resetIndex() {
    dashBoardIndex = 0;
    ordersTabIndex = 0;
    notifyListeners();
  }

  setDashBoardIndex(int index) {
    dashBoardIndex = index;

    notifyListeners();
  }

  setOrdersTabIndex(int index) {
    ordersTabIndex = index;

    notifyListeners();
  }

  onPartnerBackPress(BuildContext context) async {
    if (dashBoardIndex == 0) {
      await onPartnerDashboardBack().then((willPop) {
        if (willPop == true) {
          context.pop();
        }
      });
    } else {
      setDashBoardIndex(0);
    }
  }

  ServiceType _serviceType = ServiceType.freshProduce;

  ServiceType get serviceType => _serviceType;

  setServiceType({required ServiceType serviceType}) {
    _serviceType = serviceType;

    debugPrint("Current Service Type ${_serviceType.value}");
    notifyListeners();
  }

  /// 3) fetch Countries API...

  bool loadingCountries = true;
  CountriesModel? countriesModel;
  List<CountriesData>? countriesData;

  Future<List<CountriesData>?> fetchCountries({
    required BuildContext context,
    String? searchKey,
  }) async {
    refresh() {
      loadingCountries = true;
      countriesModel = null;
      countriesData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingCountries = false;
      notifyListeners();
    }

    refresh();

    Map<String, String> body = {
      "search_key": searchKey ?? "",
    };

    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_countries${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        CountriesModel responseData = CountriesModel.fromJson(json);

        if (responseData.status == true) {
          countriesModel = responseData;
          countriesData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return countriesData;
  }

  /// 4) fetch States API...

  bool loadingStates = true;
  StatesModel? statesModel;
  List<StatesData>? statesData;

  Future<List<StatesData>?> fetchStates({
    required BuildContext context,
    String? countryId,
    String? searchKey,
  }) async {
    refresh() {
      loadingStates = true;
      statesModel = null;
      statesData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingStates = false;
      notifyListeners();
    }

    refresh();
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "country_id": countryId ?? "",
      "search_key": searchKey ?? "",
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_states${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        StatesModel responseData = StatesModel.fromJson(json);

        if (responseData.status == true) {
          statesModel = responseData;
          statesData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return statesData;
  }

  /// 5) fetch Cities API...

  bool loadingCities = true;
  CitiesModel? citiesModel;
  List<CategoryData>? citiesData;

  Future<List<CategoryData>?> fetchCities({
    required BuildContext context,
    String? type,
    String? stateId,
    String? searchKey,
  }) async {
    refresh() {
      loadingCities = true;
      citiesModel = null;
      citiesData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingCities = false;
      notifyListeners();
    }

    refresh();
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "country_id": type ?? "",
      "state_id": stateId ?? "",
      "search_key": searchKey ?? "",
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_cities${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        CitiesModel responseData = CitiesModel.fromJson(json);

        if (responseData.status == true) {
          citiesModel = responseData;
          citiesData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return citiesData;
  }

  /// 3) join As Partner API...
  Future joinAsPartner({
    required BuildContext context,
    required ServiceType? type,
    required bool? isDirect,
    required List<ServiceType>? selectedServiceTypes,
    required String? name,
    required String? email,
    required String? mobile,
    required String? password,
    required String? countryCode,
    required String? latitude,
    required String? longitude,
    required String? locAddress,
    required String? address,
    required String? countryId,
    required String? stateId,
    required String? cityId,
    required String? pinCode,
    required String? categories,
    required File? profilePhoto,
    required String? partnerType,
    required String? documentName,
    required String? documentNumber,
    required List<PlatformFile?>? documents,
    required List<File?>? images,
    required String? businessName,
    required String? businessEmail,
    required String? businessMobile,
  }) async {
    Map<String, String> body = {
      "type": "${type?.value}",
      "name": name ?? "",
      "is_direct": isDirect == true ? "Yes" : "No",
      "mobile": mobile ?? "",
      "password": password ?? "",
      "country_code": countryCode ?? "",
      "email": email ?? "",
      "latitude": latitude ?? "",
      "longitude": longitude ?? "",
      "loc_address": locAddress ?? "",
      "address": address ?? "",
      "country_id": countryId ?? "",
      "state_id": stateId ?? "",
      "city_id": cityId ?? "",
      "pincode": pinCode ?? "",
      "categories": categories ?? "",
      "partner_type": partnerType ?? "",
      "document_name": documentName ?? "",
      "document_number": documentNumber ?? "",
      "business_name": businessName ?? "",
      "business_email": businessEmail ?? "",
      "business_mobile": businessMobile ?? "",
    };

    debugPrint("Sent Data is $body");
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    List<MultiPartData?> multiPartData = [];

    if (profilePhoto != null) {
      multiPartData.add(MultiPartData(field: "profile_photo", filePath: profilePhoto.path));
    }

    for (PlatformFile? element in documents ?? []) {
      var image = MultiPartData(field: "document[]", filePath: element?.path);
      multiPartData.add(image);
    }
    for (var element in images ?? []) {
      var image = MultiPartData(field: "images[]", filePath: element?.path);
      multiPartData.add(image);
    }

    var response = ApiService().multiPart(
      context: context,
      endPoint: isDirect == true ? "/direct_join_as_partner" : "/join_as_partner",
      headers: defaultHeaders,
      body: body,
      multipartFile: multiPartData,
    );

    //Processing API...
    loadingDialog(
      context: context,
      future: response,
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = jsonDecode(response);
        LocalDatabase localDatabase = LocalDatabase();
        AuthenticationModel responseData = AuthenticationModel.fromJson(json);
        List<ServiceType>? newSelectedServiceTypes = selectedServiceTypes;

        if (responseData.status == true) {
          if (isDirect == true) {
            localDatabase.saveUser(user: responseData.data);
          }
          newSelectedServiceTypes?.remove(type);
          if (newSelectedServiceTypes?.haveData == true) {
            context.pushNamed(Routs.joinAsPartner,
                extra: JoinAsPartner(
                  type: newSelectedServiceTypes?.first,
                  selectedServiceTypes: newSelectedServiceTypes,
                ));
          } else {
            AuthControllers authControllers = Provider.of<AuthControllers>(context, listen: false);
            authControllers.checkPartnerRequest(context: context);
            authControllers.fetchProfile(context: context);
            context.firstRoute();

            context.pushReplacementNamed(Routs.dashboard, extra: const DashBoard(dashBoardIndex: 0));
          }
          showSnackBar(context: context, text: responseData.message ?? "Request sent for $type Partnership");
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wrong", color: Colors.red);
        }
      }
    });
  }

  /// 4) fetch UserData API...

  PartnerData? partnerData;

  Future<PartnerData?> fetchPartnerProfile({
    required BuildContext context,
  }) async {
    // partnerData = null;
    // notifyListeners();
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_partner_profile?type=${serviceType.value}",
      headers: defaultHeaders,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        PartnerModel responseData = PartnerModel.fromJson(json);

        if (responseData.status == true) {
          partnerData = responseData.data;

          notifyListeners();
        } else {
          partnerData = responseData.data;
          notifyListeners();
        }
      }
    }).catchError((e, s) {
      debugPrint("Error is $e & $s");
    });

    return partnerData;
  }

  /// 5) edit Partner ProfileAPI...
  Future editPartnerProfile({
    required BuildContext context,
    required num? id,
    required ServiceType? type,
    required String? name,
    required String? email,
    required String? mobile,
    required String? countryCode,
    required String? latitude,
    required String? longitude,
    required String? locAddress,
    required String? address,
    required String? countryId,
    required String? stateId,
    required String? cityId,
    required String? pinCode,
    required String? categories,
    required File? profilePhoto,
    required String? partnerType,
    required String? documentName,
    required String? documentNumber,
    required List<PlatformFile?>? documents,
    required List<File?>? images,
    required String? businessName,
    required String? businessEmail,
    required String? businessMobile,
  }) async {
    Map<String, String> body = {
      "id": "${id ?? ""}",
      "type": "${type?.value}",
      "name": name ?? "",
      "mobile": mobile ?? "",
      "country_code": countryCode ?? "",
      "email": email ?? "",
      "latitude": latitude ?? "",
      "longitude": longitude ?? "",
      "loc_address": locAddress ?? "",
      "address": address ?? "",
      "country_id": countryId ?? "",
      "state_id": stateId ?? "",
      "city_id": cityId ?? "",
      "pincode": pinCode ?? "",
      "categories": categories ?? "",
      "partner_type": partnerType ?? "",
      "document_name": documentName ?? "",
      "document_number": documentNumber ?? "",
      "business_name": businessName ?? "",
      "business_email": businessEmail ?? "",
      "business_mobile": businessMobile ?? "",
    };
    List<MultiPartData?> multiPartData = [];

    if (profilePhoto != null) {
      multiPartData.add(MultiPartData(field: "profile_photo", filePath: profilePhoto.path));
    }

    for (PlatformFile? element in documents ?? []) {
      var image = MultiPartData(field: "document[]", filePath: element?.path);
      multiPartData.add(image);
    }
    for (var element in images ?? []) {
      var image = MultiPartData(field: "images[]", filePath: element?.path);
      multiPartData.add(image);
    }
    debugPrint("Sent Data is $body");
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    var response = ApiService().multiPart(
      context: context,
      endPoint: "/edit_partner_profile",
      headers: defaultHeaders,
      body: body,
      multipartFile: multiPartData,
    );
//Processing API...
    loadingDialog(
      context: context,
      future: response,
    ).then((response) async {
      if (response != null) {
        Map<String, dynamic> json = jsonDecode(response);
        DefaultModel responseData = DefaultModel.fromJson(json);

        if (responseData.status == true) {
          await fetchPartnerProfile(context: context);
          context.pop();
          setDashBoardIndex(0);
          showSnackBar(context: context, text: responseData.message ?? "Updated $type Data");
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wrong", color: Colors.red);
        }
      }
    });
  }

  /// 6) fetch Cities API...

  bool loadingSubscriptions = true;
  SubscriptionsModel? subscriptionsModel;
  List<SubscriptionsData>? subscriptionsData;

  Future<List<SubscriptionsData>?> fetchSubscriptions({
    required BuildContext context,
    required String? couponCode,
  }) async {
    refresh() {
      loadingSubscriptions = true;
      subscriptionsModel = null;
      subscriptionsData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingSubscriptions = false;
      notifyListeners();
    }

    refresh();
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": _serviceType.value,
      "coupon_code": couponCode ?? "",
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_subscriptions${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        SubscriptionsModel responseData = SubscriptionsModel.fromJson(json);

        subscriptionsModel = responseData;
        subscriptionsData = responseData.data;
        notifyListeners();

        if ((couponCode?.length ?? 0) > 0 && subscriptionsModel?.isCouponApplied != true) {
          showSnackBar(context: context, text: responseData.message ?? "", color: Colors.red);
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return subscriptionsData;
  }

  /// 7) fetch Cities API...

  bool loadingTimeslots = true;
  TimeSlotsModel? timeslotsModel;
  List<TimeSlotsData>? timeslotsData;

  Future<List<TimeSlotsData>?> fetchTimeslots({
    required BuildContext context,
  }) async {
    refresh() {
      loadingTimeslots = true;
      timeslotsModel = null;
      timeslotsData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingTimeslots = false;
      notifyListeners();
    }

    refresh();
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": _serviceType.value,
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_timeslots${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        TimeSlotsModel responseData = TimeSlotsModel.fromJson(json);

        if (responseData.status == true) {
          timeslotsModel = responseData;
          timeslotsData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return timeslotsData;
  }

  /// 9) fetch Cities API...

  bool loadingDeliveryZones = true;
  DeliveryZonesModel? deliveryZonesModel;
  List<DeliveryZonesData>? deliveryZonesData;

  Future<List<DeliveryZonesData>?> fetchDeliveryZones({required BuildContext context}) async {
    refresh() {
      loadingDeliveryZones = true;
      deliveryZonesModel = null;
      deliveryZonesData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingDeliveryZones = false;
      notifyListeners();
    }

    refresh();
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": _serviceType.value,
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_partner_delivery_zones${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        DeliveryZonesModel responseData = DeliveryZonesModel.fromJson(json);

        if (responseData.status == true) {
          deliveryZonesModel = responseData;
          deliveryZonesData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return deliveryZonesData;
  }

  /// 8) Add Order Type API...

  Future<DefaultModel?> addOrderType({
    required BuildContext context,
    required String? route,
    required bool? editMode,
    required bool? isPaidSelfPicking,
    required String? eachPersonAmount,
    required Set<OrderTypes?>? selectedOrderTypes,
  }) async {
    List<String>? orderTypeList = [];

    for (OrderTypes? data in selectedOrderTypes ?? {}) {
      orderTypeList.add("${data?.value}");
    }

    String orderTypes = orderTypeList.isNotEmpty ? orderTypeList.join(",") : "";

    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": _serviceType.value,
      "is_free_self_picking": isPaidSelfPicking == true ? "No" : "Yes",
      "each_person_amount": "${isPaidSelfPicking == true ? eachPersonAmount : ""}",
      "order_types": orderTypes,
    };

    DefaultModel? responseData;
    debugPrint("Sent Data is $body");

//Processing API...
    await loadingDialog(
      context: context,
      future: ApiService().post(
        context: context,
        endPoint: "/add_order_type",
        body: body,
        headers: headers,
      ),
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        responseData = DefaultModel.fromJson(json);

        if (responseData?.status == true) {
          MembershipController membershipController =
              Provider.of<MembershipController>(context, listen: false);
          membershipController.setPartnerOrderTypes(selectedOrderTypes);
          context.pop();
          context.pushNamed(Routs.selectTimeSlots,
              extra: SelectTimeSlots(
                  editMode: editMode,
                  route: route,
                  type: _serviceType,
                  selectedOrderTypes: selectedOrderTypes));
        }
      }
    }).catchError((e, s) {
      debugPrint("Error is $e & $s");
    });

    return responseData;
  }

  TimeSlotsDayData? _dayWiseTimeSlots;

  TimeSlotsDayData? get dayWiseTimeSlots => _dayWiseTimeSlots;

  bool validateDayWiseTimeSlots() {
    bool isValid = true;
    return isValid;
  }

  setTimeslots({
    required int dayWiseTimeSlotsIndex,
    required OrderTypes orderTypes,
    required List<TimeSlotsData?>? selectedTimeSlots,
  }) {
    if (_dayWiseTimeSlots != null) {
      if (orderTypes.name == OrderTypes.uPick.name) {
        _dayWiseTimeSlots?.selfPickingTimeslots = selectedTimeSlots;
      } else if (orderTypes == OrderTypes.readyToPick) {
        _dayWiseTimeSlots?.readyToPickTimeslots = selectedTimeSlots;
      } else if (orderTypes == OrderTypes.delivery) {
        _dayWiseTimeSlots?.deliveryTimeslots = selectedTimeSlots;
      }

      notifyListeners();

      // currentDayTimeSlots = _dayWiseTimeSlots?.days?.elementAt(dayWiseTimeSlotsIndex);
      notifyListeners();
    }
  }

  TimeSlotsDayData? setDayWiseTimeSlots({
    required bool selfPickingAvailable,
    required bool readyToGoAvailable,
    required bool deliveryAvailable,
    required List<TimeSlotsData>? defaultTimeSlots,
  }) {
    List<TimeSlotsData>? timeSlots() => defaultTimeSlots?.toList();

    _dayWiseTimeSlots = TimeSlotsDayData(
      selfPickingAvailable: selfPickingAvailable,
      readyToPickAvailable: readyToGoAvailable,
      deliveryAvailable: deliveryAvailable,
      selfPickingTimeslots: timeSlots(),
      readyToPickTimeslots: timeSlots(),
      deliveryTimeslots: timeSlots(),
    );
    notifyListeners();

    notifyListeners();
    return _dayWiseTimeSlots;
  }

  TimeSlotsDayData? setPartnerDayWiseTimeSlots({
    required TimeSlotsDayData? producerTimeSlotsData,
  }) {
    loadingProducerTimeslots = true;
    _dayWiseTimeSlots = null;
    notifyListeners();

    ///Setting Fetched TimeSlots..
    _dayWiseTimeSlots = producerTimeSlotsData;
    notifyListeners();

    loadingProducerTimeslots = false;
    notifyListeners();
    return _dayWiseTimeSlots;
  }

  /// 8) fetch Producer Timeslots API...

  bool loadingProducerTimeslots = true;

  ProducerTimeslotsModel? producerTimeslotsModel;
  TimeSlotsDayData? producerTimeslotsData;

  Future<TimeSlotsDayData?> fetchPartnerTimeslots({
    required BuildContext context,
    required String? date,
    bool? timeLineTimeslots,
  }) async {
    refresh() {
      loadingProducerTimeslots = true;
      producerTimeslotsModel = null;
      producerTimeslotsData = null;
      _dayWiseTimeSlots = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingProducerTimeslots = false;
      notifyListeners();
    }

    refresh();
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": _serviceType.value,
      "date": date ?? "",
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint:
          "${timeLineTimeslots == true ? "/fetch_todays_timeslots" : "/fetch_partner_timeslots"}${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        ProducerTimeslotsModel responseData = ProducerTimeslotsModel.fromJson(json);

        if (responseData.status == true) {
          producerTimeslotsModel = responseData;
          producerTimeslotsData = responseData.data;
          notifyListeners();

          setPartnerDayWiseTimeSlots(producerTimeSlotsData: producerTimeslotsData);
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return producerTimeslotsData;
  }

  /// 8.1) fetch Producer Timeslot Dates API...

  bool loadingTimeslotDates = true;

  TimeslotDates? timeslotDates;

  Future<TimeslotDates?> fetchTimeslotDates({required BuildContext context}) async {
    refresh() {
      loadingTimeslotDates = true;
      timeslotDates = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingTimeslotDates = false;
      notifyListeners();
    }

    refresh();
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": _serviceType.value,
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_partner_timeslot_dates${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        TimeslotDates responseData = TimeslotDates.fromJson(json);

        if (responseData.status == true) {
          timeslotDates = responseData;

          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return timeslotDates;
  }

  /// 8.1) fetch Producer Timeslot Dates API...

  Future<CheckTimeLinesStatus?> checkTimelineStatus({required BuildContext context}) async {
    refresh() {
      loadingTimeslotDates = true;
      timeslotDates = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingTimeslotDates = false;
      notifyListeners();
    }

    refresh();
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": _serviceType.value,
    };

    debugPrint("Sent Data is $body");
    CheckTimeLinesStatus? responseData;
//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/check_timeline_status${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;

        responseData = CheckTimeLinesStatus.fromJson(json);
        if (responseData?.status == true) {
          updateTimeSlotsPopup(timeLineStatus: responseData, type: serviceType);
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return responseData;
  }

  /// 8.2) add Partner Timeslot API...

  Future<DefaultModel?> addPartnerTimeslot({
    required BuildContext context,
    required String? route,
    required String? date,
    required bool deliveryAvailable,
    required bool? editMode,
    required bool? timeLineUpdate,
    required ServiceType? type,
    required Set<num?>? deleteIds,
    required Set<OrderTypes?>? selectedOrderTypes,
  }) async {
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, dynamic> body = {
      "type": _serviceType.value,
      "timeslot_date": date ?? "",
      "delete_ids": ((deleteIds?.length ?? 0) > 0) ? deleteIds?.join(",") : "",
      "time_slots": jsonEncode(_dayWiseTimeSlots),
    };

    DefaultModel? responseData;
    debugPrint("Sent Data is $body");

// Processing API...
    await loadingDialog(
      context: context,
      future: ApiService().post(
        context: context,
        endPoint: editMode == true ? "/update_partner_timeslot" : "/add_partner_timeslot",
        body: body,
        headers: headers,
      ),
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        responseData = DefaultModel.fromJson(json);

        if (responseData?.status == true) {
          if (editMode == true) {
            context.pop();
            showSnackBar(
                context: context,
                text: responseData?.message ?? "${type?.value} Partner Timeslots Updated",
                icon: Icons.check_circle_outline_rounded);
          } else {
            if (timeLineUpdate == true) {
              context.pop();
              showSnackBar(
                  context: context,
                  text: responseData?.message ?? "${type?.value} Partner Timeslots Updated",
                  icon: Icons.check_circle_outline_rounded);
            } else {
              context.firstRoute();
              if (deliveryAvailable) {
                context.pushNamed(Routs.selectDeliveryZones,
                    extra: SelectDeliveryZones(
                        editMode: editMode,
                        route: route,
                        type: _serviceType,
                        selectedOrderTypes: selectedOrderTypes));
              } else {
                showSnackBar(
                    context: context,
                    text: "Congratulations...You are now ${type?.value} Partner",
                    icon: Icons.check_circle_outline_rounded);

                context.pushNamed("$route");
              }
            }
          }
        } else {
          showSnackBar(
              context: context,
              text: responseData?.message ?? "Something went wrong",
              icon: Icons.error,
              color: Colors.red);
        }
      }
    }).catchError((e, s) {
      debugPrint("Error is $e & $s");
    });

    return responseData;
  }

  /// 9) add Partner Timeslot API...

  Future<DefaultModel?> addDeliveryZone({
    required BuildContext context,
    required bool? editMode,
    required String? route,
    required Set<num?>? deleteIds,
    required List<DeliveryZonesData?>? deliveryZonesData,
  }) async {
    List<Map<String, String>>? deliveryZones = [];
    if (deliveryZonesData.haveData) {
      for (DeliveryZonesData? data in deliveryZonesData ?? []) {
        deliveryZones.add(
          {
            if (data?.id != null) "zone_id": "${data?.id ?? ""}",
            "latitude": "${data?.latitude}",
            "longitude": "${data?.longitude}",
            "address": "${data?.address}",
            "km_range": "${data?.kmRange}",
            "pincode": data?.pincode ?? "",
          },
        );
      }
    }

    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, dynamic> body = {
      "type": _serviceType.value,
      "delete_ids": ((deleteIds?.length ?? 0) > 0) ? deleteIds?.join(",") : "",
      "zone_details": jsonEncode(deliveryZones),
    };

    DefaultModel? responseData;
    debugPrint("Sent Data is $body");

//Processing API...
    await loadingDialog(
      context: context,
      future: ApiService().post(
        context: context,
        endPoint: editMode == true ? "/update_delivery_zone" : "/add_delivery_zone",
        body: body,
        headers: headers,
      ),
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        responseData = DefaultModel.fromJson(json);

        if (responseData?.status == true) {
          if (editMode == true) {
            context.pop();
            showSnackBar(context: context, text: responseData?.message ?? "Updated Delivery Zones");
          } else {
            context.firstRoute();
            context.pushNamed("$route");
            showSnackBar(context: context, text: responseData?.message ?? "Added Delivery Zones");
          }
        }
      }
    }).catchError((e, s) {
      debugPrint("Error is $e & $s");
    });

    return responseData;
  }

  /// 10) fetch PartnerDashBoardModel API...

  bool loadingPartnerDashBoard = true;
  PartnerDashBoardModel? partnerDashBoardModel;
  PartnerDashBoardData? partnerDashBoardData;

  Future<PartnerDashBoardData?> fetchPartnerDashBoard({required BuildContext context}) async {
    refresh() {
      loadingPartnerDashBoard = true;
      partnerDashBoardModel = null;
      partnerDashBoardData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingPartnerDashBoard = false;
      notifyListeners();
    }

    refresh();

    Map<String, String> body = {
      "type": serviceType.value,
    };

    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_partner_stats${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        PartnerDashBoardModel responseData = PartnerDashBoardModel.fromJson(json);

        if (responseData.status == true) {
          partnerDashBoardModel = responseData;
          partnerDashBoardData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return partnerDashBoardData;
  }

  /// 11) Add check_partner_live_status  API...
  PartnerLiveStatusData? partnerLiveStatusData;

  Future<PartnerLiveStatusData?> checkPartnerLiveStatus({
    required BuildContext context,
  }) async {
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": _serviceType.value,
    };

    PartnerLiveStatus? responseData;
    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/check_partner_live_status${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        responseData = PartnerLiveStatus.fromJson(json);

        if (responseData?.status == true) {
          partnerLiveStatusData = responseData?.data;
          notifyListeners();
        }
      }
    }).catchError((e, s) {
      debugPrint("Error is $e & $s");
    });

    return partnerLiveStatusData;
  }

  Future<bool> updatePartnerLiveStatus({
    required BuildContext context,
    required bool? status,
  }) async {
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": _serviceType.value,
      "status": status == true ? "Online" : "Offline",
    };

    bool newStatus = status ?? false;
    PartnerLiveStatus? responseData;
    debugPrint("Sent Data is $body");

    dynamic response = await loadingDialog(
      context: context,
      future: ApiService().post(
        context: context,
        endPoint: "/update_partner_live_status",
        body: body,
        headers: headers,
      ),
    ).catchError((e, s) {
      debugPrint("Error is $e & $s");
    });

    if (response != null) {
      Map<String, dynamic> json = response;
      responseData = PartnerLiveStatus.fromJson(json);

      if (responseData.status == true) {
        newStatus = !newStatus;
        partnerLiveStatusData = responseData.data;
        notifyListeners();
      }
    }
    return newStatus;
  }

  /// 12) fetch Banners API...

  bool loadingBanners = true;
  BannersModel? bannersModel;
  List<BannersData>? bannersData;

  Future<List<BannersData>?> fetchPartnerBanners({
    required BuildContext context,
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
      "banner_for": serviceType.value,
    };
    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_partner_banners${queryParameter(body: body)}",
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

  /// 12) Send Order OTP API...
  Future sendOrderOtp({
    required BuildContext context,
    required String? orderId,
  }) async {
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": serviceType.value,
      "order_id": orderId ?? " ",
      "partner_id": "${partnerData?.id}",
    };
    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .post(
      context: context,
      endPoint: "/send_order_otp",
      body: body,
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        DefaultModel responseData = DefaultModel.fromJson(json);
        if (responseData.status == true) {
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
    });
  }

  /// 13)Verify Order Otp API...
  Future<DefaultModel?> verifyOrderOtp({
    required BuildContext context,
    required String? orderId,
    required String? otp,
    required GestureTapCallback? onSuccess,
  }) async {
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": serviceType.value,
      "order_id": orderId ?? " ",
      "partner_id": "${partnerData?.id}",
      "otp": otp ?? "",
    };

    debugPrint("Sent Data is $body");

    var response = ApiService().post(
      context: context,
      endPoint: "/verify_order_otp",
      body: body,
      headers: headers,
    );
//Processing API...
    return loadingDialog(
      context: context,
      future: response,
    ).then((response) {
      Map<String, dynamic> json = response;
      DefaultModel? responseData;
      if (response != null) {
        responseData = DefaultModel.fromJson(json);
        if (responseData.status == true) {
          onSuccess?.call();
          ProductController controller = Provider.of<ProductController>(context, listen: false);
          controller.fetchPartnerOrders(context: context, isRefresh: true, orderType: "All", search: "");
          showSnackBar(context: context, text: responseData.message ?? "OTP Verified");
        } else {
          showBanner(text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
      return responseData;
    });
  }

  Future readyToPickupPopup({
    required BuildContext context,
    required String? orderId,
    required GestureTapCallback? onSuccess,
  }) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              "Ready to Pickup",
              style: TextStyle(color: primaryColor),
            ),
            content: const Text("Are you ready to pickup ?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  readyToPickupAPI(
                    context: context,
                    orderId: orderId,
                    onSuccess: onSuccess,
                  );
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          );
        });
  }

  /// 12) Send Order OTP API...
  Future readyToPickupAPI({
    required BuildContext context,
    required String? orderId,
    required GestureTapCallback? onSuccess,
  }) async {
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": serviceType.value,
      "order_id": orderId ?? " ",
      "partner_id": "${partnerData?.id}",
    };
    debugPrint("Sent Data is $body");

//Processing API...
    loadingDialog(
      context: context,
      future: ApiService().post(
        context: context,
        endPoint: "/ready_to_pickup_order",
        body: body,
        headers: headers,
      ),
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        DefaultModel responseData = DefaultModel.fromJson(json);
        if (responseData.status == true) {
          onSuccess?.call();
          ProductController controller = Provider.of<ProductController>(context, listen: false);
          controller.fetchPartnerOrders(context: context, isRefresh: true, orderType: "All", search: "");
          showSnackBar(context: context, text: responseData.message ?? "Ready to Pickup");
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
    });
  }

  /// 13)submit_review API...
  Future<DefaultModel?> submitReview({
    required BuildContext context,
    required String? id,
    required String? otp,
    required GestureTapCallback? onSuccess,
  }) async {
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": serviceType.value,
      "order_id": id ?? " ",
      "partner_id": "${partnerData?.id}",
      "otp": otp ?? "",
    };

    debugPrint("Sent Data is $body");

    var response = ApiService().post(
      context: context,
      endPoint: "/submit_review",
      body: body,
      headers: headers,
    );
//Processing API...
    return loadingDialog(
      context: context,
      future: response,
    ).then((response) {
      Map<String, dynamic> json = response;
      DefaultModel? responseData;
      if (response != null) {
        responseData = DefaultModel.fromJson(json);
        if (responseData.status == true) {
          onSuccess?.call();

          ProductController controller = Provider.of<ProductController>(context, listen: false);
          controller.fetchPartnerOrders(context: context, isRefresh: true, orderType: "All", search: "");
          showSnackBar(context: context, text: responseData.message ?? "OTP Verified");
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
      return responseData;
    });
  }

  /// 14) Fetch EarningsModel API...

  bool loadingEarnings = true;

  EarningsModel? _earningsModel;

  EarningsModel? get earningsModel => _earningsModel;
  List<EarningsData>? _earningsData;

  List<EarningsData>? get earningsData => _earningsData;
  num earningsIndex = 1;
  num earningsTotal = 1;

  RefreshController earningsController = RefreshController(initialRefresh: false);

  Future<List<EarningsData>?> fetchEarnings({
    required BuildContext context,
    required EarningStatuses? status,
    required String? search,
    bool? isRefresh = false,
    bool? loadingNext = false,
  }) async {
    debugPrint("Fetching ${_earningsData.runtimeType}...");

    refresh() {
      earningsIndex = 1;
      earningsTotal = 1;
      loadingEarnings = true;

      earningsController.resetNoData();
      _earningsModel = null;
      _earningsData = null;

      notifyListeners();
      debugPrint("cleared");
    }

    apiResponseCompleted() {
      loadingEarnings = false;
      notifyListeners();
    }

    onError() {
      if (loadingNext == true) {
        earningsController.loadFailed();
      } else {
        earningsController.refreshFailed();
      }
      notifyListeners();
    }

    if (isRefresh == true) {
      refresh();
    }

    if (earningsIndex <= earningsTotal) {
      Map<String, String> body = {
        "page": "$earningsIndex",
        "type": serviceType.value,
        "status": status?.value ?? "",
        "search_key": search ?? "",
      };

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      try {
        var response = await ApiService().get(
          context: context,
          endPoint: "/fetch_earnings${queryParameter(body: body)}",
          headers: defaultHeaders,
        );

        Map<String, dynamic> json = response;

        EarningsModel? responseData = EarningsModel.fromJson(json);
        _earningsModel = responseData;
        if (responseData.status == true) {
          debugPrint("Current Page $earningsTotal");
          debugPrint(responseData.message);

          for (int index = 0; index < (responseData.data?.length ?? 0); index++) {
            if (_earningsData == null) {
              debugPrint("Initialized Empty Array in ${_earningsData.runtimeType}...");
              _earningsData = [];
              notifyListeners();
            }

            if (_earningsData?.contains(responseData.data!.elementAt(index)) == false) {
              _earningsData?.add(responseData.data!.elementAt(index));
            }
          }

          earningsTotal = responseData.totalPage ?? 1;
          earningsIndex++;
          if (loadingNext == true) {
            earningsController.loadComplete();
          } else {
            earningsController.refreshCompleted();
          }

          if (earningsTotal <= earningsIndex) {
            earningsController.loadComplete();
          }
          notifyListeners();
          debugPrint("Total Pages $earningsTotal");
          debugPrint("Updated Current Page $earningsIndex");
          return _earningsData;
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
      earningsController.loadNoData();
      apiResponseCompleted();
      debugPrint("Load no More data ");
    }
    notifyListeners();
    return _earningsData;
  }
}
