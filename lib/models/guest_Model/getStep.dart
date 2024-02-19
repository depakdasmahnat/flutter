import 'dart:convert';
GetStep getStepFromJson(String str) => GetStep.fromJson(json.decode(str));
String getStepToJson(GetStep data) => json.encode(data.toJson());
class GetStep {
  GetStep({
      this.status, 
      this.message, 
      this.demoStep,});

  GetStep.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    demoStep = json['demo_step'];
  }
  bool? status;
  String? message;
  num? demoStep;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['demo_step'] = demoStep;
    return map;
  }

}