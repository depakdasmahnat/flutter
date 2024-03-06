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
    this.advanceEligible,
  });

  TrainingProgressModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    chapter = json['chapter'];
    perc = json['perc'];
    advanceEligible = json['advance_eligible'];
  }

  bool? status;
  String? message;
  String? chapter;
  num? perc;
  bool? advanceEligible;

  TrainingProgressModel copyWith({
    bool? status,
    String? message,
    String? chapter,
    num? perc,
    bool? advanceEligible,
  }) =>
      TrainingProgressModel(
        status: status ?? this.status,
        message: message ?? this.message,
        chapter: chapter ?? this.chapter,
        perc: perc ?? this.perc,
        advanceEligible: advanceEligible ?? this.advanceEligible,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['chapter'] = chapter;
    map['perc'] = perc;
    map['advance_eligible'] = advanceEligible;
    return map;
  }
}
