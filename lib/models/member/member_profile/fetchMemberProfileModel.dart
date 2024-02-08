import 'dart:convert';

FetchMemberProfileModel fetchMemberProfileModelFromJson(String str) =>
    FetchMemberProfileModel.fromJson(json.decode(str));
String fetchMemberProfileModelToJson(FetchMemberProfileModel data) =>
    json.encode(data.toJson());

class FetchMemberProfileModel {
  FetchMemberProfileModel({
    this.status,
    this.message,
    this.data,
  });

  FetchMemberProfileModel.fromJson(dynamic json) {
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
    this.id,
    this.firstName,
    this.lastName,
    this.enagicId,
    this.memberId,
    this.mobile,
    this.path,
    this.profilePhoto,
    this.address,
    this.stateId,
    this.stateName,
    this.cityId,
    this.cityName,
    this.pincode,
    this.rank,
    this.title,
    this.nextRank,
    this.sales,
    this.salesTarget,
    this.pendingSales,
    this.pendingRankSales,
    this.leadsAddded,
    this.leadsClosed,
    this.leadsConversion,
    this.demoScheduled,
    this.demoCompleted,
    this.hotLeads,
    this.coldLeads,
    this.memberCounts,
    this.achievedSales,
    this.analytics,
  });

  Data.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    enagicId = json['enagic_id'];
    memberId = json['member_id'];
    mobile = json['mobile'];
    path = json['path'];
    profilePhoto = json['profile_photo'];
    address = json['address'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    pincode = json['pincode'];
    rank = json['rank'];
    title = json['title'];
    nextRank = json['next_rank'];
    sales = json['sales'];
    salesTarget = json['sales_target'];
    pendingSales = json['pending_sales'];
    pendingRankSales = json['pending_rank_sales'];
    leadsAddded = json['leads_addded'];
    leadsClosed = json['leads_closed'];
    leadsConversion = json['leadsConversion'];
    demoScheduled = json['demoScheduled'];
    demoCompleted = json['demoCompleted'];
    hotLeads = json['hotLeads'];
    memberCounts = json['member_counts'];
    achievedSales = json['achieved_sales'];
    coldLeads = json['coldLeads'];
    if (json['analytics'] != null) {
      analytics = [];
      json['analytics'].forEach((v) {
        analytics?.add(Analytics.fromJson(v));
      });
    }
  }
  num? id;
  String? firstName;
  String? lastName;
  String? enagicId;
  String? memberId;
  String? mobile;
  dynamic path;
  dynamic profilePhoto;
  String? address;
  dynamic stateId;
  dynamic stateName;
  dynamic cityId;
  dynamic cityName;
  dynamic pincode;
  dynamic rank;
  String? title;
  dynamic nextRank;
  num? sales;
  num? salesTarget;
  num? pendingSales;
  num? pendingRankSales;
  num? leadsAddded;
  num? leadsClosed;
  num? leadsConversion;
  num? demoScheduled;
  num? demoCompleted;
  num? hotLeads;
  num? coldLeads;
  num? memberCounts;
  num? achievedSales;
  List<Analytics>? analytics;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['enagic_id'] = enagicId;
    map['member_id'] = memberId;
    map['mobile'] = mobile;
    map['path'] = path;
    map['profile_photo'] = profilePhoto;
    map['address'] = address;
    map['state_id'] = stateId;
    map['state_name'] = stateName;
    map['city_id'] = cityId;
    map['city_name'] = cityName;
    map['pincode'] = pincode;
    map['rank'] = rank;
    map['title'] = title;
    map['next_rank'] = nextRank;
    map['sales'] = sales;
    map['sales_target'] = salesTarget;
    map['pending_sales'] = pendingSales;
    map['pending_rank_sales'] = pendingRankSales;
    map['leads_addded'] = leadsAddded;
    map['leads_closed'] = leadsClosed;
    map['leadsConversion'] = leadsConversion;
    map['demoScheduled'] = demoScheduled;
    map['demoCompleted'] = demoCompleted;
    map['hotLeads'] = hotLeads;
    map['coldLeads'] = coldLeads;
    map['member_counts'] = memberCounts;
    map['achieved_sales'] = achievedSales;
    if (analytics != null) {
      map['analytics'] = analytics?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Analytics analyticsFromJson(String str) => Analytics.fromJson(json.decode(str));
String analyticsToJson(Analytics data) => json.encode(data.toJson());

class Analytics {
  Analytics({
    this.xaxis,
    this.yaxis,
    this.performance,
  });

  Analytics.fromJson(dynamic json) {
    xaxis = json['xaxis'];
    yaxis = json['yaxis'];
    performance = json['performance'];
  }
  String? xaxis;
  int? yaxis;
  int? performance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['xaxis'] = xaxis;
    map['yaxis'] = yaxis;
    map['performance'] = performance;
    return map;
  }
}
