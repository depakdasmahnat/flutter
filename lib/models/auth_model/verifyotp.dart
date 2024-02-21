import 'dart:convert';

import 'package:mrwebbeast/models/auth_model/guest_data.dart';

Verifyotp verifyotpFromJson(String str) => Verifyotp.fromJson(json.decode(str));

String verifyotpToJson(Verifyotp data) => json.encode(data.toJson());

class Verifyotp {
  Verifyotp({
    bool? status,
    String? message,
    String? url,
    GuestData? data,
  }) {
    _status = status;
    _message = message;
    _url = url;
    _data = data;
  }

  Verifyotp.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _url = json['url'];
    _data = json['data'] != null ? GuestData.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  String? _url;
  GuestData? _data;

  bool? get status => _status;

  String? get message => _message;

  String? get url => _url;

  GuestData? get data => _data;

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
