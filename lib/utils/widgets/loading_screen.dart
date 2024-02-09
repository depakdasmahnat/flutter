import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    super.key,
    this.message,
    this.heightFactor,
    this.widthFactor,
    this.alignment,
    this.color,
    this.backgroundColor, this.fontSize,
  })  : assert(widthFactor == null || widthFactor >= 0.0),
        assert(heightFactor == null || heightFactor >= 0.0);

  final String? message;
  final double? heightFactor;
  final double? widthFactor;
  final Color? color;
  final Color? backgroundColor;
  final double? fontSize;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: backgroundColor ?? Colors.transparent,
      height: (heightFactor ?? 0.8) * size.height,
      width: (widthFactor ?? 1) * size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoActivityIndicator(
              radius: 12,
              color: color ?? Theme.of(context).primaryColor,
            ),
          ),
          Text(
            message ?? "Loading Data...",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color ?? Theme.of(context).primaryColor,
              fontSize: fontSize
                ),
          ),
        ],
      ),
    );
  }
}
