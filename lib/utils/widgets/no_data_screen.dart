import 'package:flutter/material.dart';

class NoDataScreen extends StatelessWidget {
  const NoDataScreen({
    super.key,
    this.message,
    this.heightFactor,
    this.widthFactor,
    this.alignment,
    this.color,
    this.backgroundColor,
    this.fontSize,
  })  : assert(widthFactor == null || widthFactor >= 0.0),
        assert(heightFactor == null || heightFactor >= 0.0);

  final String? message;
  final double? heightFactor;
  final double? widthFactor;
  final double? fontSize;
  final Color? color;
  final Color? backgroundColor;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: backgroundColor ?? Colors.transparent,
      height: (heightFactor ?? 1) * size.height,
      width: (widthFactor ?? 1) * size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            message ?? "No Data Found",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color ?? Theme.of(context).primaryColor,
                  fontSize: fontSize,
                ),
          ),
        ],
      ),
    );
  }
}
