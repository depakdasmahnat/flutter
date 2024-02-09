import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaas/controllers/partner/partner_controller.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/core/services/api/api_service.dart';
import 'package:gaas/models/partner/services/lead_details_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/services/database/local_database.dart';
import '../../../models/default_model.dart';
import '../../../utils/widgets/widgets.dart';
import '../../models/partner/services/leads_model.dart';
import '../../models/partner/services/my_service_model.dart';
import '../../models/partner/services/partner_dashboard_states_model.dart';
import '../../models/partner/services/service_image_model.dart';
import '../../models/partner/services/services_model.dart';
import '../../route/route_paths.dart';

class ServiceProviderController extends ChangeNotifier {
  /// 1) fetch_services API...

  bool loadingServices = true;
  ServicesModel? servicesModel;
  List<ServicesData>? services;

  List<Subcategory>? selectedCategories() {
    List<Subcategory>? subcategories = [];

    services?.forEach((element) {
      element.subcategories?.forEach((subcategory) {
        if (subcategory.selected == true) {
          subcategories.add(
            Subcategory(
              id: subcategory.id,
              categoryId: subcategory.categoryId,
              name: subcategory.name,
              selected: subcategory.selected,
              amount: subcategory.amount,
              unit: subcategory.unit,
              about: subcategory.about,
              isActive: subcategory.isActive,
              serviceImages: subcategory.serviceImages,
            ),
          );
        }
      });
    });

    return subcategories;
  }

  addSubCategoryImages({
    required num? serviceId,
    required num? subCategoryId,
    required ServiceImages? serviceImage,
  }) {
    int? serviceIndex = services?.indexWhere((element) => element.id == serviceId);

    if (serviceIndex?.isNegative == false) {
      int? subCategoryIndex =
          services?[serviceIndex!].subcategories?.indexWhere((element) => element.id == subCategoryId);
      if (serviceIndex?.isNegative == false && serviceImage != null) {
        if (services?[serviceIndex!].subcategories?[subCategoryIndex!].serviceImages == null) {
          services?[serviceIndex!].subcategories?[subCategoryIndex!].serviceImages = [serviceImage];
        } else {
          services?[serviceIndex!].subcategories?[subCategoryIndex!].serviceImages?.add(serviceImage);
        }

        debugPrint("SubCategory Images Added");
        notifyListeners();
      }
    }
  }

  updateSubCategorySelectedUnit({
    required num? categoryId,
    required num? subCategoryId,
    required String? unit,
  }) {
    services?.forEach((service) {
      debugPrint("categoryId = $categoryId subCategoryId = $subCategoryId unit = $unit");
      if (service.subcategories != null) {
        List<Subcategory>? subCategory =
            service.subcategories?.where((sc) => sc.id == subCategoryId).toList();

        if (subCategory.haveData) {
          subCategory?.first.unit = unit;
          notifyListeners();
          debugPrint("unit = ${subCategory?.first.unit}");
        }
      }
    });
  }

  updateSubCategoryActiveStatus({
    required num? categoryId,
    required num? subCategoryId,
    required bool? status,
  }) {
    services?.forEach((service) {
      debugPrint("categoryId = $categoryId subCategoryId = $subCategoryId status = $status");
      if (service.subcategories != null) {
        List<Subcategory>? subCategory =
            service.subcategories?.where((sc) => sc.id == subCategoryId).toList();

        if (subCategory.haveData) {
          subCategory?.first.isActive = status == true ? false : true;
          notifyListeners();

          debugPrint("status = ${subCategory?.first.isActive}");
        }
      }
    });
  }

  updateSubCategoryAbout({
    required num? categoryId,
    required num? subCategoryId,
    required String? about,
  }) {
    services?.forEach((service) {
      debugPrint("categoryId = $categoryId subCategoryId = $subCategoryId about = $about");
      if (service.subcategories != null) {
        List<Subcategory>? subCategory =
            service.subcategories?.where((sc) => sc.id == subCategoryId).toList();

        if (subCategory.haveData) {
          subCategory?.first.about = about;
          notifyListeners();
          debugPrint("unit = ${subCategory?.first.unit}");
        }
      }
    });
  }

  updateSubCategorySelectedAmount({
    required num? categoryId,
    required num? subCategoryId,
    required String? amount,
  }) {
    services?.forEach((service) {
      if (service.subcategories != null) {
        List<Subcategory>? subCategory =
            service.subcategories?.where((sc) => sc.id == subCategoryId).toList();

        if (subCategory.haveData) {
          subCategory?.first.amount = num.tryParse("${amount ?? 0}");
          notifyListeners();

          debugPrint("Amount = ${subCategory?.first.amount}");
        }
      }
    });
  }

