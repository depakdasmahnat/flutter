import 'dart:convert';
import 'feeds_model.dart';

ViewFeedModel viewPostModelFromJson(String str) => ViewFeedModel.fromJson(json.decode(str));

String viewPostModelToJson(ViewFeedModel data) => json.encode(data.toJson());

class ViewFeedModel {
  ViewFeedModel({
    this.status,
    this.message,
    this.data,
  });

  ViewFeedModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? FeedsData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  FeedsData? data;

  ViewFeedModel copyWith({
    bool? status,
    String? message,
    FeedsData? data,
  }) =>
      ViewFeedModel(
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
