import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    this.status,
    this.message,
    this.data,
  });

  CategoryModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CategoryData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<CategoryData>? data;

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

CategoryData dataFromJson(String str) => CategoryData.fromJson(json.decode(str));

String dataToJson(CategoryData data) => json.encode(data.toJson());

class CategoryData {
  CategoryData({
    this.id,
    this.name,
    this.icon,
    this.path,
    this.sequence,
  });

  CategoryData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    path = json['path'];
    sequence = json['sequence'];
  }

  num? id;
  String? name;
  String? icon;
  String? path;
  num? sequence;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['icon'] = icon;
    map['path'] = path;
    map['sequence'] = sequence;
    return map;
  }
}
