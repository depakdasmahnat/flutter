import 'dart:convert';

import 'guest_data.dart';

GuestModel guestModelFromJson(String str) => GuestModel.fromJson(json.decode(str));

String guestModelToJson(GuestModel data) => json.encode(data.toJson());

class GuestModel {
  GuestModel({
    this.status,
    this.message,
    this.url,
    this.data,
  });

  GuestModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    url = json['url'];
    data = json['data'] != null ? GuestData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  String? url;
  GuestData? data;

  GuestModel copyWith({
    bool? status,
    String? message,
    String? url,
    GuestData? data,
  }) =>
      GuestModel(
        status: status ?? this.status,
        message: message ?? this.message,
        url: url ?? this.url,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['url'] = url;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}
