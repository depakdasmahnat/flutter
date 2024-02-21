import 'dart:convert';
GuestDemoQuestion guestDemoQuestionFromJson(String str) => GuestDemoQuestion.fromJson(json.decode(str));
String guestDemoQuestionToJson(GuestDemoQuestion data) => json.encode(data.toJson());
class GuestDemoQuestion {
  GuestDemoQuestion({
      this.status, 
      this.message, 
      this.data,});

  GuestDemoQuestion.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<Data>? data;

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

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.questionType1, 
      this.questionType2,});

  Data.fromJson(dynamic json) {
    if (json['question_type_1'] != null) {
      questionType1 = [];
      json['question_type_1'].forEach((v) {
        questionType1?.add(QuestionType1.fromJson(v));
      });
    }
    if (json['question_type_2'] != null) {
      questionType2 = [];
      json['question_type_2'].forEach((v) {
        questionType2?.add(QuestionType2.fromJson(v));
      });
    }
  }
  List<QuestionType1>? questionType1;
  List<QuestionType2>? questionType2;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (questionType1 != null) {
      map['question_type_1'] = questionType1?.map((v) => v.toJson()).toList();
    }
    if (questionType2 != null) {
      map['question_type_2'] = questionType2?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

QuestionType2 questionType2FromJson(String str) => QuestionType2.fromJson(json.decode(str));
String questionType2ToJson(QuestionType2 data) => json.encode(data.toJson());
class QuestionType2 {
  QuestionType2({
      this.id, 
      this.question, 
      this.answer,});

  QuestionType2.fromJson(dynamic json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'] != null ? json['answer'].cast<String>() : [];
  }
  num? id;
  String? question;
  List<String>? answer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['question'] = question;
    map['answer'] = answer;
    return map;
  }

}

QuestionType1 questionType1FromJson(String str) => QuestionType1.fromJson(json.decode(str));
String questionType1ToJson(QuestionType1 data) => json.encode(data.toJson());
class QuestionType1 {
  QuestionType1({
      this.id, 
      this.question, 
      this.answer,});

  QuestionType1.fromJson(dynamic json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
  }
  num? id;
  String? question;
  bool? answer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['question'] = question;
    map['answer'] = answer;
    return map;
  }

}