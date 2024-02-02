import 'dart:convert';
FetchGuestProfile fetchGuestProfileFromJson(String str) => FetchGuestProfile.fromJson(json.decode(str));
String fetchGuestProfileToJson(FetchGuestProfile data) => json.encode(data.toJson());
class FetchGuestProfile {
  FetchGuestProfile({
      this.status, 
      this.message, 
      this.data,});

  FetchGuestProfile.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.id, 
      this.firstName, 
      this.lastName, 
      this.mobile, 
      this.email, 
      this.profilePhoto, 
      this.referredBy, 
      this.gender, 
      this.leadRefType, 
      this.occupation, 
      this.dob, 
      this.noOfFamilyMembers, 
      this.illnessInFamily, 
      this.stateId, 
      this.stateName,
      this.cityId,
      this.cityName,
      this.address,
      this.pincode, 
      this.deviceToken, 
      this.role, 
      this.feedback, 
      this.remarks, 
      this.status, 
      this.priority, 
      this.disability, 
      this.monthlyIncome, 
      this.sponsorId, 
      this.steps, 
      this.sponsorName,
      this.enagicId,
      this.accessToken,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    enagicId = json['enagic_id'];
    mobile = json['mobile'];
    email = json['email'];
    profilePhoto = json['profile_photo'];
    referredBy = json['referred_by'];
    gender = json['gender'];
    leadRefType = json['lead_ref_type'];
    occupation = json['occupation'];
    dob = json['dob'];
    noOfFamilyMembers = json['no_of_family_members'];
    illnessInFamily = json['illness_in_family'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    address = json['address'];
    pincode = json['pincode'];
    deviceToken = json['device_token'];
    role = json['role'];
    sponsorName = json['sponsor_name'];
    feedback = json['feedback'];
    remarks = json['remarks'];
    status = json['status'];
    priority = json['priority'];
    disability = json['disability'];
    monthlyIncome = json['monthly_income'];
    sponsorId = json['sponsor_id'];
    steps = json['steps'];
    accessToken = json['access_token'];
  }
  num? id;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? enagicId;
  String? sponsorName;
  dynamic profilePhoto;
  num? referredBy;
  String? gender;
  String? leadRefType;
  String? occupation;
  String? dob;
  num? noOfFamilyMembers;
  dynamic illnessInFamily;
  num? stateId;
  String? stateName;
  num? cityId;
  String? cityName;
  dynamic address;
  String? pincode;
  dynamic deviceToken;
  String? role;
  dynamic feedback;
  dynamic remarks;
  String? status;
  String? priority;
  String? disability;
  String? monthlyIncome;
  dynamic sponsorId;
  num? steps;
  dynamic accessToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['enagic_id'] = enagicId;
    map['last_name'] = lastName;
    map['mobile'] = mobile;
    map['sponsor_name'] = sponsorName;
    map['email'] = email;
    map['profile_photo'] = profilePhoto;
    map['referred_by'] = referredBy;
    map['gender'] = gender;
    map['lead_ref_type'] = leadRefType;
    map['occupation'] = occupation;
    map['dob'] = dob;
    map['no_of_family_members'] = noOfFamilyMembers;
    map['illness_in_family'] = illnessInFamily;
    map['state_id'] = stateId;
    map['state_name'] = stateName;
    map['city_id'] = cityId;
    map['city_name'] = cityName;
    map['address'] = address;
    map['pincode'] = pincode;
    map['device_token'] = deviceToken;
    map['role'] = role;
    map['feedback'] = feedback;
    map['remarks'] = remarks;
    map['status'] = status;
    map['priority'] = priority;
    map['disability'] = disability;
    map['monthly_income'] = monthlyIncome;
    map['sponsor_id'] = sponsorId;
    map['steps'] = steps;
    map['access_token'] = accessToken;
    return map;
  }

}