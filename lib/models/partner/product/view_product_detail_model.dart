import 'dart:convert';

import 'my_products_model.dart';

ViewProductDetailModel viewProductDetailModelFromJson(String str) => ViewProductDetailModel.fromJson(json.decode(str));

String viewProductDetailModelToJson(ViewProductDetailModel data) => json.encode(data.toJson());

class ViewProductDetailModel {
  ViewProductDetailModel({
    this.status,
    this.message,
    this.data,
  });

  ViewProductDetailModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ViewProductDetailData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  ViewProductDetailData? data;

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

ViewProductDetailData dataFromJson(String str) => ViewProductDetailData.fromJson(json.decode(str));

String dataToJson(ViewProductDetailData data) => json.encode(data.toJson());

class ViewProductDetailData {
  ViewProductDetailData({
    this.id,
    this.name,
    this.categoryId,
    this.subcategoryId,
    this.type,
    this.description,
    this.price,
    this.image,
    this.path,
    this.unitId,
    this.initialInventory,
    this.templateId,
    this.filterIds,
    this.filterOptions,
    this.categoryName,
    this.subcategoryName,
    this.unitName,
    this.filters,
  });

  ViewProductDetailData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    type = json['type'];
    description = json['description'];
    price = json['price'];
    image = json['image'];
    path = json['path'];
    unitId = json['unit_id'];
    initialInventory = json['initial_inventory'];
    templateId = json['template_id'];
    filterIds = json['filter_ids'];
    filterOptions = json['filter_options'];
    categoryName = json['category_name'];
    subcategoryName = json['subcategory_name'];
    unitName = json['unit_name'];
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
  String? description;
  String? price;
  String? image;
  String? path;
  num? unitId;
  num? initialInventory;
  num? templateId;
  String? filterIds;
  String? filterOptions;
  String? categoryName;
  dynamic subcategoryName;
  String? unitName;
  List<ProductFilters>? filters;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['category_id'] = categoryId;
    map['subcategory_id'] = subcategoryId;
    map['type'] = type;
    map['description'] = description;
    map['price'] = price;
    map['image'] = image;
    map['path'] = path;
    map['unit_id'] = unitId;
    map['initial_inventory'] = initialInventory;
    map['template_id'] = templateId;
    map['filter_ids'] = filterIds;
    map['filter_options'] = filterOptions;
    map['category_name'] = categoryName;
    map['subcategory_name'] = subcategoryName;
    map['unit_name'] = unitName;
    if (filters != null) {
      map['filters'] = filters?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
