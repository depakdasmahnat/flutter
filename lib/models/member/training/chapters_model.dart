import 'dart:convert';

ChaptersModel chaptersModelFromJson(String str) => ChaptersModel.fromJson(json.decode(str));

String chaptersModelToJson(ChaptersModel data) => json.encode(data.toJson());

class ChaptersModel {
  ChaptersModel({
    this.status,
    this.message,
    this.data,
  });

  ChaptersModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ChapterData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<ChapterData>? data;

  ChaptersModel copyWith({
    bool? status,
    String? message,
    List<ChapterData>? data,
  }) =>
      ChaptersModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

ChapterData dataFromJson(String str) => ChapterData.fromJson(json.decode(str));

String dataToJson(ChapterData data) => json.encode(data.toJson());

class ChapterData {
  ChapterData({
    this.id,
    this.chapterNo,
    this.chapterName,
    this.description,
    this.chapterStatus,
  });

  ChapterData.fromJson(dynamic json) {
    id = json['id'];
    chapterNo = json['chapter_no'];
    chapterName = json['chapter_name'];
    description = json['description'];
    chapterStatus = json['chapter_status'];
  }

  num? id;
  num? chapterNo;
  String? chapterName;
  String? description;
  String? chapterStatus;

  ChapterData copyWith({
    num? id,
    num? chapterNo,
    String? chapterName,
    String? description,
    String? chapterStatus,
  }) =>
      ChapterData(
        id: id ?? this.id,
        chapterNo: chapterNo ?? this.chapterNo,
        chapterName: chapterName ?? this.chapterName,
        description: description ?? this.description,
        chapterStatus: chapterStatus ?? this.chapterStatus,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['chapter_no'] = chapterNo;
    map['chapter_name'] = chapterName;
    map['description'] = description;
    map['chapter_status'] = chapterStatus;
    return map;
  }
}
