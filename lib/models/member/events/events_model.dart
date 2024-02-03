import 'dart:convert';

EventsModel eventsModelFromJson(String str) => EventsModel.fromJson(json.decode(str));

String eventsModelToJson(EventsModel data) => json.encode(data.toJson());

class EventsModel {
  EventsModel({
    this.status,
    this.message,
    this.dataRecords,
    this.data,
  });

  EventsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    dataRecords = json['data_records'] != null ? DataRecords.fromJson(json['data_records']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(EventsData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  DataRecords? dataRecords;
  List<EventsData>? data;

  EventsModel copyWith({
    bool? status,
    String? message,
    DataRecords? dataRecords,
    List<EventsData>? data,
  }) =>
      EventsModel(
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

EventsData dataFromJson(String str) => EventsData.fromJson(json.decode(str));

String dataToJson(EventsData data) => json.encode(data.toJson());

class EventsData {
  EventsData({
    this.id,
    this.categoryId,
    this.userId,
    this.userType,
    this.name,
    this.type,
    this.meetingLink,
    this.location,
    this.description,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.path,
    this.image,
    this.memberIds,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.deletedAt,
    this.permission,
    this.eventCategory,
    this.eventLink,
    this.totalAttendees,
    this.noOfMembers,
    this.categoryName,
  });

  EventsData.fromJson(dynamic json) {
    id = json['id'];
    categoryId = json['category_id'];
    userId = json['user_id'];
    userType = json['user_type'];
    name = json['name'];
    type = json['type'];
    meetingLink = json['meeting_link'];
    location = json['location'];
    description = json['description'];
    startDate = json['start_date'];
    startTime = json['start_time'];
    endDate = json['end_date'];
    endTime = json['end_time'];
    path = json['path'];
    image = json['image'];
    memberIds = json['member_ids'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
    deletedAt = json['deleted_at'];
    permission = json['permission'];
    eventCategory = json['event_category'];
    eventLink = json['event_link'];
    totalAttendees = json['total_attendees'];
    noOfMembers = json['no_of_members'];
    categoryName = json['category_name'];
  }

  num? id;
  dynamic categoryId;
  num? userId;
  String? userType;
  String? name;
  String? type;
  String? meetingLink;
  dynamic location;
  String? description;
  String? startDate;
  String? startTime;
  String? endDate;
  String? endTime;
  String? path;
  String? image;
  String? memberIds;
  String? createdAt;
  String? updatedAt;
  String? isActive;
  dynamic deletedAt;
  dynamic permission;
  dynamic eventCategory;
  dynamic eventLink;
  num? totalAttendees;
  num? noOfMembers;
  dynamic categoryName;

  EventsData copyWith({
    num? id,
    dynamic categoryId,
    num? userId,
    String? userType,
    String? name,
    String? type,
    String? meetingLink,
    dynamic location,
    String? description,
    String? startDate,
    String? startTime,
    String? endDate,
    String? endTime,
    String? path,
    String? image,
    String? memberIds,
    String? createdAt,
    String? updatedAt,
    String? isActive,
    dynamic deletedAt,
    dynamic permission,
    dynamic eventCategory,
    dynamic eventLink,
    num? totalAttendees,
    num? noOfMembers,
    dynamic categoryName,
  }) =>
      EventsData(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        userId: userId ?? this.userId,
        userType: userType ?? this.userType,
        name: name ?? this.name,
        type: type ?? this.type,
        meetingLink: meetingLink ?? this.meetingLink,
        location: location ?? this.location,
        description: description ?? this.description,
        startDate: startDate ?? this.startDate,
        startTime: startTime ?? this.startTime,
        endDate: endDate ?? this.endDate,
        endTime: endTime ?? this.endTime,
        path: path ?? this.path,
        image: image ?? this.image,
        memberIds: memberIds ?? this.memberIds,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isActive: isActive ?? this.isActive,
        deletedAt: deletedAt ?? this.deletedAt,
        permission: permission ?? this.permission,
        eventCategory: eventCategory ?? this.eventCategory,
        eventLink: eventLink ?? this.eventLink,
        totalAttendees: totalAttendees ?? this.totalAttendees,
        noOfMembers: noOfMembers ?? this.noOfMembers,
        categoryName: categoryName ?? this.categoryName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['category_id'] = categoryId;
    map['user_id'] = userId;
    map['user_type'] = userType;
    map['name'] = name;
    map['type'] = type;
    map['meeting_link'] = meetingLink;
    map['location'] = location;
    map['description'] = description;
    map['start_date'] = startDate;
    map['start_time'] = startTime;
    map['end_date'] = endDate;
    map['end_time'] = endTime;
    map['path'] = path;
    map['image'] = image;
    map['member_ids'] = memberIds;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['is_active'] = isActive;
    map['deleted_at'] = deletedAt;
    map['permission'] = permission;
    map['event_category'] = eventCategory;
    map['event_link'] = eventLink;
    map['total_attendees'] = totalAttendees;
    map['no_of_members'] = noOfMembers;
    map['category_name'] = categoryName;
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
