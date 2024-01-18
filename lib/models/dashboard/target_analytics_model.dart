import 'dart:convert';

TargetAnalyticsModel targetAnalyticsModelFromJson(String str) =>
    TargetAnalyticsModel.fromJson(json.decode(str));

String targetAnalyticsModelToJson(TargetAnalyticsModel data) => json.encode(data.toJson());

class TargetAnalyticsModel {
  TargetAnalyticsModel({
    this.success,
    this.message,
    this.data,
  });

  TargetAnalyticsModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? TargetData.fromJson(json['data']) : null;
  }

  bool? success;
  String? message;
  TargetData? data;

  TargetAnalyticsModel copyWith({
    bool? success,
    String? message,
    TargetData? data,
  }) =>
      TargetAnalyticsModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

TargetData dataFromJson(String str) => TargetData.fromJson(json.decode(str));

String dataToJson(TargetData data) => json.encode(data.toJson());

class TargetData {
  TargetData({
    this.title,
    this.sales,
    this.salesTarget,
    this.pendingSales,
    this.rank,
    this.nextRank,
    this.pendingRankSales,
    this.leadsAdded,
    this.leadsClosed,
    this.leadsConversion,
    this.demoScheduled,
    this.demoCompleted,
    this.hotLeads,
    this.coldLeads,
    this.analytics,
  });

  TargetData.fromJson(dynamic json) {
    title = json['title'];
    sales = json['sales'];
    salesTarget = json['salesTarget'];
    pendingSales = json['pendingSales'];
    rank = json['rank'];
    nextRank = json['nextRank'];
    pendingRankSales = json['pendingRankSales'];
    leadsAdded = json['leadsAdded'];
    leadsClosed = json['leadsClosed'];
    leadsConversion = json['leadsConversion'];
    demoScheduled = json['demoScheduled'];
    demoCompleted = json['demoCompleted'];
    hotLeads = json['hotLeads'];
    coldLeads = json['coldLeads'];
    if (json['analytics'] != null) {
      analytics = [];
      json['analytics'].forEach((v) {
        analytics?.add(TargetAnalyticsData.fromJson(v));
      });
    }
  }

  String? title;
  num? sales;
  num? salesTarget;
  num? pendingSales;
  String? rank;
  String? nextRank;
  num? pendingRankSales;
  num? leadsAdded;
  num? leadsClosed;
  num? leadsConversion;
  num? demoScheduled;
  num? demoCompleted;
  num? hotLeads;
  num? coldLeads;
  List<TargetAnalyticsData>? analytics;

  TargetData copyWith({
    String? title,
    num? sales,
    num? salesTarget,
    num? pendingSales,
    String? rank,
    String? nextRank,
    num? pendingRankSales,
    num? leadsAdded,
    num? leadsClosed,
    num? leadsConversion,
    num? demoScheduled,
    num? demoCompleted,
    num? hotLeads,
    num? coldLeads,
    List<TargetAnalyticsData>? analytics,
  }) =>
      TargetData(
        title: title ?? this.title,
        sales: sales ?? this.sales,
        salesTarget: salesTarget ?? this.salesTarget,
        pendingSales: pendingSales ?? this.pendingSales,
        rank: rank ?? this.rank,
        nextRank: nextRank ?? this.nextRank,
        pendingRankSales: pendingRankSales ?? this.pendingRankSales,
        leadsAdded: leadsAdded ?? this.leadsAdded,
        leadsClosed: leadsClosed ?? this.leadsClosed,
        leadsConversion: leadsConversion ?? this.leadsConversion,
        demoScheduled: demoScheduled ?? this.demoScheduled,
        demoCompleted: demoCompleted ?? this.demoCompleted,
        hotLeads: hotLeads ?? this.hotLeads,
        coldLeads: coldLeads ?? this.coldLeads,
        analytics: analytics ?? this.analytics,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['sales'] = sales;
    map['salesTarget'] = salesTarget;
    map['pendingSales'] = pendingSales;
    map['rank'] = rank;
    map['nextRank'] = nextRank;
    map['pendingRankSales'] = pendingRankSales;
    map['leadsAdded'] = leadsAdded;
    map['leadsClosed'] = leadsClosed;
    map['leadsConversion'] = leadsConversion;
    map['demoScheduled'] = demoScheduled;
    map['demoCompleted'] = demoCompleted;
    map['hotLeads'] = hotLeads;
    map['coldLeads'] = coldLeads;
    if (analytics != null) {
      map['analytics'] = analytics?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

TargetAnalyticsData analyticsFromJson(String str) => TargetAnalyticsData.fromJson(json.decode(str));

String analyticsToJson(TargetAnalyticsData data) => json.encode(data.toJson());

class TargetAnalyticsData {
  TargetAnalyticsData({
    this.xAxis,
    this.yAxis,
    this.performance,
  });

  TargetAnalyticsData.fromJson(dynamic json) {
    xAxis = json['xAxis'];
    yAxis = json['yAxis'];
    performance = json['performance'];
  }

  String? xAxis;
  String? yAxis;
  num? performance;

  TargetAnalyticsData copyWith({
    String? xAxis,
    String? yAxis,
    num? performance,
  }) =>
      TargetAnalyticsData(
        xAxis: xAxis ?? this.xAxis,
        yAxis: yAxis ?? this.yAxis,
        performance: performance ?? this.performance,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['xAxis'] = xAxis;
    map['yAxis'] = yAxis;
    map['performance'] = performance;
    return map;
  }
}
