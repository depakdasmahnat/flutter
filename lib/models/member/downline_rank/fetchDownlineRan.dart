import 'dart:convert';
FetchDownlineRan fetchDownlineRanFromJson(String str) => FetchDownlineRan.fromJson(json.decode(str));
String fetchDownlineRanToJson(FetchDownlineRan data) => json.encode(data.toJson());
class FetchDownlineRan {
  FetchDownlineRan({
      this.status, 
      this.message, 
      this.data,});

  FetchDownlineRan.fromJson(dynamic json) {
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