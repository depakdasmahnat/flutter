import 'dart:convert';

import 'package:gaas/models/dashboard/producer_details_model.dart';

AllProducers allProducersFromJson(String str) => AllProducers.fromJson(json.decode(str));

String allProducersToJson(AllProducers data) => json.encode(data.toJson());

class AllProducers {
  AllProducers({
    this.status,
    this.message,
    this.totalPage,
    this.data,
  });

  AllProducers.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(AllProducersData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  num? totalPage;
  List<AllProducersData>? data;

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

AllProducersData dataFromJson(String str) => AllProducersData.fromJson(json.decode(str));

String dataToJson(AllProducersData data) => json.encode(data.toJson());

class AllProducersData {
  AllProducersData({
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
    this.reason,
    this.orderTypes,
    this.rating,
    this.reviews,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.deletedAt,
    this.distanceNumber,
    this.distance,
    this.distanceLabel,
    this.productCounts,
    this.products,
    this.inWishlist,
    this.wishlistId,
    this.orderMode,
    this.offers,
  });

  AllProducersData.fromJson(dynamic json) {
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
    reason = json['reason'];
    orderTypes = json['order_types'];
    rating = json['rating'];
    reviews = json['reviews'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    distanceNumber = json['distance_number'];
    distance = json['distance'];
    distanceLabel = json['distance_label'];
    productCounts = json['product_counts'];
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(AllProducersProducts.fromJson(v));
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
  String? pincode;
  dynamic categories;
  dynamic reason;
  String? orderTypes;
  num? rating;
  num? reviews;
  String? createdAt;
  String? updatedAt;
  String? status;
  dynamic deletedAt;
  num? distanceNumber;
  num? distance;
  String? distanceLabel;
  num? productCounts;
  List<AllProducersProducts>? products;
  bool? inWishlist;
  num? wishlistId;
  String? orderMode;
  List<ProducerOffers>? offers;

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
    map['reason'] = reason;
    map['order_types'] = orderTypes;
    map['rating'] = rating;
    map['reviews'] = reviews;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['status'] = status;
    map['deleted_at'] = deletedAt;
    map['distance_number'] = distanceNumber;
    map['distance'] = distance;
    map['distance_label'] = distanceLabel;
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

AllProducersProducts productsFromJson(String str) => AllProducersProducts.fromJson(json.decode(str));

String productsToJson(AllProducersProducts data) => json.encode(data.toJson());

class AllProducersProducts {
  AllProducersProducts({
    this.id,
    this.name,
    this.image,
    this.path,
  });

  AllProducersProducts.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    path = json['path'];
  }

  num? id;
  String? name;
  String? image;
  String? path;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    map['path'] = path;
    return map;
  }
}
