import 'dart:convert';

TrainingProgressModel trainingProgressModelFromJson(String str) =>
    TrainingProgressModel.fromJson(json.decode(str));

String trainingProgressModelToJson(TrainingProgressModel data) => json.encode(data.toJson());

class TrainingProgressModel {
  TrainingProgressModel({
    this.status,
    this.message,
    this.chapter,
    this.perc,
  });

  TrainingProgressModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    chapter = json['chapter'];
    perc = json['perc'];
  }

  bool? status;
  String? message;
  String? chapter;
  num? perc;

  TrainingProgressModel copyWith({
    bool? status,
    String? message,
    String? chapter,
    num? perc,
  }) =>
      TrainingProgressModel(
        status: status ?? this.status,
        message: message ?? this.message,
        chapter: chapter ?? this.chapter,
        perc: perc ?? this.perc,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['chapter'] = chapter;
    map['perc'] = perc;
    return map;
  }
}
