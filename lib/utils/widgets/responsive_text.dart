import 'package:flutter/material.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const ResponsiveText(this.text, {super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        final fontSize =
            availableWidth / text.length < availableHeight ? availableWidth / text.length : availableHeight;

        return Text(
          text,
          style: style.copyWith(fontSize: fontSize),
        );
      },
    );
  }
}
