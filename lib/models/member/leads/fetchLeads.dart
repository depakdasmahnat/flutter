import 'dart:convert';
import 'dart:core';

FetchLeads fetchLeadsFromJson(String str) => FetchLeads.fromJson(json.decode(str));

String fetchLeadsToJson(FetchLeads data) => json.encode(data.toJson());

class FetchLeads {
  FetchLeads({
    this.status,
    this.message,
    this.dataRecords,
    this.stats,
    this.data,
  });

  FetchLeads.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    dataRecords = json['data_records'] != null ? DataRecords.fromJson(json['data_records']) : null;
    stats = json['stats'] != null ? Stats.fromJson(json['stats']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  DataRecords? dataRecords;
  Stats? stats;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (dataRecords != null) {
      map['data_records'] = dataRecords?.toJson();
    }
    if (stats != null) {
      map['stats'] = stats?.toJson();
    }
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
    this.id,
    this.firstName,
    this.lastName,
    this.mobile,
    this.profilePhoto,
    this.path,
    this.address,
    this.stateName,
    this.cityName,
    this.status,
    this.priority,
    this.parentId,
    this.demoId,
    this.demoDate,
    this.demoTime,
    this.remarks,
    this.demoStatus,
    this.memberId,
    this.rescheduleCallReason,
    this.date,
    this.time,
  });

  Data.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    profilePhoto = json['profile_photo'];
    path = json['path'];
    address = json['address'];
    stateName = json['state_name'];
    cityName = json['city_name'];
    status = json['status'];
    priority = json['priority'];
    parentId = json['parent_id'];
    demoId = json['demo_id'];
    demoDate = json['demo_date'];
    demoTime = json['demo_time'];
    remarks = json['remarks'];
    demoStatus = json['demo_status'];
    memberId = json['member_id'];
    rescheduleCallReason = json['reschedule_call_reason'];
    date = json['date'];
    time = json['time'];
  }

  num? id;
  String? firstName;
  String? lastName;
  String? mobile;
  String? profilePhoto;
  dynamic path;
  String? address;
  String? stateName;
  String? cityName;
  String? status;
  String? priority;
  num? parentId;
  num? demoId;
  String? demoDate;
  String? demoTime;
  String? remarks;
  String? demoStatus;
  String? rescheduleCallReason;
  String? date;
  String? time;
  int? memberId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['mobile'] = mobile;
    map['profile_photo'] = profilePhoto;
    map['path'] = path;
    map['address'] = address;
    map['state_name'] = stateName;
    map['city_name'] = cityName;
    map['status'] = status;
    map['priority'] = priority;
    map['parent_id'] = parentId;
    map['demo_id'] = demoId;
    map['demo_date'] = demoDate;
    map['demo_time'] = demoTime;
    map['remarks'] = remarks;
    map['demo_status'] = demoStatus;
    map['member_id'] = memberId;
    map['date'] = date;
    map['time'] = time;
    map['reschedule_call_reason'] = rescheduleCallReason;
    return map;
  }
}

Stats statsFromJson(String str) => Stats.fromJson(json.decode(str));

String statsToJson(Stats data) => json.encode(data.toJson());

class Stats {
  Stats({
    this.new1,
    this.invitationCall,
    this.demoScheduled,
    this.followup,
    this.closed,
    this.hot,
    this.warm,
    this.cold,
    this.bin,
    this.appDownloads,
  });

  Stats.fromJson(dynamic json) {
    new1 = json['new'];
    invitationCall = json['invitation_call'];
    demoScheduled = json['demo_scheduled'];
    followup = json['followup'];
    closed = json['closed'];
    hot = json['hot'];
    warm = json['warm'];
    cold = json['cold'];
    bin = json['bin'];
    appDownloads = json['app_downloads'];
  }

  num? new1;
  num? invitationCall;
  num? demoScheduled;
  num? followup;
  num? closed;
  num? hot;
  num? warm;
  num? cold;
  num? bin;
  num? appDownloads;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['new'] = new1;
    map['invitation_call'] = invitationCall;
    map['demo_scheduled'] = demoScheduled;
    map['followup'] = followup;
    map['closed'] = closed;
    map['hot'] = hot;
    map['warm'] = warm;
    map['cold'] = cold;
    map['bin'] = bin;
    map['app_downloads'] = appDownloads;
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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_page'] = totalPage;
    map['limit'] = limit;
    map['page'] = page;
    return map;
  }
}
