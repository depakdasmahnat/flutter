import 'dart:convert';
BannersModel bannersModelFromJson(String str) => BannersModel.fromJson(json.decode(str));
String bannersModelToJson(BannersModel data) => json.encode(data.toJson());
class BannersModel {
  BannersModel({
      this.status, 
      this.message, 
      this.data,});

  BannersModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(BannersData.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<BannersData>? data;

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

BannersData dataFromJson(String str) => BannersData.fromJson(json.decode(str));
String dataToJson(BannersData data) => json.encode(data.toJson());
class BannersData {
  BannersData({
      this.id, 
      this.bannerFor, 
      this.image, 
      this.path, 
      this.sequence, 
      this.type, 
      this.partners, 
      this.products,});

  BannersData.fromJson(dynamic json) {
    id = json['id'];
    bannerFor = json['banner_for'];
    image = json['image'];
    path = json['path'];
    sequence = json['sequence'];
    type = json['type'];
    partners = json['partners'];
    products = json['products'];
  }
  num? id;
  String? bannerFor;
  String? image;
  String? path;
  num? sequence;
  String? type;
  String? partners;
  dynamic products;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['banner_for'] = bannerFor;
    map['image'] = image;
    map['path'] = path;
    map['sequence'] = sequence;
    map['type'] = type;
    map['partners'] = partners;
    map['products'] = products;
    return map;
  }

}