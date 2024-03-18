import 'dart:convert';

DashboardStatesModel dashboardStatesModelFromJson(String str) =>
    DashboardStatesModel.fromJson(json.decode(str));

String dashboardStatesModelToJson(DashboardStatesModel data) => json.encode(data.toJson());

class DashboardStatesModel {
  DashboardStatesModel({
    this.status,
    this.message,
    this.data,
  });

  DashboardStatesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DashboardStatesData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  DashboardStatesData? data;

  DashboardStatesModel copyWith({
    bool? status,
    String? message,
    DashboardStatesData? data,
  }) =>
      DashboardStatesModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

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

DashboardStatesData dataFromJson(String str) => DashboardStatesData.fromJson(json.decode(str));

String dataToJson(DashboardStatesData data) => json.encode(data.toJson());

class DashboardStatesData {
  DashboardStatesData({
    this.id,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.enagicId,
    this.memberId,
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
    this.memberCounts,
    this.sales,
    this.salesTarget,
    this.pendingSales,
    this.achievedSales,
    this.pendingRankSales,
    this.currentRank,
    this.targetRank,
    this.rankPendingSales,
    this.leadsAdded,
    this.leadsClosed,
    this.leadsConversion,
    this.demoScheduled,
    this.demoCompleted,
    this.invitationCall,
    this.hotLeads,
    this.warmLeads,
    this.coldLeads,
    this.total_turnover,
    this.analytics,
    this.performance,
  });

  DashboardStatesData.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    email = json['email'];
    enagicId = json['enagic_id'];
    memberId = json['member_id'];
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
    memberCounts = json['member_counts'];
    sales = json['sales'];
    salesTarget = json['sales_target'];
    pendingSales = json['pending_sales'];
    achievedSales = json['achieved_sales'];
    pendingRankSales = json['pending_rank_sales'];
    currentRank = json['current_rank'];
    targetRank = json['target_rank'];
    rankPendingSales = json['rank_pending_sales'];
    leadsAdded = json['leads_added'];
    leadsClosed = json['leads_closed'];
    leadsConversion = json['leadsConversion'];
    demoScheduled = json['demoScheduled'];
    demoCompleted = json['demoCompleted'];
    invitationCall = json['invitationCall'];
    hotLeads = json['hotLeads'];
    warmLeads = json['warmLeads'];
    coldLeads = json['coldLeads'];
    total_turnover = json['total_turnover'];
    performance = json['performance'];
    if (json['analytics'] != null) {
      analytics = [];
      json['analytics'].forEach((v) {
        analytics?.add(DashboardAnalytics.fromJson(v));
      });
    }
  }

  num? id;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? enagicId;
  String? memberId;
  dynamic path;
  String? profilePhoto;
  dynamic address;
  dynamic stateId;
  dynamic stateName;
  dynamic cityId;
  dynamic cityName;
  dynamic pincode;
  dynamic rank;
  String? title;
  dynamic nextRank;
  num? memberCounts;
  num? sales;
  num? salesTarget;
  num? pendingSales;
  num? achievedSales;
  num? pendingRankSales;
  num? currentRank;
  num? targetRank;
  num? rankPendingSales;
  num? leadsAdded;
  num? leadsClosed;
  num? leadsConversion;
  num? demoScheduled;
  num? demoCompleted;
  num? invitationCall;
  num? hotLeads;
  num? warmLeads;
  num? coldLeads;
  num? performance;
  String? total_turnover;
  List<DashboardAnalytics>? analytics;

