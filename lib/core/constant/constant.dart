import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';

import 'colors.dart';

const double kPadding = 16;
const double bottomNavbarSize = 120;
const double kMargin = 16;
const double kBorderRadius = 24;

const BorderRadius upperBorderRadius = BorderRadius.only(
  topLeft: Radius.circular(kBorderRadius),
  topRight: Radius.circular(kBorderRadius),
);
Decoration? decoration = ShapeDecoration(
  gradient: const LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [Color(0xFF1B1B1B), Color(0xFF282828)],
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.96),
  ),
);

Gradient primaryGradientTransparent = LinearGradient(
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  colors: [
    primaryColor.withOpacity(0.65),
    secondaryColor.withOpacity(0.53),
  ],
);

Color statusColor({required num? value}) {
  Color color = Colors.grey;
  num? percentage = num.tryParse('$value') ?? 0;
  if (percentage == 0 || percentage < 20) {
    color = Colors.red;
  } else if (percentage < 40) {
    color = Colors.orangeAccent;
  } else if (percentage < 60) {
    color = Colors.purple;
  } else if (percentage < 80) {
    color = Colors.blue;
  } else {
    color = Colors.green;
  }
  return color;
}

Gradient statusGradient({required num? sale}) {
  num? sales = num.tryParse('$sale') ?? 0;

  Gradient gradient = primaryGradient;

  if (sales == 0 || sales < 20) {
    gradient = redGradient;
  } else if (sales < 40) {
    gradient = yellowGradient;
  } else if (sales < 60) {
    gradient = purpleGradient;
  } else if (sales < 80) {
    gradient = blueGradient;
  } else {
    gradient = greenGradient;
  }
  return gradient;
}

String dayFormat = 'EEE dd MMM';
