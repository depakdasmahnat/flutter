import 'dart:convert';

import 'package:gaas/models/orders/orders_model.dart';

UnReviewedOrders unReviewedOrdersFromJson(String str) => UnReviewedOrders.fromJson(json.decode(str));

String unReviewedOrdersToJson(UnReviewedOrders data) => json.encode(data.toJson());

class UnReviewedOrders {
  UnReviewedOrders({
    this.status,
    this.message,
    this.data,
  });

  UnReviewedOrders.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(OrdersData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<OrdersData>? data;

  UnReviewedOrders copyWith({
    bool? status,
    String? message,
    List<OrdersData>? data,
  }) =>
      UnReviewedOrders(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
