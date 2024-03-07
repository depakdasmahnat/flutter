import 'package:flutter/material.dart';

import '../../core/constant/gradients.dart';

class GradientProgressBar extends StatelessWidget {
  final double lineHeight;
  final double value;
  final double cursorSize;
  final double borderRadius;

  final Gradient? gradient;
  final Color? backgroundColor;
  final EdgeInsets? margin;

  const GradientProgressBar({
    super.key,
    required this.value,
    this.gradient,
    this.lineHeight = 6,
    this.borderRadius = 16,
    this.cursorSize = 6,
    this.backgroundColor ,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final progressBarWidth = constraints.maxWidth * value;

          return Stack(
            alignment: Alignment.centerLeft,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: lineHeight,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: backgroundColor??Colors.grey.shade700,
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    height: lineHeight,
                    width: progressBarWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: gradient ?? rainbowGradient,
                    ),
                  ),
                  Positioned(
                    right: value <= 8 ? -18 : -5,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(cursorSize + cursorSize)),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(cursorSize)),
                        child: Container(
                          height: cursorSize,
                          width: cursorSize,
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              gradient: primaryGradient, borderRadius: BorderRadius.circular(cursorSize)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
