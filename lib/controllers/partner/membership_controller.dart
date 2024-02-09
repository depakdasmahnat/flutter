import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/extensions/normal/build_context_extension.dart';
import 'package:gaas/screens/partner/service/manage_services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/enums/enums.dart';
import '../../core/services/api/api_service.dart';
import '../../core/services/database/local_database.dart';
import '../../models/partner/membership/check_membership_model.dart';
import '../../models/partner/membership/create_membership_model.dart';
import '../../models/partner/membership/create_order_id_model.dart';
import '../../models/partner/membership/membership_popup_model.dart';
import '../../models/partner/membership/subscriptions_model.dart';
import '../../route/route_paths.dart';
import '../../screens/partner/setup/select_delivery_zone.dart';
import '../../screens/partner/setup/select_order_types.dart';
import '../../screens/partner/setup/select_timeslots.dart';
import '../../screens/partner/signup/partner_membership.dart';
import '../../utils/widgets/widgets.dart';
import 'partner_controller.dart';

class MembershipController extends ChangeNotifier {
  bool checkingMembership = true;
  CheckMembershipModel? checkMembership;
  Set<OrderTypes?>? partnerOrderTypes = {};

  setPartnerOrderTypes(Set<OrderTypes?>? orderTypes) {
    partnerOrderTypes = orderTypes;
    notifyListeners();
  }

  Future<CheckMembershipModel?> checkMembershipAPI({
    required BuildContext context,
    required String? route,
    required ServiceType? type,
  }) async {
    PartnerController controllers = Provider.of(context, listen: false);
    ServiceType? serviceType = controllers.serviceType;
    try {
      checkingMembership = true;
      checkMembership = null;
      partnerOrderTypes?.clear();
      notifyListeners();
      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      loadingDialog(
        context: context,
        future: ApiService().get(
          context: context,
          endPoint: "/check_membership?type=${serviceType.value}",
          headers: defaultHeaders,
        ),
      ).then((response) {
        Map<String, dynamic> json = response;
        CheckMembershipModel? data = CheckMembershipModel.fromJson(json);

        debugPrint("Check membership response is $response");

        if (data.status == true) {
          checkMembership = data;
          notifyListeners();
          String? url = data.url;

          Set<OrderTypes>? selectedOrderTypes = getOrderTypes(orderTypes: data.orderTypes);
          partnerOrderTypes = selectedOrderTypes;
          notifyListeners();

          debugPrint("partnerOrderTypes $partnerOrderTypes");
          if (url == "/dashboard") {
            showSnackBar(
                context: context,
                text: "Welcome back...${serviceType.value} Partner",
                icon: Icons.check_circle_outline_rounded);
            context.firstRoute();

            context.pushNamed("$route");
          } else if (url == Routs.manageServices) {
            context.pushNamed(Routs.manageServices, extra: const ManageService(registerMode: true));
          } else if (url == Routs.selectOrderTypes) {
            context.pushNamed(Routs.selectOrderTypes, extra: SelectOrderTypes(route: route, type: type));
          } else if (url == Routs.selectTimeSlots) {
            context.pushNamed(Routs.selectTimeSlots,
                extra: SelectTimeSlots(route: route, type: type, selectedOrderTypes: partnerOrderTypes));
          } else if (url == Routs.selectDeliveryZones) {
            context.pushNamed(Routs.selectDeliveryZones,
                extra: SelectDeliveryZones(route: route, type: type, selectedOrderTypes: partnerOrderTypes));
          } else if (url == Routs.partnerMembership) {
            context.pushNamed(Routs.partnerMembership,
                extra: const PartnerMembership(
                  route: Routs.freshProduce,
                  type: ServiceType.freshProduce,
                ));
          }

          debugPrint(checkMembership.toString());
        } else {
          checkMembership = data;
          showSnackBar(
              context: context,
              text: data.message ?? "Something went wrong",
              color: Colors.red,
              icon: Icons.error);
          notifyListeners();
        }
      });
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    } finally {
      checkingMembership = false;
      notifyListeners();
    }
    return checkMembership;
  }

