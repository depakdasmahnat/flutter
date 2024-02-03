import 'dart:convert';

CommentsModel commentsModelFromJson(String str) => CommentsModel.fromJson(json.decode(str));

String commentsModelToJson(CommentsModel data) => json.encode(data.toJson());

class CommentsModel {
  CommentsModel({
    this.status,
    this.message,
    this.dataRecords,
    this.data,
  });

  CommentsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    dataRecords = json['data_records'] != null ? DataRecords.fromJson(json['data_records']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CommentsData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  DataRecords? dataRecords;
  List<CommentsData>? data;

  CommentsModel copyWith({
    bool? status,
    String? message,
    DataRecords? dataRecords,
    List<CommentsData>? data,
  }) =>
      CommentsModel(
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

CommentsData dataFromJson(String str) => CommentsData.fromJson(json.decode(str));

String dataToJson(CommentsData data) => json.encode(data.toJson());

class CommentsData {
  CommentsData({
    this.id,
    this.postId,
    this.userId,
    this.userType,
    this.comment,
    this.replies,
    this.createdAt,
    this.userFirstName,
    this.userLastName,
    this.userPath,
    this.userProfilePicture,
    this.guestFirstName,
    this.guestLastName,
    this.guestPath,
    this.guestProfilePicture,
    this.profilePicture,
    this.timeAgo,
  });

  CommentsData.fromJson(dynamic json) {
    id = json['id'];
    postId = json['post_id'];
    userId = json['user_id'];
    userType = json['user_type'];
    comment = json['comment'];
    replies = json['replies'];
    createdAt = json['created_at'];
    userFirstName = json['user_first_name'];
    userLastName = json['user_last_name'];
    userPath = json['user_path'];
    userProfilePicture = json['user_profile_picture'];
    guestFirstName = json['guest_first_name'];
    guestLastName = json['guest_last_name'];
    guestPath = json['guest_path'];
    guestProfilePicture = json['guest_profile_picture'];
    profilePicture = json['profile_picture'];
    timeAgo = json['time_ago'];
  }

  num? id;
  num? postId;
  num? userId;
  String? userType;
  String? comment;
  num? replies;
  String? createdAt;
  dynamic userFirstName;
  dynamic userLastName;
  dynamic userPath;
  dynamic userProfilePicture;
  String? guestFirstName;
  String? guestLastName;
  dynamic guestPath;
  dynamic guestProfilePicture;
  String? profilePicture;
  String? timeAgo;

  CommentsData copyWith({
    num? id,
    num? postId,
    num? userId,
    String? userType,
    String? comment,
    num? replies,
    String? createdAt,
    dynamic userFirstName,
    dynamic userLastName,
    dynamic userPath,
    dynamic userProfilePicture,
    String? guestFirstName,
    String? guestLastName,
    dynamic guestPath,
    dynamic guestProfilePicture,
    String? profilePicture,
    String? timeAgo,
  }) =>
      CommentsData(
        id: id ?? this.id,
        postId: postId ?? this.postId,
        userId: userId ?? this.userId,
        userType: userType ?? this.userType,
        comment: comment ?? this.comment,
        replies: replies ?? this.replies,
        createdAt: createdAt ?? this.createdAt,
        userFirstName: userFirstName ?? this.userFirstName,
        userLastName: userLastName ?? this.userLastName,
        userPath: userPath ?? this.userPath,
        userProfilePicture: userProfilePicture ?? this.userProfilePicture,
        guestFirstName: guestFirstName ?? this.guestFirstName,
        guestLastName: guestLastName ?? this.guestLastName,
        guestPath: guestPath ?? this.guestPath,
        guestProfilePicture: guestProfilePicture ?? this.guestProfilePicture,
        profilePicture: profilePicture ?? this.profilePicture,
        timeAgo: timeAgo ?? this.timeAgo,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['post_id'] = postId;
    map['user_id'] = userId;
    map['user_type'] = userType;
    map['comment'] = comment;
    map['replies'] = replies;
    map['created_at'] = createdAt;
    map['user_first_name'] = userFirstName;
    map['user_last_name'] = userLastName;
    map['user_path'] = userPath;
    map['user_profile_picture'] = userProfilePicture;
    map['guest_first_name'] = guestFirstName;
    map['guest_last_name'] = guestLastName;
    map['guest_path'] = guestPath;
    map['guest_profile_picture'] = guestProfilePicture;
    map['profile_picture'] = profilePicture;
    map['time_ago'] = timeAgo;
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
