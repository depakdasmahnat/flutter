import 'dart:convert';

import 'producer_details_model.dart';

NearbyProducersModel nearbyProducersModelFromJson(String str) => NearbyProducersModel.fromJson(json.decode(str));

String nearbyProducersModelToJson(NearbyProducersModel data) => json.encode(data.toJson());

class NearbyProducersModel {
  NearbyProducersModel({
    this.status,
    this.message,
    this.totalPage,
    this.data,
  });

  NearbyProducersModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(NearbyProducersData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  num? totalPage;
  List<NearbyProducersData>? data;

  NearbyProducersModel copyWith({
    bool? status,
    String? message,
    num? totalPage,
    List<NearbyProducersData>? data,
  }) =>
      NearbyProducersModel(
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

NearbyProducersData dataFromJson(String str) => NearbyProducersData.fromJson(json.decode(str));

String dataToJson(NearbyProducersData data) => json.encode(data.toJson());

class NearbyProducersData {
  NearbyProducersData({
    this.id,
    this.userId,
    this.type,
    this.profilePhoto,
    this.path,
    this.name,
    this.email,
    this.countryCode,
    this.mobile,
    this.latitude,
    this.longitude,
    this.address,
    this.countryId,
    this.stateId,
    this.cityId,
    this.pincode,
    this.categories,
    this.isFeatured,
    this.services,
    this.about,
    this.serviceImages,
    this.reason,
    this.orderTypes,
    this.rating,
    this.reviews,
    this.isFreeSelfPicking,
    this.eachPersonAmount,
    this.isLive,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.isActive,
    this.deletedAt,
    this.distanceNumber,
    this.distance,
    this.distanceLabel,
    this.inWishlist,
    this.wishlistId,
    this.orderMode,
    this.offers,
  });

  NearbyProducersData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    profilePhoto = json['profile_photo'];
    path = json['path'];
    name = json['name'];
    email = json['email'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    pincode = json['pincode'];
    categories = json['categories'];
    isFeatured = json['is_featured'];
    services = json['services'];
    about = json['about'];
    serviceImages = json['service_images'];
    reason = json['reason'];
    orderTypes = json['order_types'];
    rating = json['rating'];
    reviews = json['reviews'];
    isFreeSelfPicking = json['is_free_self_picking'];
    eachPersonAmount = json['each_person_amount'];
    isLive = json['is_live'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    isActive = json['is_active'];
    deletedAt = json['deleted_at'];
    distanceNumber = json['distance_number'];
    distance = json['distance'];
    distanceLabel = json['distance_label'];
    inWishlist = json['in_wishlist'];
    wishlistId = json['wishlist_id'];
    orderMode = json['order_mode'];
    if (json['offers'] != null) {
      offers = [];
      json['offers'].forEach((v) {
        offers?.add(ProducerOffers.fromJson(v));
      });
    }
  }

  num? id;
  num? userId;
  String? type;
  String? profilePhoto;
  String? path;
  String? name;
  String? email;
  String? countryCode;
  String? mobile;
  String? latitude;
  String? longitude;
  String? address;
  num? countryId;
  num? stateId;
  num? cityId;
  dynamic pincode;
  dynamic categories;
  String? isFeatured;
  dynamic services;
  dynamic about;
  dynamic serviceImages;
  dynamic reason;
  String? orderTypes;
  num? rating;
  num? reviews;
  String? isFreeSelfPicking;
  num? eachPersonAmount;
  String? isLive;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? isActive;
  dynamic deletedAt;
  num? distanceNumber;
  num? distance;
  String? distanceLabel;
  bool? inWishlist;
  num? wishlistId;
  String? orderMode;
  List<ProducerOffers>? offers;

  NearbyProducersData copyWith({
    num? id,
    num? userId,
    String? type,
    String? profilePhoto,
    String? path,
    String? name,
    String? email,
    String? countryCode,
    String? mobile,
    String? latitude,
    String? longitude,
    String? address,
    num? countryId,
    num? stateId,
    num? cityId,
    dynamic pincode,
    dynamic categories,
    String? isFeatured,
    dynamic services,
    dynamic about,
    dynamic serviceImages,
    dynamic reason,
    String? orderTypes,
    num? rating,
    num? reviews,
    String? isFreeSelfPicking,
    num? eachPersonAmount,
    String? isLive,
    String? createdAt,
    String? updatedAt,
    String? status,
    String? isActive,
    dynamic deletedAt,
    num? distanceNumber,
    num? distance,
    String? distanceLabel,
    bool? inWishlist,
    num? wishlistId,
    String? orderMode,
    List<ProducerOffers>? offers,
  }) =>
      NearbyProducersData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        type: type ?? this.type,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        path: path ?? this.path,
        name: name ?? this.name,
        email: email ?? this.email,
        countryCode: countryCode ?? this.countryCode,
        mobile: mobile ?? this.mobile,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        address: address ?? this.address,
        countryId: countryId ?? this.countryId,
        stateId: stateId ?? this.stateId,
        cityId: cityId ?? this.cityId,
        pincode: pincode ?? this.pincode,
        categories: categories ?? this.categories,
        isFeatured: isFeatured ?? this.isFeatured,
        services: services ?? this.services,
        about: about ?? this.about,
        serviceImages: serviceImages ?? this.serviceImages,
        reason: reason ?? this.reason,
        orderTypes: orderTypes ?? this.orderTypes,
        rating: rating ?? this.rating,
        reviews: reviews ?? this.reviews,
        isFreeSelfPicking: isFreeSelfPicking ?? this.isFreeSelfPicking,
        eachPersonAmount: eachPersonAmount ?? this.eachPersonAmount,
        isLive: isLive ?? this.isLive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status,
        isActive: isActive ?? this.isActive,
        deletedAt: deletedAt ?? this.deletedAt,
        distanceNumber: distanceNumber ?? this.distanceNumber,
        distance: distance ?? this.distance,
        distanceLabel: distanceLabel ?? this.distanceLabel,
        inWishlist: inWishlist ?? this.inWishlist,
        wishlistId: wishlistId ?? this.wishlistId,
        orderMode: orderMode ?? this.orderMode,
        offers: offers ?? this.offers,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['type'] = type;
    map['profile_photo'] = profilePhoto;
    map['path'] = path;
    map['name'] = name;
    map['email'] = email;
    map['country_code'] = countryCode;
    map['mobile'] = mobile;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['address'] = address;
    map['country_id'] = countryId;
    map['state_id'] = stateId;
    map['city_id'] = cityId;
    map['pincode'] = pincode;
    map['categories'] = categories;
    map['is_featured'] = isFeatured;
    map['services'] = services;
    map['about'] = about;
    map['service_images'] = serviceImages;
    map['reason'] = reason;
    map['order_types'] = orderTypes;
    map['rating'] = rating;
    map['reviews'] = reviews;
    map['is_free_self_picking'] = isFreeSelfPicking;
    map['each_person_amount'] = eachPersonAmount;
    map['is_live'] = isLive;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['status'] = status;
    map['is_active'] = isActive;
    map['deleted_at'] = deletedAt;
    map['distance_number'] = distanceNumber;
    map['distance'] = distance;
    map['distance_label'] = distanceLabel;
    map['in_wishlist'] = inWishlist;
    map['wishlist_id'] = wishlistId;
    map['order_mode'] = orderMode;
    if (offers != null) {
      map['offers'] = offers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
