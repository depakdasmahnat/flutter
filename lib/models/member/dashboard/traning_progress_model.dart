import 'dart:convert';

TrainingProgressModel trainingProgressModelFromJson(String str) =>
    TrainingProgressModel.fromJson(json.decode(str));

String trainingProgressModelToJson(TrainingProgressModel data) => json.encode(data.toJson());

class TrainingProgressModel {
  TrainingProgressModel({
    this.status,
    this.message,
    this.modules,
    this.perc,
    this.advanceEligible,
  });

  TrainingProgressModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    modules = json['modules'];
    perc = json['perc'];
    advanceEligible = json['advance_eligible'];
  }

  bool? status;
  String? message;
  String? modules;
  num? perc;
  bool? advanceEligible;

  TrainingProgressModel copyWith({
    bool? status,
    String? message,
    String? modules,
    num? perc,
    bool? advanceEligible,
  }) =>
      TrainingProgressModel(
        status: status ?? this.status,
        message: message ?? this.message,
        modules: modules ?? this.modules,
        perc: perc ?? this.perc,
        advanceEligible: advanceEligible ?? this.advanceEligible,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['modules'] = modules;
    map['perc'] = perc;
    map['advance_eligible'] = advanceEligible;
    return map;
  }
}
