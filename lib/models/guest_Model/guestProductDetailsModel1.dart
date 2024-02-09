import 'dart:convert';
GuestProductDetailsModel1 guestProductDetailsModel1FromJson(String str) => GuestProductDetailsModel1.fromJson(json.decode(str));
String guestProductDetailsModel1ToJson(GuestProductDetailsModel1 data) => json.encode(data.toJson());
class GuestProductDetailsModel1 {
  GuestProductDetailsModel1({
      this.status, 
      this.message, 
      this.data,});

  GuestProductDetailsModel1.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  Data? data;

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

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.id, 
      this.name, 
      this.price, 
      this.description, 
      this.path, 
      this.productVideo, 
      this.specifications, 
      this.productImage, 
      this.images,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    description = json['description'];
    path = json['path'];
    productVideo = json['product_video'];
    if (json['specifications'] != null) {
      specifications = [];
      json['specifications'].forEach((v) {
        specifications?.add(Specifications.fromJson(v));
      });
    }
    productImage = json['product_image'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
  }
  num? id;
  String? name;
  String? price;
  String? description;
  String? path;
  String? productVideo;
  List<Specifications>? specifications;
  String? productImage;
  List<String>? images;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['price'] = price;
    map['description'] = description;
    map['path'] = path;
    map['product_video'] = productVideo;
    if (specifications != null) {
      map['specifications'] = specifications?.map((v) => v.toJson()).toList();
    }
    map['product_image'] = productImage;
    map['images'] = images;
    return map;
  }

}

Specifications specificationsFromJson(String str) => Specifications.fromJson(json.decode(str));
String specificationsToJson(Specifications data) => json.encode(data.toJson());
class Specifications {
  Specifications({
      this.title, 
      this.value,});

  Specifications.fromJson(dynamic json) {
    title = json['title'];
    value = json['value'];
  }
  String? title;
  String? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['value'] = value;
    return map;
  }

}