  DashboardStatesData copyWith({
    num? id,
    String? firstName,
    String? lastName,
    String? mobile,
    String? email,
    String? enagicId,
    String? memberId,
    dynamic path,
    String? profilePhoto,
    dynamic address,
    dynamic stateId,
    dynamic stateName,
    dynamic cityId,
    dynamic cityName,
    dynamic pincode,
    dynamic rank,
    String? title,
    dynamic nextRank,
    num? memberCounts,
    num? sales,
    num? salesTarget,
    num? pendingSales,
    num? achievedSales,
    num? pendingRankSales,
    num? currentRank,
    num? targetRank,
    num? rankPendingSales,
    num? leadsAdded,
    num? leadsClosed,
    num? leadsConversion,
    num? demoScheduled,
    num? demoCompleted,
    num? invitationCall,
    num? hotLeads,
    num? warmLeads,
    num? coldLeads,
    String? totalTurnover,
    num? performance,
    List<DashboardAnalytics>? analytics,
  }) =>
      DashboardStatesData(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobile: mobile ?? this.mobile,
        email: email ?? this.email,
        enagicId: enagicId ?? this.enagicId,
        memberId: memberId ?? this.memberId,
        path: path ?? this.path,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        address: address ?? this.address,
        stateId: stateId ?? this.stateId,
        stateName: stateName ?? this.stateName,
        cityId: cityId ?? this.cityId,
        cityName: cityName ?? this.cityName,
        pincode: pincode ?? this.pincode,
        rank: rank ?? this.rank,
        title: title ?? this.title,
        nextRank: nextRank ?? this.nextRank,
        memberCounts: memberCounts ?? this.memberCounts,
        sales: sales ?? this.sales,
        salesTarget: salesTarget ?? this.salesTarget,
        pendingSales: pendingSales ?? this.pendingSales,
        achievedSales: achievedSales ?? this.achievedSales,
        pendingRankSales: pendingRankSales ?? this.pendingRankSales,
        currentRank: currentRank ?? this.currentRank,
        targetRank: targetRank ?? this.targetRank,
        rankPendingSales: rankPendingSales ?? this.rankPendingSales,
        leadsAdded: leadsAdded ?? this.leadsAdded,
        leadsClosed: leadsClosed ?? this.leadsClosed,
        leadsConversion: leadsConversion ?? this.leadsConversion,
        demoScheduled: demoScheduled ?? this.demoScheduled,
        demoCompleted: demoCompleted ?? this.demoCompleted,
        invitationCall: invitationCall ?? this.invitationCall,
        hotLeads: hotLeads ?? this.hotLeads,
        warmLeads: warmLeads ?? this.warmLeads,
        coldLeads: coldLeads ?? this.coldLeads,
        total_turnover: totalTurnover ?? this.total_turnover,
        analytics: analytics ?? this.analytics,
        performance: performance ?? this.performance,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['mobile'] = mobile;
    map['email'] = email;
    map['enagic_id'] = enagicId;
    map['member_id'] = memberId;
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
    map['member_counts'] = memberCounts;
    map['sales'] = sales;
    map['sales_target'] = salesTarget;
    map['pending_sales'] = pendingSales;
    map['achieved_sales'] = achievedSales;
    map['pending_rank_sales'] = pendingRankSales;
    map['current_rank'] = currentRank;
    map['target_rank'] = targetRank;
    map['rank_pending_sales'] = rankPendingSales;
    map['leads_added'] = leadsAdded;
    map['leads_closed'] = leadsClosed;
    map['leadsConversion'] = leadsConversion;
    map['demoScheduled'] = demoScheduled;
    map['demoCompleted'] = demoCompleted;
    map['invitationCall'] = invitationCall;
    map['hotLeads'] = hotLeads;
    map['warmLeads'] = warmLeads;
    map['coldLeads'] = coldLeads;
    map['total_turnover'] = total_turnover;
    map['performance'] = performance;
    if (analytics != null) {
      map['analytics'] = analytics?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

DashboardAnalytics analyticsFromJson(String str) => DashboardAnalytics.fromJson(json.decode(str));

String analyticsToJson(DashboardAnalytics data) => json.encode(data.toJson());

class DashboardAnalytics {
  DashboardAnalytics({
    this.xaxis,
    this.yaxis,
    this.performance,
  });

  DashboardAnalytics.fromJson(dynamic json) {
    xaxis = json['xaxis'];
    yaxis = json['yaxis'];
    performance = json['performance'];
  }

  String? xaxis;
  num? yaxis;
  num? performance;

  DashboardAnalytics copyWith({
    String? xaxis,
    num? yaxis,
    num? performance,
  }) =>
      DashboardAnalytics(
        xaxis: xaxis ?? this.xaxis,
        yaxis: yaxis ?? this.yaxis,
        performance: performance ?? this.performance,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['xaxis'] = xaxis;
    map['yaxis'] = yaxis;
    map['performance'] = performance;
    return map;
  }
}
