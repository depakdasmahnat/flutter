import 'dart:convert';

import 'package:hive/hive.dart';

part 'guest_data.g.dart';

GuestData dataFromJson(String str) => GuestData.fromJson(json.decode(str));

String dataToJson(GuestData data) => json.encode(data.toJson());

@HiveType(typeId: 2)
class GuestData {
  GuestData({
    this.id,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.profilePhoto,
    this.referredBy,
    this.deviceToken,
    this.sponsorMobile,
    this.role,
    this.steps,
    this.accessToken,
  });

  GuestData.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    email = json['email'];
    profilePhoto = json['profile_photo'];
    referredBy = json['referred_by'];
    deviceToken = json['device_token'];
    role = json['role'];
    steps = json['steps'];
    sponsorMobile = json['sponsor_mobile'];
    accessToken = json['access_token'];
  }

  @HiveField(0)
  num? id;
  @HiveField(1)
  String? firstName;
  @HiveField(2)
  String? lastName;
  @HiveField(3)
  String? mobile;
  @HiveField(4)
  String? email;
  @HiveField(5)
  String? profilePhoto;
  @HiveField(6)
  num? referredBy;
  @HiveField(7)
  String? deviceToken;
  @HiveField(8)
  String? role;
  @HiveField(9)
  num? steps;
  @HiveField(10)
  String? accessToken;
  @HiveField(11)
  String? sponsorMobile;

  GuestData copyWith({
    num? id,
    String? firstName,
    String? lastName,
    String? mobile,
    String? sponsorMobile,
    dynamic email,
    dynamic profilePhoto,
    dynamic referredBy,
    dynamic deviceToken,
    String? role,
    num? steps,
    String? accessToken,
  }) =>
      GuestData(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobile: mobile ?? this.mobile,
        email: email ?? this.email,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        referredBy: referredBy ?? this.referredBy,
        deviceToken: deviceToken ?? this.deviceToken,
        role: role ?? this.role,
        steps: steps ?? this.steps,
        sponsorMobile: sponsorMobile ?? this.sponsorMobile,
        accessToken: accessToken ?? this.accessToken,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['mobile'] = mobile;
    map['email'] = email;
    map['profile_photo'] = profilePhoto;
    map['referred_by'] = referredBy;
    map['device_token'] = deviceToken;
    map['role'] = role;
    map['steps'] = steps;
    map['sponsor_mobile'] = sponsorMobile;
    map['access_token'] = accessToken;
    return map;
  }
}
