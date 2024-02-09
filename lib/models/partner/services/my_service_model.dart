import 'dart:convert';

import '../../dashboard/service/service_provider_detail.dart';
import '../category_model.dart';

MyServiceModel myServiceModelFromJson(String str) => MyServiceModel.fromJson(json.decode(str));

String myServiceModelToJson(MyServiceModel data) => json.encode(data.toJson());

class MyServiceModel {
  MyServiceModel({
    this.status,
    this.message,
    this.data,
  });

  MyServiceModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? MyServiceData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  MyServiceData? data;

  MyServiceModel copyWith({
    bool? status,
    String? message,
    MyServiceData? data,
  }) =>
      MyServiceModel(
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

MyServiceData dataFromJson(String str) => MyServiceData.fromJson(json.decode(str));

String dataToJson(MyServiceData data) => json.encode(data.toJson());

class MyServiceData {
  MyServiceData({
    this.id,
    this.userId,
    this.type,
    this.profilePhoto,
    this.path,
    this.name,
    this.email,
    this.mobile,
    this.latitude,
    this.longitude,
    this.address,
    this.countryId,
    this.stateId,
    this.cityId,
    this.countryCode,
    this.countryName,
    this.stateName,
    this.cityName,
    this.pincode,
    this.reason,
    this.orderTypes,
    this.isFeatured,
    this.perHourCharge,
    this.categories,
    this.subcategories,
    this.services,
    this.serviceImages,
    this.about,
    this.accessToken,
  });

  MyServiceData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    profilePhoto = json['profile_photo'];
    path = json['path'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
    stateName = json['state_name'];
    cityName = json['city_name'];
    pincode = json['pincode'];
    reason = json['reason'];
    orderTypes = json['order_types'];
    isFeatured = json['is_featured'];
    perHourCharge = json['per_hour_charge'];
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories?.add(CategoryData.fromJson(v));
      });
    }
    if (json['subcategories'] != null) {
      subcategories = [];
      json['subcategories'].forEach((v) {
        subcategories?.add(CategoryData.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = [];
      json['services'].forEach((v) {
        services?.add(Services.fromJson(v));
      });
    }
    if (json['service_images'] != null) {
      serviceImages = [];
      json['service_images'].forEach((v) {
        serviceImages?.add(ServiceImages.fromJson(v));
      });
    }
    about = json['about'];
    accessToken = json['access_token'];
  }

  num? id;
  num? userId;
  String? type;
  dynamic profilePhoto;
  dynamic path;
  String? name;
  String? email;
  String? mobile;
  String? latitude;
  String? longitude;
  String? address;
  num? countryId;
  num? stateId;
  num? cityId;
  String? countryCode;
  String? countryName;
  String? stateName;
  String? cityName;
  dynamic pincode;
  dynamic reason;
  dynamic orderTypes;
  String? isFeatured;
  num? perHourCharge;
  List<CategoryData>? categories;
  List<CategoryData>? subcategories;
  List<Services>? services;
  List<ServiceImages>? serviceImages;
  String? about;
  dynamic accessToken;

  MyServiceData copyWith({
    num? id,
    num? userId,
    String? type,
    dynamic profilePhoto,
    dynamic path,
    String? name,
    String? email,
    String? mobile,
    String? latitude,
    String? longitude,
    String? address,
    num? countryId,
    num? stateId,
    num? cityId,
    String? countryCode,
    String? countryName,
    String? stateName,
    String? cityName,
    dynamic pincode,
    dynamic reason,
    dynamic orderTypes,
    String? isFeatured,
    num? perHourCharge,
    List<CategoryData>? categories,
    List<CategoryData>? subcategories,
    List<Services>? services,
    List<ServiceImages>? serviceImages,
    String? about,
    dynamic accessToken,
  }) =>
      MyServiceData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        type: type ?? this.type,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        path: path ?? this.path,
        name: name ?? this.name,
        email: email ?? this.email,
        mobile: mobile ?? this.mobile,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        address: address ?? this.address,
        countryId: countryId ?? this.countryId,
        stateId: stateId ?? this.stateId,
        cityId: cityId ?? this.cityId,
        countryCode: countryCode ?? this.countryCode,
        countryName: countryName ?? this.countryName,
        stateName: stateName ?? this.stateName,
        cityName: cityName ?? this.cityName,
        pincode: pincode ?? this.pincode,
        reason: reason ?? this.reason,
        orderTypes: orderTypes ?? this.orderTypes,
        isFeatured: isFeatured ?? this.isFeatured,
        perHourCharge: perHourCharge ?? this.perHourCharge,
        categories: categories ?? this.categories,
        subcategories: subcategories ?? this.subcategories,
        services: services ?? this.services,
        serviceImages: serviceImages ?? this.serviceImages,
        about: about ?? this.about,
        accessToken: accessToken ?? this.accessToken,
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
    map['mobile'] = mobile;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['address'] = address;
    map['country_id'] = countryId;
    map['state_id'] = stateId;
    map['city_id'] = cityId;
    map['country_code'] = countryCode;
    map['country_name'] = countryName;
    map['state_name'] = stateName;
    map['city_name'] = cityName;
    map['pincode'] = pincode;
    map['reason'] = reason;
    map['order_types'] = orderTypes;
    map['is_featured'] = isFeatured;
    map['per_hour_charge'] = perHourCharge;
    if (categories != null) {
      map['categories'] = categories?.map((v) => v.toJson()).toList();
    }
    if (subcategories != null) {
      map['subcategories'] = subcategories?.map((v) => v.toJson()).toList();
    }
    if (services != null) {
      map['services'] = services?.map((v) => v.toJson()).toList();
    }
    if (serviceImages != null) {
      map['service_images'] = serviceImages?.map((v) => v.toJson()).toList();
    }
    map['about'] = about;
    map['access_token'] = accessToken;
    return map;
  }
}

ServiceImages serviceImagesFromJson(String str) => ServiceImages.fromJson(json.decode(str));

String serviceImagesToJson(ServiceImages data) => json.encode(data.toJson());

class ServiceImages {
  ServiceImages({
    this.id,
    this.path,
    this.filename,
    this.image,
  });

  ServiceImages.fromJson(dynamic json) {
    id = json['id'];
    path = json['path'];
    filename = json['filename'];
    image = json['image'];
  }

  String? id;
  String? path;
  String? filename;
  String? image;

  ServiceImages copyWith({
    String? id,
    String? path,
    String? filename,
    String? image,
  }) =>
      ServiceImages(
        id: id ?? this.id,
        path: path ?? this.path,
        filename: filename ?? this.filename,
        image: image ?? this.image,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['path'] = path;
    map['filename'] = filename;
    map['image'] = image;
    return map;
  }
}
