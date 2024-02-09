import 'dart:convert';

SuggestedTimesSlotsModel suggestedTimesSlotsModelFromJson(String str) =>
    SuggestedTimesSlotsModel.fromJson(json.decode(str));

String suggestedTimesSlotsModelToJson(SuggestedTimesSlotsModel data) => json.encode(data.toJson());

class SuggestedTimesSlotsModel {
  SuggestedTimesSlotsModel({
    this.status,
    this.message,
    this.data,
  });

  SuggestedTimesSlotsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(SuggestedTimesSlotsData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<SuggestedTimesSlotsData>? data;

  SuggestedTimesSlotsModel copyWith({
    bool? status,
    String? message,
    List<SuggestedTimesSlotsData>? data,
  }) =>
      SuggestedTimesSlotsModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

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

SuggestedTimesSlotsData dataFromJson(String str) => SuggestedTimesSlotsData.fromJson(json.decode(str));

String dataToJson(SuggestedTimesSlotsData data) => json.encode(data.toJson());

class SuggestedTimesSlotsData {
  SuggestedTimesSlotsData({
    this.partnerSlotId,
    this.id,
    this.name,
    this.timeRange,
    this.fromTime,
    this.toTime,
  });

  SuggestedTimesSlotsData.fromJson(dynamic json) {
    partnerSlotId = json['partner_slot_id'];
    id = json['id'];
    name = json['name'];
    timeRange = json['time_range'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
  }

  num? partnerSlotId;
  num? id;
  String? name;
  String? timeRange;
  String? fromTime;
  String? toTime;

  SuggestedTimesSlotsData copyWith({
    num? partnerSlotId,
    num? id,
    String? name,
    String? timeRange,
    String? fromTime,
    String? toTime,
  }) =>
      SuggestedTimesSlotsData(
        partnerSlotId: partnerSlotId ?? this.partnerSlotId,
        id: id ?? this.id,
        name: name ?? this.name,
        timeRange: timeRange ?? this.timeRange,
        fromTime: fromTime ?? this.fromTime,
        toTime: toTime ?? this.toTime,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['partner_slot_id'] = partnerSlotId;
    map['id'] = id;
    map['name'] = name;
    map['time_range'] = timeRange;
    map['from_time'] = fromTime;
    map['to_time'] = toTime;
    return map;
  }
}
