import 'dart:convert';
FetchGoalForEditModel fetchGoalForEditModelFromJson(String str) => FetchGoalForEditModel.fromJson(json.decode(str));
String fetchGoalForEditModelToJson(FetchGoalForEditModel data) => json.encode(data.toJson());
class FetchGoalForEditModel {
  FetchGoalForEditModel({
      this.status, 
      this.message, 
      this.data,});

  FetchGoalForEditModel.fromJson(dynamic json) {
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
      this.memberId, 
      this.name, 
      this.type, 
      this.startDate, 
      this.endDate, 
      this.description, 
      this.path, 
      this.image, 
      this.createdAt, 
      this.updatedAt, 
      this.status, 
      this.typeId,
      this.deletedAt,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    memberId = json['member_id'];
    name = json['name'];
    type = json['type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    description = json['description'];
    path = json['path'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    typeId = json['type_id'];
  }
  num? id;
  num? memberId;
  String? name;
  String? type;
  String? startDate;
  String? endDate;
  String? description;
  String? path;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? typeId;
  dynamic deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['member_id'] = memberId;
    map['name'] = name;
    map['type'] = type;
    map['start_date'] = startDate;
    map['end_date'] = endDate;
    map['description'] = description;
    map['path'] = path;
    map['image'] = image;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['status'] = status;
    map['deleted_at'] = deletedAt;
    map['type_id'] = typeId;
    return map;
  }
}