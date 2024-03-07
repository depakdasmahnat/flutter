import 'dart:convert';

GuestProfileDetailsModel leadsMemberDetailsFromJson(String str) => GuestProfileDetailsModel.fromJson(json.decode(str));

String leadsMemberDetailsToJson(GuestProfileDetailsModel data) => json.encode(data.toJson());

class GuestProfileDetailsModel {
  GuestProfileDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  GuestProfileDetailsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? GuestProfileDetailsData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  GuestProfileDetailsData? data;

  GuestProfileDetailsModel copyWith({
    bool? status,
    String? message,
    GuestProfileDetailsData? data,
  }) =>
      GuestProfileDetailsModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

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

GuestProfileDetailsData dataFromJson(String str) => GuestProfileDetailsData.fromJson(json.decode(str));

String dataToJson(GuestProfileDetailsData data) => json.encode(data.toJson());

class GuestProfileDetailsData {
  GuestProfileDetailsData({
    this.profilePhoto,
    this.firstName,
    this.lastName,
    this.mobile,
    this.address,
    this.city,
    this.state,
    this.watchedVideosCount,
    this.pendingVideosCount,
    this.watchCount,
    this.watchedVideos,
  });

  GuestProfileDetailsData.fromJson(dynamic json) {
    profilePhoto = json['profile_photo'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    watchedVideosCount = json['watched_videos_count'];
    pendingVideosCount = json['pending_videos_count'];
    watchCount = json['watch_count'];
    if (json['watched_videos'] != null) {
      watchedVideos = [];
      json['watched_videos'].forEach((v) {
        watchedVideos?.add(WatchedVideos.fromJson(v));
      });
    }
  }

  String? profilePhoto;
  String? firstName;
  String? lastName;
  String? mobile;
  dynamic address;
  String? city;
  String? state;
  num? watchedVideosCount;
  num? pendingVideosCount;
  String? watchCount;
  List<WatchedVideos>? watchedVideos;

  GuestProfileDetailsData copyWith({
    String? profilePhoto,
    String? firstName,
    String? lastName,
    String? mobile,
    dynamic address,
    String? city,
    String? state,
    num? watchedVideosCount,
    num? pendingVideosCount,
    String? watchCount,
    List<WatchedVideos>? watchedVideos,
  }) =>
      GuestProfileDetailsData(
        profilePhoto: profilePhoto ?? this.profilePhoto,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobile: mobile ?? this.mobile,
        address: address ?? this.address,
        city: city ?? this.city,
        state: state ?? this.state,
        watchedVideosCount: watchedVideosCount ?? this.watchedVideosCount,
        pendingVideosCount: pendingVideosCount ?? this.pendingVideosCount,
        watchCount: watchCount ?? this.watchCount,
        watchedVideos: watchedVideos ?? this.watchedVideos,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profile_photo'] = profilePhoto;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['mobile'] = mobile;
    map['address'] = address;
    map['city'] = city;
    map['state'] = state;
    map['watched_videos_count'] = watchedVideosCount;
    map['pending_videos_count'] = pendingVideosCount;
    map['watch_count'] = watchCount;
    if (watchedVideos != null) {
      map['watched_videos'] = watchedVideos?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

WatchedVideos watchedVideosFromJson(String str) => WatchedVideos.fromJson(json.decode(str));

String watchedVideosToJson(WatchedVideos data) => json.encode(data.toJson());

class WatchedVideos {
  WatchedVideos({
    this.id,
    this.title,
    this.fileType,
    this.path,
    this.file,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isActive,
  });

  WatchedVideos.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    fileType = json['file_type'];
    path = json['path'];
    file = json['file'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    isActive = json['is_active'];
  }

  num? id;
  String? title;
  String? fileType;
  String? path;
  String? file;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? isActive;

  WatchedVideos copyWith({
    num? id,
    String? title,
    String? fileType,
    String? path,
    String? file,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    String? isActive,
  }) =>
      WatchedVideos(
        id: id ?? this.id,
        title: title ?? this.title,
        fileType: fileType ?? this.fileType,
        path: path ?? this.path,
        file: file ?? this.file,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        isActive: isActive ?? this.isActive,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['file_type'] = fileType;
    map['path'] = path;
    map['file'] = file;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['is_active'] = isActive;
    return map;
  }
}
