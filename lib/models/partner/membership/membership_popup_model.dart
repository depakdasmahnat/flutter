import 'dart:convert';
MembershipPopupModel membershipPopupModelFromJson(String str) => MembershipPopupModel.fromJson(json.decode(str));
String membershipPopupModelToJson(MembershipPopupModel data) => json.encode(data.toJson());
class MembershipPopupModel {
  MembershipPopupModel({
      this.status, 
      this.message, 
      this.data,});

  MembershipPopupModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }
  bool? status;
  String? message;
  dynamic data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['data'] = data;
    return map;
  }

}