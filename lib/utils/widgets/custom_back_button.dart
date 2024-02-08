import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/constant/constant.dart';

class CustomBackButton extends StatefulWidget {
  const CustomBackButton({super.key, this.padding, this.icon,this.iconSize});

  final EdgeInsetsGeometry? padding;
  final IconData? icon;
  final double? iconSize;

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Container(
            height: 40,
            margin: const EdgeInsets.only(left: kPadding),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.6),
            ),
            child: Center(
              child: Padding(
                padding: widget.padding ?? const EdgeInsets.all(0),
                child: Icon(
                  widget.icon ?? AntDesign.left,
                  color: Colors.black,
                  size: widget.iconSize,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
