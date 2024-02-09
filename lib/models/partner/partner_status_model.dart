import 'dart:convert';

PartnerStatusModel partnerStatusModelFromJson(String str) => PartnerStatusModel.fromJson(json.decode(str));

String partnerStatusModelToJson(PartnerStatusModel data) => json.encode(data.toJson());

class PartnerStatusModel {
  PartnerStatusModel({
    this.status,
    this.message,
    this.showSection,
    this.sectionMsg,
    this.freshProduce,
    this.nursery,
    this.serviceProvider,
  });

  PartnerStatusModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    showSection = json['show_section'];
    sectionMsg = json['section_msg'] != null ? PartnerSectionMsg.fromJson(json['section_msg']) : null;
    freshProduce = json['fresh_produce'] != null ? PartnerStatus.fromJson(json['fresh_produce']) : null;
    nursery = json['nursery'] != null ? PartnerStatus.fromJson(json['nursery']) : null;
    serviceProvider =
        json['service_provider'] != null ? PartnerStatus.fromJson(json['service_provider']) : null;
  }

  bool? status;
  String? message;
  bool? showSection;
  PartnerSectionMsg? sectionMsg;
  PartnerStatus? freshProduce;
  PartnerStatus? nursery;
  PartnerStatus? serviceProvider;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['show_section'] = showSection;
    if (sectionMsg != null) {
      map['section_msg'] = sectionMsg?.toJson();
    }
    if (freshProduce != null) {
      map['fresh_produce'] = freshProduce?.toJson();
    }
    if (nursery != null) {
      map['nursery'] = nursery?.toJson();
    }
    if (serviceProvider != null) {
      map['service_provider'] = serviceProvider?.toJson();
    }
    return map;
  }
}

PartnerSectionMsg sectionMsgFromJson(String str) => PartnerSectionMsg.fromJson(json.decode(str));

String sectionMsgToJson(PartnerSectionMsg data) => json.encode(data.toJson());

class PartnerSectionMsg {
  PartnerSectionMsg({
    this.title,
    this.description,
  });

  PartnerSectionMsg.fromJson(dynamic json) {
    title = json['title'];
    description = json['description'];
  }

  String? title;
  String? description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['description'] = description;
    return map;
  }
}

PartnerStatus partnerStatusFromJson(String str) => PartnerStatus.fromJson(json.decode(str));

String partnerStatusToJson(PartnerStatus data) => json.encode(data.toJson());

class PartnerStatus {
  PartnerStatus({
    this.status,
    this.message,
    this.orderCounts,
  });

  PartnerStatus.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    orderCounts = json['order_counts'];
  }

  String? status;

  String? message;
  num? orderCounts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['order_counts'] = orderCounts;
    return map;
  }
}
