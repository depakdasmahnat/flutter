import 'dart:convert';

EarningsModel earningsModelFromJson(String str) => EarningsModel.fromJson(json.decode(str));

String earningsModelToJson(EarningsModel data) => json.encode(data.toJson());

class EarningsModel {
  EarningsModel({
    this.status,
    this.message,
    this.totalEarning,
    this.totalPaid,
    this.totalPending,
    this.totalPage,
    this.data,
  });

  EarningsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    totalEarning = json['total_earning'];
    totalPaid = json['total_paid'];
    totalPending = json['total_pending'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(EarningsData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  num? totalEarning;
  num? totalPaid;
  num? totalPending;
  num? totalPage;
  List<EarningsData>? data;

  EarningsModel copyWith({
    bool? status,
    String? message,
    num? totalEarning,
    num? totalPaid,
    num? totalPending,
    num? totalPage,
    List<EarningsData>? data,
  }) =>
      EarningsModel(
        status: status ?? this.status,
        message: message ?? this.message,
        totalEarning: totalEarning ?? this.totalEarning,
        totalPaid: totalPaid ?? this.totalPaid,
        totalPending: totalPending ?? this.totalPending,
        totalPage: totalPage ?? this.totalPage,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['total_earning'] = totalEarning;
    map['total_paid'] = totalPaid;
    map['total_pending'] = totalPending;
    map['total_page'] = totalPage;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

EarningsData dataFromJson(String str) => EarningsData.fromJson(json.decode(str));

String dataToJson(EarningsData data) => json.encode(data.toJson());

class EarningsData {
  EarningsData({
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
    this.settledAt,
    this.settlementAmount,
    this.createdAt,
    this.userLatitude,
    this.userLongitude,
    this.userName,
    this.path,
    this.profilePhoto,
    this.timeslotId,
    this.timeslotDay,
    this.timeslotName,
    this.datetime,
    this.isVerified,
    this.productCounts,
  });

  EarningsData.fromJson(dynamic json) {
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
    settledAt = json['settled_at'];
    settlementAmount = json['settlement_amount'];
    createdAt = json['created_at'];
    userLatitude = json['user_latitude'];
    userLongitude = json['user_longitude'];
    userName = json['user_name'];
    path = json['path'];
    profilePhoto = json['profile_photo'];
    timeslotId = json['timeslot_id'];
    timeslotDay = json['timeslot_day'];
    timeslotName = json['timeslot_name'];
    datetime = json['datetime'];
    isVerified = json['is_verified'];
    productCounts = json['product_counts'];
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
  String? settledAt;
  num? settlementAmount;
  String? createdAt;
  String? userLatitude;
  String? userLongitude;
  String? userName;
  String? path;
  String? profilePhoto;
  num? timeslotId;
  String? timeslotDay;
  String? timeslotName;
  String? datetime;
  bool? isVerified;
  num? productCounts;

  EarningsData copyWith({
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
    String? settledAt,
    num? settlementAmount,
    String? createdAt,
    String? userLatitude,
    String? userLongitude,
    String? userName,
    String? path,
    String? profilePhoto,
    num? timeslotId,
    String? timeslotDay,
    String? timeslotName,
    String? datetime,
    bool? isVerified,
    num? productCounts,
  }) =>
      EarningsData(
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
        settledAt: settledAt ?? this.settledAt,
        settlementAmount: settlementAmount ?? this.settlementAmount,
        createdAt: createdAt ?? this.createdAt,
        userLatitude: userLatitude ?? this.userLatitude,
        userLongitude: userLongitude ?? this.userLongitude,
        userName: userName ?? this.userName,
        path: path ?? this.path,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        timeslotId: timeslotId ?? this.timeslotId,
        timeslotDay: timeslotDay ?? this.timeslotDay,
        timeslotName: timeslotName ?? this.timeslotName,
        datetime: datetime ?? this.datetime,
        isVerified: isVerified ?? this.isVerified,
        productCounts: productCounts ?? this.productCounts,
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
    map['settled_at'] = settledAt;
    map['settlement_amount'] = settlementAmount;
    map['created_at'] = createdAt;
    map['user_latitude'] = userLatitude;
    map['user_longitude'] = userLongitude;
    map['user_name'] = userName;
    map['path'] = path;
    map['profile_photo'] = profilePhoto;
    map['timeslot_id'] = timeslotId;
    map['timeslot_day'] = timeslotDay;
    map['timeslot_name'] = timeslotName;
    map['datetime'] = datetime;
    map['is_verified'] = isVerified;
    map['product_counts'] = productCounts;
    return map;
  }
}
