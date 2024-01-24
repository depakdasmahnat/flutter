import 'dart:convert';
import 'package:hive/hive.dart';

part 'member_data.g.dart';
MemberData dataFromJson(String str) => MemberData.fromJson(json.decode(str));

String dataToJson(MemberData data) => json.encode(data.toJson());

@HiveType(typeId: 1)
class MemberData {
  MemberData({
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
    this.salesFacilitatorId,
    this.occupation,
    this.dob,
    this.noOfFamilyMembers,
    this.illnessInFamily,
    this.disability,
    this.monthlyIncome,
    this.stateId,
    this.cityId,
    this.pincode,
    this.address,
    this.referralCode,
    this.role,
    this.url,
    this.accessToken,
  });

  MemberData.fromJson(dynamic json) {
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
    salesFacilitatorId = json['sales_facilitator_id'];
    occupation = json['occupation'];
    dob = json['dob'];
    noOfFamilyMembers = json['no_of_family_members'];
    illnessInFamily = json['illness_in_family'];
    disability = json['disability'];
    monthlyIncome = json['monthly_income'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    pincode = json['pincode'];
    address = json['address'];
    referralCode = json['referral_code'];
    role = json['role'];
    url = json['url'];
    if (json['access_token'] != null) {
      accessToken = json['access_token'];
    }
  }

  @HiveField(0)
  String? memberId;
  @HiveField(1)
  String? firstName;
  @HiveField(2)
  String? lastName;
  @HiveField(3)
  String? mobile;
  @HiveField(4)
  String? email;
  @HiveField(5)
  String? enagicId;
  @HiveField(6)
  String? profilePhoto;
  @HiveField(7)
  String? path;
  @HiveField(8)
  String? gender;
  @HiveField(9)
  String? leadRefType;
  @HiveField(10)
  num? sponsorId;
  @HiveField(11)
  num? salesFacilitatorId;
  @HiveField(12)
  String? occupation;
  @HiveField(13)
  String? dob;
  @HiveField(14)
  num? noOfFamilyMembers;
  @HiveField(15)
  String? illnessInFamily;
  @HiveField(16)
  String? disability;
  @HiveField(17)
  String? monthlyIncome;
  @HiveField(18)
  num? stateId;
  @HiveField(19)
  num? cityId;
  @HiveField(20)
  String? pincode;
  @HiveField(21)
  String? address;
  @HiveField(22)
  String? referralCode;
  @HiveField(23)
  String? role;
  @HiveField(24)
  String? url;
  @HiveField(25)
  String? accessToken;

  MemberData copyWith({
    String? memberId,
    String? firstName,
    String? lastName,
    String? mobile,
    String? email,
    String? enagicId,
    dynamic profilePhoto,
    dynamic path,
    String? gender,
    String? leadRefType,
    num? sponsorId,
    num? salesFacilitatorId,
    String? occupation,
    String? dob,
    num? noOfFamilyMembers,
    dynamic illnessInFamily,
    String? disability,
    String? monthlyIncome,
    num? stateId,
    num? cityId,
    String? pincode,
    String? address,
    String? referralCode,
    String? role,
    String? url,
    String? accessToken,
  }) =>
      MemberData(
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
        salesFacilitatorId: salesFacilitatorId ?? this.salesFacilitatorId,
        occupation: occupation ?? this.occupation,
        dob: dob ?? this.dob,
        noOfFamilyMembers: noOfFamilyMembers ?? this.noOfFamilyMembers,
        illnessInFamily: illnessInFamily ?? this.illnessInFamily,
        disability: disability ?? this.disability,
        monthlyIncome: monthlyIncome ?? this.monthlyIncome,
        stateId: stateId ?? this.stateId,
        cityId: cityId ?? this.cityId,
        pincode: pincode ?? this.pincode,
        address: address ?? this.address,
        referralCode: referralCode ?? this.referralCode,
        role: role ?? this.role,
        url: url ?? this.url,
        accessToken: accessToken ?? this.accessToken,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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
    map['sales_facilitator_id'] = salesFacilitatorId;
    map['occupation'] = occupation;
    map['dob'] = dob;
    map['no_of_family_members'] = noOfFamilyMembers;
    map['illness_in_family'] = illnessInFamily;
    map['disability'] = disability;
    map['monthly_income'] = monthlyIncome;
    map['state_id'] = stateId;
    map['city_id'] = cityId;
    map['pincode'] = pincode;
    map['address'] = address;
    map['referral_code'] = referralCode;
    map['role'] = role;
    map['url'] = url;
    if (accessToken != null) {
      map['access_token'] = accessToken;
    }
    return map;
  }
}
