import 'dart:convert';

import 'package:gaas/models/dashboard/service/service_provider_detail.dart';

AllServiceProvidersModel allServiceProvidersModelFromJson(String str) =>
    AllServiceProvidersModel.fromJson(json.decode(str));

String allServiceProvidersModelToJson(AllServiceProvidersModel data) => json.encode(data.toJson());

class AllServiceProvidersModel {
  AllServiceProvidersModel({
    this.status,
    this.message,
    this.totalPage,
    this.data,
  });

  AllServiceProvidersModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ServiceProviderData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  num? totalPage;
  List<ServiceProviderData>? data;

  AllServiceProvidersModel copyWith({
    bool? status,
    String? message,
    num? totalPage,
    List<ServiceProviderData>? data,
  }) =>
      AllServiceProvidersModel(
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
