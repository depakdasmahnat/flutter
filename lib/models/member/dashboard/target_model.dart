import 'dart:convert';

import 'dashboard_states_model.dart';

TargetModel targetModelFromJson(String str) => TargetModel.fromJson(json.decode(str));

String targetModelToJson(TargetModel data) => json.encode(data.toJson());

class TargetModel {
  TargetModel({
    this.status,
    this.message,
    this.data,
  });

  TargetModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? TargetData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  TargetData? data;

  TargetModel copyWith({
    bool? status,
    String? message,
    TargetData? data,
  }) =>
      TargetModel(
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

TargetData dataFromJson(String str) => TargetData.fromJson(json.decode(str));

String dataToJson(TargetData data) => json.encode(data.toJson());

class TargetData {
  TargetData({
    this.pendingTarget,
    this.salesTarget,
    this.achievedTarget,
    this.status,
    this.currentRank,
    this.targetRank,
    this.pendingRankTarget,
    this.conversionRatio,
    this.analytics,
    this.pinnaclePendingTarget,
    this.pinnacleSalesTarget,
    this.pinnacleAchievedTarget,
  });

  TargetData.fromJson(dynamic json) {
    pendingTarget = json['pending_target'];
    salesTarget = json['sales_target'];
    achievedTarget = json['achieved_target'];
    status = json['status'];
    currentRank = json['current_rank'];
    targetRank = json['target_rank'];
    pendingRankTarget = json['pending_rank_target'];
    conversionRatio = json['conversion_ratio'];
    if (json['analytics'] != null) {
      analytics = [];
      json['analytics'].forEach((v) {
        analytics?.add(DashboardAnalytics.fromJson(v));
      });
    }
    pinnaclePendingTarget = json['pinnacle_pending_target'];
    pinnacleSalesTarget = json['pinnacle_sales_target'];
    pinnacleAchievedTarget = json['pinnacle_achieved_target'];
  }

  num? pendingTarget;
  num? salesTarget;
  num? achievedTarget;
  String? status;
  String? currentRank;
  String? targetRank;
  num? pendingRankTarget;
  num? conversionRatio;

  List<DashboardAnalytics>? analytics;
  num? pinnaclePendingTarget;
  num? pinnacleSalesTarget;
  num? pinnacleAchievedTarget;

  TargetData copyWith({
    num? pendingTarget,
    num? salesTarget,
    num? achievedTarget,
    String? status,
    String? currentRank,
    String? targetRank,
    num? pendingRankTarget,
    num? conversionRatio,
    List<DashboardAnalytics>? analytics,
    num? pinnaclePendingTarget,
    num? pinnacleSalesTarget,
    num? pinnacleAchievedTarget,
  }) =>
      TargetData(
        pendingTarget: pendingTarget ?? this.pendingTarget,
        salesTarget: salesTarget ?? this.salesTarget,
        achievedTarget: achievedTarget ?? this.achievedTarget,
        status: status ?? this.status,
        currentRank: currentRank ?? this.currentRank,
        targetRank: targetRank ?? this.targetRank,
        pendingRankTarget: pendingRankTarget ?? this.pendingRankTarget,
        conversionRatio: conversionRatio ?? this.conversionRatio,
        analytics: analytics ?? this.analytics,
        pinnaclePendingTarget: pinnaclePendingTarget ?? this.pinnaclePendingTarget,
        pinnacleSalesTarget: pinnacleSalesTarget ?? this.pinnacleSalesTarget,
        pinnacleAchievedTarget: pinnacleAchievedTarget ?? this.pinnacleAchievedTarget,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pending_target'] = pendingTarget;
    map['sales_target'] = salesTarget;
    map['achieved_target'] = achievedTarget;
    map['status'] = status;
    map['current_rank'] = currentRank;
    map['target_rank'] = targetRank;
    map['pending_rank_target'] = pendingRankTarget;
    map['conversion_ratio'] = conversionRatio;
    if (analytics != null) {
      map['analytics'] = analytics?.map((v) => v.toJson()).toList();
    }
    map['pinnacle_pending_target'] = pinnaclePendingTarget;
    map['pinnacle_sales_target'] = pinnacleSalesTarget;
    map['pinnacle_achieved_target'] = pinnacleAchievedTarget;
    return map;
  }
}

// DashboardAnalytics analyticsFromJson(String str) => DashboardAnalytics.fromJson(json.decode(str));
//
// String analyticsToJson(DashboardAnalytics data) => json.encode(data.toJson());
//
// class DashboardAnalytics {
//   DashboardAnalytics({
//     this.xaxis,
//     this.yaxis,
//     this.performance,
//   });
//
//   DashboardAnalytics.fromJson(dynamic json) {
//     xaxis = json['xaxis'];
//     yaxis = json['yaxis'];
//     performance = json['performance'];
//   }
//
//   String? xaxis;
//   num? yaxis;
//   num? performance;
//
//   DashboardAnalytics copyWith({
//     String? xaxis,
//     num? yaxis,
//     num? performance,
//   }) =>
//       DashboardAnalytics(
//         xaxis: xaxis ?? this.xaxis,
//         yaxis: yaxis ?? this.yaxis,
//         performance: performance ?? this.performance,
//       );
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['xaxis'] = xaxis;
//     map['yaxis'] = yaxis;
//     map['performance'] = performance;
//     return map;
//   }
// }
