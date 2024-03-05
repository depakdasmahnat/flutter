import 'dart:convert';

GuestLeadReport guestLeadReportFromJson(String str) => GuestLeadReport.fromJson(json.decode(str));

String guestLeadReportToJson(GuestLeadReport data) => json.encode(data.toJson());

class GuestLeadReport {
  GuestLeadReport({
    this.status,
    this.message,
    this.dataRecords,
    this.data,
  });

  GuestLeadReport.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    dataRecords = json['data_records'] != null ? DataRecords.fromJson(json['data_records']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(LeadReportData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  DataRecords? dataRecords;
  List<LeadReportData>? data;

  GuestLeadReport copyWith({
    bool? status,
    String? message,
    DataRecords? dataRecords,
    List<LeadReportData>? data,
  }) =>
      GuestLeadReport(
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

LeadReportData dataFromJson(String str) => LeadReportData.fromJson(json.decode(str));

String dataToJson(LeadReportData data) => json.encode(data.toJson());

class LeadReportData {
  LeadReportData({
    this.id,
    this.firstName,
    this.lastName,
    this.mobile,
    this.profilePhoto,
    this.path,
    this.address,
    this.status,
    this.priority,
    this.parentId,
    this.occupation,
    this.deletedAt,
    this.updatedAt,
    this.memberId,
    this.demoStatus,
    this.appDownloads,
    this.pending,
    this.count,
    this.demoDone,
    this.profileUpdated,
  });

  LeadReportData.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    profilePhoto = json['profile_photo'];
    path = json['path'];
    address = json['address'];
    status = json['status'];
    priority = json['priority'];
    parentId = json['parent_id'];
    occupation = json['occupation'];
    deletedAt = json['deleted_at'];
    updatedAt = json['updated_at'];
    memberId = json['member_id'];
    demoStatus = json['demo_status'];
    appDownloads = json['app_downloads'];
    pending = json['pending'];
    count = json['count'];
    demoDone = json['demo_done'];
    profileUpdated = json['profile_updated'];
  }

  num? id;
  String? firstName;
  String? lastName;
  String? mobile;
  dynamic profilePhoto;
  dynamic path;
  String? address;
  String? status;
  String? priority;
  num? parentId;
  String? occupation;
  dynamic deletedAt;
  String? updatedAt;
  dynamic memberId;
  dynamic demoStatus;
  num? appDownloads;
  num? pending;
  num? count;
  num? demoDone;
  String? profileUpdated;

  LeadReportData copyWith({
    num? id,
    String? firstName,
    String? lastName,
    String? mobile,
    dynamic profilePhoto,
    dynamic path,
    String? address,
    String? status,
    String? priority,
    num? parentId,
    String? occupation,
    dynamic deletedAt,
    String? updatedAt,
    dynamic memberId,
    dynamic demoStatus,
    num? appDownloads,
    num? pending,
    num? count,
    num? demoDone,
    String? profileUpdated,
  }) =>
      LeadReportData(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobile: mobile ?? this.mobile,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        path: path ?? this.path,
        address: address ?? this.address,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        parentId: parentId ?? this.parentId,
        occupation: occupation ?? this.occupation,
        deletedAt: deletedAt ?? this.deletedAt,
        updatedAt: updatedAt ?? this.updatedAt,
        memberId: memberId ?? this.memberId,
        demoStatus: demoStatus ?? this.demoStatus,
        appDownloads: appDownloads ?? this.appDownloads,
        pending: pending ?? this.pending,
        count: count ?? this.count,
        demoDone: demoDone ?? this.demoDone,
        profileUpdated: profileUpdated ?? this.profileUpdated,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['mobile'] = mobile;
    map['profile_photo'] = profilePhoto;
    map['path'] = path;
    map['address'] = address;
    map['status'] = status;
    map['priority'] = priority;
    map['parent_id'] = parentId;
    map['occupation'] = occupation;
    map['deleted_at'] = deletedAt;
    map['updated_at'] = updatedAt;
    map['member_id'] = memberId;
    map['demo_status'] = demoStatus;
    map['app_downloads'] = appDownloads;
    map['pending'] = pending;
    map['count'] = count;
    map['demo_done'] = demoDone;
    map['profile_updated'] = profileUpdated;
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
