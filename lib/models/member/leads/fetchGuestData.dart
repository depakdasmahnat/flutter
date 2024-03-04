import 'dart:convert';
FetchGuestData fetchGuestDataFromJson(String str) => FetchGuestData.fromJson(json.decode(str));
String fetchGuestDataToJson(FetchGuestData data) => json.encode(data.toJson());
class FetchGuestData {
  FetchGuestData({
      this.status, 
      this.message, 
      this.data,});

  FetchGuestData.fromJson(dynamic json) {
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
      this.path, 
      this.stateId, 
      this.cityId, 
      this.address, 
      this.role, 
      this.emailVerifiedAt, 
      this.deviceToken, 
      this.createdAt, 
      this.updatedAt, 
      this.isActive, 
      this.status, 
      this.priority, 
      this.deletedAt, 
      this.steps, 
      this.gender, 
      this.leadRefType, 
      this.occupation, 
      this.dob, 
      this.noOfFamilyMembers, 
      this.illnessInFamily, 
      this.pincode, 
      this.remarks, 
      this.feedback, 
      this.disability, 
      this.monthlyIncome, 
      this.sponsorId, 
      this.rescheduleCallReason, 
      this.invitationCallDateTime, 
      this.businessDemoDateTime, 
      this.demoSteps, 
      this.productDemoDateTime, 
      this.followUpDateTime, 
      this.incompleteDemo, 
      this.demoRescheduleRemark, 
      this.countryCode,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    email = json['email'];
    profilePhoto = json['profile_photo'];
    path = json['path'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    address = json['address'];
    role = json['role'];
    emailVerifiedAt = json['email_verified_at'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
    status = json['status'];
    priority = json['priority'];
    deletedAt = json['deleted_at'];
    steps = json['steps'];
    gender = json['gender'];
    leadRefType = json['lead_ref_type'];
    occupation = json['occupation'];
    dob = json['dob'];
    noOfFamilyMembers = json['no_of_family_members'];
    illnessInFamily = json['illness_in_family'];
    pincode = json['pincode'];
    remarks = json['remarks'];
    feedback = json['feedback'];
    disability = json['disability'];
    monthlyIncome = json['monthly_income'];
    sponsorId = json['sponsor_id'];
    rescheduleCallReason = json['reschedule_call_reason'];
    invitationCallDateTime = json['invitation_call_date_time'];
    businessDemoDateTime = json['business_demo_date_time'];
    demoSteps = json['demo_steps'];
    productDemoDateTime = json['product_demo_date_time'];
    followUpDateTime = json['follow_up_date_time'];
    incompleteDemo = json['incomplete_demo'];
    demoRescheduleRemark = json['demo_reschedule_remark'];
    countryCode = json['country_code'];
  }
  num? id;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  dynamic profilePhoto;
  dynamic path;
  num? stateId;
  dynamic cityId;
  String? address;
  String? role;
  dynamic emailVerifiedAt;
  dynamic deviceToken;
  String? createdAt;
  String? updatedAt;
  String? isActive;
  String? status;
  String? priority;
  dynamic deletedAt;
  num? steps;
  String? gender;
  String? leadRefType;
  String? occupation;
  dynamic dob;
  dynamic noOfFamilyMembers;
  dynamic illnessInFamily;
  dynamic pincode;
  dynamic remarks;
  dynamic feedback;
  String? disability;
  dynamic monthlyIncome;
  num? sponsorId;
  dynamic rescheduleCallReason;
  String? invitationCallDateTime;
  String? businessDemoDateTime;
  num? demoSteps;
  dynamic productDemoDateTime;
  dynamic followUpDateTime;
  dynamic incompleteDemo;
  dynamic demoRescheduleRemark;
  String? countryCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['mobile'] = mobile;
    map['email'] = email;
    map['profile_photo'] = profilePhoto;
    map['path'] = path;
    map['state_id'] = stateId;
    map['city_id'] = cityId;
    map['address'] = address;
    map['role'] = role;
    map['email_verified_at'] = emailVerifiedAt;
    map['device_token'] = deviceToken;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['is_active'] = isActive;
    map['status'] = status;
    map['priority'] = priority;
    map['deleted_at'] = deletedAt;
    map['steps'] = steps;
    map['gender'] = gender;
    map['lead_ref_type'] = leadRefType;
    map['occupation'] = occupation;
    map['dob'] = dob;
    map['no_of_family_members'] = noOfFamilyMembers;
    map['illness_in_family'] = illnessInFamily;
    map['pincode'] = pincode;
    map['remarks'] = remarks;
    map['feedback'] = feedback;
    map['disability'] = disability;
    map['monthly_income'] = monthlyIncome;
    map['sponsor_id'] = sponsorId;
    map['reschedule_call_reason'] = rescheduleCallReason;
    map['invitation_call_date_time'] = invitationCallDateTime;
    map['business_demo_date_time'] = businessDemoDateTime;
    map['demo_steps'] = demoSteps;
    map['product_demo_date_time'] = productDemoDateTime;
    map['follow_up_date_time'] = followUpDateTime;
    map['incomplete_demo'] = incompleteDemo;
    map['demo_reschedule_remark'] = demoRescheduleRemark;
    map['country_code'] = countryCode;
    return map;
  }

}