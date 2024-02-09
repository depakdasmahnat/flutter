import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/core/services/api/api_service.dart';
import 'package:gaas/models/partner/setup/timeslots_model.dart';
import 'package:gaas/screens/orders/order_status.dart';
import 'package:geocoder/geocoder.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/services/database/local_database.dart';
import '../../core/strings.dart';
import '../../models/dashboard/producer_details_model.dart';
import '../../models/default_model.dart';
import '../../models/orders/download_invoice_model.dart';
import '../../models/orders/order_addresses.dart';
import '../../models/orders/applie_coupon_model.dart';
import '../../models/orders/cart_Items_model.dart';
import '../../models/orders/manage_cart_model.dart';
import '../../models/orders/order_detail_model.dart';
import '../../models/orders/orders_model.dart';
import '../../models/orders/partner_time_slots_model.dart';
import '../../models/orders/partner_timeslote_dates_model.dart';
import '../../models/orders/payment_summary_model.dart';
import '../../models/orders/place_order_model.dart';
import '../../models/orders/un_reviewed_orders.dart';
import '../../models/orders/valid_coupons_model.dart';
import '../../models/partner/orders/suggested_times_slots_model.dart';
import '../../models/partner/setup/delivery_zones_model.dart';
import '../../route/route_paths.dart';
import '../../utils/widgets/widgets.dart';
import '../dashboard_controller.dart';

class CartController extends ChangeNotifier {
  clearData(BuildContext context) {
    clearCart(context);
    clearFreshProduceUnReviewedOrders();
    clearNurseryUnReviewedOrders();
    notifyListeners();
  }

  /// 1) Cart Items API...
  List<ProducerDetailsData?>? _cartItems = [];

  List<ProducerDetailsData?>? get cartItems => _cartItems;

  setCartItems(List<ProducerDetailsData?>? items) {
    if (items != null) {
      _cartItems = items;
      debugPrint("Setting Cart Items $_cartItems &&  $items");
      notifyListeners();
    }
  }

  setOrderMethod({
    required ProducerDetailsData? producer,
    required String? orderMethod,
  }) {
    int index = getProducerIndex(producerId: producer?.id);
    if (!index.isNegative) {
      _cartItems?[index]?.selectedOrderMethod = orderMethod;
      notifyListeners();
    }
  }

  setSelfPickingPersons({
    required ProducerDetailsData? producer,
    required num? noOfPersons,
  }) {
    int index = getProducerIndex(producerId: producer?.id);
    if (!index.isNegative) {
      _cartItems?[index]?.noOfPersons = noOfPersons ?? 1;
      notifyListeners();
    }
  }

  setHomeAddress({
    required ProducerDetailsData? producer,
    required OrderAddress? address,
  }) {
    int index = getProducerIndex(producerId: producer?.id);
    if (!index.isNegative) {
      _cartItems?[index]?.homeAddress = address;
      notifyListeners();
    }
  }

  setDeliveryAddressOrder({
    required ProducerDetailsData? producer,
    required OrderAddress? address,
  }) {
    int index = getProducerIndex(producerId: producer?.id);
    if (!index.isNegative) {
      _cartItems?[index]?.deliveryAddressOrder = address;
      notifyListeners();
    }
  }

  setBillingAddress({
    required ProducerDetailsData? producer,
    required OrderAddress? address,
  }) {
    int index = getProducerIndex(producerId: producer?.id);
    if (!index.isNegative) {
      _cartItems?[index]?.billingAddress = address;
      notifyListeners();
    }
  }

  setDateSlot({
    required ProducerDetailsData? producer,
    required PartnerTimeSlotDates? timeSlot,
  }) {
    int index = getProducerIndex(producerId: producer?.id);
    if (!index.isNegative) {
      _cartItems?[index]?.selectedDateSlot = timeSlot;
      notifyListeners();
    }
  }

  setTimeSlot({
    required ProducerDetailsData? producer,
    required TimeSlotsData? timeSlot,
  }) {
    int index = getProducerIndex(producerId: producer?.id);
    if (!index.isNegative) {
      _cartItems?[index]?.selectedTimeSlot = timeSlot;
      notifyListeners();
    }
  }

  setIsSameAddress({
    required ProducerDetailsData? producer,
    required bool? same,
  }) {
    int index = getProducerIndex(producerId: producer?.id);
    if (!index.isNegative) {
      _cartItems?[index]?.isSameAddress = same;
      notifyListeners();
    }
  }

  setOrderType({
    required BuildContext context,
    required num? producerId,
    required String? orderType,
  }) {
    int index = getProducerIndex(producerId: producerId);
    if (!index.isNegative) {
      ProducerDetailsData? producer = _cartItems?[index];
      producer?.orderType = orderType;
      notifyListeners();
      changeCount(
        context: context,
        producer: producer,
        refreshPaymentSummary: true,
      );
    }
  }

  setDeliveryLocation({
    required ProducerDetailsData? producer,
    required double? deliveryLatitude,
    required double? deliveryLongitude,
    required String? deliveryAddress,
  }) {
    int index = getProducerIndex(producerId: producer?.id);
    if (!index.isNegative) {
      _cartItems?[index]?.deliveryLatitude = "$deliveryLatitude";
      _cartItems?[index]?.deliveryLongitude = "$deliveryLongitude";
      _cartItems?[index]?.deliveryAddress = deliveryAddress;

      debugPrint(
          "deliveryLatitude is $deliveryLatitude && deliveryLongitude is $deliveryLatitude &&  deliveryAddress is $deliveryAddress ");
      notifyListeners();
    }
  }

  setDeliveryZone({
    required ProducerDetailsData? producer,
    required DeliveryZonesData? deliveryZone,
  }) {
    int index = getProducerIndex(producerId: producer?.id);
    if (!index.isNegative) {
      _cartItems?[index]?.selectedDeliveryZone = deliveryZone;
      notifyListeners();
    }
  }

  loadCart(BuildContext context) {
    LocalDatabase localDatabase = LocalDatabase();
    late bool isAuthenticated = localDatabase.accessToken != null;
    if (isAuthenticated) {
      fetchCartItems(context: context).then((value) {
        List<CartItemsData>? items = value;
        setCartItemsFromServer(items);
      });
    } else {
      LocalDatabase().getCartItems(context);
    }
  }

