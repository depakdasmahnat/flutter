import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaas/controllers/partner/partner_controller.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:gaas/core/extensions/normal/build_context_extension.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/models/default_model.dart';
import 'package:gaas/models/partner/product/units_model.dart';
import 'package:gaas/route/route_paths.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/services/api/api_service.dart';
import '../../core/services/database/local_database.dart';
import '../../models/dashboard/filters_model.dart';
import '../../models/partner/auth/partner_model.dart';
import '../../models/partner/orders/partner_order_detail_model.dart';
import '../../models/partner/orders/partner_order_model.dart';
import '../../models/partner/orders/suggested_times_slots_model.dart';
import '../../models/partner/product/my_products_model.dart';
import '../../models/partner/product/product_templates_model.dart';
import '../../models/partner/product/view_product_detail_model.dart';
import '../auth/auth_controller.dart';

class ProductController extends ChangeNotifier {
  update() {
    notifyListeners();
  }

  /// 1) fetch Categories API...

  bool loadingProductTemplates = true;
  ProductTemplatesModel? productTemplatesModel;
  List<ProductTemplatesData>? productTemplateData;

  Future<List<ProductTemplatesData>?> fetchProductTemplates({
    required BuildContext context,
    String? searchKey,
    num? categoryId,
    String? subCategoryId,
  }) async {
    refresh() {
      loadingProductTemplates = true;
      productTemplatesModel = null;
      productTemplateData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingProductTemplates = false;
      notifyListeners();
    }

    refresh();
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    PartnerController controllers = Provider.of(context, listen: false);
    ServiceType? serviceType = controllers.serviceType;
    Map<String, String> body = {
      "type": serviceType.value,
      "search_key": searchKey ?? "",
      "category_id": "${categoryId ?? ""}",
      "subcategory_id": subCategoryId ?? "",
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_product_templates${queryParameter(body: body)}",
      headers: defaultHeaders,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        ProductTemplatesModel responseData = ProductTemplatesModel.fromJson(json);

        if (responseData.status == true) {
          productTemplatesModel = responseData;
          productTemplateData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return productTemplateData;
  }

  /// 1) fetch UnitsModel API...

  bool loadingUnitsModel = true;
  UnitsModel? unitsModel;
  List<UnitData>? unitData;

  Future<List<UnitData>?> fetchUnits({required BuildContext context, ServiceType? type}) async {
    refresh() {
      loadingUnitsModel = true;
      unitsModel = null;
      unitData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingUnitsModel = false;
      notifyListeners();
    }

    refresh();
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": type?.value ?? "",
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_units${queryParameter(body: body)}",
      headers: defaultHeaders,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        UnitsModel responseData = UnitsModel.fromJson(json);

        if (responseData.status == true) {
          unitsModel = responseData;
          unitData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return unitData;
  }

  String getFilterName({
    String? hintText,
    required List<FiltersData?>? filterOptions,
  }) {
    String value = hintText ?? "Select Filter";
    List<String>? values = [];
    if (filterOptions.haveData) {
      for (FiltersData? data in filterOptions ?? []) {
        values.add("${data?.name}(${data?.selected?.name})");
      }
    }

    if (values.haveData) {
      value = values.join(", ");
    }

    return value;
  }

  String getFilterIds({
    required List<FiltersData?>? filterOptions,
  }) {
    String value = "";
    List<String>? values = [];
    if (filterOptions.haveData) {
      for (FiltersData? data in filterOptions ?? []) {
        values.add("${data?.id}");
      }
    }

    if (values.haveData) {
      value = values.join(", ");
    }

    return value;
  }

  String getFilterOptionIds({
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
      value = values.join(", ");
    }

    return value;
  }

  /// 2) Add Product API...
  Future addProduct({
    required BuildContext context,
    required String? name,
    required String? categoryId,
    required String? subcategoryId,
    required String? description,
    required String? price,
    required String? mrpPrice,
    required String? unitId,
    required String? initialInventory,
    required String? templateId,
    required String? imageName,
    required String? imagePath,
    required File? image,
    required List<FiltersData?>? filterOptions,
  }) async {
    PartnerController controllers = Provider.of(context, listen: false);
    ServiceType? serviceType = controllers.serviceType;

    Map<String, String> body = {
      "type": serviceType.value,
      "category_id": categoryId ?? "",
      "subcategory_id": subcategoryId ?? "",
      "name": name ?? "",
      "description": description ?? "",
      "price": price ?? "0",
      "mrp_price": mrpPrice ?? "0",
      "unit_id": unitId ?? "",
      "initial_inventory": initialInventory ?? "",
      "template_id": templateId ?? "",
      "image_name": imageName ?? "",
      "path": imagePath ?? "",
      "filter_ids": getFilterIds(filterOptions: filterOptions),
      "filter_options": getFilterOptionIds(filterOptions: filterOptions),
    };

    debugPrint("Sent Data is $body");
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    var response = ApiService().multiPart(
        context: context,
        endPoint: "/add_product",
        headers: defaultHeaders,
        body: body,
        multipartFile: [
          if (image != null) MultiPartData(field: "image", filePath: image.path),
        ]);
//Processing API...

    return await loadingDialog(
      context: context,
      future: response,
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = jsonDecode(response);
        DefaultModel responseData = DefaultModel.fromJson(json);

        if (responseData.status == true) {
          context.pop();
          showSnackBar(context: context, text: responseData.message ?? "Data Saved");
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wrong", color: Colors.red);
        }
      }
    });
  }

  /// 3) Edit Product API...
  Future editProduct({
    required BuildContext context,
    required String? id,
    required String? name,
    required String? categoryId,
    required String? subcategoryId,
    required String? description,
    required String? price,
    required String? mrpPrice,
    required String? unitId,
    required String? initialInventory,
    required String? templateId,
    required String? imageName,
    required String? imagePath,
    required File? image,
    required List<FiltersData?>? filterOptions,
  }) async {
    PartnerController controllers = Provider.of(context, listen: false);
    ServiceType? serviceType = controllers.serviceType;
    Map<String, String> body = {
      "type": serviceType.value,
      "id": id ?? "",
      "category_id": categoryId ?? "",
      "subcategory_id": subcategoryId ?? "",
      "name": name ?? "",
      "description": description ?? "",
      "price": price ?? "0",
      "mrp_price": mrpPrice ?? "0",
      "unit_id": unitId ?? "",
      "initial_inventory": initialInventory ?? "",
      "template_id": templateId ?? "",
      "image_name": imageName ?? "",
      "path": imagePath ?? "",
      "filter_ids": getFilterIds(filterOptions: filterOptions),
      "filter_options": getFilterOptionIds(filterOptions: filterOptions),
    };
    debugPrint("Sent Data is $body");
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    var response = ApiService().multiPart(
        context: context,
        endPoint: "/edit_product",
        headers: defaultHeaders,
        body: body,
        multipartFile: [
          if (image != null) MultiPartData(field: "image", filePath: image.path),
        ]);

//Processing API...

    return await loadingDialog(
      context: context,
      future: response,
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = jsonDecode(response);
        DefaultModel responseData = DefaultModel.fromJson(json);
        if (responseData.status == true) {
          context.pop();
          showSnackBar(context: context, text: responseData.message ?? "Data Saved");
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wrong", color: Colors.red);
        }
      }
    });
  }

  /// 4) fetch ViewProductDetailModel API...

  bool loadingViewProductDetail = true;
  ViewProductDetailModel? viewProductDetailModel;
  ViewProductDetailData? viewProductDetailData;

  Future<ViewProductDetailData?> viewProductDescription({
    required BuildContext context,
    num? id,
  }) async {
    refresh() {
      loadingViewProductDetail = true;
      viewProductDetailModel = null;
      viewProductDetailData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingViewProductDetail = false;
      notifyListeners();
    }

    refresh();
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    Map<String, String> body = {
      "id": "${id ?? ""}",
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/view_product_description${queryParameter(body: body)}",
      headers: defaultHeaders,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        ViewProductDetailModel responseData = ViewProductDetailModel.fromJson(json);

        if (responseData.status == true) {
          viewProductDetailModel = responseData;
          viewProductDetailData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return viewProductDetailData;
  }

  /// 5) fetch UserData API...

  PartnerData? partnerData;

  Future<PartnerData?> fetchPartnerProfile({
    required BuildContext context,
    required ServiceType type,
  }) async {
    // partnerData = null;
    // notifyListeners();
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_partner_profile?type=${type.value}",
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
          partnerData = null;
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
    required String? address,
    required String? countryId,
    required String? stateId,
    required String? cityId,
    required String? pinCode,
    required String? categories,
    required File? profilePhoto,
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
      "address": address ?? "",
      "country_id": countryId ?? "",
      "state_id": stateId ?? "",
      "city_id": cityId ?? "",
      "pincode": pinCode ?? "",
      "categories": categories ?? "",
    };

    debugPrint("Sent Data is $body");
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    var response = ApiService().multiPart(
        context: context,
        endPoint: "/edit_partner_profile",
        headers: defaultHeaders,
        body: body,
        multipartFile: [
          if (profilePhoto != null) MultiPartData(field: "profile_photo", filePath: profilePhoto.path),
        ]);
//Processing API...
    loadingDialog(
      context: context,
      future: response,
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = jsonDecode(response);
        DefaultModel responseData = DefaultModel.fromJson(json);

        if (responseData.status == true) {
          AuthControllers authControllers = Provider.of<AuthControllers>(context, listen: false);
          authControllers.checkPartnerRequest(context: context);
          authControllers.fetchProfile(context: context);
          context.firstRoute();
          context.pushReplacementNamed(Routs.dashboard);

          showSnackBar(context: context, text: responseData.message ?? "Updated $type Data");
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wrong", color: Colors.red);
        }
      }
    });
  }

  /// 6) Fetch MyProductsModel API...

  bool loadingMyProducts = true;

  MyProductsModel? _myProductsModel;

  MyProductsModel? get myProductsModel => _myProductsModel;
  List<MyProductsData>? _myProductsData;

  List<MyProductsData>? get myProductsData => _myProductsData;
  num myProductsIndex = 1;
  num myProductsTotal = 1;

  changeSalesPrice({
    required num? id,
    required String? price,
  }) {
    _myProductsData?.firstWhere((element) => element.id == id).price = price ?? "0";
    _myProductsData?.firstWhere((element) => element.id == id).hasChanges = true;
    notifyListeners();
  }

  changeMrpPrice({
    required num? id,
    required String? price,
  }) {
    _myProductsData?.firstWhere((element) => element.id == id).mrpPrice = price ?? "0";
    _myProductsData?.firstWhere((element) => element.id == id).hasChanges = true;
    notifyListeners();
  }

  updateProductSchemeStatus({required num? id}) {
    String? selectedScheme = _myProductsData?.firstWhere((element) => element.id == id).selected;
    String updatedStatus = selectedScheme == "Yes" ? "No" : "Yes";

    _myProductsData?.firstWhere((element) => element.id == id).selected = updatedStatus;
    notifyListeners();
  }

  int changeQuantity({
    required num? id,
    required String? quantity,
    bool? addOne,
    bool? removeOne,
  }) {
    num newInitialInventory = quantity != null ? num.parse(quantity) : 0;
    if (addOne == true) {
      newInitialInventory = newInitialInventory + 1;
    }
    if (removeOne == true) {
      if (newInitialInventory > 0) {
        newInitialInventory = newInitialInventory - 1;
      }
    }
    debugPrint("newInitialInventory $newInitialInventory");

    _myProductsData?.firstWhere((element) => element.id == id).initialInventory = newInitialInventory.toInt();
    _myProductsData?.firstWhere((element) => element.id == id).hasChanges = true;
    notifyListeners();
    return newInitialInventory.toInt();
  }

  bool inventoryHaveChanges() {
    bool haveChanges = _myProductsData?.any((element) => element.hasChanges == true) == true;
    return haveChanges;
  }

  RefreshController myProductsController = RefreshController(initialRefresh: false);

  Future<List<MyProductsData>?> fetchMyProducts({
    required BuildContext context,
    String? searchKey,
    num? bannerId,
    String? showType,
    bool? isRefresh = false,
    bool? loadingNext = false,
  }) async {
    debugPrint("Fetching ${_myProductsData.runtimeType}...");

    refresh() {
      myProductsIndex = 1;
      myProductsTotal = 1;
      loadingMyProducts = true;

      myProductsController.resetNoData();
      _myProductsModel = null;
      _myProductsData = null;

      notifyListeners();
      debugPrint("cleared");
    }

    PartnerController partnerController = Provider.of<PartnerController>(context, listen: false);
    ServiceType? type = partnerController.serviceType;

    apiResponseCompleted() {
      loadingMyProducts = false;
      notifyListeners();
    }

    onError() {
      if (loadingNext == true) {
        myProductsController.loadFailed();
      } else {
        myProductsController.refreshFailed();
      }
      notifyListeners();
    }

    if (isRefresh == true) {
      refresh();
    }

    if (myProductsIndex <= myProductsTotal) {
      Map<String, String> body = {
        "page": "$myProductsIndex",
        "search_key": searchKey ?? "",
        if (bannerId != null) "banner_id": "${bannerId}",
        "type": type.value,
        "show_type": showType ?? "All",
      };

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      try {
        var response = await ApiService().get(
          context: context,
          endPoint: "/fetch_my_products${queryParameter(body: body)}",
          headers: defaultHeaders,
        );

        Map<String, dynamic> json = response;

        MyProductsModel? responseData = MyProductsModel.fromJson(json);
        _myProductsModel = responseData;
        if (responseData.status == true) {
          debugPrint("Current Page $myProductsTotal");
          debugPrint(responseData.message);

          for (int index = 0; index < (responseData.data?.length ?? 0); index++) {
            if (_myProductsData == null) {
              debugPrint("Initialized Empty Array in ${_myProductsData.runtimeType}...");
              _myProductsData = [];
              notifyListeners();
            }

            if (_myProductsData?.contains(responseData.data!.elementAt(index)) == false) {
              _myProductsData?.add(responseData.data!.elementAt(index));
            }
          }

          myProductsTotal = responseData.totalPage ?? 1;
          myProductsIndex++;
          if (loadingNext == true) {
            myProductsController.loadComplete();
          } else {
            myProductsController.refreshCompleted();
          }

          if (myProductsTotal <= myProductsIndex) {
            myProductsController.loadComplete();
          }
          notifyListeners();
          debugPrint("Total Pages $myProductsTotal");
          debugPrint("Updated Current Page $myProductsIndex");
          return _myProductsData;
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
      myProductsController.loadNoData();
      apiResponseCompleted();
      debugPrint("Load no More data ");
    }
    notifyListeners();
    return _myProductsData;
  }

  /// 7)  update_inventory API...
  Future updateInventory({
    required BuildContext context,
  }) async {
    try {
      PartnerController controllers = Provider.of(context, listen: false);
      ServiceType? serviceType = controllers.serviceType;

      List<Map<String, String>> products = [];
      List<MyProductsData>? changedProducts =
          _myProductsData?.where((element) => element.hasChanges == true).toList();
      if (changedProducts.haveData) {
        for (MyProductsData? data in changedProducts ?? []) {
          products.add(
            {
              "id": "${data?.id}",
              "category_id": "${data?.categoryId}",
              "subcategory_id": "${data?.subcategoryId}",
              "quantity": "${data?.initialInventory}",
              "unit_id": "${data?.unitId}",
              "amount": "${data?.price ?? 0}",
              "mrp_price": "${data?.mrpPrice ?? 0}",
            },
          );
        }
      }

      Map<String, String> body = {
        "type": serviceType.value,
        "product_details": jsonEncode(products),
      };
      debugPrint("Body is $body");

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      var response = ApiService().post(
        context: context,
        endPoint: "/update_inventory",
        body: body,
        headers: defaultHeaders,
      );

      loadingDialog(
        context: context,
        future: response,
      ).then((response) {
        Map<String, dynamic> json = response;
        DefaultModel? data = DefaultModel.fromJson(json);
        PartnerController controllers = Provider.of(context, listen: false);
        ServiceType? serviceType = controllers.serviceType;
        if (data.status == true) {
          showSnackBar(
              context: context,
              text: data.message ?? "${serviceType.value} Partner Inventory Updated",
              icon: Icons.check);

          fetchMyProducts(context: context, isRefresh: true);
          context.pop();

          return response;
        } else {
          showSnackBar(
              context: context,
              text: data.message ?? "${serviceType.value} Partner Inventory not Updated",
              icon: Icons.error_outline,
              color: Colors.red);
        }
      });
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  /// 7)  manage_scheme_products API...
  Future manageSchemeProducts({
    required BuildContext context,
    required num? banner_id,
  }) async {
    try {
      PartnerController controllers = Provider.of(context, listen: false);
      ServiceType? serviceType = controllers.serviceType;

      List<num?> products = [];
      List<MyProductsData>? changedProducts =
          _myProductsData?.where((element) => element.selected == "Yes").toList();
      if (changedProducts.haveData) {
        for (MyProductsData? data in changedProducts ?? []) {
          products.add(data?.id);
        }
      }

      String productIds = products.isEmpty ? "" : products.join(",");
      Map<String, String> body = {
        "type": serviceType.value,
        "banner_id": "${banner_id ?? ""}",
        "product_ids": productIds,
      };
      debugPrint("Body is $body");

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      var response = ApiService().post(
        context: context,
        endPoint: "/manage_scheme_products",
        body: body,
        headers: defaultHeaders,
      );

      loadingDialog(
        context: context,
        future: response,
      ).then((response) {
        Map<String, dynamic> json = response;
        DefaultModel? data = DefaultModel.fromJson(json);
        PartnerController controllers = Provider.of(context, listen: false);
        ServiceType? serviceType = controllers.serviceType;
        if (data.status == true) {
          showSnackBar(
              context: context,
              text: data.message ?? "${serviceType.value} Schemes Updated",
              icon: Icons.check);

          context.pop();

          return response;
        } else {
          showSnackBar(
              context: context,
              text: data.message ?? "${serviceType.value} Schemes not Updated",
              icon: Icons.error_outline,
              color: Colors.red);
        }
      });
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  DateTime? orderStartDate;

  String? orderStartDateString() {
    return orderStartDate != null
        ? '${orderStartDate?.day}/${orderStartDate?.month}/${orderStartDate?.year}'
        : null;
  }

  Future<bool> showOrderStartDatePicker(BuildContext context) async {
    bool dateChanged = false;

    DateTime currentDate = DateTime.now();
    var date = await showDatePicker(
      context: context,
      initialDate: orderStartDate ?? currentDate,
      firstDate: DateTime(2023, 1, 1),
      lastDate: currentDate,
    );

    if (date != null) {
      orderStartDate = date;
      dateChanged = true;
      notifyListeners();
    }

    return dateChanged;
  }

  DateTime? orderEndDate;

  String? orderEndDateString() {
    return orderEndDate != null ? '${orderEndDate?.day}/${orderEndDate?.month}/${orderEndDate?.year}' : null;
  }

  Future<bool> showOrderEndDatePicker(BuildContext context) async {
    bool dateChanged = false;

    DateTime currentDate = DateTime.now();
    var date = await showDatePicker(
      context: context,
      initialDate: orderEndDate ?? currentDate,
      firstDate: DateTime(2023, 1, 1),
      lastDate: currentDate,
    );

    if (date != null) {
      orderEndDate = date;
      dateChanged = true;
      notifyListeners();
    }

    return dateChanged;
  }

  /// 8) Fetch OrdersModel API...

  bool loadingOrders = true;

  PartnerOrderModel? _ordersModel;

  PartnerOrderModel? get ordersModel => _ordersModel;
  List<PartnerOrderData>? _ordersData;

  List<PartnerOrderData>? get ordersData => _ordersData;
  num ordersIndex = 1;
  num ordersTotal = 1;
  RefreshController ordersRefresher = RefreshController(initialRefresh: false);

  Future<List<PartnerOrderData>?> fetchPartnerOrders({
    required BuildContext context,
    required String search,
    required String orderType,
    bool isRefresh = false,
    bool loadingNext = false,
  }) async {
    debugPrint("Fetching ${_ordersData.runtimeType}...");
    PartnerController controllers = Provider.of(context, listen: false);
    ServiceType? serviceType = controllers.serviceType;
    refresh() {
      ordersIndex = 1;
      ordersTotal = 1;
      loadingOrders = true;

      ordersRefresher.resetNoData();
      _ordersModel = null;
      _ordersData = null;

      notifyListeners();
      debugPrint("cleared");
    }

    apiResponseCompleted() {
      loadingOrders = false;
      notifyListeners();
    }

    onError() {
      if (loadingNext) {
        ordersRefresher.loadFailed();
      } else {
        ordersRefresher.refreshFailed();
      }
      notifyListeners();
    }

    if (isRefresh) {
      refresh();
    }

    if (ordersIndex <= ordersTotal) {
      Map<String, String> body = {
        "page": "$ordersIndex",
        "search_key": search,
        "order_type": orderType,
        "start_date": orderStartDate != null ? orderStartDate.toString() : '',
        "end_date": orderEndDate != null ? orderEndDate.toString() : '',
        "type": serviceType.value,
      };

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      try {
        var response = await ApiService().get(
          context: context,
          endPoint: "/fetch_partner_orders${queryParameter(body: body)}",
          headers: defaultHeaders,
        );

        if (response != null) {
          Map<String, dynamic> json = response;

          PartnerOrderModel? responseData = PartnerOrderModel.fromJson(json);
          _ordersModel = responseData;
          if (responseData.status == true) {
            debugPrint("Current Page $ordersTotal");
            debugPrint(responseData.message);

            for (int index = 0; index < (responseData.data?.length ?? 0); index++) {
              if (_ordersData == null) {
                debugPrint("Initialized Empty Array in ${_ordersData.runtimeType}...");
                _ordersData = [];
                notifyListeners();
              }

              if (_ordersData?.contains(responseData.data!.elementAt(index)) == false) {
                _ordersData?.add(responseData.data!.elementAt(index));
              }
            }

            ordersTotal = responseData.totalPage ?? 1;
            ordersIndex++;
            if (loadingNext) {
              ordersRefresher.loadComplete();
            } else {
              ordersRefresher.refreshCompleted();
            }

            if (ordersTotal <= ordersIndex) {
              ordersRefresher.loadComplete();
            }
            notifyListeners();
            debugPrint("Total Pages $ordersTotal");
            debugPrint("Updated Current Page $ordersIndex");
            return _ordersData;
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
      ordersRefresher.loadNoData();
      apiResponseCompleted();
      debugPrint("Load no More data ");
    }
    notifyListeners();
    return _ordersData;
  }

  /// 9) fetch Cart Items API...

  bool loadingOrderDetail = true;
  PartnerOrderDetailModel? orderDetailModel;
  PartnerOrderDetailData? orderDetailData;

  Future<PartnerOrderDetailData?> fetchOrderDetail({
    required BuildContext context,
    required num? orderId,
    required num? partnerId,
  }) async {
    ServiceType type = context.read<PartnerController>().serviceType;
    refresh() {
      loadingOrderDetail = true;
      orderDetailModel = null;
      orderDetailData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingOrderDetail = false;
      notifyListeners();
    }

    refresh();

    Map<String, String> body = {
      "type": type.value,
      "order_id": "${orderId ?? ""}",
      "partner_id": "${partnerId ?? ""}",
    };

    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_partner_order_detail${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        PartnerOrderDetailModel responseData = PartnerOrderDetailModel.fromJson(json);

        if (responseData.status == true) {
          orderDetailModel = responseData;
          orderDetailData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return orderDetailData;
  }

  /// 8) fetch Suggested Times Slots API...

  bool loadingSuggestedTimesSlots = true;
  SuggestedTimesSlotsModel? suggestedTimesSlotsModel;
  List<SuggestedTimesSlotsData>? suggestedTimesSlotsData;

  Future<List<SuggestedTimesSlotsData>?> fetchSuggestedTimesSlots({
    required BuildContext context,
    num? partnerId,
    num? orderId,
  }) async {
    refresh() {
      loadingSuggestedTimesSlots = true;
      suggestedTimesSlotsModel = null;
      suggestedTimesSlotsData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingSuggestedTimesSlots = false;
      notifyListeners();
    }

    refresh();
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    PartnerController controllers = Provider.of(context, listen: false);
    ServiceType? serviceType = controllers.serviceType;
    Map<String, String> body = {
      "type": serviceType.value,
      "partner_id": "${partnerId ?? ""}",
      "order_id": "${orderId ?? ""}",
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_suggested_timeslots${queryParameter(body: body)}",
      headers: defaultHeaders,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        SuggestedTimesSlotsModel responseData = SuggestedTimesSlotsModel.fromJson(json);

        if (responseData.status == true) {
          suggestedTimesSlotsModel = responseData;
          suggestedTimesSlotsData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return suggestedTimesSlotsData;
  }

  Future sendSuggestedTimesSlots({
    required BuildContext context,
    required num? partnerId,
    required num? orderId,
    required String? comment,
    required DateTime? date,
    required List<SuggestedTimesSlotsData?>? selectedTimeSlots,
  }) async {
    List<num?> timeSlots = [];

    selectedTimeSlots?.forEach((element) {
      timeSlots.add(element?.partnerSlotId);
    });

    String timeSlotIds = timeSlots.haveData ? timeSlots.join(",") : "";
    apiResponseCompleted() {
      notifyListeners();
    }

    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    PartnerController controllers = Provider.of(context, listen: false);
    ServiceType? serviceType = controllers.serviceType;
    Map<String, String> body = {
      "type": serviceType.value,
      "partner_id": "${partnerId ?? ""}",
      "order_id": "${orderId ?? ""}",
      "date": date == null ? '' : date.toString(),
      "comment": comment ?? "",
      "timeslot_ids": timeSlotIds,
    };

    debugPrint("Sent Data is $body");

//Processing API...

    loadingDialog(
      context: context,
      future: ApiService().post(
        context: context,
        endPoint: "/send_suggested_timeslot",
        body: body,
        headers: defaultHeaders,
      ),
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        DefaultModel responseData = DefaultModel.fromJson(json);

        if (responseData.status == true) {
          notifyListeners();
          context.pop();
          showSnackBar(context: context, text: responseData.message ?? "Timeslots Suggestion Submitted");
          fetchOrderDetail(context: context, orderId: orderId, partnerId: partnerId);
          fetchPartnerOrders(context: context, search: '', orderType: "All", isRefresh: true);
        } else {
          showBanner(text: responseData.message ?? "Timeslots Suggestion not submitted", color: Colors.red);
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });
  }
}
