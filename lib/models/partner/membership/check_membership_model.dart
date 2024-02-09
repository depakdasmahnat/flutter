import 'dart:convert';
CheckMembershipModel checkMembershipModelFromJson(String str) => CheckMembershipModel.fromJson(json.decode(str));
String checkMembershipModelToJson(CheckMembershipModel data) => json.encode(data.toJson());
class CheckMembershipModel {
  CheckMembershipModel({
      this.status, 
      this.message, 
      this.showMembershipPurchaseBtn, 
      this.expiredAt, 
      this.url, 
      this.orderTypes, 
      this.data,});

  CheckMembershipModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    showMembershipPurchaseBtn = json['show_membership_purchase_btn'];
    expiredAt = json['expired_at'];
    url = json['url'];
    orderTypes = json['order_types'] != null ? json['order_types'].cast<String>() : [];
    data = json['data'] != null ? MembershipData.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  bool? showMembershipPurchaseBtn;
  String? expiredAt;
  String? url;
  List<String>? orderTypes;
  MembershipData? data;
CheckMembershipModel copyWith({  bool? status,
  String? message,
  bool? showMembershipPurchaseBtn,
  String? expiredAt,
  String? url,
  List<String>? orderTypes,
  MembershipData? data,
}) => CheckMembershipModel(  status: status ?? this.status,
  message: message ?? this.message,
  showMembershipPurchaseBtn: showMembershipPurchaseBtn ?? this.showMembershipPurchaseBtn,
  expiredAt: expiredAt ?? this.expiredAt,
  url: url ?? this.url,
  orderTypes: orderTypes ?? this.orderTypes,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['show_membership_purchase_btn'] = showMembershipPurchaseBtn;
    map['expired_at'] = expiredAt;
    map['url'] = url;
    map['order_types'] = orderTypes;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

MembershipData dataFromJson(String str) => MembershipData.fromJson(json.decode(str));
String dataToJson(MembershipData data) => json.encode(data.toJson());
class MembershipData {
  MembershipData({
      this.id, 
      this.subscriptionId, 
      this.userId, 
      this.partnerId, 
      this.levelType, 
      this.paidAmount, 
      this.type, 
      this.paymentType, 
      this.duration, 
      this.unit, 
      this.days, 
      this.startedAt, 
      this.expiredAt, 
      this.couponId, 
      this.status, 
      this.createdAt, 
      this.updatedAt, 
      this.deletedAt, 
      this.subscriptionTitle,});

  MembershipData.fromJson(dynamic json) {
    id = json['id'];
    subscriptionId = json['subscription_id'];
    userId = json['user_id'];
    partnerId = json['partner_id'];
    levelType = json['level_type'];
    paidAmount = json['paid_amount'];
    type = json['type'];
    paymentType = json['payment_type'];
    duration = json['duration'];
    unit = json['unit'];
    days = json['days'];
    startedAt = json['started_at'];
    expiredAt = json['expired_at'];
    couponId = json['coupon_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    subscriptionTitle = json['subscription_title'];
  }
  num? id;
  num? subscriptionId;
  num? userId;
  num? partnerId;
  String? levelType;
  String? paidAmount;
  String? type;
  String? paymentType;
  num? duration;
  String? unit;
  num? days;
  String? startedAt;
  String? expiredAt;
  dynamic couponId;
  String? status;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? subscriptionTitle;
MembershipData copyWith({  num? id,
  num? subscriptionId,
  num? userId,
  num? partnerId,
  String? levelType,
  String? paidAmount,
  String? type,
  String? paymentType,
  num? duration,
  String? unit,
  num? days,
  String? startedAt,
  String? expiredAt,
  dynamic couponId,
  String? status,
  String? createdAt,
  String? updatedAt,
  dynamic deletedAt,
  String? subscriptionTitle,
}) => MembershipData(  id: id ?? this.id,
  subscriptionId: subscriptionId ?? this.subscriptionId,
  userId: userId ?? this.userId,
  partnerId: partnerId ?? this.partnerId,
  levelType: levelType ?? this.levelType,
  paidAmount: paidAmount ?? this.paidAmount,
  type: type ?? this.type,
  paymentType: paymentType ?? this.paymentType,
  duration: duration ?? this.duration,
  unit: unit ?? this.unit,
  days: days ?? this.days,
  startedAt: startedAt ?? this.startedAt,
  expiredAt: expiredAt ?? this.expiredAt,
  couponId: couponId ?? this.couponId,
  status: status ?? this.status,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  deletedAt: deletedAt ?? this.deletedAt,
  subscriptionTitle: subscriptionTitle ?? this.subscriptionTitle,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['subscription_id'] = subscriptionId;
    map['user_id'] = userId;
    map['partner_id'] = partnerId;
    map['level_type'] = levelType;
    map['paid_amount'] = paidAmount;
    map['type'] = type;
    map['payment_type'] = paymentType;
    map['duration'] = duration;
    map['unit'] = unit;
    map['days'] = days;
    map['started_at'] = startedAt;
    map['expired_at'] = expiredAt;
    map['coupon_id'] = couponId;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['subscription_title'] = subscriptionTitle;
    return map;
  }

}