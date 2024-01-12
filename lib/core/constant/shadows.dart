import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/colors.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';

///1) Text Shadow...

List<Shadow>? primaryTextShadow(BuildContext context, {Color? color}) {
  return [
    Shadow(
      color: color ?? (context.darkMode ? Colors.black : Colors.white),
      blurRadius: 1,
    ),
  ];
}

///2) Box Shadow...
List<BoxShadow> primaryBoxShadow(BuildContext context) {
  List<BoxShadow> boxShadow = [
    BoxShadow(
        offset: const Offset(1, 2),
        color: context.darkMode ? Colors.grey.shade900 : Colors.grey.shade400,
        blurRadius: 3,
        spreadRadius: 0),
    BoxShadow(
        offset: const Offset(0, 0),
        color: context.darkMode ? Colors.grey.shade800 : Colors.grey.shade50,
        blurRadius: 3,
        spreadRadius: 0),
  ];
  return boxShadow;
}

List<BoxShadow> primaryBubbleShadow({
  required double radius,
}) {
  List<BoxShadow> boxShadow = [
    BoxShadow(
      offset: const Offset(0, 0),
      color: primaryColor.withOpacity(0.1),
      blurRadius: radius * 2,
      spreadRadius: radius,
    ),
    BoxShadow(
      offset: const Offset(1, 1),
      color: primaryColor.withOpacity(0.16),
      blurRadius: radius * 2,
      spreadRadius: radius,
    ),
  ];
  return boxShadow;
}
