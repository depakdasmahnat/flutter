import 'dart:convert';

import '../../core/enums/enums.dart';
import 'partner_status_model.dart';
JoinPartnerData joinPartnerDataFromJson(String str) => JoinPartnerData.fromJson(json.decode(str));
String joinPartnerDataToJson(JoinPartnerData data) => json.encode(data.toJson());
class JoinPartnerData {
  JoinPartnerData({
      this.status,
      this.type,});

  JoinPartnerData.fromJson(dynamic json) {
    status = json['status'];
    type = json['type'];
  }
  PartnerStatus? status;
  ServiceType? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['type'] = type;
    return map;
  }

}