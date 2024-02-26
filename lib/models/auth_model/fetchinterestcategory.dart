import 'dart:convert';

Fetchinterestcategory fetchinterestcategoryFromJson(String str) =>
    Fetchinterestcategory.fromJson(json.decode(str));

String fetchinterestcategoryToJson(Fetchinterestcategory data) => json.encode(data.toJson());

class Fetchinterestcategory {
  Fetchinterestcategory({
    bool? status,
    String? message,
    List<ResourceCategoryData>? data,
  }) {
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
        _data?.add(ResourceCategoryData.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<ResourceCategoryData>? _data;

  bool? get status => _status;

  String? get message => _message;

  List<ResourceCategoryData>? get data => _data;

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

ResourceCategoryData dataFromJson(String str) => ResourceCategoryData.fromJson(json.decode(str));

String dataToJson(ResourceCategoryData data) => json.encode(data.toJson());

class ResourceCategoryData {
  ResourceCategoryData({
    num? id,
    String? name,
    String? image,
    String? type,
    String? path,
    num? position,
  }) {
    _id = id;
    _name = name;
    _name = image;
    _type = type;
    _position = position;
   _path = path;
  }

  ResourceCategoryData.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _type = json['type'];
    _path = json['path'];
    _position = json['position'];
  }

  num? _id;
  String? _name;
  String? _image;
  String? _type;
  String? _path;
  num? _position;

  num? get id => _id;

  String? get name => _name;

  String? get image => _image;

  String? get type => _type;
  String? get path => _path;

  num? get position => _position;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['image'] = _image;
    map['type'] = _type;
    map['path'] = _path;
    map['position'] = _position;
    return map;
  }
}
