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
Gradient blackGradient = const LinearGradient(
  end: Alignment.bottomCenter,
  begin: Alignment.topCenter,
  colors: [
    Color(0xff1C1C1C),
    Color(0xff282828),
  ],
);

Gradient targetGradient = LinearGradient(
  end: Alignment.bottomLeft,
  begin: Alignment.topRight,
  colors: [
    Colors.grey.shade300,
    Colors.grey.shade400,
  ],
);

Gradient limeGradient = const LinearGradient(
  end: Alignment.bottomLeft,
  begin: Alignment.topRight,
  colors: [
    Color(0xffD1F35A),
    Color(0xffC0D968),
  ],
);

Gradient blueGradient = const LinearGradient(
  end: Alignment.bottomLeft,
  begin: Alignment.topRight,
  colors: [
    Color(0xff3CDCDC),
    Color(0xff13BCBC),
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

Gradient rainbowGradient = const LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xffCC0000),
    Color(0xffFFEA30),
    Color(0xff00E24D),
    Color(0xff005BE2),
    Color(0xff7F00E2),
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
