import 'dart:convert';

DeliveryZonesModel deliveryZonesModelFromJson(String str) => DeliveryZonesModel.fromJson(json.decode(str));

String deliveryZonesModelToJson(DeliveryZonesModel data) => json.encode(data.toJson());

class DeliveryZonesModel {
  DeliveryZonesModel({
    this.status,
    this.message,
    this.data,
  });

  DeliveryZonesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DeliveryZonesData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<DeliveryZonesData>? data;

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

DeliveryZonesData dataFromJson(String str) => DeliveryZonesData.fromJson(json.decode(str));

String dataToJson(DeliveryZonesData data) => json.encode(data.toJson());

class DeliveryZonesData {
  DeliveryZonesData({
    this.id,
    this.userId,
    this.partnerId,
    this.type,
    this.pincode,
    this.latitude,
    this.longitude,
    this.address,
    this.kmRange,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.deletedAt,
  });

  DeliveryZonesData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    partnerId = json['partner_id'];
    type = json['type'];
    pincode = json['pincode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    kmRange = json['km_range'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    deletedAt = json['deleted_at'];
  }

  num? id;
  num? userId;
  num? partnerId;
  String? type;
  String? pincode;
  String? latitude;
  String? longitude;
  String? address;
  num? kmRange;
  String? createdAt;
  String? updatedAt;
  String? status;
  dynamic deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['partner_id'] = partnerId;
    map['type'] = type;
    map['pincode'] = pincode;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['address'] = address;
    map['km_range'] = kmRange;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['status'] = status;
    map['deleted_at'] = deletedAt;
    return map;
  }
}
