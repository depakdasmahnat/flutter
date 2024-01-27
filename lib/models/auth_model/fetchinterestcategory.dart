import 'dart:convert';
Fetchinterestcategory fetchinterestcategoryFromJson(String str) => Fetchinterestcategory.fromJson(json.decode(str));
String fetchinterestcategoryToJson(Fetchinterestcategory data) => json.encode(data.toJson());
class Fetchinterestcategory {
  Fetchinterestcategory({
      bool? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  Fetchinterestcategory.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Data>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      num? id, 
      String? name, 
      String? type, 
      num? position,}){
    _id = id;
    _name = name;
    _type = type;
    _position = position;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _type = json['type'];
    _position = json['position'];
  }
  num? _id;
  String? _name;
  String? _type;
  num? _position;

  num? get id => _id;
  String? get name => _name;
  String? get type => _type;
  num? get position => _position;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['type'] = _type;
    map['position'] = _position;
    return map;
  }

}