  setCartItemsFromServer(List<CartItemsData?>? serverItems) {
    _cartItems?.clear();
    notifyListeners();
    if (serverItems != null) {
      List<ProducerDetailsData>? cartItems = serverItems
          .map(
            (producer) => ProducerDetailsData(
              id: producer?.partnerId,
              name: producer?.partnerName,
              path: producer?.path,
              profilePhoto: producer?.profilePhoto,
              address: producer?.partnerAddress,
              orderType: producer?.orderType,
              orderTypes: producer?.orderTypes,
              serviceTypes: producer?.serviceTypes,
              products: producer?.products,
              isFreeSelfPicking: producer?.isFreeSelfPicking,
              eachPersonAmount: producer?.eachPersonAmount,
            ),
          )
          .toList();
      _cartItems = cartItems;

      debugPrint("Setting Server Cart Items $_cartItems &&  $serverItems");
      notifyListeners();
    }
  }

  clearCart(BuildContext context) async {
    debugPrint("Clearing getProductsCount ${getProductsCount()}");
    debugPrint("Clearing Cart Items...");
    _cartItems?.clear();
    clearAppliedCoupon(context);
    appliedGaasCoin = null;
    notifyListeners();
    cartItemsModel = null;
    cartItemsData = null;
    LocalDatabase().setCartItems(_cartItems);
    notifyListeners();
  }

  int getProductsCount() {
    int length = 0;

    if (_cartItems != null) {
      _cartItems?.forEach((element) {
        int productsLength = element?.products?.length ?? 0;
        length = length + productsLength;
      });
    }

    return length;
  }

  bool validForm(BuildContext context) {
    ///Enter partner Id to get subtotal of specific Partner Order
    bool valid = true;

    if (_cartItems.haveData) {
      _cartItems?.forEach((partner) {
        if (partner?.selectedOrderMethod == OrderTypes.delivery.value) {
          // if ((partner?.deliveryAddress?.length ?? 0) <= 0 && valid == true) {
          //   valid = false;
          //   String error = '${partner?.name} Delivery Address is Required';
          //   showSnackBar(context: context, text: error, color: Colors.red);
          // }

          if (partner?.homeAddress == null && valid == true) {
            valid = false;
            String error = '${partner?.name} Home Address is Required';
            showSnackBar(context: context, text: error, color: Colors.red);
          }
          if (partner?.billingAddress == null && valid == true) {
            valid = false;
            String error = '${partner?.name} Billing Address is Required';
            showSnackBar(context: context, text: error, color: Colors.red);
          }

          if (partner?.deliveryAddressOrder == null && valid == true) {
            valid = false;
            String error = '${partner?.name} Delivery Address is Required';
            showSnackBar(context: context, text: error, color: Colors.red);
          }
        }

        if (partner?.selectedDateSlot == null && valid == true) {
          valid = false;
          String error = '${partner?.name} Pickup Date is Required';
          showSnackBar(context: context, text: error, color: Colors.red);
        }

        if (partner?.selectedTimeSlot == null && valid == true) {
          valid = false;
          String error = '${partner?.name} Pickup Time is Required';
          showSnackBar(context: context, text: error, color: Colors.red);
        }
      });
    } else {
      valid = false;
    }
    debugPrint("valid $valid");

    return valid;
  }

  num getSelfPickingCharges() {
    ///Enter partner Id to get subtotal of specific Partner Order
    debugPrint("Getting getSelfPickingCharges");
    num selfPickingCharges = 0;

    if (_cartItems.haveData) {
      debugPrint("getSelfPickingCharges haveData");
      _cartItems?.forEach((partner) {
        if (partner?.selectedOrderMethod == OrderTypes.uPick.value) {
          num noOfPersons = num.parse("${partner?.noOfPersons ?? 1}");
          num eachPersonAmount = num.parse("${partner?.eachPersonAmount ?? 0}");
          selfPickingCharges = selfPickingCharges + (noOfPersons * eachPersonAmount);
          debugPrint(
              "getSelfPickingCharges noOfPersons $noOfPersons & noOfPersons $noOfPersons & eachPersonAmount $eachPersonAmount &selfPickingCharges $selfPickingCharges }");
        }
      });
    }

    debugPrint("TotalSelfPickingCharges $selfPickingCharges");
    return num.parse((selfPickingCharges).toStringAsFixed(2));
  }

  num getSubTotal({num? partnerId}) {
    ///Enter partner Id to get subtotal of specific Partner Order

    num subTotal = 0;

    bool partnerCoupon = appliedCouponData?.creatorType == "Partner";

    if (_cartItems != null) {
      _cartItems?.forEach((partner) {
        bool allPartners = partnerId != null ? (partner?.id == partnerId) : true;

        if (allPartners) {
          for (ProducerProducts? data in partner?.products ?? []) {
            num price = num.parse("${data?.price ?? 0}");
            num quantity = num.parse("${data?.quantity ?? 0}");
            subTotal = subTotal + (price * quantity);
          }
        }
      });
    }

    return num.parse((subTotal).toStringAsFixed(2));
  }

  bool productExist({required num? productId}) {
    bool result = _cartItems
            ?.where((element) =>
                element?.products?.where((element) => element?.id == productId).isNotEmpty == true)
            .isNotEmpty ==
        true;
    return result;
  }

  int getProducerIndex({
    required num? producerId,
  }) {
    int? index;
    index = _cartItems?.indexWhere((element) => element?.id == producerId);
    return index ?? -1;
  }

  int getProductIndex({
    required num? producerId,
    required num? productId,
  }) {
    int? index = _cartItems
        ?.firstWhere((element) => element?.id == producerId)
        ?.products
        ?.indexWhere((element) => element?.id == productId);
    return index ?? -1;
  }

  ProducerProducts? getProduct({
    required num? producerId,
    required num? productId,
  }) {
    ProducerProducts? product;
    try {
      List<ProducerProducts?>? producerData =
          _cartItems?.firstWhere((element) => element?.id == producerId)?.products;
      if (producerData.haveData) {
        List<ProducerProducts?>? products =
            producerData?.where((element) => element?.id == productId).toList();
        if (products.haveData) {
          product = products?.first;
        }
      }
    } catch (e, s) {
      debugPrint("Cart getProduct Error $e & $s");
    }
    return product;
  }

  // addProducerProduct({
  //   ProducerDetailsData? producer,
  //   ProducerProducts? product,
  // }) {
  //   int? producerIndex = getProducerIndex(producerId: producer?.id);
  //
  //   bool hasProducer = producerIndex != null && (producerIndex.isNegative == false);
  //
  //   if (hasProducer) {
  //     addProduct(producer: producer, product: product);
  //   } else {
  //     _cartItems?.add(
  //       ProducerDetailsData().copyWith(
  //         copy: producer,
  //         products: [product],
  //       ),
  //     );
  //     notifyListeners();
  //   }
  // }

