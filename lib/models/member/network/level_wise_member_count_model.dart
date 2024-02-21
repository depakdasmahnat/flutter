import 'dart:convert';
LevelWiseMemberCountModel levelWiseMemberCountModelFromJson(String str) => LevelWiseMemberCountModel.fromJson(json.decode(str));
String levelWiseMemberCountModelToJson(LevelWiseMemberCountModel data) => json.encode(data.toJson());
class LevelWiseMemberCountModel {
  LevelWiseMemberCountModel({
      this.status, 
      this.message, 
      this.remainingMembers,});

  LevelWiseMemberCountModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    remainingMembers = json['remaining_members'];
  }
  bool? status;
  String? message;
  num? remainingMembers;
LevelWiseMemberCountModel copyWith({  bool? status,
  String? message,
  num? remainingMembers,
}) => LevelWiseMemberCountModel(  status: status ?? this.status,
  message: message ?? this.message,
  remainingMembers: remainingMembers ?? this.remainingMembers,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['remaining_members'] = remainingMembers;
    return map;
  }

}