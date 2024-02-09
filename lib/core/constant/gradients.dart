import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';

///Gradient

Gradient primaryGradient = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    secondaryColor,
    primaryColor,
  ],
  stops: [0.13, 0.76],
);

Gradient inActiveGradient = LinearGradient(
  begin: Alignment.bottomRight,
  end: Alignment.topLeft,
  colors: [
    Colors.black,
    const Color(0xff000000),
    Colors.grey.shade600,
  ],
  stops: const [0, 0.42, 1],
);
Gradient locationCardGradient = LinearGradient(
  colors: [
    const Color(0xff000000).withOpacity(0.65),
    Colors.grey.shade900.withOpacity(0.70),
  ],
);
Gradient blankGradient = const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
  Colors.grey,
  Colors.grey,
], stops: [
  0,
  0.100
]);
Gradient glassMorphismGradient = LinearGradient(
  colors: [
    Colors.white.withOpacity(0.9),
    Colors.white.withOpacity(0.6),
  ],
  begin: AlignmentDirectional.topStart,
  end: AlignmentDirectional.bottomEnd,
);

Gradient primaryChipButtonGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    primaryColor.withOpacity(0.7),
    secondaryColor.withOpacity(0.8),
  ],
);

Gradient primaryGreyGradient = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
  Colors.grey.shade500.withOpacity(0.8),
  Colors.grey.shade600.withOpacity(0.8),
  Colors.grey.shade800.withOpacity(0.8),
], stops: const [
  0.2,
  0.6,
  0.9
]);

Gradient carCardGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    const Color(0xff15E41E).withOpacity(0.9),
    const Color(0xffC3FF1A),
  ],
);
Gradient textFieldGradient = const LinearGradient(
  begin: Alignment.centerRight,
  end: Alignment.centerLeft,
  colors: [
    Color(0xff0C0C0D),
    Color(0xff35383F),
  ],
);
Gradient primaryPinkGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Colors.pinkAccent.withOpacity(0.4),
    Colors.pinkAccent.withOpacity(0.4),
  ],
);
Gradient primaryGreenGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    const Color(0xff0CF649).withOpacity(0.3),
    const Color(0xff4FD012).withOpacity(0.3),
  ],
);

Gradient backButtonGradient = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xff15E41E),
    Color(0xffC3FF1A),
  ],
  stops: [0, 1],
);
