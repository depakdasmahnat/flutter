import 'dart:convert';
CountriesModel countriesModelFromJson(String str) => CountriesModel.fromJson(json.decode(str));
String countriesModelToJson(CountriesModel data) => json.encode(data.toJson());
class CountriesModel {
  CountriesModel({
      this.status, 
      this.message, 
      this.data,});

  CountriesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CountriesData.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<CountriesData>? data;

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

CountriesData dataFromJson(String str) => CountriesData.fromJson(json.decode(str));
String dataToJson(CountriesData data) => json.encode(data.toJson());
class CountriesData {
  CountriesData({
      this.id, 
      this.name, 
      this.code, 
      this.path, 
      this.flagImage, 
      this.sequence,});

  CountriesData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    path = json['path'];
    flagImage = json['flag_image'];
    sequence = json['sequence'];
  }
  num? id;
  String? name;
  String? code;
  String? path;
  String? flagImage;
  num? sequence;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    map['path'] = path;
    map['flag_image'] = flagImage;
    map['sequence'] = sequence;
    return map;
  }

}