import 'dart:convert';
Verifyotp verifyotpFromJson(String str) => Verifyotp.fromJson(json.decode(str));
String verifyotpToJson(Verifyotp data) => json.encode(data.toJson());
class Verifyotp {
  Verifyotp({
      bool? status, 
      String? message, 
      String? url, 
      Data? data,}){
    _status = status;
    _message = message;
    _url = url;
    _data = data;
}

  Verifyotp.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _url = json['url'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _status;
  String? _message;
  String? _url;
  Data? _data;

  bool? get status => _status;
  String? get message => _message;
  String? get url => _url;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['url'] = _url;
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
      num? id, 
      String? firstName, 
      String? lastName, 
      String? mobile, 
      String? email, 
      dynamic profilePhoto, 
      dynamic referredBy, 
      dynamic deviceToken, 
      String? role, 
      num? steps, 
      String? accessToken,}){
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _mobile = mobile;
    _email = email;
    _profilePhoto = profilePhoto;
    _referredBy = referredBy;
    _deviceToken = deviceToken;
    _role = role;
    _steps = steps;
    _accessToken = accessToken;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _mobile = json['mobile'];
    _email = json['email'];
    _profilePhoto = json['profile_photo'];
    _referredBy = json['referred_by'];
    _deviceToken = json['device_token'];
    _role = json['role'];
    _steps = json['steps'];
    _accessToken = json['access_token'];
  }
  num? _id;
  String? _firstName;
  String? _lastName;
  String? _mobile;
  String? _email;
  dynamic _profilePhoto;
  dynamic _referredBy;
  dynamic _deviceToken;
  String? _role;
  num? _steps;
  String? _accessToken;

  num? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get mobile => _mobile;
  String? get email => _email;
  dynamic get profilePhoto => _profilePhoto;
  dynamic get referredBy => _referredBy;
  dynamic get deviceToken => _deviceToken;
  String? get role => _role;
  num? get steps => _steps;
  String? get accessToken => _accessToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['mobile'] = _mobile;
    map['email'] = _email;
    map['profile_photo'] = _profilePhoto;
    map['referred_by'] = _referredBy;
    map['device_token'] = _deviceToken;
    map['role'] = _role;
    map['steps'] = _steps;
    map['access_token'] = _accessToken;
    return map;
  }

}