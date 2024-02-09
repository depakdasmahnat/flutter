import 'dart:convert';

SendOtpModel sendOtpModelFromJson(String str) => SendOtpModel.fromJson(json.decode(str));
String sendOtpModelToJson(SendOtpModel data) => json.encode(data.toJson());
class SendOtpModel {
  SendOtpModel({
      this.status, 
      this.message, 
      this.mobile,});

  SendOtpModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    mobile = json['mobile'];
  }
  bool? status;
  String? message;
  String? mobile;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['mobile'] = mobile;
    return map;
  }

}