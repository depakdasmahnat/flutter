import 'dart:convert';

import 'feeds_data.dart';

FeedDetailsModel feedDetailsModelFromJson(String str) => FeedDetailsModel.fromJson(json.decode(str));

String feedDetailsModelToJson(FeedDetailsModel data) => json.encode(data.toJson());

class FeedDetailsModel {
  FeedDetailsModel({
    this.status,
    this.message,
    this.moreDataAvailable,
    this.data,
  });

  FeedDetailsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    moreDataAvailable = json['more_data_available'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(FeedsData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  num? moreDataAvailable;
  List<FeedsData>? data;

  FeedDetailsModel copyWith({
    bool? status,
    String? message,
    num? moreDataAvailable,
    List<FeedsData>? data,
  }) =>
      FeedDetailsModel(
        status: status ?? this.status,
        message: message ?? this.message,
        moreDataAvailable: moreDataAvailable ?? this.moreDataAvailable,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['more_data_available'] = moreDataAvailable;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
