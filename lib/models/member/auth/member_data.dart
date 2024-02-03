import 'dart:convert';

import 'package:hive/hive.dart';

part 'member_data.g.dart';

MemberData dataFromJson(String str) => MemberData.fromJson(json.decode(str));

String dataToJson(MemberData data) => json.encode(data.toJson());

@HiveType(typeId: 1)
class MemberData {
  MemberData({
    this.id,
    this.memberId,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.enagicId,
    this.profilePhoto,
    this.path,
    this.gender,
    this.leadRefType,
    this.sponsorId,
    this.sponsorName,
    this.salesFacilitatorId,
    this.salesFacilitatorName,
    this.occupation,
    this.dob,
    this.noOfFamilyMembers,
    this.illnessInFamily,
    this.disability,
    this.monthlyIncome,
    this.stateId,
    this.stateName,
    this.cityId,
    this.cityName,
    this.pincode,
    this.address,
    this.referralCode,
    this.role,
    this.url,
    this.accessToken,
  });

  MemberData.fromJson(dynamic json) {
    id = json['id'];
    memberId = json['member_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    email = json['email'];
    enagicId = json['enagic_id'];
    profilePhoto = json['profile_photo'];
    path = json['path'];
    gender = json['gender'];
    leadRefType = json['lead_ref_type'];
    sponsorId = json['sponsor_id'];
    sponsorName = json['sponsor_name'];
    salesFacilitatorId = json['sales_facilitator_id'];
    salesFacilitatorName = json['sales_facilitator_name'];
    occupation = json['occupation'];
    dob = json['dob'];
    noOfFamilyMembers = json['no_of_family_members'];
    illnessInFamily = json['illness_in_family'];
    disability = json['disability'];
    monthlyIncome = json['monthly_income'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    pincode = json['pincode'];
    address = json['address'];
    referralCode = json['referral_code'];
    role = json['role'];
    url = json['url'];
    accessToken = json['access_token'];
  }

  @HiveField(0)
  num? id;
  @HiveField(1)
  String? memberId;
  @HiveField(2)
  String? firstName;
  @HiveField(3)
  String? lastName;
  @HiveField(4)
  String? mobile;
  @HiveField(5)
  String? email;
  @HiveField(6)
  String? enagicId;
  @HiveField(7)
  String? profilePhoto;
  @HiveField(8)
  dynamic path;
  @HiveField(9)
  String? gender;
  @HiveField(10)
  dynamic leadRefType;
  @HiveField(11)
  num? sponsorId;
  @HiveField(12)
  dynamic sponsorName;
  @HiveField(13)
  dynamic salesFacilitatorId;
  @HiveField(14)
  dynamic salesFacilitatorName;
  @HiveField(15)
  dynamic occupation;
  @HiveField(16)
  dynamic dob;
  @HiveField(17)
  dynamic noOfFamilyMembers;
  @HiveField(18)
  dynamic illnessInFamily;
  @HiveField(19)
  dynamic disability;
  @HiveField(20)
  dynamic monthlyIncome;
  @HiveField(21)
  dynamic stateId;
  @HiveField(22)
  dynamic stateName;
  @HiveField(23)
  dynamic cityId;
  @HiveField(24)
  dynamic cityName;
  @HiveField(25)
  dynamic pincode;
  @HiveField(26)
  dynamic address;
  @HiveField(27)
  String? referralCode;
  @HiveField(28)
  String? role;
  @HiveField(29)
  String? url;
  @HiveField(30)
  String? accessToken;

  MemberData copyWith({
    num? id,
    String? memberId,
    String? firstName,
    String? lastName,
    String? mobile,
    String? email,
    String? enagicId,
    String? profilePhoto,
    dynamic path,
    String? gender,
    dynamic leadRefType,
    num? sponsorId,
    dynamic sponsorName,
    dynamic salesFacilitatorId,
    dynamic salesFacilitatorName,
    dynamic occupation,
    dynamic dob,
    dynamic noOfFamilyMembers,
    dynamic illnessInFamily,
    dynamic disability,
    dynamic monthlyIncome,
    dynamic stateId,
    dynamic stateName,
    dynamic cityId,
    dynamic cityName,
    dynamic pincode,
    dynamic address,
    String? referralCode,
    String? role,
    String? url,
    String? accessToken,
  }) =>
      MemberData(
        id: id ?? this.id,
        memberId: memberId ?? this.memberId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobile: mobile ?? this.mobile,
        email: email ?? this.email,
        enagicId: enagicId ?? this.enagicId,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        path: path ?? this.path,
        gender: gender ?? this.gender,
        leadRefType: leadRefType ?? this.leadRefType,
        sponsorId: sponsorId ?? this.sponsorId,
        sponsorName: sponsorName ?? this.sponsorName,
        salesFacilitatorId: salesFacilitatorId ?? this.salesFacilitatorId,
        salesFacilitatorName: salesFacilitatorName ?? this.salesFacilitatorName,
        occupation: occupation ?? this.occupation,
        dob: dob ?? this.dob,
        noOfFamilyMembers: noOfFamilyMembers ?? this.noOfFamilyMembers,
        illnessInFamily: illnessInFamily ?? this.illnessInFamily,
        disability: disability ?? this.disability,
        monthlyIncome: monthlyIncome ?? this.monthlyIncome,
        stateId: stateId ?? this.stateId,
        stateName: stateName ?? this.stateName,
        cityId: cityId ?? this.cityId,
        cityName: cityName ?? this.cityName,
        pincode: pincode ?? this.pincode,
        address: address ?? this.address,
        referralCode: referralCode ?? this.referralCode,
        role: role ?? this.role,
        url: url ?? this.url,
        accessToken: accessToken ?? this.accessToken,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['member_id'] = memberId;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['mobile'] = mobile;
    map['email'] = email;
    map['enagic_id'] = enagicId;
    map['profile_photo'] = profilePhoto;
    map['path'] = path;
    map['gender'] = gender;
    map['lead_ref_type'] = leadRefType;
    map['sponsor_id'] = sponsorId;
    map['sponsor_name'] = sponsorName;
    map['sales_facilitator_id'] = salesFacilitatorId;
    map['sales_facilitator_name'] = salesFacilitatorName;
    map['occupation'] = occupation;
    map['dob'] = dob;
    map['no_of_family_members'] = noOfFamilyMembers;
    map['illness_in_family'] = illnessInFamily;
    map['disability'] = disability;
    map['monthly_income'] = monthlyIncome;
    map['state_id'] = stateId;
    map['state_name'] = stateName;
    map['city_id'] = cityId;
    map['city_name'] = cityName;
    map['pincode'] = pincode;
    map['address'] = address;
    map['referral_code'] = referralCode;
    map['role'] = role;
    map['url'] = url;
    map['access_token'] = accessToken;
    return map;
  }
}
