import 'dart:convert';
FetchNotificationModel fetchNotificationModelFromJson(String str) => FetchNotificationModel.fromJson(json.decode(str));
String fetchNotificationModelToJson(FetchNotificationModel data) => json.encode(data.toJson());
class FetchNotificationModel {
  FetchNotificationModel({
      this.status, 
      this.message, 
      this.counts, 
      this.eventNotification, 
      this.otherNotification,});

  FetchNotificationModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    counts = json['counts'];
    if (json['event_notification'] != null) {
      eventNotification = [];
      json['event_notification'].forEach((v) {
        eventNotification?.add(EventNotification.fromJson(v));
      });
    }
    if (json['other_notification'] != null) {
      otherNotification = [];
      json['other_notification'].forEach((v) {
        otherNotification?.add(OtherNotification.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  num? counts;
  List<EventNotification>? eventNotification;
  List<OtherNotification>? otherNotification;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['counts'] = counts;
    if (eventNotification != null) {
      map['event_notification'] = eventNotification?.map((v) => v.toJson()).toList();
    }
    if (otherNotification != null) {
      map['other_notification'] = otherNotification?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

OtherNotification otherNotificationFromJson(String str) => OtherNotification.fromJson(json.decode(str));
String otherNotificationToJson(OtherNotification data) => json.encode(data.toJson());
class OtherNotification {
  OtherNotification({
      this.id, 
      this.userId, 
      this.userType, 
      this.title, 
      this.description, 
      this.image, 
      this.path, 
      this.messageType, 
      this.receiverType, 
      this.receiverIds, 
      this.createdAt, 
      this.updatedAt, 
      this.isActive, 
      this.deletedAt, 
      this.time, 
      this.redirectTo, 
      this.sentAt,});

  OtherNotification.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    userType = json['user_type'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    path = json['path'];
    messageType = json['message_type'];
    receiverType = json['receiver_type'];
    receiverIds = json['receiver_ids'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
    deletedAt = json['deleted_at'];
    time = json['time'];
    redirectTo = json['redirect_to'];
    sentAt = json['sent_at'];
  }
  num? id;
  num? userId;
  String? userType;
  String? title;
  String? description;
  dynamic image;
  dynamic path;
  String? messageType;
  String? receiverType;
  String? receiverIds;
  String? createdAt;
  String? updatedAt;
  String? isActive;
  dynamic deletedAt;
  dynamic time;
  String? redirectTo;
  String? sentAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['user_type'] = userType;
    map['title'] = title;
    map['description'] = description;
    map['image'] = image;
    map['path'] = path;
    map['message_type'] = messageType;
    map['receiver_type'] = receiverType;
    map['receiver_ids'] = receiverIds;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['is_active'] = isActive;
    map['deleted_at'] = deletedAt;
    map['time'] = time;
    map['redirect_to'] = redirectTo;
    map['sent_at'] = sentAt;
    return map;
  }

}

EventNotification eventNotificationFromJson(String str) => EventNotification.fromJson(json.decode(str));
String eventNotificationToJson(EventNotification data) => json.encode(data.toJson());
class EventNotification {
  EventNotification({
      this.id, 
      this.userId, 
      this.userType, 
      this.title, 
      this.description, 
      this.image, 
      this.path, 
      this.messageType, 
      this.receiverType, 
      this.receiverIds, 
      this.createdAt, 
      this.updatedAt, 
      this.isActive, 
      this.deletedAt, 
      this.time, 
      this.redirectTo, 
      this.sentAt,});

  EventNotification.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    userType = json['user_type'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    path = json['path'];
    messageType = json['message_type'];
    receiverType = json['receiver_type'];
    receiverIds = json['receiver_ids'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
    deletedAt = json['deleted_at'];
    time = json['time'];
    redirectTo = json['redirect_to'];
    sentAt = json['sent_at'];
  }
  num? id;
  num? userId;
  String? userType;
  String? title;
  String? description;
  dynamic image;
  dynamic path;
  String? messageType;
  String? receiverType;
  dynamic receiverIds;
  String? createdAt;
  dynamic updatedAt;
  String? isActive;
  dynamic deletedAt;
  dynamic time;
  dynamic redirectTo;
  String? sentAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['user_type'] = userType;
    map['title'] = title;
    map['description'] = description;
    map['image'] = image;
    map['path'] = path;
    map['message_type'] = messageType;
    map['receiver_type'] = receiverType;
    map['receiver_ids'] = receiverIds;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['is_active'] = isActive;
    map['deleted_at'] = deletedAt;
    map['time'] = time;
    map['redirect_to'] = redirectTo;
    map['sent_at'] = sentAt;
    return map;
  }

}