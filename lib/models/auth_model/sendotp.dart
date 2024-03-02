import 'dart:convert';
Sendotp sendotpFromJson(String str) => Sendotp.fromJson(json.decode(str));
String sendotpToJson(Sendotp data) => json.encode(data.toJson());
class Sendotp {
  Sendotp({
      bool? status, 
      String? message, 
      Data? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  Sendotp.fromJson(dynamic json) {
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
      String? mobile, 
      String? firstName, 
      String? lastName,
      String? countryCode,
      String? address,
    String? isMobileValidated,
      dynamic referralCode,}){
    _mobile = mobile;
    _firstName = firstName;
    _lastName = lastName;
    _address = address;
    _countryCode = countryCode;
    _isMobileValidated = isMobileValidated;
    _referralCode = referralCode;
}

  Data.fromJson(dynamic json) {
    _mobile = json['mobile'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _address = json['address'];
    _countryCode = json['country_code'];
    _isMobileValidated = json['is_mobile_validated'];
    _referralCode = json['referral_code'];
  }
  String? _mobile;
  String? _firstName;
  String? _lastName;
  String? _isMobileValidated;
  String? _address;
  String? _countryCode;
  dynamic _referralCode;

  String? get mobile => _mobile;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get isMobileValidated => _isMobileValidated;
  String? get address => _address;
  String? get countryCode => _countryCode;
  dynamic get referralCode => _referralCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobile'] = _mobile;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['address'] = _address;
    map['is_mobile_validated'] = _isMobileValidated;
    map['referral_code'] = _referralCode;
    map['country_code'] = _countryCode;
    return map;
  }

}