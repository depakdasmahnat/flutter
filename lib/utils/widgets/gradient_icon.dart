import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  const GradientIcon(
      {super.key, required this.icon, required this.size, required this.gradient, this.margin, this.padding});
  final IconData icon;
  final double size;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: Container(
        width: size,
        height: size,
        padding: padding,
        margin: margin ?? const EdgeInsets.only(left: 4, right: 4),
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}
