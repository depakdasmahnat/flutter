import 'dart:convert';
PinnacleListModel pinnacleListModelFromJson(String str) => PinnacleListModel.fromJson(json.decode(str));
String pinnacleListModelToJson(PinnacleListModel data) => json.encode(data.toJson());
class PinnacleListModel {
  PinnacleListModel({
      this.status, 
      this.message, 
      this.data,});

  PinnacleListModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PinnacleListData.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<PinnacleListData>? data;
PinnacleListModel copyWith({  bool? status,
  String? message,
  List<PinnacleListData>? data,
}) => PinnacleListModel(  status: status ?? this.status,
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

PinnacleListData dataFromJson(String str) => PinnacleListData.fromJson(json.decode(str));
String dataToJson(PinnacleListData data) => json.encode(data.toJson());
class PinnacleListData {
  PinnacleListData({
      this.id, 
      this.profilePic, 
      this.name, 
      this.target, 
      this.pending, 
      this.conversion, 
      this.lists, 
      this.demo, 
      this.training, 
      this.progress, 
      this.call, 
      this.achievement,});

  PinnacleListData.fromJson(dynamic json) {
    id = json['id'];
    profilePic = json['profile_pic'];
    name = json['name'];
    target = json['target'];
    pending = json['pending'];
    conversion = json['conversion'];
    lists = json['lists'];
    demo = json['demo'];
    training = json['training'];
    progress = json['progress'];
    call = json['call'];
    achievement = json['achievement'];
  }
  num? id;
  String? profilePic;
  String? name;
  num? target;
  num? pending;
  num? conversion;
  num? lists;
  num? demo;
  num? training;
  num? progress;
  String? call;
  String? achievement;
PinnacleListData copyWith({  num? id,
  String? profilePic,
  String? name,
  num? target,
  num? pending,
  num? conversion,
  num? lists,
  num? demo,
  num? training,
  num? progress,
  String? call,
  String? achievement,
}) => PinnacleListData(  id: id ?? this.id,
  profilePic: profilePic ?? this.profilePic,
  name: name ?? this.name,
  target: target ?? this.target,
  pending: pending ?? this.pending,
  conversion: conversion ?? this.conversion,
  lists: lists ?? this.lists,
  demo: demo ?? this.demo,
  training: training ?? this.training,
  progress: progress ?? this.progress,
  call: call ?? this.call,
  achievement: achievement ?? this.achievement,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profile_pic'] = profilePic;
    map['name'] = name;
    map['target'] = target;
    map['pending'] = pending;
    map['conversion'] = conversion;
    map['lists'] = lists;
    map['demo'] = demo;
    map['training'] = training;
    map['progress'] = progress;
    map['call'] = call;
    map['achievement'] = achievement;
    return map;
  }

}