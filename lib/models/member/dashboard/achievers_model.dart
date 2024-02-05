import 'dart:convert';

AchieversModel achieversModelFromJson(String str) => AchieversModel.fromJson(json.decode(str));

String achieversModelToJson(AchieversModel data) => json.encode(data.toJson());

class AchieversModel {
  AchieversModel({
    this.status,
    this.message,
    this.data,
  });

  AchieversModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(AchieversData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<AchieversData>? data;

  AchieversModel copyWith({
    bool? status,
    String? message,
    List<AchieversData>? data,
  }) =>
      AchieversModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

AchieversData dataFromJson(String str) => AchieversData.fromJson(json.decode(str));

String dataToJson(AchieversData data) => json.encode(data.toJson());

class AchieversData {
  AchieversData({
    this.id,
    this.profile_pic,
    this.firstName,
    this.lastName,
    this.sales,
    this.demo,
    this.closing,
    this.rank,
    this.appDownloads,
    this.level,
    this.achievement,
  });

  AchieversData.fromJson(dynamic json) {
    id = json['id'];
    profile_pic = json['profile_pic'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    sales = json['sales'];
    demo = json['demo'];
    closing = json['closing'];
    rank = json['rank'];
    appDownloads = json['app_downloads'];
    level = json['level'];
    achievement = json['achievement'];
  }

  num? id;
  String? profile_pic;
  String? firstName;
  String? lastName;
  num? sales;
  num? demo;
  num? closing;
  num? rank;
  num? appDownloads;
  num? level;
  String? achievement;

  AchieversData copyWith({
    num? id,
    String? profile_pic,
    String? firstName,
    String? lastName,
    num? sales,
    num? demo,
    num? closing,
    num? rank,
    num? appDownloads,
    num? level,
    String? achievement,
  }) =>
      AchieversData(
        id: id ?? this.id,
        profile_pic: profile_pic ?? this.profile_pic,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        sales: sales ?? this.sales,
        demo: demo ?? this.demo,
        closing: closing ?? this.closing,
        rank: rank ?? this.rank,
        appDownloads: appDownloads ?? this.appDownloads,
        level: level ?? this.level,
        achievement: achievement ?? this.achievement,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;

    map['profile_pic'] = profile_pic;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['sales'] = sales;
    map['demo'] = demo;
    map['closing'] = closing;
    map['rank'] = rank;
    map['app_downloads'] = appDownloads;
    map['level'] = level;
    map['achievement'] = achievement;
    return map;
  }
}
