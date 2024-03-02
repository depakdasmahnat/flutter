import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    this.gradient,
    this.style,
    this.textAlign,
    this.maxLines,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return gradient != null
        ? ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => gradient!.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: Text(
              text,
              style: style,
              textAlign: textAlign,
              maxLines: maxLines,
            ),
          )
        : Text(
            text,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
          );
  }
}
