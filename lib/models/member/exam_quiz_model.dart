import 'dart:convert';

ExamQuizModel examQuizModelFromJson(String str) => ExamQuizModel.fromJson(json.decode(str));

String examQuizModelToJson(ExamQuizModel data) => json.encode(data.toJson());

class ExamQuizModel {
  ExamQuizModel({
    this.status,
    this.message,
    this.data,
  });

  ExamQuizModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ExamQuizQuestion.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<ExamQuizQuestion>? data;

  ExamQuizModel copyWith({
    bool? status,
    String? message,
    List<ExamQuizQuestion>? data,
  }) =>
      ExamQuizModel(
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

ExamQuizQuestion dataFromJson(String str) => ExamQuizQuestion.fromJson(json.decode(str));

String dataToJson(ExamQuizQuestion data) => json.encode(data.toJson());

class ExamQuizQuestion {
  ExamQuizQuestion({
    this.id,
    this.categoryId,
    this.question,
    this.selectedAnswer,
    this.answers,
    this.position,
  });

  ExamQuizQuestion.fromJson(dynamic json) {
    id = json['id'];
    categoryId = json['category_id'];
    question = json['question'];
    selectedAnswer = json['selectedAnswer'];
    answers = json['answers'] != null ? json['answers'].cast<String>() : [];
    position = json['position'];
  }

  num? id;
  num? categoryId;
  String? question;
  String? selectedAnswer;
  List<String>? answers;
  dynamic position;

  ExamQuizQuestion copyWith({
    num? id,
    num? categoryId,
    String? question,
    String? selectedAnswer,
    List<String>? answers,
    dynamic position,
  }) =>
      ExamQuizQuestion(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        question: question ?? this.question,
        selectedAnswer: selectedAnswer ?? this.selectedAnswer,
        answers: answers ?? this.answers,
        position: position ?? this.position,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['category_id'] = categoryId;
    map['question'] = question;
    map['selectedAnswer'] = selectedAnswer;
    map['answers'] = answers;
    map['position'] = position;
    return map;
  }
}
