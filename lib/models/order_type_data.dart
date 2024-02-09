import 'dart:convert';

import '../core/enums/enums.dart';

OrderTypeData timeCardDataFromJson(String str) => OrderTypeData.fromJson(json.decode(str));

String timeCardDataToJson(OrderTypeData data) => json.encode(data.toJson());

class OrderTypeData {
  OrderTypeData({
    required this.type,
     this.image,
  });

  OrderTypeData.fromJson(dynamic json) {
    type = json['type'];
    image = json['image'];
  }

  AllOrderTypes? type;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['type'] = type;
    map['image'] = image;
    return map;
  }
}
