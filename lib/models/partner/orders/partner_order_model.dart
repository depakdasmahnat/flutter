import 'dart:convert';

PartnerOrderModel partnerOrderModelFromJson(String str) => PartnerOrderModel.fromJson(json.decode(str));

String partnerOrderModelToJson(PartnerOrderModel data) => json.encode(data.toJson());

class PartnerOrderModel {
  PartnerOrderModel({
    this.status,
    this.message,
    this.totalPage,
    this.counts,
    this.data,
  });

  PartnerOrderModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    totalPage = json['total_page'];
    counts = json['counts'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PartnerOrderData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  num? totalPage;
  num? counts;
  List<PartnerOrderData>? data;

  PartnerOrderModel copyWith({
    bool? status,
    String? message,
    num? totalPage,
    num? counts,
    List<PartnerOrderData>? data,
  }) =>
      PartnerOrderModel(
        status: status ?? this.status,
        message: message ?? this.message,
        totalPage: totalPage ?? this.totalPage,
        counts: counts ?? this.counts,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['total_page'] = totalPage;
    map['counts'] = counts;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

PartnerOrderData dataFromJson(String str) => PartnerOrderData.fromJson(json.decode(str));

String dataToJson(PartnerOrderData data) => json.encode(data.toJson());

class PartnerOrderData {
  PartnerOrderData({
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
    this.userName,
    this.path,
    this.profilePhoto,
    this.timeslotId,
    this.timeslotDay,
    this.fromTime,
    this.toTime,
    this.timeslotName,
    this.datetime,
    this.products,
    this.reviewAdded,
    this.ratings,
    this.partnerReviews,
    this.distanceNumber,
    this.distance,
    this.distanceLabel,
  });

  PartnerOrderData.fromJson(dynamic json) {
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
    userName = json['user_name'];
    path = json['path'];
    profilePhoto = json['profile_photo'];
    timeslotId = json['timeslot_id'];
    timeslotDay = json['timeslot_day'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    timeslotName = json['timeslot_name'];
    datetime = json['datetime'];
    products = json['products'];
    reviewAdded = json['review_added'];
    ratings = json['ratings'];
    partnerReviews = json['partner_reviews'];
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
  String? userName;
  dynamic path;
  dynamic profilePhoto;
  num? timeslotId;
  String? timeslotDay;
  String? fromTime;
  String? toTime;
  String? timeslotName;
  String? datetime;
  num? products;
  bool? reviewAdded;
  num? ratings;
  String? partnerReviews;
  num? distanceNumber;
  num? distance;
  String? distanceLabel;

  PartnerOrderData copyWith({
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
    String? userName,
    dynamic path,
    dynamic profilePhoto,
    num? timeslotId,
    String? timeslotDay,
    String? fromTime,
    String? toTime,
    String? timeslotName,
    String? datetime,
    num? products,
    bool? reviewAdded,
    num? ratings,
    String? partnerReviews,
    num? distanceNumber,
    num? distance,
    String? distanceLabel,
  }) =>
      PartnerOrderData(
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
        userName: userName ?? this.userName,
        path: path ?? this.path,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        timeslotId: timeslotId ?? this.timeslotId,
        timeslotDay: timeslotDay ?? this.timeslotDay,
        fromTime: fromTime ?? this.fromTime,
        toTime: toTime ?? this.toTime,
        timeslotName: timeslotName ?? this.timeslotName,
        datetime: datetime ?? this.datetime,
        products: products ?? this.products,
        reviewAdded: reviewAdded ?? this.reviewAdded,
        ratings: ratings ?? this.ratings,
        partnerReviews: partnerReviews ?? this.partnerReviews,
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
    map['user_name'] = userName;
    map['path'] = path;
    map['profile_photo'] = profilePhoto;
    map['timeslot_id'] = timeslotId;
    map['timeslot_day'] = timeslotDay;
    map['from_time'] = fromTime;
    map['to_time'] = toTime;
    map['timeslot_name'] = timeslotName;
    map['datetime'] = datetime;
    map['products'] = products;
    map['review_added'] = reviewAdded;
    map['ratings'] = ratings;
    map['partner_reviews'] = partnerReviews;
    map['distance_number'] = distanceNumber;
    map['distance'] = distance;
    map['distance_label'] = distanceLabel;
    return map;
  }
}
