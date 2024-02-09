import 'dart:convert';

LocationPlacesData locationPlacesDataFromJson(String str) => LocationPlacesData.fromJson(json.decode(str));
String locationPlacesDataToJson(LocationPlacesData data) => json.encode(data.toJson());

class LocationPlacesData {
  LocationPlacesData({
    this.name,
    this.description,
    this.latitude,
    this.longitude,
  });

  LocationPlacesData.fromJson(dynamic json) {
    name = json['name'];
    description = json['description'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }
  String? name;
  String? description;
  double? latitude;
  double? longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['description'] = description;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    return map;
  }
}
