import 'dart:convert';

GenrateReferralModel genrateReferralModelFromJson(String str) =>
    GenrateReferralModel.fromJson(json.decode(str));

String genrateReferralModelToJson(GenrateReferralModel data) => json.encode(data.toJson());

class GenrateReferralModel {
  GenrateReferralModel({
    this.status,
    this.message,
    this.data,
  });

  GenrateReferralModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  Data? data;

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

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    this.title,
    this.message,
    this.shareMessage,
    this.referCode,
  });

  Data.fromJson(dynamic json) {
    title = json['title'];
    message = json['message'];
    shareMessage = json['share_message'];
    referCode = json['refer_code'];
  }

  String? title;
  String? message;
  String? shareMessage;
  String? referCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['message'] = message;
    map['share_message'] = shareMessage;
    map['refer_code'] = referCode;
    return map;
  }
}
