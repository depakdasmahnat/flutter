import 'dart:convert';

UserData dataFromJson(String str) => UserData.fromJson(json.decode(str));

String dataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.countryCode,
    this.profilePhoto,
    this.providerId,
    this.referralCode,
    this.latitude,
    this.longitude,
    this.address,
    this.locAddress,
    this.countryId,
    this.stateId,
    this.cityId,
    this.countryName,
    this.stateName,
    this.cityName,
    this.role,
    this.deviceToken,
    this.eachCoinAmount,
    this.balanceCoins,
    this.accessToken,
  });

  UserData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    profilePhoto = json['profile_photo'];
    providerId = json['provider_id'];
    referralCode = json['referral_code'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    countryName = json['country_name'];
    stateName = json['state_name'];
    cityName = json['city_name'];
    role = json['role'];
    deviceToken = json['device_token'];
    eachCoinAmount = json['each_coin_amount'];
    balanceCoins = json['balance_coins'];
    accessToken = json['access_token'];
  }

  num? id;
  String? name;
  String? email;
  String? mobile;
  dynamic countryCode;
  String? profilePhoto;
  dynamic providerId;
  String? referralCode;
  String? latitude;
  String? longitude;
  String? address;
  String? locAddress;
  dynamic countryId;
  dynamic stateId;
  dynamic cityId;
  dynamic countryName;
  dynamic stateName;
  dynamic cityName;
  String? role;
  num? eachCoinAmount;
  num? balanceCoins;
  dynamic deviceToken;
  dynamic accessToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['mobile'] = mobile;
    map['country_code'] = countryCode;
    map['profile_photo'] = profilePhoto;
    map['provider_id'] = providerId;
    map['referral_code'] = referralCode;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['address'] = address;
    map['loc_address'] = locAddress;
    map['country_id'] = countryId;
    map['state_id'] = stateId;
    map['city_id'] = cityId;
    map['country_name'] = countryName;
    map['state_name'] = stateName;
    map['city_name'] = cityName;
    map['role'] = role;
    map['device_token'] = deviceToken;
    map['each_coin_amount'] = eachCoinAmount;
    map['balance_coins'] = balanceCoins;
    map['access_token'] = accessToken;
    return map;
  }
}
