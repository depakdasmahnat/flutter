import 'dart:convert';

import 'package:flutter/material.dart';

ColorGrades colorGradesFromJson(String str) => ColorGrades.fromJson(json.decode(str));

String colorGradesToJson(ColorGrades data) => json.encode(data.toJson());

class ColorGrades {
  ColorGrades({
    this.gradient,
    this.percentage,
  });

  ColorGrades.fromJson(dynamic json) {
    gradient = json['gradient'];
    percentage = json['percentage'];
  }

  Gradient? gradient;
  num? percentage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['gradient'] = gradient;
    map['percentage'] = percentage;
    return map;
  }
}
