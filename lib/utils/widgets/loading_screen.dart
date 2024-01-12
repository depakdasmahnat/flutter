import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({
    Key? key,
    this.message,
    this.heightFactor,
    this.color,
    this.widthFactor,
  }) : super(key: key);

  final String? message;
  final double? heightFactor;
  final double? widthFactor;
  final Color? color;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late String? message = widget.message;
  late double? heightFactor = widget.heightFactor;
  late double? widthFactor = widget.widthFactor;
  late Color? color = widget.color;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: heightFactor != null ? (size.height * heightFactor!) : null,
        width: widthFactor != null ? size.width * widthFactor! : size.width,
        color: color ?? Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CupertinoActivityIndicator(
                color: Colors.white,
                radius: 12,
              ),
            ),
            Text(
              message ?? 'Loading Data...',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
