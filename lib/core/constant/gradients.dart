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

Gradient inActiveGradient = const LinearGradient(
  end: Alignment.topCenter,
  begin: Alignment.bottomCenter,
  colors: [
    Color(0xff3B3B3B),
    Color(0xff4A4A4A),
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
