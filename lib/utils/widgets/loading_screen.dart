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
    this.backgroundColor,
    required this.buildContext,
  })  : assert(widthFactor == null || widthFactor >= 0.0),
        assert(heightFactor == null || heightFactor >= 0.0);

  final BuildContext buildContext;
  final String? message;
  final double? heightFactor;
  final double? widthFactor;
  final Color? color;
  final Color? backgroundColor;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: alignment ?? Alignment.center,
      heightFactor: heightFactor ?? 1,
      widthFactor: widthFactor ?? 1,
      child: Container(
        color: backgroundColor ?? Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoActivityIndicator(
                radius: 12,
                color: color ?? Theme.of(buildContext).primaryColor,
              ),
            ),
            Text(
              message ?? 'Loading Data...',
              style: Theme.of(buildContext).textTheme.titleMedium?.copyWith(
                    color: color ?? Theme.of(buildContext).primaryColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
