import 'dart:convert';

import 'package:flutter/cupertino.dart';

BottomNavBarData bottomNavBarDataFromJson(String str) => BottomNavBarData.fromJson(json.decode(str));

String bottomNavBarDataToJson(BottomNavBarData data) => json.encode(data.toJson());

class BottomNavBarData {
  BottomNavBarData({
    required this.title,
    required this.image,
    required this.widget,
    this.selected,
  });

  BottomNavBarData.fromJson(dynamic json) {
    title = json['title'];
    image = json['image'];
    widget = json['widget']??Container();
    selected = json['selected'];
  }

  String? title;
  String? image;
  Widget? widget;
  bool? selected;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['image'] = image;
    map['widget'] = widget;
    map['selected'] = selected;
    return map;
  }
}
