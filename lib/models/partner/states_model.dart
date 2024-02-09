import 'dart:convert';
StatesModel statesModelFromJson(String str) => StatesModel.fromJson(json.decode(str));
String statesModelToJson(StatesModel data) => json.encode(data.toJson());
class StatesModel {
  StatesModel({
      this.status, 
      this.message, 
      this.data,});

  StatesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(StatesData.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<StatesData>? data;

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

StatesData dataFromJson(String str) => StatesData.fromJson(json.decode(str));
String dataToJson(StatesData data) => json.encode(data.toJson());
class StatesData {
  StatesData({
      this.id, 
      this.countryId, 
      this.name, 
      this.sequence,});

  StatesData.fromJson(dynamic json) {
    id = json['id'];
    countryId = json['country_id'];
    name = json['name'];
    sequence = json['sequence'];
  }
  num? id;
  num? countryId;
  String? name;
  num? sequence;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['country_id'] = countryId;
    map['name'] = name;
    map['sequence'] = sequence;
    return map;
  }

}