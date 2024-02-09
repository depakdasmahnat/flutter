import 'dart:convert';
NotificationsModel notificationsModelFromJson(String str) => NotificationsModel.fromJson(json.decode(str));
String notificationsModelToJson(NotificationsModel data) => json.encode(data.toJson());
class NotificationsModel {
  NotificationsModel({
      this.status, 
      this.message, 
      this.counts, 
      this.data,});

  NotificationsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    counts = json['counts'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(NotificationsData.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  num? counts;
  List<NotificationsData>? data;
NotificationsModel copyWith({  bool? status,
  String? message,
  num? counts,
  List<NotificationsData>? data,
}) => NotificationsModel(  status: status ?? this.status,
  message: message ?? this.message,
  counts: counts ?? this.counts,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['counts'] = counts;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

NotificationsData dataFromJson(String str) => NotificationsData.fromJson(json.decode(str));
String dataToJson(NotificationsData data) => json.encode(data.toJson());
class NotificationsData {
  NotificationsData({
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
      this.redirectId, 
      this.redirectTo, 
      this.createdAt, 
      this.updatedAt, 
      this.status, 
      this.deletedAt, 
      this.sentAt,});

  NotificationsData.fromJson(dynamic json) {
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
    redirectId = json['redirect_id'];
    redirectTo = json['redirect_to'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    sentAt = json['sent_at'];
  }
  num? id;
  num? userId;
  String? userType;
  String? title;
  String? description;
  String? image;
  String? path;
  String? messageType;
  String? receiverType;
  String? receiverIds;
  String? redirectId;
  String? redirectTo;
  String? createdAt;
  String? updatedAt;
  String? status;
  dynamic deletedAt;
  String? sentAt;
NotificationsData copyWith({  num? id,
  num? userId,
  String? userType,
  String? title,
  String? description,
  String? image,
  String? path,
  String? messageType,
  String? receiverType,
  String? receiverIds,
  String? redirectId,
  String? redirectTo,
  String? createdAt,
  String? updatedAt,
  String? status,
  dynamic deletedAt,
  String? sentAt,
}) => NotificationsData(  id: id ?? this.id,
  userId: userId ?? this.userId,
  userType: userType ?? this.userType,
  title: title ?? this.title,
  description: description ?? this.description,
  image: image ?? this.image,
  path: path ?? this.path,
  messageType: messageType ?? this.messageType,
  receiverType: receiverType ?? this.receiverType,
  receiverIds: receiverIds ?? this.receiverIds,
  redirectId: redirectId ?? this.redirectId,
  redirectTo: redirectTo ?? this.redirectTo,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  status: status ?? this.status,
  deletedAt: deletedAt ?? this.deletedAt,
  sentAt: sentAt ?? this.sentAt,
);
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
    map['redirect_id'] = redirectId;
    map['redirect_to'] = redirectTo;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['status'] = status;
    map['deleted_at'] = deletedAt;
    map['sent_at'] = sentAt;
    return map;
  }

}