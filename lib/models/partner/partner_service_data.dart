import 'dart:convert';

PartnerServiceData partnerServiceDataFromJson(String str) => PartnerServiceData.fromJson(json.decode(str));

String partnerServiceDataToJson(PartnerServiceData data) => json.encode(data.toJson());

class PartnerServiceData {
  PartnerServiceData({
    required this.id,
    required this.name,
    required this.image,
    required this.route,
    this.haveMembership,
  });

  PartnerServiceData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    route = json['route'];
    haveMembership = json['haveMembership'];
  }

  String? id;
  String? name;
  String? image;
  String? route;
  bool? haveMembership;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    map['route'] = route;
    map['haveMembership'] = haveMembership;
    return map;
  }
}
