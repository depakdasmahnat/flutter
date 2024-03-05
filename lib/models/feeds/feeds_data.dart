import 'dart:convert';

FeedsData dataFromJson(String str) => FeedsData.fromJson(json.decode(str));

String dataToJson(FeedsData data) => json.encode(data.toJson());

class FeedsData {
  FeedsData({
    this.id,
    this.categoryId,
    this.userId,
    this.userType,
    this.title,
    this.description,
    this.fileType,
    this.path,
    this.uploadType,
    this.likes,
    this.comments,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.deletedAt,
    this.categoryName,
    this.isLiked,
    this.isCommented,
    this.isBookmarked,
    this.file,
    this.files,
    this.downloadAndSharePermission,
  });

  FeedsData.fromJson(dynamic json) {
    id = json['id'];
    categoryId = json['category_id'];
    userId = json['user_id'];
    userType = json['user_type'];
    title = json['title'];
    description = json['description'];
    fileType = json['file_type'];
    path = json['path'];
    uploadType = json['upload_type'];
    likes = json['likes'];
    comments = json['comments'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
    deletedAt = json['deleted_at'];
    categoryName = json['category_name'];
    isLiked = json['is_liked'];
    isCommented = json['is_commented'];
    downloadAndSharePermission = json['download_and_share_permission'];

    isBookmarked = json['is_bookmarked'];
    file = json['file'];
    files = json['files'] != null ? json['files'].cast<String>() : [];
  }

  num? id;
  num? categoryId;
  num? userId;
  String? userType;
  String? title;
  dynamic description;
  String? fileType;
  String? path;
  String? uploadType;
  num? likes;
  num? comments;
  String? createdAt;
  String? updatedAt;
  String? isActive;
  dynamic deletedAt;
  dynamic categoryName;
  bool? isLiked;
  bool? isCommented;

  bool? isBookmarked;
  String? file;
  bool? downloadAndSharePermission;
  List<String>? files;

  FeedsData copyWith({
    num? id,
    num? categoryId,
    num? userId,
    String? userType,
    String? title,
    dynamic description,
    String? fileType,
    String? path,
    String? uploadType,
    num? likes,
    num? comments,
    String? createdAt,
    String? updatedAt,
    String? isActive,
    dynamic deletedAt,
    dynamic categoryName,
    bool? isLiked,
    bool? isCommented,
    bool? isBookmarked,
    String? file,
    bool? downloadAndSharePermission,
    List<String>? files,
  }) =>
      FeedsData(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        userId: userId ?? this.userId,
        userType: userType ?? this.userType,
        title: title ?? this.title,
        description: description ?? this.description,
        fileType: fileType ?? this.fileType,
        path: path ?? this.path,
        uploadType: uploadType ?? this.uploadType,
        likes: likes ?? this.likes,
        comments: comments ?? this.comments,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isActive: isActive ?? this.isActive,
        deletedAt: deletedAt ?? this.deletedAt,
        categoryName: categoryName ?? this.categoryName,
        isLiked: isLiked ?? this.isLiked,
        isCommented: isCommented ?? this.isCommented,
        isBookmarked: isBookmarked ?? this.isBookmarked,
        downloadAndSharePermission: downloadAndSharePermission ?? this.downloadAndSharePermission,
        file: file ?? this.file,
        files: files ?? this.files,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['category_id'] = categoryId;
    map['user_id'] = userId;
    map['user_type'] = userType;
    map['title'] = title;
    map['description'] = description;
    map['file_type'] = fileType;
    map['path'] = path;
    map['upload_type'] = uploadType;
    map['likes'] = likes;
    map['comments'] = comments;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['is_active'] = isActive;
    map['deleted_at'] = deletedAt;
    map['category_name'] = categoryName;
    map['is_liked'] = isLiked;
    map['is_commented'] = isCommented;
    map['is_bookmarked'] = isBookmarked;
    map['file'] = file;
    map['download_and_share_permission'] = downloadAndSharePermission;
    map['files'] = files;
    return map;
  }
}
