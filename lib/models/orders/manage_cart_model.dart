import 'dart:convert';

ManageCartModel manageCartModelFromJson(String str) => ManageCartModel.fromJson(json.decode(str));

String manageCartModelToJson(ManageCartModel data) => json.encode(data.toJson());

class ManageCartModel {
  ManageCartModel({
    this.status,
    this.message,
    this.id,
  });

  ManageCartModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    id = json['id'];
  }

  bool? status;
  String? message;
  num? id;

  ManageCartModel copyWith({
    bool? status,
    String? message,
    num? id,
  }) =>
      ManageCartModel(
        status: status ?? this.status,
        message: message ?? this.message,
        id: id ?? this.id,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['id'] = id;
    return map;
  }
}