  bool loadingCreateOrderId = true;
  CreateOrderIdModel? createOrderIdModel;

  Future<CreateOrderIdModel?> createOrderId({
    required num? amount,
    required BuildContext context,
  }) async {
    createOrderIdModel = null;
    notifyListeners();
    try {
      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      PartnerController controllers = Provider.of(context, listen: false);
      ServiceType? serviceType = controllers.serviceType;
      var response = await ApiService().post(
        context: context,
        endPoint: "/create_razorpay_order-id",
        body: {
          'amount': "$amount",
          'type': serviceType.value,
        },
        headers: defaultHeaders,
      );
      Map<String, dynamic> json = response;
      CreateOrderIdModel? data = CreateOrderIdModel.fromJson(json);
      if (data.status == true) {
        createOrderIdModel = data;
        notifyListeners();
      } else {}
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    } finally {
      notifyListeners();
    }
    return createOrderIdModel;
  }

  Future<CreateMembershipModel?> createMembership({
    required BuildContext context,
    required dynamic paymentOrderId,
    required String? route,
    required SubscriptionsData? data,
  }) async {
    CreateMembershipModel? createMembershipModel;
    try {
      PartnerController controllers = Provider.of(context, listen: false);
      ServiceType? serviceType = controllers.serviceType;

      Map<String, String> body = {
        "type": serviceType.value,
        "subscription_id": "${data?.id ?? ""}",
        "coupon_id": "${data?.couponId ?? ""}",
        "membership_days": "${data?.days ?? ""}",
        "payment_order_id": "${paymentOrderId ?? ""}",
        "amount": data?.amount ?? "",
      };

      debugPrint("Body is $body");

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      var response = ApiService().post(
        context: context,
        endPoint: "/create_membership",
        body: body,
        headers: defaultHeaders,
      );

      loadingDialog(
        context: context,
        future: response,
      ).then((response) {
        Map<String, dynamic> json = response;
        CreateMembershipModel? data = CreateMembershipModel.fromJson(json);
        PartnerController controllers = Provider.of(context, listen: false);
        ServiceType? serviceType = controllers.serviceType;
        if (data.status == true) {
          showSnackBar(
              context: context,
              text: "Congratulations...You are now ${serviceType.value} Partner",
              icon: Icons.check_circle_outline_rounded);

          context.firstRoute();
          if (serviceType == ServiceType.serviceProvider) {
            context.pushNamed(Routs.manageServices, extra: const ManageService(registerMode: true));
          } else {
            context.pushNamed(Routs.selectOrderTypes,
                extra: SelectOrderTypes(route: route, type: serviceType));
          }

          return response;
        } else {
          showSnackBar(
              context: context,
              text: data.message ?? "Congratulations...You are now ${serviceType.value} Partner",
              color: Colors.red,
              icon: Icons.error);
          // context.firstRoute();
          // context.pushNamed("$route");
        }
      });
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return createMembershipModel;
  }

  MembershipPopupModel? showMembershipPopupModel;

  Future<MembershipPopupModel?> showMembershipPopupAPI({required BuildContext context}) async {
    PartnerController controllers = Provider.of(context, listen: false);
    ServiceType? serviceType = controllers.serviceType;
    try {
      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      debugPrint("Checking hideMembershipPopupBool");
      var response = await ApiService().get(
        context: context,
        endPoint: "/show_membership_popup?type=${serviceType.value}",
        headers: defaultHeaders,
      );

      Map<String, dynamic> json = response;
      MembershipPopupModel? data = MembershipPopupModel.fromJson(json);

      notifyListeners();
      showMembershipPopupModel = data;
      debugPrint(
          "hideMembershipPopupBool ${showMembershipPopupModel?.status}  & ${showMembershipPopupModel?.message}");

      notifyListeners();

      return showMembershipPopupModel;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    } finally {
      notifyListeners();
    }
    return showMembershipPopupModel;
  }

  Future<bool> checkInternetConnection() async {
    bool connected = true;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
        connected = true;
      }
    } on SocketException catch (_) {
      debugPrint('not connected');
      connected = false;
    }
    return connected;
  }

  bool skipMembershipPopup = false;

  Future showMembershipPopup({
    required BuildContext context,
    required String? message,
    required bool? isSkip,
  }) async {
    onMembershipTap() {
      PartnerController controllers = Provider.of(context, listen: false);
      ServiceType? serviceType = controllers.serviceType;
      if (isSkip == true) {
        Navigator.pop(context);
        context.pushNamed(Routs.partnerMembership,
            extra: PartnerMembership(type: serviceType, route: "/${serviceType.value}"));
      } else {
        Navigator.pop(context);
        context.pushNamed(Routs.partnerMembership,
            extra: PartnerMembership(type: serviceType, route: "/${serviceType.value}"));
      }
    }

    notifyListeners();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WillPopScope(
                  onWillPop: () async {
                    onMembershipTap();
                    return true;
                  },
                  child: SimpleDialog(
                    shape:
                        const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    children: <Widget>[
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(30, 24, 30, 6),
                                child: Text(
                                  "Your Membership has been Expired...",
                                  style:
                                      TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                              //   child: Text(
                              //     "$message",
                              //     style: TextStyle(
                              //         fontSize: cashBackFont ?? 12,
                              //         fontWeight: FontWeight.w600,
                              //         color: Colors.grey.shade700),
                              //     textAlign: TextAlign.center,
                              //   ),
                              // ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                                child: SizedBox(
                                  height: 30,
                                  width: 150,
                                  child: CupertinoButton(
                                    color: Colors.green,
                                    padding: EdgeInsets.zero,
                                    borderRadius: BorderRadius.circular(45),
                                    child: const Text(
                                      "Purchase",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    onPressed: () {
                                      onMembershipTap();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                              top: -40,
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(70),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.info,
                                    color: Colors.red,
                                    size: 56,
                                  ),
                                ),
                              )),
                          if (isSkip == true)
                            Positioned(
                                top: -12,
                                right: 10,
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.only(left: 16, right: 16, top: 1.5, bottom: 1.5),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(70),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.skip_next,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          "Skip",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    skipMembershipPopup = true;
                                    notifyListeners();
                                  },
                                )),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          });
        });
  }

  bool showingNoInternetPopup = false;

  setNoInternetPopupBool() {
    showingNoInternetPopup = false;
    notifyListeners();
  }

  Future showNoInternetPopup({
    required BuildContext context,
    bool goBack = false,
  }) async {
    debugPrint("Showing No Internet Popup");

    return showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: StatefulBuilder(builder: (context, setState) {
              showingNoInternetPopup = true;
              notifyListeners();
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: SimpleDialog(
                      shape:
                          const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      children: <Widget>[
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(30, 36, 30, 2),
                                  child: Text(
                                    "You don't have Active Internet Connection...",
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 26),
                                  child: Text(
                                    "Please Connect to Active Mobile Internet or Wifi to use Hindustan Contractor",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade500),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                                //   child: SizedBox(
                                //     height: 30,
                                //     width: 150,
                                //     child: CupertinoButton(
                                //       color: Colors.green,
                                //       padding: EdgeInsets.zero,
                                //       borderRadius: BorderRadius.circular(45),
                                //       child: const Text(
                                //         "Connect",
                                //         style: TextStyle(
                                //           fontSize: 13,
                                //           fontWeight: FontWeight.w500,
                                //         ),
                                //       ),
                                //       onPressed: () {
                                //         // Navigator.pop(context);
                                //       },
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            Positioned(
                                top: -40,
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(70),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.info,
                                      color: Colors.red,
                                      size: 56,
                                    ),
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        });
  }
}
