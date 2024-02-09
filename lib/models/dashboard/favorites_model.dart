import 'dart:convert';

FavoritesModel favoritesModelFromJson(String str) => FavoritesModel.fromJson(json.decode(str));

String favoritesModelToJson(FavoritesModel data) => json.encode(data.toJson());

class FavoritesModel {
  FavoritesModel({
    this.status,
    this.message,
    this.totalPage,
    this.data,
  });

  FavoritesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(FavoritesData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  num? totalPage;
  List<FavoritesData>? data;

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

FavoritesData dataFromJson(String str) => FavoritesData.fromJson(json.decode(str));

String dataToJson(FavoritesData data) => json.encode(data.toJson());

class FavoritesData {
  FavoritesData({
    this.id,
    this.userId,
    this.type,
    this.profilePhoto,
    this.image,
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
    this.inWishlist,
    this.wishlistId,
  });

  FavoritesData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    profilePhoto = json['profile_photo'];
    image = json['image'];
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
    inWishlist = json['in_wishlist'];
    wishlistId = json['wishlist_id'];
  }

  num? id;
  num? userId;
  String? type;
  String? profilePhoto;
  String? image;
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
  bool? inWishlist;
  num? wishlistId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['type'] = type;
    map['profile_photo'] = profilePhoto;
    map['image'] = image;
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
    map['in_wishlist'] = inWishlist;
    map['wishlist_id'] = wishlistId;
    return map;
  }
}
