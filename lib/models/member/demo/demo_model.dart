import 'dart:convert';

DemosModel demoModelFromJson(String str) => DemosModel.fromJson(json.decode(str));

String demoModelToJson(DemosModel data) => json.encode(data.toJson());

class DemosModel {
  DemosModel({
    this.status,
    this.message,
    this.dataRecords,
    this.data,
  });

  DemosModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    dataRecords = json['data_records'] != null ? DataRecords.fromJson(json['data_records']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DemosData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  DataRecords? dataRecords;
  List<DemosData>? data;

  DemosModel copyWith({
    bool? status,
    String? message,
    DataRecords? dataRecords,
    List<DemosData>? data,
  }) =>
      DemosModel(
        status: status ?? this.status,
        message: message ?? this.message,
        dataRecords: dataRecords ?? this.dataRecords,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (dataRecords != null) {
      map['data_records'] = dataRecords?.toJson();
    }
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

DemosData dataFromJson(String str) => DemosData.fromJson(json.decode(str));

String dataToJson(DemosData data) => json.encode(data.toJson());

class DemosData {
  DemosData({
    this.id,
    this.guestId,
    this.memberId,
    this.demoDate,
    this.demoTime,
    this.demoType,
    this.remarks,
    this.firstName,
    this.lastName,
    this.status,
    this.profilePhoto,
    this.path,
  });

  DemosData.fromJson(dynamic json) {
    id = json['id'];
    guestId = json['guest_id'];
    memberId = json['member_id'];
    demoDate = json['demo_date'];
    demoTime = json['demo_time'];
    demoType = json['demo_type'];
    remarks = json['remarks'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePhoto = json['profile_photo'];
    status = json['status'];
    path = json['path'];
  }

  num? id;
  String? guestId;
  num? memberId;
  String? demoDate;
  String? demoTime;
  String? demoType;
  String? remarks;
  String? firstName;
  String? lastName;
  String? status;
  dynamic profilePhoto;
  dynamic path;

  DemosData copyWith({
    num? id,
    String? guestId,
    num? memberId,
    String? demoDate,
    String? demoTime,
    String? demoType,
    String? remarks,
    String? firstName,
    String? lastName,
    String? status,
    dynamic profilePhoto,
    dynamic path,
  }) =>
      DemosData(
        id: id ?? this.id,
        guestId: guestId ?? this.guestId,
        memberId: memberId ?? this.memberId,
        demoDate: demoDate ?? this.demoDate,
        demoTime: demoTime ?? this.demoTime,
        demoType: demoType ?? this.demoType,
        remarks: remarks ?? this.remarks,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        status: status ?? this.status,
        path: path ?? this.path,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['guest_id'] = guestId;
    map['member_id'] = memberId;
    map['demo_date'] = demoDate;
    map['demo_time'] = demoTime;
    map['demo_type'] = demoType;
    map['remarks'] = remarks;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['profile_photo'] = profilePhoto;
    map['path'] = path;
    map['status'] = status;
    return map;
  }
}

DataRecords dataRecordsFromJson(String str) => DataRecords.fromJson(json.decode(str));

String dataRecordsToJson(DataRecords data) => json.encode(data.toJson());

class DataRecords {
  DataRecords({
    this.totalPage,
    this.limit,
    this.page,
  });

  DataRecords.fromJson(dynamic json) {
    totalPage = json['total_page'];
    limit = json['limit'];
    page = json['page'];
  }

  num? totalPage;
  num? limit;
  num? page;

  DataRecords copyWith({
    num? totalPage,
    num? limit,
    num? page,
  }) =>
      DataRecords(
        totalPage: totalPage ?? this.totalPage,
        limit: limit ?? this.limit,
        page: page ?? this.page,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_page'] = totalPage;
    map['limit'] = limit;
    map['page'] = page;
    return map;
  }
}
