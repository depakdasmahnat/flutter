import 'dart:convert';

FiltersModel filtersModelFromJson(String str) => FiltersModel.fromJson(json.decode(str));

String filtersModelToJson(FiltersModel data) => json.encode(data.toJson());

class FiltersModel {
  FiltersModel({
    this.status,
    this.message,
    this.data,
  });

  FiltersModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(FiltersData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<FiltersData>? data;

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

FiltersData dataFromJson(String str) => FiltersData.fromJson(json.decode(str));

String dataToJson(FiltersData data) => json.encode(data.toJson());

class FiltersData {
  FiltersData({
    this.id,
    this.name,
    this.selected,
    this.options,
  });

  FiltersData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    selected = json['selected'] != null ? FilterOptions.fromJson(json['selected']) : null;
    if (json['options'] != null) {
      options = [];
      json['options'].forEach((v) {
        options?.add(FilterOptions.fromJson(v));
      });
    }
  }

  num? id;
  String? name;
  FilterOptions? selected;
  List<FilterOptions>? options;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if (selected != null) {
      map['selected'] = selected?.toJson();
    }
    if (options != null) {
      map['options'] = options?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

FilterOptions optionsFromJson(String str) => FilterOptions.fromJson(json.decode(str));

String optionsToJson(FilterOptions data) => json.encode(data.toJson());

class FilterOptions {
  FilterOptions({
    this.id,
    this.name,
  });

  FilterOptions.fromJson(dynamic json) {
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
