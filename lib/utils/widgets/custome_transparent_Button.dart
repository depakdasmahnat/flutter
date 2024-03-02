import 'package:flutter/material.dart';

import '../../core/constant/colors.dart';

class CustomTransparentButton extends StatefulWidget {
  String? title;
  void Function()? onTap;

  CustomTransparentButton({super.key, this.title, this.onTap});

  @override
  State<CustomTransparentButton> createState() => _CustomTransparentButtonState();
}

class _CustomTransparentButtonState extends State<CustomTransparentButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 70,
        // width: 374,
        decoration: BoxDecoration(
            // color: goldColor,

            border: Border.all(color: primaryColor, strokeAlign: 1),
            borderRadius: BorderRadius.circular(18)),
        child: Center(
            child: Text(widget.title ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ))),
      ),
    );
  }
}
