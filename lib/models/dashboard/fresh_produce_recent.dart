import 'dart:convert';

FreshProduceRecent freshProduceRecentFromJson(String str) => FreshProduceRecent.fromJson(json.decode(str));

String freshProduceRecentToJson(FreshProduceRecent data) => json.encode(data.toJson());

class FreshProduceRecent {
  FreshProduceRecent({
    this.status,
    this.message,
    this.data,
  });

  FreshProduceRecent.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(FreshProduceRecentData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<FreshProduceRecentData>? data;

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

FreshProduceRecentData dataFromJson(String str) => FreshProduceRecentData.fromJson(json.decode(str));

String dataToJson(FreshProduceRecentData data) => json.encode(data.toJson());

class FreshProduceRecentData {
  FreshProduceRecentData({
    this.id,
    this.partnerId,
    this.partnerName,
    this.profilePhoto,
    this.path,
    this.itemCounts,
  });

  FreshProduceRecentData.fromJson(dynamic json) {
    id = json['id'];
    partnerId = json['partner_id'];
    partnerName = json['partner_name'];
    profilePhoto = json['profile_photo'];
    path = json['path'];
    itemCounts = json['item_counts'];
  }

  num? id;
  num? partnerId;
  String? partnerName;
  String? profilePhoto;
  String? path;
  int? itemCounts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['partner_id'] = partnerId;
    map['partner_name'] = partnerName;
    map['profile_photo'] = profilePhoto;
    map['path'] = path;
    map['item_counts'] = itemCounts;
    return map;
  }
}
