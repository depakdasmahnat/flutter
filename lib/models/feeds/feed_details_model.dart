import 'dart:convert';

import 'feeds_data.dart';

FeedDetailsModel feedDetailsModelFromJson(String str) => FeedDetailsModel.fromJson(json.decode(str));

String feedDetailsModelToJson(FeedDetailsModel data) => json.encode(data.toJson());

class FeedDetailsModel {
  FeedDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  FeedDetailsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? FeedsData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  FeedsData? data;

  FeedDetailsModel copyWith({
    bool? status,
    String? message,
    FeedsData? data,
  }) =>
      FeedDetailsModel(
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
