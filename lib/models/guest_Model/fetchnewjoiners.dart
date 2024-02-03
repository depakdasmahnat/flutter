import 'dart:convert';

Fetchnewjoiners fetchnewjoinersFromJson(String str) => Fetchnewjoiners.fromJson(json.decode(str));

String fetchnewjoinersToJson(Fetchnewjoiners data) => json.encode(data.toJson());

class Fetchnewjoiners {
  Fetchnewjoiners({
    bool? status,
    String? message,
    Data? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  Fetchnewjoiners.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  Data? _data;

  bool? get status => _status;

  String? get message => _message;

  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    num? counts,
    List<Members>? members,
  }) {
    _counts = counts;
    _members = members;
  }

  Data.fromJson(dynamic json) {
    _counts = json['counts'];
    if (json['members'] != null) {
      _members = [];
      json['members'].forEach((v) {
        _members?.add(Members.fromJson(v));
      });
    }
  }

  num? _counts;
  List<Members>? _members;

  num? get counts => _counts;

  List<Members>? get members => _members;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['counts'] = _counts;
    if (_members != null) {
      map['members'] = _members?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Members membersFromJson(String str) => Members.fromJson(json.decode(str));

String membersToJson(Members data) => json.encode(data.toJson());

class Members {
  Members({
    num? id,
    String? memberId,
    String? firstName,
    String? lastName,
    String? profilePhoto,
    String? cityName,
    String? path,
  }) {
    _id = id;
    _memberId = memberId;
    _firstName = firstName;
    _lastName = lastName;
    _cityName = cityName;
    _profilePhoto = profilePhoto;
    _path = path;
  }

  Members.fromJson(dynamic json) {
    _id = json['id'];
    _memberId = json['member_id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _cityName = json['city_name'];
    _profilePhoto = json['profile_photo'];
    _path = json['path'];
  }

  num? _id;
  String? _memberId;
  String? _firstName;
  String? _lastName;
  String? _cityName;
  String? _profilePhoto;
  String? _path;

  num? get id => _id;

  String? get memberId => _memberId;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  String? get profilePhoto => _profilePhoto;

  String? get path => _path;

  String? get cityName => _cityName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['member_id'] = _memberId;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['profile_photo'] = _profilePhoto;
    map['path'] = _path;
    map['city_name'] = _cityName;
    return map;
  }
}
