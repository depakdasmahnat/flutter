import 'dart:convert';
FreshProduceData freshProduceDataFromJson(String str) => FreshProduceData.fromJson(json.decode(str));
String freshProduceDataToJson(FreshProduceData data) => json.encode(data.toJson());
class FreshProduceData {
  FreshProduceData({
     required
     this.id,
      required this.name,
    required  this.image,});

  FreshProduceData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
  String? id;
  String? name;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    return map;
  }

}