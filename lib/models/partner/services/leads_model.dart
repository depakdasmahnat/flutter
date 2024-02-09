import 'dart:convert';

import 'lead_details_model.dart';

LeadsModel leadsModelFromJson(String str) => LeadsModel.fromJson(json.decode(str));

String leadsModelToJson(LeadsModel data) => json.encode(data.toJson());

class LeadsModel {
  LeadsModel({
    this.status,
    this.message,
    this.totalPage,
    this.data,
  });

  LeadsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(LeadData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  num? totalPage;
  List<LeadData>? data;

  LeadsModel copyWith({
    bool? status,
    String? message,
    num? totalPage,
    List<LeadData>? data,
  }) =>
      LeadsModel(
        status: status ?? this.status,
        message: message ?? this.message,
        totalPage: totalPage ?? this.totalPage,
        data: data ?? this.data,
      );

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
