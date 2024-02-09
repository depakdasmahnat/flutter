import 'dart:convert';

ValidCouponsModel validCouponsModelFromJson(String str) => ValidCouponsModel.fromJson(json.decode(str));

String validCouponsModelToJson(ValidCouponsModel data) => json.encode(data.toJson());

class ValidCouponsModel {
  ValidCouponsModel({
    this.status,
    this.message,
    this.data,
  });

  ValidCouponsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ValidCouponsData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<ValidCouponsData>? data;

  ValidCouponsModel copyWith({
    bool? status,
    String? message,
    List<ValidCouponsData>? data,
  }) =>
      ValidCouponsModel(
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

ValidCouponsData dataFromJson(String str) => ValidCouponsData.fromJson(json.decode(str));

String dataToJson(ValidCouponsData data) => json.encode(data.toJson());

class ValidCouponsData {
  ValidCouponsData({
    this.id,
    this.couponFor,
    this.name,
    this.code,
    this.startDate,
    this.endDate,
    this.maxUser,
    this.eligibilityType,
    this.categoryId,
    this.claimType,
    this.percent,
    this.discountUpto,
    this.amount,
    this.creatorId,
    this.creatorType,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.deletedAt,
  });

  ValidCouponsData.fromJson(dynamic json) {
    id = json['id'];
    couponFor = json['coupon_for'];
    name = json['name'];
    code = json['code'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    maxUser = json['max_user'];
    eligibilityType = json['eligibility_type'];
    categoryId = json['category_id'];
    claimType = json['claim_type'];
    percent = json['percent'];
    discountUpto = json['discount_upto'];
    amount = json['amount'];
    creatorId = json['creator_id'];
    creatorType = json['creator_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    deletedAt = json['deleted_at'];
  }

  num? id;
  String? couponFor;
  String? name;
  String? code;
  String? startDate;
  String? endDate;
  num? maxUser;
  String? eligibilityType;
  dynamic categoryId;
  String? claimType;
  num? percent;
  String? discountUpto;
  String? amount;
  num? creatorId;
  String? creatorType;
  String? createdAt;
  String? updatedAt;
  String? status;
  dynamic deletedAt;

  ValidCouponsData copyWith({
    num? id,
    String? couponFor,
    String? name,
    String? code,
    String? startDate,
    String? endDate,
    num? maxUser,
    String? eligibilityType,
    dynamic categoryId,
    String? claimType,
    num? percent,
    String? discountUpto,
    String? amount,
    num? creatorId,
    String? creatorType,
    String? createdAt,
    String? updatedAt,
    String? status,
    dynamic deletedAt,
  }) =>
      ValidCouponsData(
        id: id ?? this.id,
        couponFor: couponFor ?? this.couponFor,
        name: name ?? this.name,
        code: code ?? this.code,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        maxUser: maxUser ?? this.maxUser,
        eligibilityType: eligibilityType ?? this.eligibilityType,
        categoryId: categoryId ?? this.categoryId,
        claimType: claimType ?? this.claimType,
        percent: percent ?? this.percent,
        discountUpto: discountUpto ?? this.discountUpto,
        amount: amount ?? this.amount,
        creatorId: creatorId ?? this.creatorId,
        creatorType: creatorType ?? this.creatorType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status,
        deletedAt: deletedAt ?? this.deletedAt,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['coupon_for'] = couponFor;
    map['name'] = name;
    map['code'] = code;
    map['start_date'] = startDate;
    map['end_date'] = endDate;
    map['max_user'] = maxUser;
    map['eligibility_type'] = eligibilityType;
    map['category_id'] = categoryId;
    map['claim_type'] = claimType;
    map['percent'] = percent;
    map['discount_upto'] = discountUpto;
    map['amount'] = amount;
    map['creator_id'] = creatorId;
    map['creator_type'] = creatorType;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['status'] = status;
    map['deleted_at'] = deletedAt;
    return map;
  }
}
