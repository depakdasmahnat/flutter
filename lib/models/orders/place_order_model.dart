import 'dart:convert';

PlaceOrderModel placeOrderModelFromJson(String str) => PlaceOrderModel.fromJson(json.decode(str));

String placeOrderModelToJson(PlaceOrderModel data) => json.encode(data.toJson());

class PlaceOrderModel {
  PlaceOrderModel({
    this.status,
    this.message,
    this.data,
  });

  PlaceOrderModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PlaceOrderData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  PlaceOrderData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

PlaceOrderData dataFromJson(String str) => PlaceOrderData.fromJson(json.decode(str));

String dataToJson(PlaceOrderData data) => json.encode(data.toJson());

class PlaceOrderData {
  PlaceOrderData({
    this.orderId,
    this.orderNumber,
    this.walletBalance,
  });

  PlaceOrderData.fromJson(dynamic json) {
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    walletBalance = json['wallet_balance'];
  }

  num? orderId;
  String? orderNumber;
  num? walletBalance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = orderId;
    map['order_number'] = orderNumber;
    map['wallet_balance'] = walletBalance;
    return map;
  }
}
