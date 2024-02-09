import 'package:flutter/material.dart';

class CustomTabData {
  CustomTabData({
    required this.id,
    required this.title,
    required this.tab,
  });

  int id;
  String title;

  Widget tab;
}
