import 'dart:convert';

AchieversModel achieversModelFromJson(String str) => AchieversModel.fromJson(json.decode(str));

String achieversModelToJson(AchieversModel data) => json.encode(data.toJson());

class AchieversModel {
  AchieversModel({
    this.status,
    this.message,
    this.data,
    this.topListData,
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
    if (json['top_list_data'] != null) {
      topListData = [];
      json['top_list_data'].forEach((v) {
        topListData?.add(AchieversData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<AchieversData>? data;
  List<AchieversData>? topListData;

  AchieversModel copyWith({
    bool? status,
    String? message,
    List<AchieversData>? data,
    List<AchieversData>? topListData,
  }) =>
      AchieversModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
        topListData: topListData ?? this.topListData,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (topListData != null) {
      map['top_list_data'] = topListData?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

AchieversData dataFromJson(String str) => AchieversData.fromJson(json.decode(str));

String dataToJson(AchieversData data) => json.encode(data.toJson());

class AchieversData {
  AchieversData({
    this.id,
    this.firstName,
    this.lastName,
    this.sales,
    this.demo,
    this.closing,
    this.appDownloads,
    this.level,
    this.achievement,
    this.profilePhoto,
    this.turnover,
    this.performance,
  });

  AchieversData.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    sales = json['sales'];
    demo = json['demo'];
    closing = json['closing'];
    appDownloads = json['app_downloads'];
    level = json['level'];
    achievement = json['achievement'];
    profilePhoto = json['profile_photo'];
    turnover = json['turnover'];
    performance = json['performance'];
  }

  num? id;
  String? firstName;
  String? lastName;
  num? sales;
  num? demo;
  num? closing;
  num? appDownloads;
  num? level;
  String? achievement;
  String? profilePhoto;
  String? turnover;
  num? performance;

  AchieversData copyWith({
    num? id,
    String? firstName,
    String? lastName,
    num? sales,
    num? demo,
    num? closing,
    num? appDownloads,
    num? level,
    String? achievement,
    String? profilePhoto,
    String? turnover,
    num? performance,
  }) =>
      AchieversData(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        sales: sales ?? this.sales,
        demo: demo ?? this.demo,
        closing: closing ?? this.closing,
        appDownloads: appDownloads ?? this.appDownloads,
        level: level ?? this.level,
        achievement: achievement ?? this.achievement,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        turnover: turnover ?? this.turnover,
        performance: performance ?? this.performance,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['sales'] = sales;
    map['demo'] = demo;
    map['closing'] = closing;
    map['app_downloads'] = appDownloads;
    map['level'] = level;
    map['achievement'] = achievement;
    map['profile_photo'] = profilePhoto;
    map['turnover'] = turnover;
    map['performance'] = performance;
    return map;
  }
}
