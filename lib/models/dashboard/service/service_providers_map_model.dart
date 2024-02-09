import 'dart:convert';

import 'package:gaas/models/dashboard/service/service_provider_detail.dart';

ServiceProvidersMapModel serviceProvidersMapModelFromJson(String str) =>
    ServiceProvidersMapModel.fromJson(json.decode(str));

String serviceProvidersMapModelToJson(ServiceProvidersMapModel data) => json.encode(data.toJson());

class ServiceProvidersMapModel {
  ServiceProvidersMapModel({
    this.status,
    this.message,
    this.data,
  });

  ServiceProvidersMapModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ServiceProviderData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<ServiceProviderData>? data;

  ServiceProvidersMapModel copyWith({
    bool? status,
    String? message,
    List<ServiceProviderData>? data,
  }) =>
      ServiceProvidersMapModel(
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
