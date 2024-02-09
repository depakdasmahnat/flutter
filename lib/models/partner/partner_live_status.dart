import 'dart:convert';

PartnerLiveStatus partnerLiveStatusFromJson(String str) => PartnerLiveStatus.fromJson(json.decode(str));

String partnerLiveStatusToJson(PartnerLiveStatus data) => json.encode(data.toJson());

class PartnerLiveStatus {
  PartnerLiveStatus({
    this.status,
    this.message,
    this.data,
  });

  PartnerLiveStatus.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PartnerLiveStatusData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  PartnerLiveStatusData? data;

  PartnerLiveStatus copyWith({
    bool? status,
    String? message,
    PartnerLiveStatusData? data,
  }) =>
      PartnerLiveStatus(
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

PartnerLiveStatusData dataFromJson(String str) => PartnerLiveStatusData.fromJson(json.decode(str));

String dataToJson(PartnerLiveStatusData data) => json.encode(data.toJson());

class PartnerLiveStatusData {
  PartnerLiveStatusData({
    this.id,
    this.isLive,
    this.status,
  });

  PartnerLiveStatusData.fromJson(dynamic json) {
    id = json['id'];
    isLive = json['is_live'];
    status = json['status'];
  }

  num? id;
  String? isLive;
  String? status;

  PartnerLiveStatusData copyWith({
    num? id,
    String? isLive,
    String? status,
  }) =>
      PartnerLiveStatusData(
        id: id ?? this.id,
        isLive: isLive ?? this.isLive,
        status: status ?? this.status,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['is_live'] = isLive;
    map['status'] = status;
    return map;
  }
}
