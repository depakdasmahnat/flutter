import 'dart:convert';

import '../../orders/order_detail_model.dart';

LeadDetailsModel leadDetailsModelFromJson(String str) => LeadDetailsModel.fromJson(json.decode(str));

String leadDetailsModelToJson(LeadDetailsModel data) => json.encode(data.toJson());

class LeadDetailsModel {
  LeadDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  LeadDetailsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? LeadData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  LeadData? data;

  LeadDetailsModel copyWith({
    bool? status,
    String? message,
    LeadData? data,
  }) =>
      LeadDetailsModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

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

LeadData dataFromJson(String str) => LeadData.fromJson(json.decode(str));

String dataToJson(LeadData data) => json.encode(data.toJson());

class LeadData {
  LeadData({
    this.id,
    this.userId,
    this.partnerId,
    this.name,
    this.email,
    this.mobile,
    this.publicContactInfo,
    this.serviceIds,
    this.comment,
    this.reply,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.deletedAt,
    this.profilePhoto,
    this.path,
    this.reviewAdded,
    this.ratings,
    this.reviewDetail,
    this.services,
  });

  LeadData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    partnerId = json['partner_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    publicContactInfo = json['public_contact_info'];
    serviceIds = json['service_ids'];
    comment = json['comment'];
    reply = json['reply'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    profilePhoto = json['profile_photo'];
    path = json['path'];
    reviewAdded = json['review_added'];
    ratings = json['ratings'];
    reviewDetail = json['review_detail'] != null ? ReviewDetail.fromJson(json['review_detail']) : null;
    if (json['services'] != null) {
      services = [];
      json['services'].forEach((v) {
        services?.add(Services.fromJson(v));
      });
    }
  }

  num? id;
  num? userId;
  num? partnerId;
  String? name;
  String? email;
  String? mobile;
  String? publicContactInfo;
  String? serviceIds;
  String? comment;
  String? reply;
  String? createdAt;
  String? updatedAt;
  String? status;
  dynamic deletedAt;
  dynamic profilePhoto;
  dynamic path;
  bool? reviewAdded;
  num? ratings;
  ReviewDetail? reviewDetail;
  List<Services>? services;

  LeadData copyWith({
    num? id,
    num? userId,
    num? partnerId,
    String? name,
    String? email,
    String? mobile,
    String? public_contact_info,
    String? serviceIds,
    String? comment,
    String? reply,
    String? createdAt,
    String? updatedAt,
    String? status,
    dynamic deletedAt,
    dynamic profilePhoto,
    dynamic path,
    bool? reviewAdded,
    num? ratings,
    ReviewDetail? reviewDetail,
    List<Services>? services,
  }) =>
      LeadData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        partnerId: partnerId ?? this.partnerId,
        name: name ?? this.name,
        email: email ?? this.email,
        mobile: mobile ?? this.mobile,
        publicContactInfo: public_contact_info ?? this.publicContactInfo,
        serviceIds: serviceIds ?? this.serviceIds,
        comment: comment ?? this.comment,
        reply: reply ?? this.reply,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status,
        deletedAt: deletedAt ?? this.deletedAt,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        path: path ?? this.path,
        reviewAdded: reviewAdded ?? this.reviewAdded,
        ratings: ratings ?? this.ratings,
        reviewDetail: reviewDetail ?? this.reviewDetail,
        services: services ?? this.services,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['partner_id'] = partnerId;
    map['name'] = name;
    map['email'] = email;

    map['mobile'] = mobile;
    map['public_contact_info'] = publicContactInfo;
    map['service_ids'] = serviceIds;
    map['comment'] = comment;
    map['reply'] = reply;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['status'] = status;
    map['deleted_at'] = deletedAt;
    map['profile_photo'] = profilePhoto;
    map['path'] = path;
    map['review_added'] = reviewAdded;
    map['ratings'] = ratings;
    if (reviewDetail != null) {
      map['review_detail'] = reviewDetail?.toJson();
    }
    if (services != null) {
      map['services'] = services?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Services servicesFromJson(String str) => Services.fromJson(json.decode(str));

String servicesToJson(Services data) => json.encode(data.toJson());

class Services {
  Services({
    this.id,
    this.name,
    this.path,
    this.icon,
  });

  Services.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    path = json['path'];
    icon = json['icon'];
  }

  num? id;
  String? name;
  String? path;
  String? icon;

  Services copyWith({
    num? id,
    String? name,
    String? path,
    String? icon,
  }) =>
      Services(
        id: id ?? this.id,
        name: name ?? this.name,
        path: path ?? this.path,
        icon: icon ?? this.icon,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['path'] = path;
    map['icon'] = icon;
    return map;
  }
}
