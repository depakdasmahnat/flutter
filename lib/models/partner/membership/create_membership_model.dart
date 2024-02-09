import 'dart:convert';
CreateMembershipModel createMembershipModelFromJson(String str) => CreateMembershipModel.fromJson(json.decode(str));
String createMembershipModelToJson(CreateMembershipModel data) => json.encode(data.toJson());
class CreateMembershipModel {
  CreateMembershipModel({
      this.status, 
      this.message, 
      this.data,});

  CreateMembershipModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CreateMembershipData.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  CreateMembershipData? data;

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

CreateMembershipData dataFromJson(String str) => CreateMembershipData.fromJson(json.decode(str));
String dataToJson(CreateMembershipData data) => json.encode(data.toJson());
class CreateMembershipData {
  CreateMembershipData({
      this.id, 
      this.userId, 
      this.partnerId, 
      this.paidAmount, 
      this.type, 
      this.duration, 
      this.unit, 
      this.days, 
      this.startedAt, 
      this.expiredAt, 
      this.status, 
      this.createdAt, 
      this.updatedAt, 
      this.deletedAt, 
      this.startedDatetime, 
      this.expiredDatetime,});

  CreateMembershipData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    partnerId = json['partner_id'];
    paidAmount = json['paid_amount'];
    type = json['type'];
    duration = json['duration'];
    unit = json['unit'];
    days = json['days'];
    startedAt = json['started_at'];
    expiredAt = json['expired_at'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    startedDatetime = json['started_datetime'];
    expiredDatetime = json['expired_datetime'];
  }
  num? id;
  num? userId;
  num? partnerId;
  String? paidAmount;
  String? type;
  num? duration;
  String? unit;
  num? days;
  String? startedAt;
  String? expiredAt;
  String? status;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? startedDatetime;
  String? expiredDatetime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['partner_id'] = partnerId;
    map['paid_amount'] = paidAmount;
    map['type'] = type;
    map['duration'] = duration;
    map['unit'] = unit;
    map['days'] = days;
    map['started_at'] = startedAt;
    map['expired_at'] = expiredAt;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['started_datetime'] = startedDatetime;
    map['expired_datetime'] = expiredDatetime;
    return map;
  }

}