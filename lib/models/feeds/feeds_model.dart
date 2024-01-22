import 'dart:convert';
FeedsModel feedsModelFromJson(String str) => FeedsModel.fromJson(json.decode(str));
String feedsModelToJson(FeedsModel data) => json.encode(data.toJson());
class FeedsModel {
  FeedsModel({
      this.success, 
      this.message, 
      this.dataRecords, 
      this.data,});

  FeedsModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    dataRecords = json['dataRecords'] != null ? DataRecords.fromJson(json['dataRecords']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(FeedsData.fromJson(v));
      });
    }
  }
  bool? success;
  String? message;
  DataRecords? dataRecords;
  List<FeedsData>? data;
FeedsModel copyWith({  bool? success,
  String? message,
  DataRecords? dataRecords,
  List<FeedsData>? data,
}) => FeedsModel(  success: success ?? this.success,
  message: message ?? this.message,
  dataRecords: dataRecords ?? this.dataRecords,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (dataRecords != null) {
      map['dataRecords'] = dataRecords?.toJson();
    }
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

FeedsData dataFromJson(String str) => FeedsData.fromJson(json.decode(str));
String dataToJson(FeedsData data) => json.encode(data.toJson());
class FeedsData {
  FeedsData({
      this.id, 
      this.title, 
      this.duration, 
      this.likes, 
      this.comments, 
      this.wishlistId, 
      this.isLiked, 
      this.isBookmarked, 
      this.images, 
      this.videoUrl, 
      this.youtubeUrl, 
      this.share,});

  FeedsData.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    duration = json['duration'];
    likes = json['likes'];
    comments = json['comments'];
    wishlistId = json['wishlistId'];
    isLiked = json['isLiked'];
    isBookmarked = json['isBookmarked'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
    videoUrl = json['videoUrl'];
    youtubeUrl = json['youtubeUrl'];
    share = json['share'];
  }
  String? id;
  String? title;
  String? duration;
  num? likes;
  num? comments;
  String? wishlistId;
  bool? isLiked;
  bool? isBookmarked;
  List<String>? images;
  String? videoUrl;
  String? youtubeUrl;
  String? share;
FeedsData copyWith({  String? id,
  String? title,
  String? duration,
  num? likes,
  num? comments,
  String? wishlistId,
  bool? isLiked,
  bool? isBookmarked,
  List<String>? images,
  String? videoUrl,
  String? youtubeUrl,
  String? share,
}) => FeedsData(  id: id ?? this.id,
  title: title ?? this.title,
  duration: duration ?? this.duration,
  likes: likes ?? this.likes,
  comments: comments ?? this.comments,
  wishlistId: wishlistId ?? this.wishlistId,
  isLiked: isLiked ?? this.isLiked,
  isBookmarked: isBookmarked ?? this.isBookmarked,
  images: images ?? this.images,
  videoUrl: videoUrl ?? this.videoUrl,
  youtubeUrl: youtubeUrl ?? this.youtubeUrl,
  share: share ?? this.share,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['duration'] = duration;
    map['likes'] = likes;
    map['comments'] = comments;
    map['wishlistId'] = wishlistId;
    map['isLiked'] = isLiked;
    map['isBookmarked'] = isBookmarked;
    map['images'] = images;
    map['videoUrl'] = videoUrl;
    map['youtubeUrl'] = youtubeUrl;
    map['share'] = share;
    return map;
  }

}

DataRecords dataRecordsFromJson(String str) => DataRecords.fromJson(json.decode(str));
String dataRecordsToJson(DataRecords data) => json.encode(data.toJson());
class DataRecords {
  DataRecords({
      this.totalPage, 
      this.limit, 
      this.page,});

  DataRecords.fromJson(dynamic json) {
    totalPage = json['totalPage'];
    limit = json['limit'];
    page = json['page'];
  }
  num? totalPage;
  num? limit;
  num? page;
DataRecords copyWith({  num? totalPage,
  num? limit,
  num? page,
}) => DataRecords(  totalPage: totalPage ?? this.totalPage,
  limit: limit ?? this.limit,
  page: page ?? this.page,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalPage'] = totalPage;
    map['limit'] = limit;
    map['page'] = page;
    return map;
  }

}