import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';

///1) Text Shadow...

List<Shadow>? defaultTextShadow({Color? color}) {
  return [
    Shadow(
      color: color ?? Colors.white,
      blurRadius: 1,
    ),
  ];
}

///2) Box Shadow...
List<BoxShadow> defaultBoxShadow({Color? color}) {
  List<BoxShadow> boxShadow = [
    BoxShadow(offset: const Offset(2, 3), color: color ?? Colors.grey.shade300, blurRadius: 4, spreadRadius: 0.4),
    BoxShadow(offset: const Offset(0, 0), color: color ?? primaryGrey.withOpacity(0.4), blurRadius: 1, spreadRadius: 0),
  ];
  return boxShadow;
}

List<BoxShadow> primaryBoxShadow({Color? color}) {
  List<BoxShadow> boxShadow = [
    BoxShadow(
      color: color ?? const Color(0xFF000000).withOpacity(0.06),
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 2,
    ),
  ];
  return boxShadow;
}

List<BoxShadow> locationCardBoxShadow({Color? color}) {
  List<BoxShadow> boxShadow = [
    BoxShadow(offset: const Offset(1, 2), color: color ?? const Color(0xffFFFFFF), blurRadius: 3, spreadRadius: 0),
    BoxShadow(offset: const Offset(0, 0), color: color ?? const Color(0xff000000), blurRadius: 3, spreadRadius: 0),
  ];
  return boxShadow;
}

List<BoxShadow> primaryBubbleShadow({
  required double radius,
}) {
  List<BoxShadow> boxShadow = [
    BoxShadow(
      offset: const Offset(0, 0),
      color: Colors.green.withOpacity(0.1),
      blurRadius: radius * 2,
      spreadRadius: radius,
    ),
    BoxShadow(
      offset: const Offset(1, 1),
      color: const Color(0xff27C048).withOpacity(0.16),
      blurRadius: radius * 2,
      spreadRadius: radius,
    ),
  ];
  return boxShadow;
}

List<BoxShadow> primaryButtonBoxShadow({Color? color}) {
  List<BoxShadow> boxShadow = [
    BoxShadow(
      offset: const Offset(-1, -1),
      color: const Color(0xff15E41E).withOpacity(0.8),
      blurRadius: 4,
      spreadRadius: 2.5,
    ),
    const BoxShadow(
      offset: Offset(1, 1),
      color: Color(0xffC3FF1A),
      blurRadius: 4,
      spreadRadius: 2.5,
    ),
    BoxShadow(
      offset: const Offset(0, 0),
      color: color ?? Colors.black,
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];
  return boxShadow;
}

List<BoxShadow> primaryTextShadow({Color? color}) {
  List<BoxShadow> boxShadow = [
    BoxShadow(
      offset: const Offset(0, 8),
      color: const Color(0xff15E41E).withOpacity(0.9),
      blurRadius: 20,
      spreadRadius: 10,
    ),
    BoxShadow(
      offset: const Offset(-10, 12),
      color: const Color(0xff15E41E).withOpacity(0.7),
      blurRadius: 20,
      spreadRadius: 10,
    ),
    BoxShadow(
      offset: const Offset(16, 16),
      color: const Color(0xff15E41E).withOpacity(0.7),
      blurRadius: 16,
      spreadRadius: 10,
    ),
    BoxShadow(
      offset: const Offset(-16, 16),
      color: const Color(0xff15E41E).withOpacity(0.4),
      blurRadius: 24,
      spreadRadius: 10,
    ),
    const BoxShadow(
      offset: Offset(1, 1),
      color: Color(0xffC3FF1A),
      blurRadius: 4,
      spreadRadius: 2.5,
    ),
  ];
  return boxShadow;
}
