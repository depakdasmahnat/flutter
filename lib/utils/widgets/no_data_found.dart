import 'package:flutter/material.dart';

class NoDataFound extends StatefulWidget {
  const NoDataFound({super.key, this.message, this.heightFactor, this.widthFactor, this.color});

  final String? message;
  final double? heightFactor;
  final double? widthFactor;
  final Color? color;

  @override
  State<NoDataFound> createState() => _NoDataFoundState();
}

class _NoDataFoundState extends State<NoDataFound> {
  late String? message = widget.message;
  late double? heightFactor = widget.heightFactor;
  late double? widthFactor = widget.widthFactor;
  late Color? color = widget.color;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: heightFactor != null ? size.height * heightFactor! : null,
      width: widthFactor != null ? size.width * widthFactor! : size.width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                message ?? 'No Data Found',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color ?? Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
