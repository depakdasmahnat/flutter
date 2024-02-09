import 'dart:convert';

TimeSlotsModel timeslotsModelFromJson(String str) => TimeSlotsModel.fromJson(json.decode(str));

String timeslotsModelToJson(TimeSlotsModel data) => json.encode(data.toJson());

class TimeSlotsModel {
  TimeSlotsModel({
    this.status,
    this.message,
    this.data,
  });

  TimeSlotsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(TimeSlotsData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<TimeSlotsData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

TimeSlotsData dataFromJson(String str) => TimeSlotsData.fromJson(json.decode(str));

String dataToJson(TimeSlotsData data) => json.encode(data.toJson());

class TimeSlotsData {
  TimeSlotsData({
    this.id,
    this.partnerSlotId,
    this.name,
    this.timeRange,
    this.fromTime,
    this.toTime,
  });

  TimeSlotsData.fromJson(dynamic json) {
    id = json['id'];
    partnerSlotId = json['partner_slot_id'];
    name = json['name'];
    timeRange = json['time_range'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
  }

  num? id;
  num? partnerSlotId;
  String? name;
  String? timeRange;
  String? fromTime;
  String? toTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['partner_slot_id'] = partnerSlotId;
    map['name'] = name;
    map['time_range'] = timeRange;
    map['from_time'] = fromTime;
    map['to_time'] = toTime;
    return map;
  }
}
