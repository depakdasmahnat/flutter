import 'dart:convert';

import 'package:gaas/models/dashboard/filters_model.dart';

MyProductsModel myProductsModelFromJson(String str) => MyProductsModel.fromJson(json.decode(str));

String myProductsModelToJson(MyProductsModel data) => json.encode(data.toJson());

class MyProductsModel {
  MyProductsModel({
    this.status,
    this.message,
    this.totalPage,
    this.data,
  });

  MyProductsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(MyProductsData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  num? totalPage;
  List<MyProductsData>? data;

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

MyProductsData dataFromJson(String str) => MyProductsData.fromJson(json.decode(str));

String dataToJson(MyProductsData data) => json.encode(data.toJson());

class MyProductsData {
  MyProductsData({
    this.id,
    this.name,
    this.status,
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
    this.selected,
    this.hasChanges,
  });

  MyProductsData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    type = json['type'];
    description = json['description'];
    price = json['price'];
    mrpPrice = json['mrp_price'];
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
    selected = json['selected'];
    hasChanges = json['hasChanges'];
    if (json['filters'] != null) {
      filters = [];
      json['filters'].forEach((v) {
        filters?.add(ProductFilters.fromJson(v));
      });
    }
  }

  num? id;
  String? name;
  String? status;
  num? categoryId;
  num? subcategoryId;
  String? type;
  String? description;
  String? price;
  String? mrpPrice;
  String? image;
  String? path;

  num? unitId;
  int? initialInventory;
  int? templateId;
  String? filterIds;
  String? filterOptions;
  String? categoryName;
  dynamic subcategoryName;
  String? unitName;
  String? selected;
  bool? hasChanges;
  List<ProductFilters>? filters;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['status'] = status;
    map['category_id'] = categoryId;
    map['subcategory_id'] = subcategoryId;
    map['type'] = type;
    map['description'] = description;
    map['price'] = price;
    map['mrp_price'] = mrpPrice;
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
    map['selected'] = selected;
    map['hasChanges'] = hasChanges;
    if (filters != null) {
      map['filters'] = filters?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

ProductFilters filtersFromJson(String str) => ProductFilters.fromJson(json.decode(str));

String filtersToJson(ProductFilters data) => json.encode(data.toJson());

class ProductFilters {
  ProductFilters({
    this.id,
    this.name,
    this.selected,
  });

  ProductFilters.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    selected = json['selected'] != null ? FilterOptions.fromJson(json['selected']) : null;
  }

  num? id;
  String? name;
  FilterOptions? selected;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if (selected != null) {
      map['selected'] = selected?.toJson();
    }
    return map;
  }
}
