import 'dart:convert';

QuizReportModel quizReportModelFromJson(String str) => QuizReportModel.fromJson(json.decode(str));

String quizReportModelToJson(QuizReportModel data) => json.encode(data.toJson());

class QuizReportModel {
  QuizReportModel({
    this.status,
    this.result,
    this.message,
    this.correctAnswers,
    this.wrongAnswers,
    this.score,
    this.questionAnswers,
  });

  QuizReportModel.fromJson(dynamic json) {
    status = json['status'];
    result = json['result'];
    message = json['message'];
    correctAnswers = json['correct_answers'];
    wrongAnswers = json['wrong_answers'];
    score = json['score'];
    if (json['question_answers'] != null) {
      questionAnswers = [];
      json['question_answers'].forEach((v) {
        questionAnswers?.add(QuestionAnswers.fromJson(v));
      });
    }
  }

  bool? status;
  String? result;
  String? message;
  num? correctAnswers;
  num? wrongAnswers;
  String? score;
  List<QuestionAnswers>? questionAnswers;

  QuizReportModel copyWith({
    bool? status,
    String? result,
    String? message,
    num? correctAnswers,
    num? wrongAnswers,
    String? score,
    List<QuestionAnswers>? questionAnswers,
  }) =>
      QuizReportModel(
        status: status ?? this.status,
        result: result ?? this.result,
        message: message ?? this.message,
        correctAnswers: correctAnswers ?? this.correctAnswers,
        wrongAnswers: wrongAnswers ?? this.wrongAnswers,
        score: score ?? this.score,
        questionAnswers: questionAnswers ?? this.questionAnswers,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['result'] = result;
    map['message'] = message;
    map['correct_answers'] = correctAnswers;
    map['wrong_answers'] = wrongAnswers;
    map['score'] = score;
    if (questionAnswers != null) {
      map['question_answers'] = questionAnswers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

QuestionAnswers questionAnswersFromJson(String str) => QuestionAnswers.fromJson(json.decode(str));

String questionAnswersToJson(QuestionAnswers data) => json.encode(data.toJson());

class QuestionAnswers {
  QuestionAnswers({
    this.question,
    this.answer,
  });

  QuestionAnswers.fromJson(dynamic json) {
    question = json['question'];
    answer = json['answer'];
  }

  String? question;
  String? answer;

  QuestionAnswers copyWith({
    String? question,
    String? answer,
  }) =>
      QuestionAnswers(
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
