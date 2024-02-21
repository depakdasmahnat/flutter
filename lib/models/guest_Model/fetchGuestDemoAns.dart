import 'dart:convert';
FetchGuestDemoAns fetchGuestDemoAnsFromJson(String str) => FetchGuestDemoAns.fromJson(json.decode(str));
String fetchGuestDemoAnsToJson(FetchGuestDemoAns data) => json.encode(data.toJson());
class FetchGuestDemoAns {
  FetchGuestDemoAns({
      this.status, 
      this.message, 
      this.data,});

  FetchGuestDemoAns.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? json['data'].cast<String>() : [];
  }
  bool? status;
  String? message;
  List<String>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['data'] = data;
    return map;
  }

}