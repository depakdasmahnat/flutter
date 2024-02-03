import 'dart:convert';

DownLineMembersModel downLineMembersModelFromJson(String str) =>
    DownLineMembersModel.fromJson(json.decode(str));

String downLineMembersModelToJson(DownLineMembersModel data) => json.encode(data.toJson());

class DownLineMembersModel {
  DownLineMembersModel({
    this.status,
    this.message,
    this.data,
  });

  DownLineMembersModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DownLineMemberData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<DownLineMemberData>? data;

  DownLineMembersModel copyWith({
    bool? status,
    String? message,
    List<DownLineMemberData>? data,
  }) =>
      DownLineMembersModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

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

DownLineMemberData dataFromJson(String str) => DownLineMemberData.fromJson(json.decode(str));

String dataToJson(DownLineMemberData data) => json.encode(data.toJson());

class DownLineMemberData {
  DownLineMemberData({
    this.id,
    this.name,
  });

  DownLineMemberData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  num? id;
  String? name;

  DownLineMemberData copyWith({
    num? id,
    String? name,
  }) =>
      DownLineMemberData(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
