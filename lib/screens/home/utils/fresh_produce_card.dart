import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../core/functions.dart';
import '../../../utils/widgets/image_view.dart';

class FreshProduceCard extends StatelessWidget {
  const FreshProduceCard({
    super.key,
    required this.selected,
    this.onTap,
    this.radius,
    this.textSize,
    this.padding,
    this.borderRadius,
    this.maxLines,
    this.name,
    this.image,
  });

  final bool? selected;
  final String? name;
  final String? image;
  final double? radius;
  final double? borderRadius;
  final double? textSize;
  final int? maxLines;
  final EdgeInsets? padding;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    double defaultRadius = deviceSpecificValue(
      context: context,
      device: 80,
      tablet: 120,
      desktop: 130,
    ).toDouble();

    return Padding(
      padding: padding ?? const EdgeInsets.only(right: 20),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Column(
          children: [
            ImageView(
              height: radius ?? defaultRadius,
              width: radius ?? defaultRadius,
              borderRadiusValue: borderRadius ?? defaultRadius,
              fit: BoxFit.cover,
              backgroundColor: Colors.white,
              networkImage: "$image",
              onTap: null,
              boxShadow: primaryBoxShadow(color: selected == true ? primaryColor.withOpacity(0.18) : null),
              margin: const EdgeInsets.only(bottom: 8),
            ),
            SizedBox(
              width: radius ?? defaultRadius,
              child: Text(
                "$name",
                style: TextStyle(
                  fontSize: textSize ?? 12,
                  color: selected == true ? primaryColor : Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontStyle: GoogleFonts.mulish().fontStyle,
                ),
                maxLines: maxLines ?? 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