  addProduct({
    required BuildContext context,
    required ProducerDetailsData? producer,
    required ProducerProducts? product,
  }) {
    debugPrint("producer ${producer?.name}");
    debugPrint("product ${product?.name}");

    int? producerIndex = getProducerIndex(producerId: producer?.id);

    bool hasProducer = !producerIndex.isNegative;
    debugPrint("hasProducer $hasProducer");
    if (hasProducer) {
      bool haveProducts = _cartItems?[producerIndex]?.products.haveData == true;
      debugPrint("haveProducts $haveProducts");
      if (haveProducts == false) {
        _cartItems?[producerIndex]?.products = [];
        notifyListeners();
      }

      _cartItems?[producerIndex]?.products?.add(
            ProducerProducts().copyWith(copy: product, quantity: 1),
          );
      notifyListeners();
    } else {
      ProducerDetailsData? newProducer = ProducerDetailsData().copyWith(
        copy: producer,
        products: [
          ProducerProducts().copyWith(copy: product, quantity: 1),
        ],
      );

      notifyListeners();
      debugPrint("newProducer ${newProducer.name}");
      debugPrint("newProducer quantity ${newProducer.products?.first?.quantity}");
      _cartItems?.add(newProducer);
      notifyListeners();
    }

    LocalDatabase().setCartItems(_cartItems);
    bool isAuthenticated = LocalDatabase().accessToken != null;
    if (isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        manageCartAPI(context: context, producer: producer, product: product).then((value) {
          getPaymentSummary(context: context);
        });
      });
    }
  }

  int setNoOfPeoplesCount({
    required BuildContext context,
    required num? producerId,
    required String? quantity,
    bool? addOne,
    bool? removeOne,
  }) {
    int producerIndex = getProducerIndex(producerId: producerId);

    int newCount = quantity != null ? int.parse(quantity) : 1;
    if (addOne == true) {
      newCount = newCount + 1;
    }

    if (removeOne == true) {
      if (newCount > 1) {
        newCount = newCount - 1;
      }
    }

    notifyListeners();
    debugPrint("New Count $newCount  & producerIndex $producerIndex");

    if (!producerIndex.isNegative) {
      ProducerDetailsData? producer = _cartItems?[producerIndex];
      producer?.noOfPersons = newCount;
      if (producer?.products.haveData == true) {}
      notifyListeners();

      changeCount(
        context: context,
        producer: producer,
        refreshPaymentSummary: true,
      );
    }

    notifyListeners();

    // bool isAuthenticated = LocalDatabase().accessToken != null;
    //
    // debugPrint("producerIndex $producerIndex");
    // if (!producerIndex.isNegative ) {
    //   ProducerProducts? product = _cartItems?[producerIndex]?.products?[productIndex];
    //   if (isAuthenticated) {
    //     manageCartAPI(
    //       context: context,
    //       producerId: producerId,
    //       product: product,
    //     );
    //   }
    // }

    LocalDatabase().setCartItems(_cartItems);
    return newCount.toInt();
  }

  Timer? _debounceCartTimer;

  void debounceCart({
    required GestureTapCallback? onTap,
  }) {
    if (_debounceCartTimer?.isActive ?? false) _debounceCartTimer?.cancel();
    _debounceCartTimer = Timer(const Duration(milliseconds: 200), () {
      onTap?.call();
      notifyListeners();
    });
  }

  int changeCount({
    required BuildContext context,
    required ProducerDetailsData? producer,
    num? productId,
    num? limit,
    String? quantity,
    bool? noCountChange,
    GestureTapCallback? onCartEmpty,
    bool? refreshPaymentSummary,
    bool? addOne,
    bool? removeOne,
    bool? debounceEffect,
  }) {
    int producerIndex = getProducerIndex(producerId: producer?.id);
    int productIndex = getProductIndex(producerId: producer?.id, productId: productId);
    int newCount = quantity != null ? int.parse(quantity) : 0;
    calculatingPaymentSummary = true;
    notifyListeners();

    debugPrint("newCount $newCount & limit $limit");

    if (noCountChange != true) {
      if (addOne == true) {
        if (newCount >= (limit ?? 0)) {
          showSnackBar(
              context: context,
              text: productLimitExceed,
              color: Colors.red,
              icon: Icons.error_outline_rounded);
        } else {
          newCount = newCount + 1;
        }
      }
      if (removeOne == true) {
        if (newCount >= 1) {
          newCount = newCount - 1;
        }
      }
    }
    notifyListeners();
    debugPrint("New Count $newCount  & producerIndex $producerIndex & productIndex $productIndex");

    if (!producerIndex.isNegative) {
      bool hasProduct = !productIndex.isNegative;
      debugPrint("hasProduct Count $hasProduct");

      if (hasProduct) {
        if (newCount <= (limit ?? 0)) {
          _cartItems?[producerIndex]?.products?[productIndex]?.quantity = newCount;
          notifyListeners();
        }
      }
    }

    notifyListeners();

    bool isAuthenticated = LocalDatabase().accessToken != null;

    bool hasProduct = !productIndex.isNegative;
    debugPrint("hasProduct Count $hasProduct producerIndex $producerIndex productIndex $productIndex");
    if (!producerIndex.isNegative) {
      ProducerProducts? product;
      if (hasProduct) {
        product = _cartItems?[producerIndex]?.products?[productIndex];
      }

      if (isAuthenticated) {
        if (debounceEffect == true && newCount > 1) {
          debounceCart(
            onTap: () {
              debugPrint("debounceEffect Called");
              manageCartAPI(
                context: context,
                producer: producer,
                product: product,
                refreshPaymentSummary: refreshPaymentSummary,
              );
            },
          );
        } else {
          manageCartAPI(
            context: context,
            producer: producer,
            product: product,
            refreshPaymentSummary: refreshPaymentSummary,
          );
        }
        notifyListeners();
      }
    }

    if (newCount == 0) {
      removeProduct(
        context: context,
        producerIndex: producerIndex,
        productId: productId,
        onCartEmpty: onCartEmpty,
      );
    }
    LocalDatabase().setCartItems(_cartItems);
    return newCount.toInt();
  }

  removeProduct({
    required BuildContext context,
    required int? producerIndex,
    required num? productId,
    required GestureTapCallback? onCartEmpty,
  }) {
    if (producerIndex != null && productId != null) {
      debugPrint("Removing producerIndex $producerIndex productId $productId");

      int productsLength = _cartItems?[producerIndex]?.products?.length ?? 0;
      if (productsLength >= 1) {
        _cartItems?[producerIndex]?.products?.removeWhere((element) => element?.id == productId);
        notifyListeners();

        if (productsLength == 1) {
          removeProducer(context: context, producerIndex: producerIndex, onCartEmpty: onCartEmpty);
        }
      }
      notifyListeners();
      LocalDatabase().setCartItems(_cartItems);
    }
  }

  removeProducer({
    required BuildContext context,
    required int producerIndex,
    required GestureTapCallback? onCartEmpty,
  }) {
    debugPrint("Removing Producer at $producerIndex");
    _cartItems?.removeAt(producerIndex);
    notifyListeners();
    int cartLength = _cartItems?.length ?? 0;
    notifyListeners();

    debugPrint("cartLength $cartLength");
    if (getProductsCount() == 0) {
      if (onCartEmpty != null) {
        onCartEmpty();
      }
    }
    notifyListeners();
  }

  /// 2) Fetch Valid Coupons API...

  bool loadingValidCoupons = true;
  ValidCouponsModel? validCouponsModel;

  Future<ValidCouponsModel?> fetchValidCoupons({
    required BuildContext context,
    num? partnerId,
    bool isRefresh = true,
  }) async {
    ServiceType type = context.read<DashboardController>().serviceType;

    debugPrint("Producer Id is $partnerId ");
    refresh() {
      loadingValidCoupons = true;
      notifyListeners();
    }

    if (isRefresh == true) {
      refresh();
    }

    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    try {
      Map<String, String> body = {
        'type': type.value,
        'partner_id': "${partnerId ?? ""}",
        'subtotal_price': "${getSubTotal()}",
      };
      debugPrint("$body");
      var response = await ApiService().get(
        context: context,
        endPoint: "/fetch_valid_coupons${queryParameter(body: body)}",
        headers: defaultHeaders,
      );

      if (response != null) {
        Map<String, dynamic> json = response;

        ValidCouponsModel? validCouponsModelAPI = ValidCouponsModel.fromJson(json);
        if (validCouponsModelAPI.status == true) {
          validCouponsModel = validCouponsModelAPI;

          notifyListeners();
        }
      }
    } catch (e, s) {
      debugPrint("$e $s");
    } finally {
      loadingValidCoupons = false;
      notifyListeners();
    }
    return validCouponsModel;
  }

  /// 3) Clear Applied Coupon API...
  clearAppliedCoupon(BuildContext context) {
    debugPrint("Clearing AppliedCoupon...");
    appliedCoupon = null;
    appliedCouponData = null;
    couponDiscountPrice = null;
    lastCouponCode = null;
    paymentSummaryModel = null;
    notifyListeners();
  }

  /// 4) Apply Coupon API...

  AppliedCoupon? appliedCoupon;
  AppliedCouponData? appliedCouponData;
  dynamic couponDiscountPrice;
  String? lastCouponCode;

  Future<AppliedCoupon?> applyCoupon({
    required BuildContext context,
    num? couponId,
    required String? couponCode,
    num? creatorId,
    String? creatorType,
    bool isRefresh = true,
  }) async {
    ServiceType type = context.read<DashboardController>().serviceType;

    debugPrint("Coupon Code is $couponCode");

    refresh() {
      couponDiscountPrice = null;
      lastCouponCode = null;
    }

    if (isRefresh == true) {
      refresh();
    }

    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    bool partnerCoupon = creatorType == "Partner";

    try {
      Map<String, String> body = {
        'type': type.value,
        'coupon_id': "${couponId ?? ""}",
        'coupon_code': couponCode ?? "",
        'subtotal_price': "${getSubTotal(partnerId: partnerCoupon ? creatorId : null)}",
      };
      debugPrint("$body");
      var response = ApiService().post(
        context: context,
        endPoint: "/apply_coupon",
        body: body,
        headers: defaultHeaders,
      );

      loadingDialog(
        context: context,
        future: response,
      ).then(
        (response) {
          if (response != null) {
            Map<String, dynamic> json = response;
            AppliedCoupon? appliedCouponAPI = AppliedCoupon.fromJson(json);

            if (appliedCouponAPI.status == true) {
              appliedCoupon = appliedCouponAPI;
              lastCouponCode = couponCode;
              couponDiscountPrice = appliedCoupon?.data?.couponDiscountPrice;
              appliedCouponData = appliedCoupon?.data;
              notifyListeners();
              getPaymentSummary(context: context);
              Navigator.pop(context);
            } else {
              couponCode = null;
              showSnackBar(
                  context: context, text: appliedCoupon?.message ?? "Invalid Coupon Code", color: Colors.red);
            }
          }
        },
      );
    } catch (e, s) {
      debugPrint("$e $s");
    } finally {
      notifyListeners();
    }
    return appliedCoupon;
  }

  /// GaaS Coins

  num? appliedGaasCoin;

  applyGaasCoin(BuildContext context, num? coin) {
    if (coin != null) {
      appliedGaasCoin = coin;
      notifyListeners();
    }

    return loadingDialog(context: context, future: getPaymentSummary(context: context));
  }

  clearGaasCoin(BuildContext context) {
    debugPrint("Clearing GaasCoin...");
    appliedGaasCoin = null;
    notifyListeners();

    return loadingDialog(context: context, future: getPaymentSummary(context: context));
  }

  /// 4.5) Payment Summary Model API...
  bool calculatingPaymentSummary = false;
  PaymentSummaryModel? paymentSummaryModel;

  Future<PaymentSummaryModel?> getPaymentSummary({
    required BuildContext context,
  }) async {
    debugPrint("PaymentSummaryModel API Data...");
    ServiceType type = context.read<DashboardController>().serviceType;

    refresh() {
      calculatingPaymentSummary = true;
      paymentSummaryModel = null;
      notifyListeners();
    }

    refresh();
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    bool partnerCoupon = appliedCouponData?.creatorType == "Partner";

    try {
      Map<String, String> body = {
        'type': type.value,
        'coupon_id': "${appliedCouponData?.couponId ?? ""}",
        'coins': "${appliedGaasCoin ?? ""}",
        'subtotal_price': "${getSubTotal()}",
        'self_picking_charges': "${getSelfPickingCharges()}",
        'partner_subtotal_price':
            partnerCoupon ? "${getSubTotal(partnerId: appliedCouponData?.creatorId)}" : "0",
      };

      debugPrint("$body");

      await ApiService()
          .post(
        context: context,
        endPoint: "/calculate_total_amounts",
        body: body,
        headers: defaultHeaders,
      )
          .then(
        (response) {
          Map<String, dynamic> json = response;
          PaymentSummaryModel? responseBody = PaymentSummaryModel.fromJson(json);

          if (responseBody.status == true) {
            paymentSummaryModel = responseBody;

            notifyListeners();
          } else {
            showSnackBar(
                context: context,
                text: paymentSummaryModel?.message ?? "Something went wrong ",
                color: Colors.red);
          }

          calculatingPaymentSummary = false;
          return paymentSummaryModel;
        },
      );
    } catch (e, s) {
      debugPrint("$e $s");
    } finally {
      notifyListeners();
    }

    return paymentSummaryModel;
  }

  /// 5) Manage Cart Model API...

  ManageCartModel? manageCartModel;

  Future<ManageCartModel?> manageCartAPI({
    required BuildContext context,
    required ProducerDetailsData? producer,
    required ProducerProducts? product,
    bool? refreshPaymentSummary,
  }) async {
    debugPrint("Updating ManageCart API Data...");
    ServiceType type = context.read<DashboardController>().serviceType;

    refresh() {
      manageCartModel = null;
      notifyListeners();
    }

    refresh();
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    try {
      Map<String, dynamic> body = {
        "type": type.value,
        "partner_id": "${producer?.id ?? ""}",
        "order_type": producer?.orderType ?? "",
        "no_of_persons": "${producer?.noOfPersons ?? ""}",
        "product_id": "${product?.id ?? ""}",
        "quantity": "${product?.quantity ?? "1"}",
        "unit_mrp_price": product?.mrpPrice ?? "",
        "unit_regular_price": product?.price ?? "",
        "unit_id": "${product?.unitId ?? ""}",
      };

      debugPrint("$body");

      return ApiService()
          .post(
        context: context,
        endPoint: "/manage_cart",
        body: body,
        headers: defaultHeaders,
      )
          .then(
        (response) {
          Map<String, dynamic> json = response;
          ManageCartModel? responseBody = ManageCartModel.fromJson(json);
          manageCartModel = responseBody;
          notifyListeners();

          if (responseBody.status == true) {
            if (refreshPaymentSummary = true) {
              getPaymentSummary(context: context);
            }
          } else {
            showSnackBar(
                context: context,
                text: manageCartModel?.message ?? "Something went wrong ",
                color: Colors.red);
          }

          return responseBody;
        },
      );
    } catch (e, s) {
      debugPrint("$e $s");
    } finally {
      notifyListeners();
    }
    return manageCartModel;
  }

  /// 6) fetch Cart Items API...

  bool loadingCartItems = true;
  CartItemsModel? cartItemsModel;
  List<CartItemsData>? cartItemsData;

  Future<List<CartItemsData>?> fetchCartItems({required BuildContext context}) async {
    ServiceType type = context.read<DashboardController>().serviceType;
    refresh() {
      loadingCartItems = true;
      cartItemsModel = null;
      cartItemsData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingCartItems = false;
      notifyListeners();
    }

    refresh();

    Map<String, String> body = {
      "type": type.value,
    };

    debugPrint("Sent Data is $body");
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_cart_items${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        CartItemsModel responseData = CartItemsModel.fromJson(json);

        if (responseData.status == true) {
          cartItemsModel = responseData;
          cartItemsData = responseData.data;
          notifyListeners();
          setCartItemsFromServer(cartItemsData);
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return cartItemsData;
  }

  /// 7) fetch Cart Items API...

  bool loadingDeliveryZones = true;
  DeliveryZonesModel? deliveryZonesModel;
  List<DeliveryZonesData>? deliveryZonesData;

  Future<List<DeliveryZonesData>?> fetchDeliveryZones({
    required BuildContext context,
    required num? partnerId,
  }) async {
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

    ServiceType type = context.read<DashboardController>().serviceType;
    refresh();
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": type.value,
      "partner_id": "$partnerId",
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_delivery_zones${queryParameter(body: body)}",
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

  /// 7) fetch validate Delivery Zone API...

  bool isValidDeliveryZone = false;

  Future<bool> validateDeliveryZone({
    required BuildContext context,
    required num? partnerId,
    required double? latitude,
    required double? longitude,
  }) async {
    isValidDeliveryZone = false;
    notifyListeners();
    apiResponseCompleted() {
      notifyListeners();
    }

    ServiceType type = context.read<DashboardController>().serviceType;
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": type.value,
      "partner_id": "$partnerId",
      "latitude": "$latitude",
      "longitude": "$longitude",
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/validate_delivery_zone${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        DeliveryZonesModel responseData = DeliveryZonesModel.fromJson(json);

        if (responseData.status == true) {
          isValidDeliveryZone = responseData.status ?? false;
          notifyListeners();
        } else {
          showSnackBar(context: context, text: responseData.message ?? "Invalid Delivery Zone");
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return isValidDeliveryZone;
  }

  /// 7.0) place Order Process...
  String getProducerIds() {
    List<num?> producerIdsList = [];
    if (_cartItems != null) {
      _cartItems?.forEach((producer) {
        producerIdsList.add(producer?.id);
      });
    }

    String producerIds = producerIdsList.isNotEmpty ? producerIdsList.join(",") : "";
    return producerIds;
  }

  PaymentModes? getOtherPaymentMode() {
    List<String?> selectedOrderMethods = [];
    PaymentModes? paymentMode;
    if (_cartItems != null) {
      _cartItems?.forEach((producer) {
        selectedOrderMethods.add(producer?.selectedOrderMethod);
      });
    }

    bool selfPickingMode = selectedOrderMethods.every((element) => element == OrderTypes.uPick.value);
    bool readyToPickMode = selectedOrderMethods.every((element) => element == OrderTypes.readyToPick.value);
    bool deliveryMode = selectedOrderMethods.every((element) => element == OrderTypes.delivery.value);
    if (selfPickingMode) {
      paymentMode = PaymentModes.payReservation;
    } else if (readyToPickMode) {
      paymentMode = PaymentModes.payAtPickup;
    } else if (deliveryMode) {
      // paymentMode = PaymentModes.payAtPickup;
    }

    return paymentMode;
  }

  PaymentModes? paymentMode = PaymentModes.payNow;

  setPaymentMode({required PaymentModes? paymentMode}) {
    this.paymentMode = paymentMode;
    notifyListeners();
  }

  List<PaymentModes>? paymentModes() {
    PaymentModes? otherPaymentMode = getOtherPaymentMode();

    List<PaymentModes>? paymentModes = [
      PaymentModes.payNow,
      if (otherPaymentMode != null) otherPaymentMode,
    ];

    return paymentModes;
  }

  /// 7.1) place Order Process...
  List<Map<String, String>> getOrderPartners() {
    List<Map<String, String>> orderPartners = [];
    if (_cartItems != null) {
      _cartItems?.forEach((producer) {
        num actualAmount = 0;
        num subTotal = 0;

        for (ProducerProducts? product in producer?.products ?? []) {
          num price = num.parse("${product?.price ?? 0}");
          num mrpPrice = num.parse("${product?.mrpPrice ?? 0}");
          num quantity = num.parse("${product?.quantity ?? 0}");
          subTotal = subTotal + (price * quantity);
          actualAmount = actualAmount + (mrpPrice * quantity);
          debugPrint("mrpPrice $mrpPrice");
        }

        orderPartners.add(
          {
            "partner_id": "${producer?.id ?? ""}",
            "order_type": producer?.selectedOrderMethod ?? "",
            "timeslot_id": "${producer?.selectedTimeSlot?.id ?? ""}",
            "delivery_zone_id": "${producer?.selectedDeliveryZone?.id ?? ""}",
            "actual_amount": "$actualAmount",
            "subtotal": "$subTotal",
            "latitude": producer?.latitude ?? "",
            "longitude": producer?.longitude ?? "",
            "delivery_latitude": producer?.deliveryLatitude ?? "",
            "delivery_longitude": producer?.deliveryLongitude ?? "",
            "delivery_address": producer?.deliveryAddress ?? "",
            "address": producer?.address ?? "",
            "address_id": "${producer?.homeAddress?.id ?? ""}",
            "delivery_address_id": "${producer?.deliveryAddressOrder?.id ?? ""}",
            "is_same_address": producer?.isSameAddress == true ? "Yes" : "No",
            "billing_address_id": "${producer?.billingAddress?.id ?? ""}",
            "no_of_persons": "${producer?.noOfPersons ?? "1"}",
          },
        );
      });
    }

    return orderPartners;
  }

  /// 7.2) place Order Process...
  List<Map<String, String>> getOrderProducts() {
    List<Map<String, String>> orderProducts = [];
    if (_cartItems != null) {
      _cartItems?.forEach((producer) {
        for (ProducerProducts? product in producer?.products ?? []) {
          orderProducts.add({
            "partner_id": "${producer?.id ?? ""}",
            "product_id": "${product?.id ?? ""}",
            "city_id": "${producer?.cityId ?? ""}",
            "quantity": "${product?.quantity ?? ""}",
            "mrp_amount": product?.mrpPrice ?? "",
            "regular_amount": product?.price ?? "",
            "remarks": ""
          });
        }
      });
    }

    return orderProducts;
  }

  /// 7.3) Place Order Model API...

  PlaceOrderData? placeOrderData;

  Future<PlaceOrderData?> placeOrder({
    required BuildContext context,
    String? paymentOrderId,
  }) async {
    debugPrint("Updating ManageCart API Data...");
    debugPrint(" paymentOrderId $paymentOrderId...");
    ServiceType type = context.read<DashboardController>().serviceType;

    refresh() {
      manageCartModel = null;
      notifyListeners();
    }

    PaymentSummaryData? paymentSummary = paymentSummaryModel?.data;

    refresh();
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    try {
      Map<String, dynamic> body = {
        "type": type.value,
        "partner_ids": getProducerIds(),
        "payment_order_id": paymentOrderId ?? "",
        "coupon_applied": appliedCouponData?.couponId != null ? "Yes" : "No",
        "coupon_id": "${appliedCouponData?.couponId ?? ""}",
        "coupon_price": "${paymentSummary?.couponPrice ?? ""}",
        "coins_applied": appliedGaasCoin != null ? "Yes" : "No",
        "coins": "${paymentSummary?.coins ?? ""}",
        "coins_amount": "${paymentSummary?.totalCoinAmount ?? ""}",
        "total_actual_subtotal": "${paymentSummary?.subtotal ?? ""}",
        "self_picking_charges": "${getSelfPickingCharges()}",
        "subtotal": "${paymentSummary?.subtotal ?? ""}",
        "grand_total": "${(paymentSummary?.grandTotal ?? 0)}",
        "remarks": "",
        "won_coins": "${paymentSummary?.wonCoins ?? ""}",
        "tax_amount": "${paymentSummary?.taxAmount ?? ""}",
        "payment_type": paymentMode?.id ?? PaymentModes.payNow.id,
        "order_partners": jsonEncode(getOrderPartners()),
        "order_products": jsonEncode(getOrderProducts())
      };
      debugPrint("$body");

      loadingDialog(
        context: context,
        future: ApiService().post(
          context: context,
          endPoint: "/place_order",
          body: body,
          headers: defaultHeaders,
        ),
      ).then(
        (response) async {
          Map<String, dynamic> json = response;
          PlaceOrderModel? responseBody = PlaceOrderModel.fromJson(json);

          if (responseBody.status == true) {
            placeOrderData = responseBody.data;
            await clearCart(context);
            notifyListeners();
            if (context.mounted) {
              context.push(Routs.orderStatus, extra: OrderStatus(placeOrderData: placeOrderData));
            }
          } else {
            showBanner(text: responseBody.message ?? "Something went wrong ", color: Colors.red);
          }
        },
      );
    } catch (e, s) {
      debugPrint("$e $s");
    } finally {
      notifyListeners();
    }
    return placeOrderData;
  }

  /// 8) Fetch OrdersModel API...

  bool loadingOrders = true;

  OrdersModel? _ordersModel;

  OrdersModel? get ordersModel => _ordersModel;
  List<OrdersData>? _ordersData;

  List<OrdersData>? get ordersData => _ordersData;
  num ordersIndex = 1;
  num ordersTotal = 1;

  Future<List<OrdersData>?> fetchPartnerOrders({
    required BuildContext context,
    required AllServiceType serviceType,
    required String search,
    bool isRefresh = false,
    bool loadingNext = false,
    required RefreshController controller,
  }) async {
    debugPrint("Fetching ${_ordersData.runtimeType}...");

    refresh() {
      ordersIndex = 1;
      ordersTotal = 1;
      loadingOrders = true;

      controller.resetNoData();
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
        controller.loadFailed();
      } else {
        controller.refreshFailed();
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
        "type": serviceType.value,
      };

      Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
      try {
        var response = await ApiService().get(
          context: context,
          endPoint: "/fetch_user_orders${queryParameter(body: body)}",
          headers: defaultHeaders,
        );

        if (response != null) {
          Map<String, dynamic> json = response;

          OrdersModel? responseData = OrdersModel.fromJson(json);
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
              controller.loadComplete();
            } else {
              controller.refreshCompleted();
            }

            if (ordersTotal <= ordersIndex) {
              controller.loadComplete();
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
      controller.loadNoData();
      apiResponseCompleted();
      debugPrint("Load no More data ");
    }
    notifyListeners();
    return _ordersData;
  }

  /// 9) fetch Cart Items API...

  bool loadingOrderDetail = true;
  OrderDetailModel? orderDetailModel;
  OrderDetailData? orderDetailData;

  Future<OrderDetailData?> fetchOrderDetail({
    required BuildContext context,
    required num? orderId,
    required num? partnerId,
  }) async {
    ServiceType type = context.read<DashboardController>().serviceType;
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
      endPoint: "/fetch_order_detail${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        OrderDetailModel responseData = OrderDetailModel.fromJson(json);

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

  /// 10)submit_review API...
  Future<DefaultModel?> submitReview({
    required BuildContext context,
    required bool leadsReview,
    required num? id,
    required num? partnerId,
    required double? rating,
    required String? review,
    required GestureTapCallback? onSuccess,
  }) async {
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      leadsReview ? "lead_id" : "order_id": "${id ?? " "}",
      "partner_id": "${partnerId ?? ""}",
      "rating": "${rating ?? ""}",
      "review": review ?? "",
    };

    debugPrint("Sent Data is $body");

    var response = ApiService().post(
      context: context,
      endPoint: leadsReview ? "/submit_service_provider_review" : "/submit_review",
      body: body,
      headers: headers,
    );

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

          showSnackBar(context: context, text: responseData.message ?? "Review Added");
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
      return responseData;
    });
  }

  /// 10)submit_review API...

  Future<DefaultModel?> updateReview({
    required BuildContext context,
    required num? reviewId,
    required double? rating,
    required String? review,
    required GestureTapCallback? onSuccess,
  }) async {
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "id": "${reviewId ?? ""}",
      "rating": "${rating ?? ""}",
      "review": review ?? "",
    };

    debugPrint("Sent Data is $body");

    var response = ApiService().post(
      context: context,
      endPoint: "/update_review",
      body: body,
      headers: headers,
    );

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
          showSnackBar(context: context, text: responseData.message ?? "Review Added");
        } else {
          showSnackBar(
              context: context, text: responseData.message ?? "Something went wong", color: Colors.red);
        }
      }
      return responseData;
    });
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

    Map<String, String> body = {
      "partner_id": "${partnerId ?? ""}",
      "order_id": "${orderId ?? ""}",
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_users_suggested_timeslots${queryParameter(body: body)}",
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

  Future confirmTimesSlot({
    required BuildContext context,
    required num? partnerId,
    required num? orderId,
    required String? comment,
    required String? date,
    required num? partnerSlotId,
    GestureTapCallback? refreshOrders,
  }) async {
    apiResponseCompleted() {
      notifyListeners();
    }

    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    Map<String, String> body = {
      "partner_id": "${partnerId ?? ""}",
      "order_id": "${orderId ?? ""}",
      "date": date ?? "",
      "comment": comment ?? "",
      "partner_slot_id": "${partnerSlotId ?? ""}",
    };

    debugPrint("Sent Data is $body");

//Processing API...

    loadingDialog(
      context: context,
      future: ApiService().post(
        context: context,
        endPoint: "/update_timeslot",
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
          refreshOrders?.call();
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

  /// 8) fetch FreshProduce UnReviewed Orders API...

  bool loadingFreshProduceUnReviewedOrders = true;
  UnReviewedOrders? freshProduceUnReviewedOrdersModel;
  List<OrdersData>? freshProduceUnReviewedOrders;

  clearFreshProduceUnReviewedOrders({int? index}) {
    if (index != null) {
      freshProduceUnReviewedOrders?.removeAt(index);
    } else {
      freshProduceUnReviewedOrders = null;
    }
    notifyListeners();
  }

  Future<List<OrdersData>?> fetchFreshProduceUnReviewedOrders({
    required BuildContext context,
  }) async {
    refresh() {
      loadingFreshProduceUnReviewedOrders = true;
      freshProduceUnReviewedOrdersModel = null;
      freshProduceUnReviewedOrders = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingFreshProduceUnReviewedOrders = false;
      notifyListeners();
    }

    refresh();
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    Map<String, String> body = {
      "type": ServiceType.freshProduce.value,
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
          freshProduceUnReviewedOrdersModel = responseData;
          freshProduceUnReviewedOrders = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return freshProduceUnReviewedOrders;
  }

  /// 9) fetch Nursery UnReviewed Orders API...

  bool loadingNurseryUnReviewedOrders = true;
  UnReviewedOrders? nurseryUnReviewedOrdersModel;
  List<OrdersData>? nurseryUnReviewedOrders;

  clearNurseryUnReviewedOrders({int? index}) {
    if (index != null) {
      nurseryUnReviewedOrders?.removeAt(index);
    } else {
      nurseryUnReviewedOrders = null;
    }
    notifyListeners();
  }

  Future<List<OrdersData>?> fetchNurseryUnReviewedOrders({required BuildContext context}) async {
    refresh() {
      loadingNurseryUnReviewedOrders = true;
      nurseryUnReviewedOrdersModel = null;
      nurseryUnReviewedOrders = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingNurseryUnReviewedOrders = false;
      notifyListeners();
    }

    refresh();
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    Map<String, String> body = {
      "type": ServiceType.nursery.value,
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
          nurseryUnReviewedOrdersModel = responseData;
          nurseryUnReviewedOrders = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return nurseryUnReviewedOrders;
  }

  /// 10) fetch PartnerService API...

  bool loadingPartnerService = true;
  PartnerServiceModel? partnerServiceModel;
  List<PartnerServicesData>? partnerServiceData;

  Future<List<PartnerServicesData>?> fetchCartTimeslots({
    required BuildContext context,
    required num? partnerId,
    required String? orderType,
    required String? date,
  }) async {
    refresh() {
      loadingPartnerService = true;
      partnerServiceModel = null;
      partnerServiceData = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingPartnerService = false;
      notifyListeners();
    }

    ServiceType type = context.read<DashboardController>().serviceType;
    refresh();
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": type.value,
      "partner_id": "$partnerId",
      "order_type": orderType ?? "",
      "date": date ?? "",
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_cart_timeslots${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        PartnerServiceModel responseData = PartnerServiceModel.fromJson(json);

        if (responseData.status == true) {
          partnerServiceModel = responseData;
          partnerServiceData = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return partnerServiceData;
  }

  /// 10) fetch PartnerService API...

  bool loadingPartnerTimeSlotDates = true;
  PartnerTimeSlotDatesModel? partnerTimeSlotDatesModel;
  List<PartnerTimeSlotDates>? partnerTimeSlotDates;

  Future<List<PartnerTimeSlotDates>?> fetchCartTimeslotDates({
    required BuildContext context,
    required num? partnerId,
    required String? orderType,
    required String? date,
  }) async {
    refresh() {
      loadingPartnerTimeSlotDates = true;
      partnerTimeSlotDatesModel = null;
      partnerTimeSlotDates = null;
      notifyListeners();
    }

    apiResponseCompleted() {
      loadingPartnerTimeSlotDates = false;
      notifyListeners();
    }

    ServiceType type = context.read<DashboardController>().serviceType;
    refresh();
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": type.value,
      "partner_id": "$partnerId",
      "order_type": orderType ?? "",
      "date": date ?? "",
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_cart_timeslot_dates${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        PartnerTimeSlotDatesModel responseData = PartnerTimeSlotDatesModel.fromJson(json);

        if (responseData.status == true) {
          partnerTimeSlotDatesModel = responseData;
          partnerTimeSlotDates = responseData.data;
          notifyListeners();
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return partnerTimeSlotDates;
  }

  /// 11) Manage Address Model API...

  Future manageAddressApi({
    required BuildContext context,
    num? id,
    required String? name,
    required String? addressType,
    required String? houseAddress,
    required String? locality,
    required String? landmark,
    required Address? address,
    required bool? isDefault,
  }) async {
    debugPrint("Manage Address API Data...");
    ServiceType type = context.read<DashboardController>().serviceType;

    refresh() {
      manageCartModel = null;
      notifyListeners();
    }

    refresh();
    Map<String, String> defaultHeaders = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};

    try {
      Map<String, dynamic> body = {
        "type": type.value,
        if (id != null) "id": "$id",
        "name": name ?? "",
        "address_type": addressType ?? "",
        "house_address": houseAddress ?? "",
        "locality": locality ?? "",
        "landmark": landmark ?? "",
        "loc_latitude": "${address?.coordinates?.latitude ?? ""}",
        "loc_longitude": "${address?.coordinates?.longitude ?? ""}",
        "loc_address": address?.addressLine ?? "",
        "is_default": isDefault == true ? 'Yes' : 'No',
      };
      debugPrint("$body");

      return loadingDialog(
        context: context,
        future: ApiService().post(
          context: context,
          endPoint: id != null ? "update_address" : "/add_address",
          body: body,
          headers: defaultHeaders,
        ),
      ).then(
        (response) {
          Map<String, dynamic> json = response;
          DefaultModel? responseBody = DefaultModel.fromJson(json);

          if (responseBody.status == true) {
            notifyListeners();
            context.pop();
            context.pop();
            fetchOrderAddress(context: context);
            showSnackBar(
              context: context,
              text: manageCartModel?.message ?? "Address added Successfully...",
            );
          } else {
            showBanner(text: manageCartModel?.message ?? "Something went wrong ", color: Colors.red);
          }

          return responseBody;
        },
      );
    } catch (e, s) {
      debugPrint("$e $s");
    } finally {
      notifyListeners();
    }
    return manageCartModel;
  }

  setDefaultOrderAddress({List<OrderAddress>? orderAddresses}) {
    if (orderAddresses.haveData) {
      OrderAddress? address = orderAddresses?.first;
      for (ProducerDetailsData? producer in _cartItems ?? []) {
        debugPrint("setDefaultOrderAddress");

        producer?.deliveryAddressOrder ??= address;
        producer?.billingAddress ??= address;
        notifyListeners();
      }
      notifyListeners();
    }
  }

  /// 10) fetch PartnerService API...

  bool loadingOrderAddress = true;
  OrderAddressesModel? orderAddressesModel;
  List<OrderAddress>? orderAddresses;

  OrderAddress? firstOrderAddress() {
    if (orderAddresses.haveData) {
      return orderAddresses?.first;
    }
    return null;
  }

  Future<List<OrderAddress>?> fetchOrderAddress({required BuildContext context}) async {
    refresh() {
      loadingOrderAddress = true;
      orderAddressesModel = null;
      orderAddresses = null;

      notifyListeners();
    }

    apiResponseCompleted() {
      loadingOrderAddress = false;
      notifyListeners();
    }

    ServiceType type = context.read<DashboardController>().serviceType;
    refresh();
    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    Map<String, String> body = {
      "type": type.value,
    };

    debugPrint("Sent Data is $body");

//Processing API...
    await ApiService()
        .get(
      context: context,
      endPoint: "/fetch_addresses${queryParameter(body: body)}",
      headers: headers,
    )
        .then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        OrderAddressesModel responseData = OrderAddressesModel.fromJson(json);

        if (responseData.status == true) {
          orderAddressesModel = responseData;
          orderAddresses = responseData.data;
          notifyListeners();
          debugPrint("cartItems.haveData ${cartItems.haveData}");

          if (cartItems.haveData) {
            for (int index = 0; index < (cartItems?.length ?? 0); index++) {
              cartItems?[index]?.homeAddress ??= firstOrderAddress();
              cartItems?[index]?.billingAddress ??= firstOrderAddress();
              cartItems?[index]?.deliveryAddressOrder ??= firstOrderAddress();

              debugPrint("Setting Order Address ${firstOrderAddress()?.locAddress}");
              notifyListeners();
            }
          }
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return orderAddresses;
  }

  /// 9) fetch Cart Items API...

  Future<DownloadInvoiceModel?> downloadOrderInvoice(
      {required BuildContext context, required num? orderId}) async {
    apiResponseCompleted() {
      loadingOrderDetail = false;
      notifyListeners();
    }

    Map<String, String> headers = {"Authorization": "Bearer ${LocalDatabase().accessToken}"};
    DownloadInvoiceModel? responseData;
//Processing API...

    await loadingDialog(
      context: context,
      future: ApiService().get(
        context: context,
        endPoint: "/download_order_invoice/$orderId",
        headers: headers,
      ),
    ).then((response) {
      if (response != null) {
        Map<String, dynamic> json = response;
        responseData = DownloadInvoiceModel.fromJson(json);
        notifyListeners();
        if (responseData?.status == true) {
          if (responseData?.data?.link != null) {
            launchUrlString("${responseData?.data?.link}");
          }
        } else {
          showSnackBar(
              context: context, text: responseData?.message ?? "Failed to download", color: Colors.red);
        }
      }

      apiResponseCompleted();
    }).catchError((e, s) {
      apiResponseCompleted();
      debugPrint("Error is $e & $s");
    });

    return responseData;
  }
}
