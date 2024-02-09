import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/partner/partner_controller.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:gaas/core/services/api/api_service.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/services/database/local_database.dart';
import '../../../models/default_model.dart';
import '../../../models/partner/offers/partner_offers_model.dart';
import '../../../utils/widgets/widgets.dart';

class OffersController extends ChangeNotifier {
  /// 1) Add Offer API...
  Future addOffer({
    required BuildContext context,
    required String? name,
    required String? code,
    required String? startDate,
    required String? endDate,
    required String? maxUser,
    required String? eligibilityType,
    required String? categoryId,
    required String? claimType,
    required String? discountUPto,
    required String? percent,
    required String? amount,
    required String? maxValidAmount,
  }) async {
    FocusScope.of(context).unfocus();
    LocalDatabase localDatabase = LocalDatabase();
    ServiceType type = context.read<PartnerController>().serviceType;

    Map<String, String> body = {
      "type": type.value,
      "name": name ?? "",
      "code": code ?? "",
      "start_date": startDate ?? "",
      "end_date": endDate ?? "",
      "max_user": maxUser ?? "",
      "eligibility_type": eligibilityType ?? "",
      "category_id": categoryId ?? "",
      "claim_type": claimType ?? "",
      "percent": percent ?? "",
      "discount_upto": discountUPto ?? "",
      "amount": amount ?? "",
      "max_valid_amount": maxValidAmount ?? "",
    };
    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${localDatabase.accessToken}"};

//Processing API...
    loadingDialog(
      context: context,
      future: ApiService().post(
        context: context,
        endPoint: "/add_partner_coupon",
        body: body,
        headers: headers,
      ),
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        DefaultModel responseData = DefaultModel.fromJson(json);
        if (responseData.status == true) {
          fetchOffers(context: context, isRefresh: true);
          Navigator.pop(context);
        } else {
          showSnackBar(context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
    });
  }

  /// 2) Edits Offer API...
  Future editOffer({
    required BuildContext context,
    required num? id,
    required String? name,
    required String? code,
    required String? startDate,
    required String? endDate,
    required String? maxUser,
    required String? eligibilityType,
    required String? categoryId,
    required String? claimType,
    required String? discountUPto,
    required String? percent,
    required String? amount,
    required String? maxValidAmount,
  }) async {
    FocusScope.of(context).unfocus();
    LocalDatabase localDatabase = LocalDatabase();

    ServiceType type = context.read<PartnerController>().serviceType;

    Map<String, String> body = {
      "type": type.value,
      "id": "${id ?? ""}",
      "name": name ?? "",
      "code": code ?? "",
      "start_date": startDate ?? "",
      "end_date": endDate ?? "",
      "max_user": maxUser ?? "",
      "eligibility_type": eligibilityType ?? "",
      "category_id": categoryId ?? "",
      "claim_type": claimType ?? "",
      "percent": percent ?? "",
      "discount_upto": discountUPto ?? "",
      "amount": amount ?? "",
      "max_valid_amount": maxValidAmount ?? "",
    };

    debugPrint("Sent Data is $body");

    Map<String, String> headers = {"Authorization": "Bearer ${localDatabase.accessToken}"};

//Processing API...

    loadingDialog(
      context: context,
      future: ApiService().post(
        context: context,
        endPoint: "/edit_partner_coupon",
        body: body,
        headers: headers,
      ),
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        DefaultModel responseData = DefaultModel.fromJson(json);
        if (responseData.status == true) {
          fetchOffers(context: context, isRefresh: true);
          Navigator.pop(context);
        } else {
          showSnackBar(context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
    });
  }

  /// 0) SignOut User....

  Future deletePartnerCouponPopUp({
    required BuildContext context,
    required num? id,
  }) {
    FocusScope.of(context).unfocus();

    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Delete Offer"),
            content: const Text("Do you want To delete this Offer"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  deletePartnerCoupon(context: context, id: id);
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          );
        });
  }

