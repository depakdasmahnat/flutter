import 'dart:convert';

import '../dashboard/dashboard_states_model.dart';
import '../member_profile/fetchMemberProfileModel.dart';

MemberProfileModel memberProfileModelFromJson(String str) => MemberProfileModel.fromJson(json.decode(str));

String memberProfileModelToJson(MemberProfileModel data) => json.encode(data.toJson());

class MemberProfileModel {
  MemberProfileModel({
    this.status,
    this.message,
    this.data,
  });

  MemberProfileModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? MemberProfileData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  MemberProfileData? data;

  MemberProfileModel copyWith({
    bool? status,
    String? message,
    MemberProfileData? data,
  }) =>
      MemberProfileModel(
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

MemberProfileData dataFromJson(String str) => MemberProfileData.fromJson(json.decode(str));

String dataToJson(MemberProfileData data) => json.encode(data.toJson());

class MemberProfileData {
  MemberProfileData({
    this.id,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.address,
    this.nextRank,
    this.hotLeads,
    this.coldLeads,
    this.enagicId,
    this.memberId,
    this.path,
    this.profilePhoto,
    this.rank,
    this.training,
    this.memberCounts,
    this.salesTarget,
    this.pendingSales,
    this.achievedSales,
    this.currentRank,
    this.targetRank,
    this.rankPendingSales,
    this.allLists,
    this.demoSchedule,
    this.demoDone,
    this.followUp,
    this.closingDone,
    this.conversionRatio,
    this.analytics,
  });

  MemberProfileData.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    email = json['email'];
    address = json['address'];
    nextRank = json['next_rank'];
    hotLeads = json['hot_leads'];
    coldLeads = json['cold_leads'];
    enagicId = json['enagic_id'];
    memberId = json['member_id'];
    path = json['path'];
    profilePhoto = json['profile_photo'];
    rank = json['rank'];
    training = json['training'];
    memberCounts = json['member_counts'];
    salesTarget = json['sales_target'];
    pendingSales = json['pending_sales'];
    achievedSales = json['achieved_sales'];
    currentRank = json['current_rank'];
    targetRank = json['target_rank'];
    rankPendingSales = json['rank_pending_sales'];
    allLists = json['all_lists'];
    demoSchedule = json['demo_schedule'];
    demoDone = json['demo_done'];
    followUp = json['follow_up'];
    closingDone = json['closing_done'];
    conversionRatio = json['conversionRatio'];
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
  String? address;
  String? nextRank;
  num? hotLeads;
  num? coldLeads;
  String? enagicId;
  String? memberId;
  dynamic path;
  String? profilePhoto;
  String? rank;
  num? training;
  num? memberCounts;
  num? salesTarget;
  num? pendingSales;
  num? achievedSales;
  String? currentRank;
  String? targetRank;
  num? rankPendingSales;
  num? allLists;
  num? demoSchedule;
  num? demoDone;
  num? followUp;
  num? closingDone;
  num? conversionRatio;
  List<DashboardAnalytics>? analytics;

  MemberProfileData copyWith({
    num? id,
    String? firstName,
    String? lastName,
    String? mobile,
    String? email,
    String? address,
    String? nextRank,
    num? hotLeads,
    num? cold_leads,
    String? enagicId,
    String? memberId,
    dynamic path,
    String? profilePhoto,
    String? rank,
    num? training,
    num? memberCounts,
    num? salesTarget,
    num? pendingSales,
    num? achievedSales,
    String? currentRank,
    String? targetRank,
    num? rankPendingSales,
    num? allLists,
    num? demoSchedule,
    num? demoDone,
    num? followUp,
    num? closingDone,
    num? conversionRatio,
    List<DashboardAnalytics>? analytics,
  }) =>
      MemberProfileData(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobile: mobile ?? this.mobile,
        email: email ?? this.email,
        address: address ?? this.address,
        nextRank: nextRank ?? this.nextRank,
        hotLeads: hotLeads ?? this.hotLeads,
        coldLeads: cold_leads ?? this.coldLeads,
        enagicId: enagicId ?? this.enagicId,
        memberId: memberId ?? this.memberId,
        path: path ?? this.path,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        rank: rank ?? this.rank,
        training: training ?? this.training,
        memberCounts: memberCounts ?? this.memberCounts,
        salesTarget: salesTarget ?? this.salesTarget,
        pendingSales: pendingSales ?? this.pendingSales,
        achievedSales: achievedSales ?? this.achievedSales,
        currentRank: currentRank ?? this.currentRank,
        targetRank: targetRank ?? this.targetRank,
        rankPendingSales: rankPendingSales ?? this.rankPendingSales,
        allLists: allLists ?? this.allLists,
        demoSchedule: demoSchedule ?? this.demoSchedule,
        demoDone: demoDone ?? this.demoDone,
        followUp: followUp ?? this.followUp,
        closingDone: closingDone ?? this.closingDone,
        conversionRatio: conversionRatio ?? this.conversionRatio,
        analytics: analytics ?? this.analytics,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['mobile'] = mobile;
    map['email'] = email;
    map['address'] = address;
    map['next_rank'] = nextRank;
    map['hot_leads'] = hotLeads;
    map['cold_leads'] = coldLeads;
    map['enagic_id'] = enagicId;
    map['member_id'] = memberId;
    map['path'] = path;
    map['profile_photo'] = profilePhoto;
    map['rank'] = rank;
    map['training'] = training;
    map['member_counts'] = memberCounts;
    map['sales_target'] = salesTarget;
    map['pending_sales'] = pendingSales;
    map['achieved_sales'] = achievedSales;
    map['current_rank'] = currentRank;
    map['target_rank'] = targetRank;
    map['rank_pending_sales'] = rankPendingSales;
    map['all_lists'] = allLists;
    map['demo_schedule'] = demoSchedule;
    map['demo_done'] = demoDone;
    map['follow_up'] = followUp;
    map['closing_done'] = closingDone;
    map['conversionRatio'] = conversionRatio;
    if (analytics != null) {
      map['analytics'] = analytics?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}