  updateSubCategorySelectedStatus({
    required num? categoryId,
    required num? subCategoryId,
    required bool? selected,
  }) {
    services?.forEach((category) {
      if (category.subcategories != null) {
        List<Subcategory?>? subCategories =
            category.subcategories?.where((sc) => sc.id == subCategoryId).toList();

        Subcategory? subCategory;

        if (subCategories.haveData) {
          subCategory = subCategories?.first;
        }

        if (subCategory != null) {
          subCategory.categoryId = category.id;
          subCategory.selected = selected;
          subCategory.isActive = true;
          notifyListeners();
          debugPrint(
              "categoryId $categoryId & subCategoryId $subCategoryId is = $selected & amount = ${subCategory.amount}");
        }
      }
    });
  }

  Future<ServicesModel?> fetchServices({
    required BuildContext context,
    String? categoryId,
    String? subCategoryId,
    bool? isAll,
    String? searchKey,
  }) async {
    refresh() {
      loadingServices = true;
      servicesModel = null;
      services = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingServices = false;
      notifyListeners();
    }

    refresh();

    Map<String, String> body = {
      "category_id": categoryId ?? "",
      "subcategory_id": subCategoryId ?? "",
      "search_key": searchKey ?? "",
      "is_all": isAll == true ? "Yes" : "No",
    };

    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_services${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        ServicesModel responseData = ServicesModel.fromJson(json);

        if (responseData.status == true) {
          servicesModel = responseData;
          services = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return servicesModel;
  }

  /// 1) Manage Services API...
  Future manageServices({
    required BuildContext context,
    required String? about,
    required bool? registerMode,
    required bool? showContacts,
    required bool? showEmail,
    // required List<ServiceImages>? serviceImages,
  }) async {
    FocusScope.of(context).unfocus();
    LocalDatabase localDatabase = LocalDatabase();

    Map<String, String> body = {
      "services": jsonEncode(selectedCategories()),
      "about": about ?? "",
      "show_contacts": showContacts == true ? "Yes" : "No",
      "show_email": showEmail == true ? "Yes" : "No",
      // "service_images": jsonEncode(serviceImages),
    };
    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${localDatabase.accessToken}"};

//Processing API...
    loadingDialog(
      context: context,
      future: ApiService().post(
        context: context,
        endPoint: "/manage_services",
        body: body,
        headers: headers,
      ),
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        DefaultModel responseData = DefaultModel.fromJson(json);
        if (responseData.status == true) {
          fetchServices(context: context);
          Navigator.pop(context);
          PartnerController partnerController = Provider.of<PartnerController>(context, listen: false);
          partnerController.fetchPartnerProfile(context: context);
          if (registerMode == true) {
            context.pushNamed(Routs.serviceProvider);
          }
          showSnackBar(context: context, text: responseData.message ?? "Service Added");
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wrong", color: Colors.red);
        }
      }
    });
  }

  /// 3) uploadServiceImage API...

  List<ServiceImages>? serviceImages = [];

  clearServiceImages(BuildContext context) {
    PartnerController partnerController = Provider.of<PartnerController>(context, listen: false);
    serviceImages?.clear();
    if (partnerController.partnerData?.serviceImages != null) {
      serviceImages = partnerController.partnerData?.serviceImages;
    }

    notifyListeners();
  }

  removeServiceImages(int index) {
    serviceImages?.removeAt(index);
    notifyListeners();
  }

  Future uploadServiceImage({
    required BuildContext context,
    required File? image,
    required Subcategory? subcategory,
  }) async {
    FocusScope.of(context).unfocus();
    LocalDatabase localDatabase = LocalDatabase();

    Map<String, String> headers = {"Authorization": "Bearer ${localDatabase.accessToken}"};

//Processing API...

    loadingDialog(
      context: context,
      future: ApiService().multiPart(
        context: context,
        endPoint: "/upload_service_image",
        multipartFile: [
          MultiPartData(
            field: "file",
            filePath: image?.path,
          )
        ],
        headers: headers,
        body: {},
      ),
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = jsonDecode(response);
        ServiceImageModel responseData = ServiceImageModel.fromJson(json);
        if (responseData.status == true) {
          addSubCategoryImages(
            serviceId: subcategory?.categoryId,
            subCategoryId: subcategory?.id,
            serviceImage: ServiceImages(
              path: responseData.path,
              filename: responseData.data,
              image: responseData.imgWithPath,
            ),
          );
          notifyListeners();
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
    });
  }

  /// 5) Fetch LeadsModel API...

  bool loadingLeads = true;

  LeadsModel? _leadsModel;

  LeadsModel? get leadsModel => _leadsModel;
  List<LeadData>? _leads;

  List<LeadData>? get leads => _leads;
  num leadsIndex = 1;
  num leadsTotal = 1;

