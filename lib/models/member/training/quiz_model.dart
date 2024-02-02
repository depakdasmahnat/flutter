import 'dart:convert';

QuizModel quizModelFromJson(String str) => QuizModel.fromJson(json.decode(str));

String quizModelToJson(QuizModel data) => json.encode(data.toJson());

class QuizModel {
  QuizModel({
    this.status,
    this.message,
    this.dataRecords,
    this.data,
  });

  QuizModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    dataRecords = json['data_records'] != null ? DataRecords.fromJson(json['data_records']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(QuizData.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  DataRecords? dataRecords;
  List<QuizData>? data;

  QuizModel copyWith({
    bool? status,
    String? message,
    DataRecords? dataRecords,
    List<QuizData>? data,
  }) =>
      QuizModel(
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

QuizData dataFromJson(String str) => QuizData.fromJson(json.decode(str));

String dataToJson(QuizData data) => json.encode(data.toJson());

class QuizData {
  QuizData({
    this.id,
    this.trainingId,
    this.chapterId,
    this.question,
    this.options,
    this.answer,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.selectedAnswer,
  });

  QuizData.fromJson(dynamic json) {
    id = json['id'];
    trainingId = json['training_id'];
    chapterId = json['chapter_id'];
    question = json['question'];
    options = json['options'] != null ? json['options'].cast<String>() : [];
    answer = json['answer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    selectedAnswer = json['selected_answer'];
  }

  num? id;
  num? trainingId;
  num? chapterId;
  String? question;
  List<String>? options;
  String? answer;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? selectedAnswer;

  QuizData copyWith({
    num? id,
    num? trainingId,
    num? chapterId,
    String? question,
    List<String>? options,
    String? answer,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    String? selectedAnswer,
  }) =>
      QuizData(
        id: id ?? this.id,
        trainingId: trainingId ?? this.trainingId,
        chapterId: chapterId ?? this.chapterId,
        question: question ?? this.question,
        options: options ?? this.options,
        answer: answer ?? this.answer,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['training_id'] = trainingId;
    map['chapter_id'] = chapterId;
    map['question'] = question;
    map['options'] = options;
    map['answer'] = answer;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['selected_answer'] = selectedAnswer;
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