  /// 3) delete_partner_coupon API...
  Future deletePartnerCoupon({
    required BuildContext context,
    required num? id,
  }) async {
    FocusScope.of(context).unfocus();
    LocalDatabase localDatabase = LocalDatabase();

    ServiceType type = context.read<PartnerController>().serviceType;

    Map<String, String> body = {
      "type": type.value,
      "id": "${id ?? ""}",
    };

    debugPrint("Sent Data is $body");

    Map<String, String> headers = {"Authorization": "Bearer ${localDatabase.accessToken}"};

//Processing API...

    loadingDialog(
      context: context,
      future: ApiService().get(
        context: context,
        endPoint: "/delete_partner_coupon${queryParameter(body: body)}",
        headers: headers,
      ),
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        DefaultModel responseData = DefaultModel.fromJson(json);
        if (responseData.status == true) {
          fetchOffers(context: context, isRefresh: true);
          Navigator.pop(context);
          showSnackBar(context: context, text: responseData.message ?? "Coupon Deleted", color: Colors.green);
        } else {
          showSnackBar(context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
    });
  }

  /// 4) Fetch Offers Data...

  bool loadingOffers = true;

  PartnerOffersModel? _gymOffersModel;

  PartnerOffersModel? get gymOffersModel => _gymOffersModel;
  List<PartnerOffersData>? _gymOffersData;

  List<PartnerOffersData>? get gymOffersData => _gymOffersData;
  num gymOffersIndex = 1;
  num gymOffersTotal = 1;

  RefreshController gymOffersController = RefreshController(initialRefresh: false);

  Future<List<PartnerOffersData>?> fetchOffers({
    required BuildContext context,
    bool isRefresh = false,
    bool loadingNext = false,
    String? searchKey,
  }) async {
    debugPrint("Fetching gymOffersModel Data...");

    refresh() {
      gymOffersIndex = 1;
      gymOffersTotal = 1;
      loadingOffers = true;
      gymOffersController.resetNoData();
      _gymOffersModel = null;
      _gymOffersData = null;
      notifyListeners();
      debugPrint("cleared");
    }

    if (isRefresh) {
      refresh();
    }

    if (gymOffersIndex <= gymOffersTotal) {
      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      ServiceType type = context.read<PartnerController>().serviceType;

      Map<String, String> body = {
        "type": type.value,
        "page": "$gymOffersIndex",
        "search_key": searchKey ?? "",
      };

      try {
        var response = await ApiService().get(
          context: context,
          endPoint: "/fetch_partner_coupons${queryParameter(body: body)}",
          headers: defaultHeaders,
        );

        Map<String, dynamic> json = response;
        PartnerOffersModel? data = PartnerOffersModel.fromJson(json);
        _gymOffersModel = data;

        if (data.status == true) {
          debugPrint("Current Page $gymOffersTotal");
          debugPrint(data.message);
          for (int i = 0; i < data.data!.length; i++) {
            if (_gymOffersData == null) {
              debugPrint("GymOffersModel Added");
              _gymOffersData = [data.data!.elementAt(i)];
            } else {
              if (_gymOffersData!.contains(data.data!.elementAt(i))) {
                debugPrint("GymOffersModel Already exit");
              } else {
                _gymOffersData!.add(data.data!.elementAt(i));
                debugPrint("GymOffersModel  Updated ");
              }
            }
          }

          if (loadingNext) {
            gymOffersController.loadComplete();
          } else {
            gymOffersController.refreshCompleted();
          }
          gymOffersTotal = data.totalPage ?? 1;
          gymOffersIndex++;
          notifyListeners();
          debugPrint("MyContractorsData Total Pages $gymOffersTotal");
          debugPrint("Updated MyContractorsData Current Page $gymOffersIndex");
          return _gymOffersData;
        } else {
          debugPrint(data.message);
          if (loadingNext) {
            gymOffersController.loadFailed();
          } else {
            gymOffersController.refreshFailed();
          }
          notifyListeners();
        }
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
      } finally {
        loadingOffers = false;
        notifyListeners();
      }
    } else {
      gymOffersController.loadNoData();
      loadingOffers = false;
      notifyListeners();
      debugPrint("Load no More data in MyAgentsData");
    }
    notifyListeners();
    return _gymOffersData;
  }
}
