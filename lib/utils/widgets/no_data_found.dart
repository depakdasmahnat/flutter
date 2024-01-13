import 'package:flutter/material.dart';

class NoDataFound extends StatefulWidget {
  const NoDataFound({Key? key, this.message, this.heightFactor, this.widthFactor}) : super(key: key);
  final String? message;
  final double? heightFactor;
  final double? widthFactor;

  @override
  State<NoDataFound> createState() => _NoDataFoundState();
}

class _NoDataFoundState extends State<NoDataFound> {
  late String? message = widget.message;
  late double? heightFactor = widget.heightFactor;
  late double? widthFactor = widget.widthFactor;

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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
