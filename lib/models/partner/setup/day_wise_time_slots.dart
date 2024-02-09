import 'dart:convert';

import 'timeslots_model.dart';

TimeSlotsDayData timeSlotsDayFromJson(String str) => TimeSlotsDayData.fromJson(json.decode(str));

String timeSlotsDayDataToJson(TimeSlotsDayData? data) => json.encode(data?.toJson());

class TimeSlotsDayData {
  TimeSlotsDayData({
     this.type,
    required this.selfPickingAvailable,
    required this.readyToPickAvailable,
    required this.deliveryAvailable,
    required this.selfPickingTimeslots,
    required this.readyToPickTimeslots,
    required this.deliveryTimeslots,
  });

  TimeSlotsDayData.fromJson(dynamic json) {
    type = json['type'];
    selfPickingAvailable = json['selfPickingAvailable'];
    readyToPickAvailable = json['readyToPickAvailable'];
    deliveryAvailable = json['deliveryAvailable'];

    if (json['selfPickingTimeslots'] != null) {
      selfPickingTimeslots = [];
      json['selfPickingTimeslots'].forEach((v) {
        selfPickingTimeslots?.add(TimeSlotsData.fromJson(v));
      });
    }
    if (json['readyToPickTimeslots'] != null) {
      readyToPickTimeslots = [];
      json['readyToPickTimeslots'].forEach((v) {
        readyToPickTimeslots?.add(TimeSlotsData.fromJson(v));
      });
    }
    if (json['deliveryTimeslots'] != null) {
      deliveryTimeslots = [];
      json['deliveryTimeslots'].forEach((v) {
        deliveryTimeslots?.add(TimeSlotsData.fromJson(v));
      });
    }
  }
  String? type;
  bool? selfPickingAvailable;
  bool? readyToPickAvailable;
  bool? deliveryAvailable;

  List<TimeSlotsData?>? selfPickingTimeslots;
  List<TimeSlotsData?>? readyToPickTimeslots;
  List<TimeSlotsData?>? deliveryTimeslots;

  TimeSlotsDayData copyWith({
    String? type,
    bool? selfPickingAvailable,
    bool? readyToPickAvailable,
    bool? deliveryAvailable,
    List<TimeSlotsData?>? selfPickingTimeslots,
    List<TimeSlotsData?>? readyToPickTimeslots,
    List<TimeSlotsData?>? deliveryTimeslots,
  }) =>
      TimeSlotsDayData(
        type: type ?? this.type,
        selfPickingAvailable: selfPickingAvailable ?? this.selfPickingAvailable,
        readyToPickAvailable: readyToPickAvailable ?? this.readyToPickAvailable,
        deliveryAvailable: deliveryAvailable ?? this.deliveryAvailable,
        selfPickingTimeslots: selfPickingTimeslots ?? this.selfPickingTimeslots,
        readyToPickTimeslots: readyToPickTimeslots ?? this.readyToPickTimeslots,
        deliveryTimeslots: deliveryTimeslots ?? this.deliveryTimeslots,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['selfPickingAvailable'] = selfPickingAvailable;
    map['readyToPickAvailable'] = readyToPickAvailable;
    map['deliveryAvailable'] = deliveryAvailable;
    if (selfPickingTimeslots != null) {
      map['selfPickingTimeslots'] = selfPickingTimeslots?.map((v) => v?.toJson()).toList();
    }
    if (readyToPickTimeslots != null) {
      map['readyToPickTimeslots'] = readyToPickTimeslots?.map((v) => v?.toJson()).toList();
    }
    if (deliveryTimeslots != null) {
      map['deliveryTimeslots'] = deliveryTimeslots?.map((v) => v?.toJson()).toList();
    }
    return map;
  }
}


