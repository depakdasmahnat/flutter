import 'dart:convert';

import 'package:gaas/models/dashboard/producer_details_model.dart';

GlobalSearchModel globalSearchModelFromJson(String str) => GlobalSearchModel.fromJson(json.decode(str));

String globalSearchModelToJson(GlobalSearchModel data) => json.encode(data.toJson());

class GlobalSearchModel {
  GlobalSearchModel({
    this.status,
    this.message,
    this.totalPage,
    this.data,
  });

  GlobalSearchModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(GlobalSearchData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  num? totalPage;
  List<GlobalSearchData>? data;

  GlobalSearchModel copyWith({
    bool? status,
    String? message,
    num? totalPage,
    List<GlobalSearchData>? data,
  }) =>
      GlobalSearchModel(
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

GlobalSearchData dataFromJson(String str) => GlobalSearchData.fromJson(json.decode(str));

String dataToJson(GlobalSearchData data) => json.encode(data.toJson());

class GlobalSearchData {
  GlobalSearchData({
    this.id,
    this.userId,
    this.type,
    this.profilePhoto,
    this.icon,
    this.path,
    this.name,
    this.email,
    this.countryCode,
    this.mobile,
    this.latitude,
    this.longitude,
    this.address,
    this.categoryId,
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
    this.groupType,
    this.productCounts,
    this.products,
    this.inWishlist,
    this.wishlistId,
    this.orderMode,
    this.offers,
  });

  GlobalSearchData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    profilePhoto = json['profile_photo'];
    icon = json['icon'];
    path = json['path'];
    name = json['name'];
    email = json['email'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    categoryId = json['category_id'];
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
    groupType = json['group_type'];
    productCounts = json['product_counts'];
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(GlobalSearchProducts.fromJson(v));
      });
    }
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
  String? icon;
  String? path;
  String? name;
  String? email;
  String? countryCode;
  String? mobile;
  String? latitude;
  String? longitude;
  String? address;
  num? categoryId;
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
  String? groupType;
  num? productCounts;
  List<GlobalSearchProducts>? products;
  bool? inWishlist;
  num? wishlistId;
  String? orderMode;
  List<ProducerOffers>? offers;

  GlobalSearchData copyWith({
    num? id,
    num? userId,
    String? type,
    String? profilePhoto,
    String? icon,
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
    String? groupType,
    num? productCounts,
    List<GlobalSearchProducts>? products,
    bool? inWishlist,
    num? wishlistId,
    String? orderMode,
    List<ProducerOffers>? offers,
  }) =>
      GlobalSearchData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        type: type ?? this.type,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        icon: icon ?? this.icon,
        path: path ?? this.path,
        name: name ?? this.name,
        email: email ?? this.email,
        countryCode: countryCode ?? this.countryCode,
        mobile: mobile ?? this.mobile,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        address: address ?? this.address,
        categoryId: countryId ?? this.categoryId,
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
        groupType: groupType ?? this.groupType,
        productCounts: productCounts ?? this.productCounts,
        products: products ?? this.products,
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
    map['icon'] = icon;
    map['path'] = path;
    map['name'] = name;
    map['email'] = email;
    map['country_code'] = countryCode;
    map['mobile'] = mobile;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['address'] = address;
    map['category_id'] = categoryId;
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
    map['group_type'] = groupType;
    map['product_counts'] = productCounts;
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    map['in_wishlist'] = inWishlist;
    map['wishlist_id'] = wishlistId;
    map['order_mode'] = orderMode;
    if (offers != null) {
      map['offers'] = offers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

GlobalSearchProducts productsFromJson(String str) => GlobalSearchProducts.fromJson(json.decode(str));

String productsToJson(GlobalSearchProducts data) => json.encode(data.toJson());

class GlobalSearchProducts {
  GlobalSearchProducts({
    this.id,
    this.name,
    this.image,
    this.path,
    this.categoryId,
    this.subcategoryId,
    this.price,
  });

  GlobalSearchProducts.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    path = json['path'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    price = json['price'];
  }

  num? id;
  String? name;
  String? image;
  String? path;
  num? categoryId;
  num? subcategoryId;
  String? price;

  GlobalSearchProducts copyWith({
    num? id,
    String? name,
    String? image,
    String? path,
    num? categoryId,
    num? subcategoryId,
    String? price,
  }) =>
      GlobalSearchProducts(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        path: path ?? this.path,
        categoryId: categoryId ?? this.categoryId,
        subcategoryId: subcategoryId ?? this.subcategoryId,
        price: price ?? this.price,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    map['path'] = path;
    map['category_id'] = categoryId;
    map['subcategory_id'] = subcategoryId;
    map['price'] = price;
    return map;
  }
}
