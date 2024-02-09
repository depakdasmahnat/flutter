import 'dart:convert';

PartnerDashboardStatesModel partnerDashboardStatesModelFromJson(String str) =>
    PartnerDashboardStatesModel.fromJson(json.decode(str));

String partnerDashboardStatesModelToJson(PartnerDashboardStatesModel data) => json.encode(data.toJson());

class PartnerDashboardStatesModel {
  PartnerDashboardStatesModel({
    this.status,
    this.message,
    this.data,
  });

  PartnerDashboardStatesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PartnerDashboardStatesData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  PartnerDashboardStatesData? data;

  PartnerDashboardStatesModel copyWith({
    bool? status,
    String? message,
    PartnerDashboardStatesData? data,
  }) =>
      PartnerDashboardStatesModel(
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

PartnerDashboardStatesData dataFromJson(String str) => PartnerDashboardStatesData.fromJson(json.decode(str));

String dataToJson(PartnerDashboardStatesData data) => json.encode(data.toJson());

class PartnerDashboardStatesData {
  PartnerDashboardStatesData({
    this.newLeads,
    this.todaysLeadHike,
    this.rating,
    this.totalLeads,
  });

  PartnerDashboardStatesData.fromJson(dynamic json) {
    newLeads = json['new_leads'];
    todaysLeadHike = json['todays_lead_hike'];
    rating = json['rating'];
    totalLeads = json['total_leads'];
  }

  num? newLeads;
  num? todaysLeadHike;
  num? rating;
  num? totalLeads;

  PartnerDashboardStatesData copyWith({
    num? newLeads,
    num? todaysLeadHike,
    num? rating,
    num? totalLeads,
  }) =>
      PartnerDashboardStatesData(
        newLeads: newLeads ?? this.newLeads,
        todaysLeadHike: todaysLeadHike ?? this.todaysLeadHike,
        rating: rating ?? this.rating,
        totalLeads: totalLeads ?? this.totalLeads,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['new_leads'] = newLeads;
    map['todays_lead_hike'] = todaysLeadHike;
    map['rating'] = rating;
    map['total_leads'] = totalLeads;
    return map;
  }
}
