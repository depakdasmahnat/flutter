import 'package:flutter/cupertino.dart';

class DashboardData {
  final String? title;
  final String activeImage;
  final String inActiveImage;
  final Widget widget;

  DashboardData({
    this.title,
    required this.activeImage,
    required this.inActiveImage,
    required this.widget,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      title: json['title'],
      activeImage: json['activeImage'],
      inActiveImage: json['inActiveImage'],
      widget: json['widget'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'activeImage': activeImage,
      'inActiveImage': inActiveImage,
      'widget': widget,
    };
  }
}
