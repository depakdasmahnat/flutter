import 'dart:convert';

import '../../orders/order_detail_model.dart';
import '../../partner/services/my_service_model.dart';

ServiceProviderDetail serviceProviderDetailFromJson(String str) =>
    ServiceProviderDetail.fromJson(json.decode(str));

String serviceProviderDetailToJson(ServiceProviderDetail data) => json.encode(data.toJson());

class ServiceProviderDetail {
  ServiceProviderDetail({
    this.status,
    this.message,
    this.data,
  });

  ServiceProviderDetail.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ServiceProviderData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  ServiceProviderData? data;

  ServiceProviderDetail copyWith({
    bool? status,
    String? message,
    ServiceProviderData? data,
  }) =>
      ServiceProviderDetail(
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

ServiceProviderData dataFromJson(String str) => ServiceProviderData.fromJson(json.decode(str));

String dataToJson(ServiceProviderData data) => json.encode(data.toJson());

class ServiceProviderData {
  ServiceProviderData({
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
    this.isLive,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.isActive,
    this.deletedAt,
    this.distanceNumber,
    this.distance,
    this.distanceLabel,
    this.ratingLabel,
    this.inWishlist,
    this.wishlistId,
    this.unit,
    this.showContacts,
    this.showEmail,
    this.offers,
    this.reviewAdded,
    this.ratings,
    this.reviewDetail,
  });

  ServiceProviderData.fromJson(dynamic json) {
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
    if (json['services'] != null) {
      services = [];
      json['services'].forEach((v) {
        services?.add(Services.fromJson(v));
      });
    }
    about = json['about'];
    if (json['service_images'] != null) {
      serviceImages = [];
      json['service_images'].forEach((v) {
        serviceImages?.add(ServiceImages.fromJson(v));
      });
    }
    reason = json['reason'];
    orderTypes = json['order_types'];
    rating = json['rating'];
    reviews = json['reviews'];
    isLive = json['is_live'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    isActive = json['is_active'];
    deletedAt = json['deleted_at'];
    distanceNumber = json['distance_number'];
    distance = json['distance'];
    distanceLabel = json['distance_label'];
    ratingLabel = json['rating_label'];
    inWishlist = json['in_wishlist'];
    wishlistId = json['wishlist_id'];
    unit = json['unit'];
    showContacts = json['show_contacts'];
    showEmail = json['show_email'];
    offers = json['offers'];
    reviewAdded = json['review_added'];
    ratings = json['ratings'];
    reviewDetail = json['review_detail'] != null ? ReviewDetail.fromJson(json['review_detail']) : null;
  }

  num? id;
  num? userId;
  String? type;
  dynamic profilePhoto;
  dynamic path;
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
  String? categories;
  String? isFeatured;
  List<Services>? services;
  String? about;
  List<ServiceImages>? serviceImages;
  dynamic reason;
  dynamic orderTypes;
  num? rating;
  num? reviews;
  String? isLive;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? isActive;
  dynamic deletedAt;
  num? distanceNumber;
  num? distance;
  String? distanceLabel;
  String? ratingLabel;
  String? unit;
  String? showContacts;
  String? showEmail;
  bool? inWishlist;
  dynamic wishlistId;
  dynamic offers;
  bool? reviewAdded;
  num? ratings;
  ReviewDetail? reviewDetail;

  ServiceProviderData copyWith({
    num? id,
    num? userId,
    String? type,
    dynamic profilePhoto,
    dynamic path,
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
    String? categories,
    String? isFeatured,
    List<Services>? services,
    String? about,
    List<ServiceImages>? serviceImages,
    dynamic reason,
    dynamic orderTypes,
    num? rating,
    num? reviews,
    String? isLive,
    String? createdAt,
    String? updatedAt,
    String? status,
    String? isActive,
    dynamic deletedAt,
    num? distanceNumber,
    num? distance,
    String? distanceLabel,
    String? ratingLabel,
    String? unit,
    String? show_contacts,
    String? show_email,
    bool? inWishlist,
    dynamic wishlistId,
    dynamic offers,
    bool? reviewAdded,
    num? ratings,
    ReviewDetail? reviewDetail,
  }) =>
      ServiceProviderData(
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
        isLive: isLive ?? this.isLive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status,
        isActive: isActive ?? this.isActive,
        deletedAt: deletedAt ?? this.deletedAt,
        distanceNumber: distanceNumber ?? this.distanceNumber,
        distance: distance ?? this.distance,
        distanceLabel: distanceLabel ?? this.distanceLabel,
        ratingLabel: ratingLabel ?? this.ratingLabel,
        inWishlist: inWishlist ?? this.inWishlist,
        wishlistId: wishlistId ?? this.wishlistId,
        unit: unit ?? this.unit,
        showContacts: show_contacts ?? this.showContacts,
        showEmail: show_email ?? this.showEmail,
        offers: offers ?? this.offers,
        reviewAdded: reviewAdded ?? this.reviewAdded,
        ratings: ratings ?? this.ratings,
        reviewDetail: reviewDetail ?? this.reviewDetail,
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
    if (services != null) {
      map['services'] = services?.map((v) => v.toJson()).toList();
    }
    map['about'] = about;
    if (serviceImages != null) {
      map['service_images'] = serviceImages?.map((v) => v.toJson()).toList();
    }
    map['reason'] = reason;
    map['order_types'] = orderTypes;
    map['rating'] = rating;
    map['reviews'] = reviews;
    map['is_live'] = isLive;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['status'] = status;
    map['is_active'] = isActive;
    map['deleted_at'] = deletedAt;
    map['distance_number'] = distanceNumber;
    map['distance'] = distance;
    map['distance_label'] = distanceLabel;
    map['rating_label'] = ratingLabel;
    map['in_wishlist'] = inWishlist;
    map['wishlist_id'] = wishlistId;
    map['unit'] = unit;
    map['show_contacts'] = showContacts;
    map['show_email'] = showEmail;
    map['offers'] = offers;
    map['review_added'] = reviewAdded;
    map['ratings'] = ratings;
    if (reviewDetail != null) {
      map['review_detail'] = reviewDetail?.toJson();
    }
    return map;
  }
}

Services servicesFromJson(String str) => Services.fromJson(json.decode(str));

String servicesToJson(Services data) => json.encode(data.toJson());

class Services {
  Services({
    this.id,
    this.amount,
    this.name,
    this.serviceImage,
    this.unit,
    this.selected,
  });

  Services.fromJson(dynamic json) {
    id = json['id'];
    amount = json['amount'];
    name = json['name'];
    serviceImage = json['service_image'];
    unit = json['unit'];
    selected = json['selected'];
  }

  dynamic id;
  dynamic amount;
  String? name;
  String? serviceImage;
  String? unit;
  bool? selected;

  Services copyWith({
    String? id,
    String? amount,
    String? name,
    bool? selected,
  }) =>
      Services(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        name: name ?? this.name,
        serviceImage: serviceImage ?? this.serviceImage,
        unit: unit ?? this.unit,
        selected: selected ?? this.selected,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['amount'] = amount;
    map['name'] = name;
    map['service_image'] = serviceImage;
    map['unit'] = unit;
    map['selected'] = selected;
    return map;
  }
}
