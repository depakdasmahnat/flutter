import 'dart:convert';

import 'member_data.dart';

MemberAuthModel memberAuthModelFromJson(String str) => MemberAuthModel.fromJson(json.decode(str));

String memberAuthModelToJson(MemberAuthModel data) => json.encode(data.toJson());

class MemberAuthModel {
  MemberAuthModel({
    this.status,
    this.message,
    this.data,
  });

  MemberAuthModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? MemberData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  MemberData? data;

  MemberAuthModel copyWith({
    bool? status,
    String? message,
    MemberData? data,
  }) =>
      MemberAuthModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

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
