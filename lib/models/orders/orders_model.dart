import 'dart:convert';

import 'order_detail_model.dart';

OrdersModel ordersModelFromJson(String str) => OrdersModel.fromJson(json.decode(str));

String ordersModelToJson(OrdersModel data) => json.encode(data.toJson());

class OrdersModel {
  OrdersModel({
    this.status,
    this.message,
    this.totalPage,
    this.data,
  });

  OrdersModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(OrdersData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  num? totalPage;
  List<OrdersData>? data;

  OrdersModel copyWith({
    bool? status,
    String? message,
    num? totalPage,
    List<OrdersData>? data,
  }) =>
      OrdersModel(
        status: status ?? this.status,
        message: message ?? this.message,
        totalPage: totalPage ?? this.totalPage,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['total_page'] = totalPage;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

OrdersData dataFromJson(String str) => OrdersData.fromJson(json.decode(str));

String dataToJson(OrdersData data) => json.encode(data.toJson());

class OrdersData {
  OrdersData({
    this.id,
    this.orderId,
    this.partnerId,
    this.userId,
    this.orderNumber,
    this.actualAmount,
    this.subtotal,
    this.taxAmount,
    this.totalAmount,
    this.orderStatus,
    this.createdAt,
    this.userLatitude,
    this.userLongitude,
    this.partnerName,
    this.path,
    this.profilePhoto,
    this.type,
    this.timeslotId,
    this.timeslotDay,
    this.fromTime,
    this.toTime,
    this.timeslotName,
    this.datetime,
    this.products,
    this.reviewAdded,
    this.ratings,
    this.reviewDetail,
    this.distanceNumber,
    this.distance,
    this.distanceLabel,
  });

  OrdersData.fromJson(dynamic json) {
    id = json['id'];
    orderId = json['order_id'];
    partnerId = json['partner_id'];
    userId = json['user_id'];
    orderNumber = json['order_number'];
    actualAmount = json['actual_amount'];
    subtotal = json['subtotal'];
    taxAmount = json['tax_amount'];
    totalAmount = json['total_amount'];
    orderStatus = json['order_status'];
    createdAt = json['created_at'];
    userLatitude = json['user_latitude'];
    userLongitude = json['user_longitude'];
    partnerName = json['partner_name'];
    path = json['path'];
    profilePhoto = json['profile_photo'];
    type = json['type'];
    timeslotId = json['timeslot_id'];
    timeslotDay = json['timeslot_day'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    timeslotName = json['timeslot_name'];
    datetime = json['datetime'];
    products = json['products'];
    reviewAdded = json['review_added'];
    ratings = json['ratings'];
    reviewDetail = json['review_detail'] != null ? ReviewDetail.fromJson(json['review_detail']) : null;
    distanceNumber = json['distance_number'];
    distance = json['distance'];
    distanceLabel = json['distance_label'];
  }

  num? id;
  num? orderId;
  num? partnerId;
  num? userId;
  String? orderNumber;
  num? actualAmount;
  num? subtotal;
  num? taxAmount;
  num? totalAmount;
  String? orderStatus;
  String? createdAt;
  String? userLatitude;
  String? userLongitude;
  String? partnerName;
  String? path;
  String? profilePhoto;
  String? type;
  num? timeslotId;
  String? timeslotDay;
  String? fromTime;
  String? toTime;
  String? timeslotName;
  String? datetime;
  num? products;
  bool? reviewAdded;
  num? ratings;
  ReviewDetail? reviewDetail;
  num? distanceNumber;
  num? distance;
  String? distanceLabel;

  OrdersData copyWith({
    num? id,
    num? orderId,
    num? partnerId,
    num? userId,
    String? orderNumber,
    num? actualAmount,
    num? subtotal,
    num? taxAmount,
    num? totalAmount,
    String? orderStatus,
    String? createdAt,
    String? userLatitude,
    String? userLongitude,
    String? partnerName,
    String? path,
    String? profilePhoto,
    String? type,
    num? timeslotId,
    String? timeslotDay,
    String? fromTime,
    String? toTime,
    String? timeslotName,
    String? datetime,
    num? products,
    bool? reviewAdded,
    num? ratings,
    ReviewDetail? reviewDetail,
    num? distanceNumber,
    num? distance,
    String? distanceLabel,
  }) =>
      OrdersData(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        partnerId: partnerId ?? this.partnerId,
        userId: userId ?? this.userId,
        orderNumber: orderNumber ?? this.orderNumber,
        actualAmount: actualAmount ?? this.actualAmount,
        subtotal: subtotal ?? this.subtotal,
        taxAmount: taxAmount ?? this.taxAmount,
        totalAmount: totalAmount ?? this.totalAmount,
        orderStatus: orderStatus ?? this.orderStatus,
        createdAt: createdAt ?? this.createdAt,
        userLatitude: userLatitude ?? this.userLatitude,
        userLongitude: userLongitude ?? this.userLongitude,
        partnerName: partnerName ?? this.partnerName,
        path: path ?? this.path,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        type: type ?? this.type,
        timeslotId: timeslotId ?? this.timeslotId,
        timeslotDay: timeslotDay ?? this.timeslotDay,
        fromTime: fromTime ?? this.fromTime,
        toTime: toTime ?? this.toTime,
        timeslotName: timeslotName ?? this.timeslotName,
        datetime: datetime ?? this.datetime,
        products: products ?? this.products,
        reviewAdded: reviewAdded ?? this.reviewAdded,
        ratings: ratings ?? this.ratings,
        reviewDetail: reviewDetail ?? this.reviewDetail,
        distanceNumber: distanceNumber ?? this.distanceNumber,
        distance: distance ?? this.distance,
        distanceLabel: distanceLabel ?? this.distanceLabel,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['order_id'] = orderId;
    map['partner_id'] = partnerId;
    map['user_id'] = userId;
    map['order_number'] = orderNumber;
    map['actual_amount'] = actualAmount;
    map['subtotal'] = subtotal;
    map['tax_amount'] = taxAmount;
    map['total_amount'] = totalAmount;
    map['order_status'] = orderStatus;
    map['created_at'] = createdAt;
    map['user_latitude'] = userLatitude;
    map['user_longitude'] = userLongitude;
    map['partner_name'] = partnerName;
    map['path'] = path;
    map['profile_photo'] = profilePhoto;
    map['type'] = type;
    map['timeslot_id'] = timeslotId;
    map['timeslot_day'] = timeslotDay;
    map['from_time'] = fromTime;
    map['to_time'] = toTime;
    map['timeslot_name'] = timeslotName;
    map['datetime'] = datetime;
    map['products'] = products;
    map['review_added'] = reviewAdded;
    map['ratings'] = ratings;
    if (reviewDetail != null) {
      map['review_detail'] = reviewDetail?.toJson();
    }
    map['distance_number'] = distanceNumber;
    map['distance'] = distance;
    map['distance_label'] = distanceLabel;
    return map;
  }
}