  Future<List<LeadData>?> fetchLeads({
    required BuildContext context,
    required bool partnerLeads,
    required RefreshController leadsController,
    String? searchKey,
    bool? todayReport,
    bool? isRefresh = false,
    bool? loadingNext = false,
  }) async {
    debugPrint("Fetching ${_leads.runtimeType}...");

    refresh() {
      leadsIndex = 1;
      leadsTotal = 1;
      loadingLeads = true;

      leadsController.resetNoData();
      _leadsModel = null;
      _leads = null;

      notifyListeners();
      debugPrint("cleared");
    }

    apiResponseCompleted() {
      loadingLeads = false;
      notifyListeners();
    }

    onError() {
      if (loadingNext == true) {
        leadsController.loadFailed();
      } else {
        leadsController.refreshFailed();
      }
      notifyListeners();
    }

    if (isRefresh == true) {
      refresh();
    }

    if (leadsIndex <= leadsTotal) {
      Map<String, String> body = {
        "page": "$leadsIndex",
        "search_key": searchKey ?? "",
        "list_type": todayReport == true ? "Today" : "",
      };

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      try {
        var response = await ApiService().get(
          context: context,
          endPoint: "${partnerLeads ? "/fetch_leads" : "/fetch_user_leads"}${queryParameter(body: body)}",
          headers: defaultHeaders,
        );

        Map<String, dynamic> json = response;

        LeadsModel? responseData = LeadsModel.fromJson(json);
        _leadsModel = responseData;
        if (responseData.status == true) {
          debugPrint("Current Page $leadsTotal");
          debugPrint(responseData.message);

          for (int index = 0; index < (responseData.data?.length ?? 0); index++) {
            if (_leads == null) {
              debugPrint("Initialized Empty Array in ${_leads.runtimeType}...");
              _leads = [];
              notifyListeners();
            }

            if (_leads?.contains(responseData.data!.elementAt(index)) == false) {
              _leads?.add(responseData.data!.elementAt(index));
            }
          }

          leadsTotal = responseData.totalPage ?? 1;
          leadsIndex++;
          if (loadingNext == true) {
            leadsController.loadComplete();
          } else {
            leadsController.refreshCompleted();
          }

          if (leadsTotal <= leadsIndex) {
            leadsController.loadComplete();
          }
          notifyListeners();
          debugPrint("Total Pages $leadsTotal");
          debugPrint("Updated Current Page $leadsIndex");
          return _leads;
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
      leadsController.loadNoData();
      apiResponseCompleted();
      debugPrint("Load no More data ");
    }
    notifyListeners();
    return _leads;
  }

  /// 3) fetch LeadDetailsModel API...

  bool loadingLeadDetails = true;
  LeadDetailsModel? leadDetailsModel;
  LeadData? leadDetail;

  Future<LeadData?> fetchLeadDetails({
    required BuildContext context,
    required bool partnerLeads,
    num? id,
  }) async {
    refresh() {
      loadingLeadDetails = true;
      leadDetailsModel = null;
      leadDetail = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingLeadDetails = false;
      notifyListeners();
    }

    refresh();

    Map<String, String> body = {
      "lead_id": "${id ?? ""}",
    };

    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint:
          "${partnerLeads ? "/fetch_lead_details" : "/fetch_user_lead_details"}${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        LeadDetailsModel responseData = LeadDetailsModel.fromJson(json);

        if (responseData.status == true) {
          leadDetailsModel = responseData;
          leadDetail = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return leadDetail;
  }

  /// 5) addReply  API...
  Future addReply({
    required BuildContext context,
    required num? leadId,
    required String? reply,
    required GestureTapCallback? onSuccess,
  }) async {
    Map<String, String> body = {
      "lead_id": "${leadId ?? ""}",
      "reply": reply ?? "",
    };

    debugPrint("Sent Data is ${jsonEncode(body)}");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    var response = ApiService().post(
      context: context,
      endPoint: "/add_a_reply",
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
          showSnackBar(context: context, text: responseData.message ?? "Reply Added Successfully.");
          onSuccess?.call();
        } else {
          showBanner(text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
    });
  }

  /// 6) fetchPartnerDashboardStates API...

  bool loadingPartnerDashboardStates = true;
  PartnerDashboardStatesModel? partnerDashboardStatesModel;
  PartnerDashboardStatesData? partnerDashboardStates;

  Future<PartnerDashboardStatesData?> fetchPartnerDashboardStates({required BuildContext context}) async {
    refresh() {
      loadingPartnerDashboardStates = true;
      partnerDashboardStatesModel = null;
      partnerDashboardStates = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingPartnerDashboardStates = false;
      notifyListeners();
    }

    refresh();

    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_stats",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        PartnerDashboardStatesModel responseData = PartnerDashboardStatesModel.fromJson(json);

        if (responseData.status == true) {
          partnerDashboardStatesModel = responseData;
          partnerDashboardStates = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return partnerDashboardStates;
  }
}
