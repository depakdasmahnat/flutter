import 'dart:convert';

import '../partner/setup/timeslots_model.dart';

PartnerServiceModel partnerTimeSlotsModelFromJson(String str) =>
    PartnerServiceModel.fromJson(json.decode(str));

String partnerTimeSlotsModelToJson(PartnerServiceModel data) => json.encode(data.toJson());

class PartnerServiceModel {
  PartnerServiceModel({
    this.status,
    this.message,
    this.counts,
    this.data,
  });

  PartnerServiceModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    counts = json['counts'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PartnerServicesData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  num? counts;
  List<PartnerServicesData>? data;

  PartnerServiceModel copyWith({
    bool? status,
    String? message,
    num? counts,
    List<PartnerServicesData>? data,
  }) =>
      PartnerServiceModel(
        status: status ?? this.status,
        message: message ?? this.message,
        counts: counts ?? this.counts,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['counts'] = counts;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

PartnerServicesData dataFromJson(String str) => PartnerServicesData.fromJson(json.decode(str));

String dataToJson(PartnerServicesData data) => json.encode(data.toJson());

class PartnerServicesData {
  PartnerServicesData({
    this.type,
    this.timeslots,
  });

  PartnerServicesData.fromJson(dynamic json) {
    type = json['type'];
    if (json['timeslots'] != null) {
      timeslots = [];
      json['timeslots'].forEach((v) {
        timeslots?.add(TimeSlotsData.fromJson(v));
      });
    }
  }

  String? type;
  List<TimeSlotsData>? timeslots;

  PartnerServicesData copyWith({
    String? type,
    List<TimeSlotsData>? timeslots,
  }) =>
      PartnerServicesData(
        type: type ?? this.type,
        timeslots: timeslots ?? this.timeslots,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    if (timeslots != null) {
      map['timeslots'] = timeslots?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
