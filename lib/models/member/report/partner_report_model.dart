import 'dart:convert';

PartnerReportModel partnerReportModelFromJson(String str) => PartnerReportModel.fromJson(json.decode(str));

String partnerReportModelToJson(PartnerReportModel data) => json.encode(data.toJson());

class PartnerReportModel {
  PartnerReportModel({
    this.status,
    this.message,
    this.data,
  });

  PartnerReportModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PartnerReportData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<PartnerReportData>? data;

  PartnerReportModel copyWith({
    bool? status,
    String? message,
    List<PartnerReportData>? data,
  }) =>
      PartnerReportModel(
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

PartnerReportData dataFromJson(String str) => PartnerReportData.fromJson(json.decode(str));

String dataToJson(PartnerReportData data) => json.encode(data.toJson());

class PartnerReportData {
  PartnerReportData({
    this.id,
    this.profilePic,
    this.name,
    this.location,
    this.productId,
    this.productPrice,
    this.call,
    this.sales,
    this.target,
    this.pending,
    this.conversion,
    this.demo,
    this.training,
    this.rank,
    this.performace,
    this.turnovers,
    this.appDownloads,
    this.lists,
    this.level,
    this.levelCompletion,
    this.downline,
  });

  PartnerReportData.fromJson(dynamic json) {
    id = json['id'];
    profilePic = json['profile_pic'];
    name = json['name'];
    location = json['location'];
    productId = json['product_id'];
    productPrice = json['product_price'];
    call = json['call'];
    sales = json['sales'];
    target = json['target'];
    pending = json['pending'];
    conversion = json['conversion'];
    demo = json['demo'];
    training = json['training'];
    rank = json['rank'];
    performace = json['performace'];
    turnovers = json['turnovers'];
    appDownloads = json['app_downloads'];
    lists = json['lists'];
    level = json['level'];
    levelCompletion = json['level_completion'];
    downline = json['downline'];
  }

  num? id;
  String? profilePic;
  String? name;
  String? location;
  num? productId;
  String? productPrice;
  String? call;
  num? sales;
  num? target;
  num? pending;
  num? conversion;
  num? demo;
  num? training;
  String? rank;
  num? performace;
  num? turnovers;
  num? appDownloads;
  num? lists;
  num? level;
  num? levelCompletion;
  num? downline;

  PartnerReportData copyWith({
    num? id,
    String? profilePic,
    String? name,
    String? location,
    num? productId,
    String? productPrice,
    String? call,
    num? sales,
    num? target,
    num? pending,
    num? conversion,
    num? demo,
    num? training,
    String? rank,
    num? performace,
    num? turnovers,
    num? appDownloads,
    num? lists,
    num? level,
    num? levelCompletion,
    num? downline,
  }) =>
      PartnerReportData(
        id: id ?? this.id,
        profilePic: profilePic ?? this.profilePic,
        name: name ?? this.name,
        location: location ?? this.location,
        productId: productId ?? this.productId,
        productPrice: productPrice ?? this.productPrice,
        call: call ?? this.call,
        sales: sales ?? this.sales,
        target: target ?? this.target,
        pending: pending ?? this.pending,
        conversion: conversion ?? this.conversion,
        demo: demo ?? this.demo,
        training: training ?? this.training,
        rank: rank ?? this.rank,
        performace: performace ?? this.performace,
        turnovers: turnovers ?? this.turnovers,
        appDownloads: appDownloads ?? this.appDownloads,
        lists: lists ?? this.lists,
        level: level ?? this.level,
        levelCompletion: levelCompletion ?? this.levelCompletion,
        downline: downline ?? this.downline,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profile_pic'] = profilePic;
    map['name'] = name;
    map['location'] = location;
    map['product_id'] = productId;
    map['product_price'] = productPrice;
    map['call'] = call;
    map['sales'] = sales;
    map['target'] = target;
    map['pending'] = pending;
    map['conversion'] = conversion;
    map['demo'] = demo;
    map['training'] = training;
    map['rank'] = rank;
    map['performace'] = performace;
    map['turnovers'] = turnovers;
    map['app_downloads'] = appDownloads;
    map['lists'] = lists;
    map['level'] = level;
    map['level_completion'] = levelCompletion;
    map['downline'] = downline;
    return map;
  }
}
