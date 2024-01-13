import 'package:flutter/material.dart';

const double kPadding = 16;
const double bottomNavbarSize = 120;
const double kMargin = 16;
const double kBorderRadius = 24;

const BorderRadius upperBorderRadius = BorderRadius.only(
  topLeft: Radius.circular(kBorderRadius),
  topRight: Radius.circular(kBorderRadius),
);

Color statusColor({required String? status}) {
  Color color = Colors.grey;
  switch (status) {
    case 'Processing':
      color = Colors.blue;
      break;
    case 'Successfully':
      color = Colors.green;
      break;
    case 'Failed':
      color = Colors.orangeAccent;
      break;
    case 'Canceled':
      color = Colors.red;
      break;
  }
  return color;
}
