import 'dart:convert';

Fetchinterestquestions fetchinterestquestionsFromJson(String str) =>
    Fetchinterestquestions.fromJson(json.decode(str));

String fetchinterestquestionsToJson(Fetchinterestquestions data) => json.encode(data.toJson());

class Fetchinterestquestions {
  Fetchinterestquestions({
    bool? status,
    String? message,
    List<Data>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  Fetchinterestquestions.fromJson(dynamic json) {
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
    num? categoryId,
    String? question,
    List<String>? answers,
    num? position,
  }) {
    _id = id;
    _categoryId = categoryId;
    _question = question;
    _answers = answers;
    _position = position;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _categoryId = json['category_id'];
    _question = json['question'];
    _answers = json['answers'] != null ? json['answers'].cast<String>() : [];
    _position = json['position'];
  }

  num? _id;
  num? _categoryId;
  String? _question;
  List<String>? _answers;
  num? _position;

  num? get id => _id;

  num? get categoryId => _categoryId;

  String? get question => _question;

  List<String>? get answers => _answers;

  num? get position => _position;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['category_id'] = _categoryId;
    map['question'] = _question;
    map['answers'] = _answers;
    map['position'] = _position;
    return map;
  }
}
