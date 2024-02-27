import 'dart:convert';

ChapterDetailsModel chapterDetailsModelFromJson(String str) => ChapterDetailsModel.fromJson(json.decode(str));

String chapterDetailsModelToJson(ChapterDetailsModel data) => json.encode(data.toJson());

class ChapterDetailsModel {
  ChapterDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  ChapterDetailsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ChapterDetailsData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  ChapterDetailsData? data;

  ChapterDetailsModel copyWith({
    bool? status,
    String? message,
    ChapterDetailsData? data,
  }) =>
      ChapterDetailsModel(
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

ChapterDetailsData dataFromJson(String str) => ChapterDetailsData.fromJson(json.decode(str));

String dataToJson(ChapterDetailsData data) => json.encode(data.toJson());

class ChapterDetailsData {
  ChapterDetailsData({
    this.id,
    this.name,
    this.number,
    this.trainingId,
    this.chapterStatus,
    this.assets,
  });

  ChapterDetailsData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    number = json['number'];
    trainingId = json['training_id'];
    chapterStatus = json['chapter_status'];
    if (json['assets'] != null) {
      assets = [];
      json['assets'].forEach((v) {
        assets?.add(ChapterExercise.fromJson(v));
      });
    }
  }

  num? id;
  String? name;
  num? number;
  num? trainingId;
  String? chapterStatus;
  List<ChapterExercise>? assets;

  ChapterDetailsData copyWith({
    num? id,
    String? name,
    num? number,
    num? trainingId,
    String? chapterStatus,
    List<ChapterExercise>? assets,
  }) =>
      ChapterDetailsData(
        id: id ?? this.id,
        name: name ?? this.name,
        number: number ?? this.number,
        trainingId: trainingId ?? this.trainingId,
        chapterStatus: chapterStatus ?? this.chapterStatus,
        assets: assets ?? this.assets,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['number'] = number;
    map['training_id'] = trainingId;
    map['chapter_status'] = chapterStatus;
    if (assets != null) {
      map['assets'] = assets?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

ChapterExercise assetsFromJson(String str) => ChapterExercise.fromJson(json.decode(str));

String assetsToJson(ChapterExercise data) => json.encode(data.toJson());

class ChapterExercise {
  ChapterExercise({
    this.id,
    this.fileType,
    this.title,
    this.description,
    this.path,
    this.file,
    this.files,
    this.sequence,
  });

  ChapterExercise.fromJson(dynamic json) {
    id = json['id'];
    fileType = json['file_type'];
    title = json['title'];
    description = json['description'];
    path = json['path'];
    file = json['file'];
    files = json['files'];
    sequence = json['sequence'];
  }

  num? id;
  String? fileType;
  dynamic title;
  dynamic description;
  String? path;
  String? file;
  List<String>? files;
  dynamic sequence;

  ChapterExercise copyWith({
    num? id,
    String? fileType,
    dynamic title,
    dynamic description,
    String? path,
    String? file,
    List<String>? files,
    dynamic sequence,
  }) =>
      ChapterExercise(
        id: id ?? this.id,
        fileType: fileType ?? this.fileType,
        title: title ?? this.title,
        description: description ?? this.description,
        path: path ?? this.path,
        file: file ?? this.file,
        files: files ?? this.files,
        sequence: sequence ?? this.sequence,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['file_type'] = fileType;
    map['title'] = title;
    map['description'] = description;
    map['path'] = path;
    map['file'] = file;
    if (files != null) {
      map['files'] = files?.map((v) => v).toList();
    }
    map['sequence'] = sequence;
    return map;
  }
}
