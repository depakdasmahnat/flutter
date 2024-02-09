import 'dart:convert';

DefaultModel defaultModelFromJson(String str) => DefaultModel.fromJson(json.decode(str));

String defaultModelToJson(DefaultModel data) => json.encode(data.toJson());

class DefaultModel {
  DefaultModel({
    this.status,
    this.id,
    this.message,
  });

  DefaultModel.fromJson(dynamic json) {
    status = json['status'];
    id = json['id'];
    message = json['message'];
  }

  bool? status;
  dynamic id;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['id'] = id;
    map['message'] = message;

    return map;
  }
}
