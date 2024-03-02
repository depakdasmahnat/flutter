import 'dart:convert';
FetchProduct fetchProductFromJson(String str) => FetchProduct.fromJson(json.decode(str));
String fetchProductToJson(FetchProduct data) => json.encode(data.toJson());
class FetchProduct {
  FetchProduct({
      this.status, 
      this.message, 
      this.dataRecords, 
      this.data,});

  FetchProduct.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    dataRecords = json['data_records'] != null ? DataRecords.fromJson(json['data_records']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  DataRecords? dataRecords;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (dataRecords != null) {
      map['data_records'] = dataRecords?.toJson();
    }
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
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
      this.productVideo, 
      this.path, 
      this.specifications, 
      this.subHeading, 
      this.productImage,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    description = json['description'];
    productVideo = json['product_video'];
    path = json['path'];
    if (json['specifications'] != null) {
      specifications = [];
      json['specifications'].forEach((v) {
        specifications?.add(Specifications.fromJson(v));
      });
    }
    subHeading = json['sub_heading'];
    productImage = json['product_image'];
  }
  num? id;
  String? name;
  String? price;
  String? description;
  String? productVideo;
  String? path;
  List<Specifications>? specifications;
  dynamic subHeading;
  String? productImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['price'] = price;
    map['description'] = description;
    map['product_video'] = productVideo;
    map['path'] = path;
    if (specifications != null) {
      map['specifications'] = specifications?.map((v) => v.toJson()).toList();
    }
    map['sub_heading'] = subHeading;
    map['product_image'] = productImage;
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

DataRecords dataRecordsFromJson(String str) => DataRecords.fromJson(json.decode(str));
String dataRecordsToJson(DataRecords data) => json.encode(data.toJson());
class DataRecords {
  DataRecords({
      this.totalPage, 
      this.limit, 
      this.page,});

  DataRecords.fromJson(dynamic json) {
    totalPage = json['total_page'];
    limit = json['limit'];
    page = json['page'];
  }
  num? totalPage;
  num? limit;
  num? page;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_page'] = totalPage;
    map['limit'] = limit;
    map['page'] = page;
    return map;
  }

}