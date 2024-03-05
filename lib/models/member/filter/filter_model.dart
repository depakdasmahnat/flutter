import 'dart:convert';
FilterModel filterModelFromJson(String str) => FilterModel.fromJson(json.decode(str));
String filterModelToJson(FilterModel data) => json.encode(data.toJson());
class FilterModel {
  FilterModel({
    this.status,
    this.message,
    this.data,});

  FilterModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(FilterData.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<FilterData>? data;

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

FilterData dataFromJson(String str) => FilterData.fromJson(json.decode(str));
String dataToJson(FilterData data) => json.encode(data.toJson());
class FilterData {
  FilterData({
    this.id,
    this.name,});

  FilterData.fromJson(dynamic json) {
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