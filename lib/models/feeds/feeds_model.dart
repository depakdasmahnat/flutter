import 'dart:convert';

FeedsModel feedsModelFromJson(String str) => FeedsModel.fromJson(json.decode(str));

String feedsModelToJson(FeedsModel data) => json.encode(data.toJson());

class FeedsModel {
  FeedsModel({
    this.status,
    this.message,
    this.totalPage,
    this.data,
  });

  FeedsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    totalPage = json['total_page'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(FeedsData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  num? totalPage;
  List<FeedsData>? data;

  FeedsModel copyWith({
    bool? status,
    String? message,
    num? totalPage,
    List<FeedsData>? data,
  }) =>
      FeedsModel(
        status: status ?? this.status,
        message: message ?? this.message,
        totalPage: totalPage ?? this.totalPage,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['total_page'] = totalPage;
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
    this.categoryId,
    this.userId,
    this.userType,
    this.title,
    this.description,
    this.faq,
    this.fileType,
    this.path,
    this.file,
    this.likes,
    this.isLiked,
    this.isCommented,
    this.comments,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.deletedAt,
    this.categoryName,
    this.files,
    this.creatorDetail,
  });

  FeedsData.fromJson(dynamic json) {
    id = json['id'];
    categoryId = json['category_id'];
    userId = json['user_id'];
    userType = json['user_type'];
    title = json['title'];
    description = json['description'];
    if (json['faq'] != null) {
      faq = [];
      json['faq'].forEach((v) {
        faq?.add(FeedsFaq.fromJson(v));
      });
    }
    fileType = json['file_type'];
    path = json['path'];
    file = json['file'];
    likes = json['likes'];
    isLiked = json['is_liked'];
    isCommented = json['is_commented'];
    comments = json['comments'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    categoryName = json['category_name'];
    if (json['files'] != null) {
      files = [];
      json['files'].forEach((v) {
        files?.add(v);
      });
    }
    creatorDetail =
        json['creator_detail'] != null ? FeedsCreatorDetail.fromJson(json['creator_detail']) : null;
  }

  num? id;
  num? categoryId;
  num? userId;
  String? userType;
  String? title;
  String? description;
  List<FeedsFaq>? faq;
  String? fileType;
  dynamic path;
  dynamic file;
  num? likes;
  bool? isLiked;
  bool? isCommented;
  num? comments;
  String? createdAt;
  String? updatedAt;
  String? status;
  dynamic deletedAt;
  String? categoryName;
  List<String?>? files;
  FeedsCreatorDetail? creatorDetail;

  FeedsData copyWith({
    num? id,
    num? categoryId,
    num? userId,
    String? userType,
    String? title,
    String? description,
    List<FeedsFaq>? faq,
    String? fileType,
    dynamic path,
    dynamic file,
    num? likes,
    bool? isLiked,
    bool? isCommented,
    num? comments,
    String? createdAt,
    String? updatedAt,
    String? status,
    dynamic deletedAt,
    String? categoryName,
    dynamic files,
    FeedsCreatorDetail? creatorDetail,
  }) =>
      FeedsData(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        userId: userId ?? this.userId,
        userType: userType ?? this.userType,
        title: title ?? this.title,
        description: description ?? this.description,
        faq: faq ?? this.faq,
        fileType: fileType ?? this.fileType,
        path: path ?? this.path,
        file: file ?? this.file,
        likes: likes ?? this.likes,
        isLiked: isLiked ?? this.isLiked,
        isCommented: isCommented ?? this.isCommented,
        comments: comments ?? this.comments,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status,
        deletedAt: deletedAt ?? this.deletedAt,
        categoryName: categoryName ?? this.categoryName,
        files: files ?? this.files,
        creatorDetail: creatorDetail ?? this.creatorDetail,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['category_id'] = categoryId;
    map['user_id'] = userId;
    map['user_type'] = userType;
    map['title'] = title;
    map['description'] = description;
    if (faq != null) {
      map['faq'] = faq?.map((v) => v.toJson()).toList();
    }
    map['file_type'] = fileType;
    map['path'] = path;
    map['file'] = file;
    map['likes'] = likes;
    map['is_liked'] = isLiked;
    map['is_commented'] = isCommented;
    map['comments'] = comments;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['status'] = status;
    map['deleted_at'] = deletedAt;
    map['category_name'] = categoryName;

    if (files != null) {
      map['files'] = files?.map((v) => v).toList();
    }
    if (creatorDetail != null) {
      map['creator_detail'] = creatorDetail?.toJson();
    }
    return map;
  }
}

FeedsCreatorDetail creatorDetailFromJson(String str) => FeedsCreatorDetail.fromJson(json.decode(str));

String creatorDetailToJson(FeedsCreatorDetail data) => json.encode(data.toJson());

class FeedsCreatorDetail {
  FeedsCreatorDetail({
    this.id,
    this.name,
    this.address,
    this.profilePic,
    this.isVerified,
  });

  FeedsCreatorDetail.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    profilePic = json['profile_pic'];
    isVerified = json['is_verified'];
  }

  num? id;
  String? name;
  String? address;
  dynamic profilePic;
  bool? isVerified;

  FeedsCreatorDetail copyWith({
    num? id,
    String? name,
    String? address,
    dynamic profilePic,
    bool? is_verified,
  }) =>
      FeedsCreatorDetail(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        profilePic: profilePic ?? this.profilePic,
        isVerified: is_verified ?? this.isVerified,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['address'] = address;
    map['profile_pic'] = profilePic;
    map['is_verified'] = isVerified;
    return map;
  }
}

FeedsFaq faqFromJson(String str) => FeedsFaq.fromJson(json.decode(str));

String faqToJson(FeedsFaq data) => json.encode(data.toJson());

class FeedsFaq {
  FeedsFaq({
    this.question,
    this.answer,
  });

  FeedsFaq.fromJson(dynamic json) {
    question = json['question'];
    answer = json['answer'];
  }

  String? question;
  String? answer;

  FeedsFaq copyWith({
    String? question,
    String? answer,
  }) =>
      FeedsFaq(
        question: question ?? this.question,
        answer: answer ?? this.answer,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question'] = question;
    map['answer'] = answer;
    return map;
  }
}
