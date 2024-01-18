import 'package:flutter/material.dart';

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
