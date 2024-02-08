import 'dart:convert';

Commonbanner commonbannerFromJson(String str) => Commonbanner.fromJson(json.decode(str));

String commonbannerToJson(Commonbanner data) => json.encode(data.toJson());

class Commonbanner {
  Commonbanner({
    bool? status,
    String? message,
    List<Data>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  Commonbanner.fromJson(dynamic json) {
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
    String? image,
    String? path,
    String? type,
    num? position,
  }) {
    _id = id;
    _image = image;
    _path = path;
    _position = position;
    _type = type;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _image = json['image'];
    _path = json['path'];
    _position = json['position'];
    _type = json['type'];
  }

  num? _id;
  String? _image;
  String? _path;
  String? _type;
  num? _position;

  num? get id => _id;

  String? get image => _image;
  String? get type => _type;

  String? get path => _path;

  num? get position => _position;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['image'] = _image;
    map['path'] = _path;
    map['position'] = _position;
    map['type'] = _type;
    return map;
  }
}
