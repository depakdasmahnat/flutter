import 'dart:convert';

GoalsModel goalsModelFromJson(String str) => GoalsModel.fromJson(json.decode(str));

String goalsModelToJson(GoalsModel data) => json.encode(data.toJson());

class GoalsModel {
  GoalsModel({
    this.status,
    this.message,
    this.dataRecords,
    this.data,
  });

  GoalsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    dataRecords = json['data_records'] != null ? DataRecords.fromJson(json['data_records']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(GoalsData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  DataRecords? dataRecords;
  List<GoalsData>? data;

  GoalsModel copyWith({
    bool? status,
    String? message,
    DataRecords? dataRecords,
    List<GoalsData>? data,
  }) =>
      GoalsModel(
        status: status ?? this.status,
        message: message ?? this.message,
        dataRecords: dataRecords ?? this.dataRecords,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (dataRecords != null) {
      map['data_records'] = dataRecords?.toJson();
    }
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

GoalsData dataFromJson(String str) => GoalsData.fromJson(json.decode(str));

String dataToJson(GoalsData data) => json.encode(data.toJson());

class GoalsData {
  GoalsData({
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
    this.deletedAt,
  });

  GoalsData.fromJson(dynamic json) {
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
  }

  num? id;
  num? memberId;
  String? name;
  String? type;
  String? startDate;
  String? endDate;
  String? description;
  dynamic path;
  dynamic image;
  String? createdAt;
  String? updatedAt;
  String? status;
  dynamic deletedAt;

  GoalsData copyWith({
    num? id,
    num? memberId,
    String? name,
    String? type,
    String? startDate,
    String? endDate,
    String? description,
    dynamic path,
    dynamic image,
    String? createdAt,
    String? updatedAt,
    String? status,
    dynamic deletedAt,
  }) =>
      GoalsData(
        id: id ?? this.id,
        memberId: memberId ?? this.memberId,
        name: name ?? this.name,
        type: type ?? this.type,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        description: description ?? this.description,
        path: path ?? this.path,
        image: image ?? this.image,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status,
        deletedAt: deletedAt ?? this.deletedAt,
      );

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
    return map;
  }
}

DataRecords dataRecordsFromJson(String str) => DataRecords.fromJson(json.decode(str));

String dataRecordsToJson(DataRecords data) => json.encode(data.toJson());

class DataRecords {
  DataRecords({
    this.totalPage,
    this.limit,
    this.page,
  });

  DataRecords.fromJson(dynamic json) {
    totalPage = json['total_page'];
    limit = json['limit'];
    page = json['page'];
  }

  num? totalPage;
  num? limit;
  num? page;

  DataRecords copyWith({
    num? totalPage,
    num? limit,
    num? page,
  }) =>
      DataRecords(
        totalPage: totalPage ?? this.totalPage,
        limit: limit ?? this.limit,
        page: page ?? this.page,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_page'] = totalPage;
    map['limit'] = limit;
    map['page'] = page;
    return map;
  }
}
