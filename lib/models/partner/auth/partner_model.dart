import 'dart:convert';

import '../services/my_service_model.dart';

PartnerModel partnerDataModelFromJson(String str) => PartnerModel.fromJson(json.decode(str));

String partnerDataModelToJson(PartnerModel data) => json.encode(data.toJson());

class PartnerModel {
  PartnerModel({
    this.status,
    this.message,
    this.data,
  });

  PartnerModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PartnerData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  PartnerData? data;

  PartnerModel copyWith({
    bool? status,
    String? message,
    PartnerData? data,
  }) =>
      PartnerModel(
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

PartnerData dataFromJson(String str) => PartnerData.fromJson(json.decode(str));

String dataToJson(PartnerData data) => json.encode(data.toJson());

class PartnerData {
  PartnerData({
    this.id,
    this.userId,
    this.eachPersonAmount,
    this.type,
    this.profilePhoto,
    this.path,
    this.name,
    this.email,
    this.mobile,
    this.businessName,
    this.businessEmail,
    this.businessMobile,
    this.latitude,
    this.longitude,
    this.address,
    this.locAddress,
    this.isFreeSelfPicking,
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
    this.categories,
    this.services,
    this.serviceImages,
    this.about,
    this.showContacts,
    this.partnerType,
    this.documentName,
    this.documentNumber,
    this.document,
    this.isLive,
    this.accessToken,
  });

  PartnerData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    eachPersonAmount = json['each_person_amount'];
    type = json['type'];
    profilePhoto = json['profile_photo'];
    path = json['path'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    businessName = json['business_name'];
    businessEmail = json['business_email'];
    businessMobile = json['business_mobile'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    locAddress = json['loc_address'];
    isFreeSelfPicking = json['is_free_self_picking'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
    stateName = json['state_name'];
    cityName = json['city_name'];
    pincode = json['pincode'];
    reason = json['reason'];
    orderTypes = json['order_types'] != null ? json['order_types'].cast<String>() : [];
    isFeatured = json['is_featured'];
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories?.add(PartnerCategories.fromJson(v));
      });
    }
    services = json['services'];
    if (json['service_images'] != null) {
      serviceImages = [];
      json['service_images'].forEach((v) {
        serviceImages?.add(ServiceImages.fromJson(v));
      });
    }
    about = json['about'];

    showContacts = json['show_contacts'];
    partnerType = json['partner_type'];
    documentName = json['document_name'];
    documentNumber = json['document_number'];
    if (json['document'] != null) {
      document = [];
      json['document'].forEach((v) {
        document?.add(Document.fromJson(v));
      });
    }
    isLive = json['is_live'];
    accessToken = json['access_token'];
  }

  num? id;
  num? userId;
  num? eachPersonAmount;
  String? type;
  String? profilePhoto;
  String? path;
  String? name;
  String? email;
  String? mobile;
  String? businessName;
  String? businessEmail;
  String? businessMobile;
  String? latitude;
  String? longitude;
  String? address;
  String? locAddress;
  String? isFreeSelfPicking;
  num? countryId;
  num? stateId;
  num? cityId;
  String? countryCode;
  String? countryName;
  String? stateName;
  String? cityName;
  dynamic pincode;
  String? reason;
  List<String>? orderTypes;
  String? isFeatured;
  List<PartnerCategories>? categories;
  dynamic services;
  List<ServiceImages>? serviceImages;
  String? about;

  String? showContacts;
  String? partnerType;
  String? documentName;
  String? documentNumber;
  List<Document>? document;
  String? isLive;
  String? accessToken;

  PartnerData copyWith({
    num? id,
    num? userId,
    num? eachPersonAmount,
    String? type,
    String? profilePhoto,
    String? path,
    String? name,
    String? email,
    String? mobile,
    String? business_name,
    String? business_email,
    String? business_mobile,
    String? latitude,
    String? longitude,
    String? address,
    String? loc_address,
    String? isFreeSelfPicking,
    num? countryId,
    num? stateId,
    num? cityId,
    String? countryCode,
    String? countryName,
    String? stateName,
    String? cityName,
    dynamic pincode,
    String? reason,
    List<String>? orderTypes,
    String? isFeatured,
    List<PartnerCategories>? categories,
    dynamic services,
    List<ServiceImages>? serviceImages,
    String? about,
    String? showContacts,
    String? partnerType,
    String? documentName,
    String? documentNumber,
    List<Document>? document,
    String? isLive,
    String? accessToken,
  }) =>
      PartnerData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        eachPersonAmount: eachPersonAmount ?? this.eachPersonAmount,
        type: type ?? this.type,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        path: path ?? this.path,
        name: name ?? this.name,
        email: email ?? this.email,
        mobile: mobile ?? this.mobile,
        businessName: business_name ?? this.businessName,
        businessEmail: business_email ?? this.businessEmail,
        businessMobile: business_mobile ?? this.businessMobile,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        address: address ?? this.address,
        locAddress: loc_address ?? this.locAddress,
        isFreeSelfPicking: isFreeSelfPicking ?? this.isFreeSelfPicking,
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
        categories: categories ?? this.categories,
        services: services ?? this.services,
        serviceImages: serviceImages ?? this.serviceImages,
        about: about ?? this.about,
        showContacts: showContacts ?? this.showContacts,
        partnerType: partnerType ?? this.partnerType,
        documentName: documentName ?? this.documentName,
        documentNumber: documentNumber ?? this.documentNumber,
        document: document ?? this.document,
        isLive: isLive ?? this.isLive,
        accessToken: accessToken ?? this.accessToken,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['each_person_amount'] = eachPersonAmount;
    map['type'] = type;
    map['profile_photo'] = profilePhoto;
    map['path'] = path;
    map['name'] = name;
    map['email'] = email;
    map['mobile'] = mobile;

    map['business_name'] = businessName;
    map['business_email'] = businessEmail;
    map['business_mobile'] = businessMobile;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['address'] = address;
    map['loc_address'] = locAddress;
    map['is_free_self_picking'] = isFreeSelfPicking;
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
    if (categories != null) {
      map['categories'] = categories?.map((v) => v.toJson()).toList();
    }
    map['services'] = services;
    if (serviceImages != null) {
      map['service_images'] = serviceImages?.map((v) => v.toJson()).toList();
    }
    map['about'] = about;
    map['is_free_self_picking'] = isFreeSelfPicking;
    map['each_person_amount'] = eachPersonAmount;
    map['show_contacts'] = showContacts;
    map['partner_type'] = partnerType;
    map['document_name'] = documentName;
    map['document_number'] = documentNumber;
    if (document != null) {
      map['document'] = document?.map((v) => v.toJson()).toList();
    }
    map['is_live'] = isLive;
    map['access_token'] = accessToken;
    return map;
  }
}

PartnerCategories categoriesFromJson(String str) => PartnerCategories.fromJson(json.decode(str));

String categoriesToJson(PartnerCategories data) => json.encode(data.toJson());

class PartnerCategories {
  PartnerCategories({
    this.id,
    this.name,
  });

  PartnerCategories.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  num? id;
  String? name;

  PartnerCategories copyWith({
    num? id,
    String? name,
  }) =>
      PartnerCategories(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}

Document documentFromJson(String str) => Document.fromJson(json.decode(str));

String documentToJson(Document data) => json.encode(data.toJson());

class Document {
  Document({
    this.path,
    this.filename,
    this.image,
  });

  Document.fromJson(dynamic json) {
    path = json['path'];
    filename = json['filename'];
    image = json['image'];
  }

  String? path;
  String? filename;
  String? image;

  Document copyWith({
    String? path,
    String? filename,
    String? image,
  }) =>
      Document(
        path: path ?? this.path,
        filename: filename ?? this.filename,
        image: image ?? this.image,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['path'] = path;
    map['filename'] = filename;
    map['image'] = image;
    return map;
  }
}
