import 'dart:convert';

FetchFeedCategoriesModel fetchfeedcategoriesmodelFromJson(String str) =>
    FetchFeedCategoriesModel.fromJson(json.decode(str));

String fetchfeedcategoriesmodelToJson(FetchFeedCategoriesModel data) => json.encode(data.toJson());

class FetchFeedCategoriesModel {
  FetchFeedCategoriesModel({
    bool? status,
    String? message,
    List<FeedCategory>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  FetchFeedCategoriesModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(FeedCategory.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<FeedCategory>? _data;

  bool? get status => _status;

  String? get message => _message;

  List<FeedCategory>? get data => _data;

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

FeedCategory dataFromJson(String str) => FeedCategory.fromJson(json.decode(str));

String dataToJson(FeedCategory data) => json.encode(data.toJson());

class FeedCategory {
  FeedCategory({
    num? id,
    String? name,
    String? type,
    num? position,
  }) {
    _id = id;
    _name = name;
    _type = type;
    _position = position;
  }

  FeedCategory.fromJson(dynamic json) {
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
