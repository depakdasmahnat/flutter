import 'dart:convert';

TimeCardData timeCardDataFromJson(String str) => TimeCardData.fromJson(json.decode(str));

String timeCardDataToJson(TimeCardData data) => json.encode(data.toJson());

class TimeCardData {
  TimeCardData({
    required this.id,
    required this.name,
    required this.time,
    required this.image,
  });

  TimeCardData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    time = json['time'];
    image = json['image'];
  }

  String? id;
  String? name;
  String? time;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['time'] = time;
    map['image'] = image;
    return map;
  }
}
