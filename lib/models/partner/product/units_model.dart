import 'dart:convert';

UnitsModel unitsModelFromJson(String str) => UnitsModel.fromJson(json.decode(str));

String unitsModelToJson(UnitsModel data) => json.encode(data.toJson());

class UnitsModel {
  UnitsModel({
    this.status,
    this.message,
    this.data,
  });

  UnitsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(UnitData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<UnitData>? data;

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

UnitData dataFromJson(String str) => UnitData.fromJson(json.decode(str));

String dataToJson(UnitData data) => json.encode(data.toJson());

class UnitData {
  UnitData({
    this.id,
    this.name,
    this.sequence,
  });

  UnitData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    sequence = json['sequence'];
  }

  num? id;
  String? name;
  num? sequence;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['sequence'] = sequence;
    return map;
  }
}
