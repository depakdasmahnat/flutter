import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String description,
  Color? color,
  required TextButton proceedButton,
  TextButton? cancelButton,
}) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          style: TextStyle(
            color: color ?? Colors.black,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          cancelButton ??
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
          proceedButton,
        ],
        content: Text(
          description,
          textAlign: TextAlign.center,
        ),
      );
    },
  );
}

num deviceSpecificValue({
  required BuildContext context,
  required num device,
  required num tablet,
  num? desktop,
}) {
  double screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 600) {
    return device; // Phone
  } else if (screenWidth < 1200) {
    return tablet; // Tablet
  } else {
    return desktop ?? tablet; // Desktop
  }
}

class TextScaleFactor {
  static double autoScale(BuildContext context, {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}
