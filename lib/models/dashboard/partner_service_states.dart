import 'dart:convert';

PartnerServiceStates partnerServiceStatesFromJson(String str) => PartnerServiceStates.fromJson(json.decode(str));

String partnerServiceStatesToJson(PartnerServiceStates data) => json.encode(data.toJson());

class PartnerServiceStates {
  PartnerServiceStates({
    this.status,
    this.message,
    this.data,
  });

  PartnerServiceStates.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PartnerServiceStatesData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  PartnerServiceStatesData? data;

  PartnerServiceStates copyWith({
    bool? status,
    String? message,
    PartnerServiceStatesData? data,
  }) =>
      PartnerServiceStates(
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

PartnerServiceStatesData dataFromJson(String str) => PartnerServiceStatesData.fromJson(json.decode(str));

String dataToJson(PartnerServiceStatesData data) => json.encode(data.toJson());

class PartnerServiceStatesData {
  PartnerServiceStatesData({
    this.freshProduce,
    this.nursery,
    this.serviceProvider,
  });

  PartnerServiceStatesData.fromJson(dynamic json) {
    freshProduce = json['fresh_produce'];
    nursery = json['nursery'];
    serviceProvider = json['service_provider'];
  }

  num? freshProduce;
  num? nursery;
  num? serviceProvider;

  PartnerServiceStatesData copyWith({
    num? freshProduce,
    num? nursery,
    num? serviceProvider,
  }) =>
      PartnerServiceStatesData(
        freshProduce: freshProduce ?? this.freshProduce,
        nursery: nursery ?? this.nursery,
        serviceProvider: serviceProvider ?? this.serviceProvider,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fresh_produce'] = freshProduce;
    map['nursery'] = nursery;
    map['service_provider'] = serviceProvider;
    return map;
  }
}
