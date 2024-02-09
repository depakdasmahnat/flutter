import 'dart:convert';

NearByMapProducers nearByMapProducersFromJson(String str) => NearByMapProducers.fromJson(json.decode(str));

String nearByMapProducersToJson(NearByMapProducers data) => json.encode(data.toJson());

class NearByMapProducers {
  NearByMapProducers({
    this.status,
    this.message,
    this.data,
  });

  NearByMapProducers.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(NearByMapProducersData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<NearByMapProducersData>? data;

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

NearByMapProducersData dataFromJson(String str) => NearByMapProducersData.fromJson(json.decode(str));

String dataToJson(NearByMapProducersData data) => json.encode(data.toJson());

class NearByMapProducersData {
  NearByMapProducersData({
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
  });

  NearByMapProducersData.fromJson(dynamic json) {
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
    return map;
  }
}
