import 'user_data.dart';
import 'dart:convert';

AuthenticationModel authenticationModelFromJson(String str) => AuthenticationModel.fromJson(json.decode(str));
String authenticationModelToJson(AuthenticationModel data) => json.encode(data.toJson());
class AuthenticationModel {
  AuthenticationModel({
      this.status, 
      this.url, 
      this.message, 
      this.data,});

  AuthenticationModel.fromJson(dynamic json) {
    status = json['status'];
    url = json['url'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }
  bool? status;
  String? url;
  String? message;
  UserData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['url'] = url;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}