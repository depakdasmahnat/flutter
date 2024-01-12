import 'dart:math';

import 'package:flutter/material.dart';

double textScaleFactor(BuildContext context, {double maxTextScaleFactor = 2}) {
  final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;

  final double screenDiagonal = sqrt(pow(screenWidth, 2) + pow(screenHeight, 2));
  const double referenceDiagonal = 1400;

  double diagonalRatio = screenDiagonal / referenceDiagonal;
  diagonalRatio = max(diagonalRatio, 1);

  double textScale = diagonalRatio * (maxTextScaleFactor / devicePixelRatio);

  return min(textScale, maxTextScaleFactor);
}
