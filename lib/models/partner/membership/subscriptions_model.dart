import 'dart:convert';

SubscriptionsModel subscriptionsModelFromJson(String str) => SubscriptionsModel.fromJson(json.decode(str));

String subscriptionsModelToJson(SubscriptionsModel data) => json.encode(data.toJson());

class SubscriptionsModel {
  SubscriptionsModel({
    this.status,
    this.message,
    this.isCouponApplied,
    this.data,
  });

  SubscriptionsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    isCouponApplied = json['is_coupon_applied'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(SubscriptionsData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  bool? isCouponApplied;
  List<SubscriptionsData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['is_coupon_applied'] = isCouponApplied;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

SubscriptionsData dataFromJson(String str) => SubscriptionsData.fromJson(json.decode(str));

String dataToJson(SubscriptionsData data) => json.encode(data.toJson());

class SubscriptionsData {
  SubscriptionsData({
    this.id,
    this.type,
    this.title,
    this.description,
    this.amount,
    this.oldAmount,
    this.days,
    this.couponId,
  });

  SubscriptionsData.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    description = json['description'];
    amount = json['amount'];
    oldAmount = json['old_amount'];
    days = json['days'];
    couponId = json['coupon_id'];
  }

  num? id;
  String? type;
  String? title;
  String? description;
  String? amount;
  String? oldAmount;
  num? days;
  num? couponId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['title'] = title;
    map['description'] = description;
    map['amount'] = amount;
    map['old_amount'] = oldAmount;
    map['days'] = days;
    map['coupon_id'] = couponId;
    return map;
  }
}
