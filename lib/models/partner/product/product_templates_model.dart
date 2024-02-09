import 'dart:convert';

import 'my_products_model.dart';

ProductTemplatesModel productModelFromJson(String str) => ProductTemplatesModel.fromJson(json.decode(str));

String productModelToJson(ProductTemplatesModel data) => json.encode(data.toJson());

class ProductTemplatesModel {
  ProductTemplatesModel({
    this.status,
    this.message,
    this.data,
  });

  ProductTemplatesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ProductTemplatesData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<ProductTemplatesData>? data;

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

ProductTemplatesData dataFromJson(String str) => ProductTemplatesData.fromJson(json.decode(str));

String dataToJson(ProductTemplatesData data) => json.encode(data.toJson());

class ProductTemplatesData {
  ProductTemplatesData({
    this.id,
    this.name,
    this.categoryId,
    this.subcategoryId,
    this.type,
    this.units,
    this.description,
    this.image,
    this.path,
    this.categoryName,
    this.subcategoryName,
    this.imageName,
    this.filters,
  });

  ProductTemplatesData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    type = json['type'];
    if (json['units'] != null) {
      units = [];
      json['units'].forEach((v) {
        units?.add(ProductTemplateUnits.fromJson(v));
      });
    }
    description = json['description'];
    image = json['image'];
    path = json['path'];
    categoryName = json['category_name'];
    subcategoryName = json['subcategory_name'];
    imageName = json['image_name'];
    if (json['filters'] != null) {
      filters = [];
      json['filters'].forEach((v) {
        filters?.add(ProductFilters.fromJson(v));
      });
    }
  }

  num? id;
  String? name;
  num? categoryId;
  num? subcategoryId;
  String? type;
  List<ProductTemplateUnits>? units;
  String? description;
  String? image;
  String? path;
  String? categoryName;
  String? subcategoryName;
  String? imageName;
  List<ProductFilters>? filters;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['category_id'] = categoryId;
    map['subcategory_id'] = subcategoryId;
    map['type'] = type;
    if (units != null) {
      map['units'] = units?.map((v) => v.toJson()).toList();
    }
    map['description'] = description;
    map['image'] = image;
    map['path'] = path;
    map['category_name'] = categoryName;
    map['subcategory_name'] = subcategoryName;
    map['image_name'] = imageName;
    if (filters != null) {
      map['filters'] = filters?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

ProductTemplateUnits unitsFromJson(String str) => ProductTemplateUnits.fromJson(json.decode(str));

String unitsToJson(ProductTemplateUnits data) => json.encode(data.toJson());

class ProductTemplateUnits {
  ProductTemplateUnits({
    this.id,
    this.name,
  });

  ProductTemplateUnits.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  num? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
