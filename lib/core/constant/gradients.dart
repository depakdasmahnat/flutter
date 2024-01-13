import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/colors.dart';

///Gradient

Gradient primaryGradient = const LinearGradient(
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  colors: [
    primaryColor,
    secondaryColor,
  ],
);
Gradient primaryGradientTransparent = LinearGradient(
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  colors: [
    primaryColor.withOpacity(0.65),
    secondaryColor.withOpacity(0.53),
  ],
);

Gradient inActiveGradient = const LinearGradient(
  end: Alignment.bottomLeft,
  begin: Alignment.topRight,
  colors: [
    Color(0xff4A4A4A),
    Color(0xff3B3B3B),
  ],
);
Gradient feedsCardGradient = const LinearGradient(
  end: Alignment.bottomLeft,
  begin: Alignment.topRight,
  colors: [
    Color(0xff1C1C1C),
    Color(0xff282828),
  ],
);
Gradient inActiveGradientTransparent = LinearGradient(
  end: Alignment.bottomLeft,
  begin: Alignment.topRight,
  colors: [
    const Color(0xff4A4A4A).withOpacity(0.61),
    const Color(0xff3B3B3B).withOpacity(0.44),
  ],
);

Gradient blankGradient = const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
  Colors.grey,
  Colors.grey,
], stops: [
  0,
  0.100
]);

Gradient textFieldGradient = const LinearGradient(
  begin: Alignment.centerRight,
  end: Alignment.centerLeft,
  colors: [
    primaryColor,
    secondaryColor,
  ],
);
