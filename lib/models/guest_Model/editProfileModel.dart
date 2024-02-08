import 'dart:convert';

import '../auth_model/guest_data.dart';

EditProfileModel editProfileModelFromJson(String str) => EditProfileModel.fromJson(json.decode(str));

String editProfileModelToJson(EditProfileModel data) => json.encode(data.toJson());

class EditProfileModel {
  EditProfileModel({
    this.status,
    this.message,
    this.data,
  });

  EditProfileModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? GuestData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  GuestData? data;

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

// Data dataFromJson(String str) => Data.fromJson(json.decode(str));
//
// String dataToJson(Data data) => json.encode(data.toJson());

// class Data {
//   Data({
//     this.id,
//     this.firstName,
//     this.lastName,
//     this.mobile,
//     this.email,
//     this.profilePhoto,
//     this.referredBy,
//     this.gender,
//     this.leadRefType,
//     this.occupation,
//     this.dob,
//     this.noOfFamilyMembers,
//     this.illnessInFamily,
//     this.stateId,
//     this.cityId,
//     this.address,
//     this.pincode,
//     this.deviceToken,
//     this.role,
//     this.steps,
//     this.accessToken,
//   });
//
//   Data.fromJson(dynamic json) {
//     id = json['id'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     mobile = json['mobile'];
//     email = json['email'];
//     profilePhoto = json['profile_photo'];
//     referredBy = json['referred_by'];
//     gender = json['gender'];
//     leadRefType = json['lead_ref_type'];
//     occupation = json['occupation'];
//     dob = json['dob'];
//     noOfFamilyMembers = json['no_of_family_members'];
//     illnessInFamily = json['illness_in_family'];
//     stateId = json['state_id'];
//     cityId = json['city_id'];
//     address = json['address'];
//     pincode = json['pincode'];
//     deviceToken = json['device_token'];
//     role = json['role'];
//     steps = json['steps'];
//     accessToken = json['access_token'];
//   }
//
//   num? id;
//   String? firstName;
//   String? lastName;
//   String? mobile;
//   String? email;
//   dynamic profilePhoto;
//   num? referredBy;
//   dynamic gender;
//   dynamic leadRefType;
//   dynamic occupation;
//   dynamic dob;
//   dynamic noOfFamilyMembers;
//   dynamic illnessInFamily;
//   dynamic stateId;
//   dynamic cityId;
//   dynamic address;
//   dynamic pincode;
//   dynamic deviceToken;
//   String? role;
//   num? steps;
//   dynamic accessToken;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['first_name'] = firstName;
//     map['last_name'] = lastName;
//     map['mobile'] = mobile;
//     map['email'] = email;
//     map['profile_photo'] = profilePhoto;
//     map['referred_by'] = referredBy;
//     map['gender'] = gender;
//     map['lead_ref_type'] = leadRefType;
//     map['occupation'] = occupation;
//     map['dob'] = dob;
//     map['no_of_family_members'] = noOfFamilyMembers;
//     map['illness_in_family'] = illnessInFamily;
//     map['state_id'] = stateId;
//     map['city_id'] = cityId;
//     map['address'] = address;
//     map['pincode'] = pincode;
//     map['device_token'] = deviceToken;
//     map['role'] = role;
//     map['steps'] = steps;
//     map['access_token'] = accessToken;
//     return map;
//   }
// }
