import 'dart:convert';
GuestCheckDemoVideoAndStep guestCheckDemoVideoAndStepFromJson(String str) => GuestCheckDemoVideoAndStep.fromJson(json.decode(str));
String guestCheckDemoVideoAndStepToJson(GuestCheckDemoVideoAndStep data) => json.encode(data.toJson());
class GuestCheckDemoVideoAndStep {
  GuestCheckDemoVideoAndStep({
      this.status, 
      this.message, 
      this.step, 
      this.mobile,
      this.data,});

  GuestCheckDemoVideoAndStep.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    step = json['step'];
    mobile = json['mobile_no'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  String? mobile;
  num? step;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['step'] = step;
    map['mobile_no'] = mobile;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.link,});

  Data.fromJson(dynamic json) {
    link = json['link'];
  }
  String? link;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['link'] = link;
    return map;
  }

}