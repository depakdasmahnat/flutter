import 'dart:convert';

import 'day_wise_time_slots.dart';

ProducerTimeslotsModel partnerTimeslotsModelFromJson(String str) => ProducerTimeslotsModel.fromJson(json.decode(str));

String partnerTimeslotsModelToJson(ProducerTimeslotsModel data) => json.encode(data.toJson());

class ProducerTimeslotsModel {
  ProducerTimeslotsModel({
    this.status,
    this.message,
    this.data,
  });

  ProducerTimeslotsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? TimeSlotsDayData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  TimeSlotsDayData? data;

  ProducerTimeslotsModel copyWith({
    bool? status,
    String? message,
    TimeSlotsDayData? data,
  }) =>
      ProducerTimeslotsModel(
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


