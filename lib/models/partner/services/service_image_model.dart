import 'dart:convert';

ServiceImageModel serviceImageModelFromJson(String str) => ServiceImageModel.fromJson(json.decode(str));

String serviceImageModelToJson(ServiceImageModel data) => json.encode(data.toJson());

class ServiceImageModel {
  ServiceImageModel({
    this.status,
    this.message,
    this.data,
    this.path,
    this.imgWithPath,
  });

  ServiceImageModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
    path = json['path'];
    imgWithPath = json['img_with_path'];
  }

  bool? status;
  String? message;
  String? data;
  String? path;
  String? imgWithPath;

  ServiceImageModel copyWith({
    bool? status,
    String? message,
    String? data,
    String? path,
    String? imgWithPath,
  }) =>
      ServiceImageModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
        path: path ?? this.path,
        imgWithPath: imgWithPath ?? this.imgWithPath,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['data'] = data;
    map['path'] = path;
    map['img_with_path'] = imgWithPath;
    return map;
  }
}
