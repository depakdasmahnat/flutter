import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';

import '../../../models/partner/product/product_templates_model.dart';
import '../../../utils/widgets/image_view.dart';

class ProductInfoCard extends StatelessWidget {
  const ProductInfoCard({
    super.key,
    required this.data,
    this.padding,
    this.onTap,
    this.margin,
    this.borderRadius,
    this.boxShadow,
  });

  final ProductTemplatesData? data;

  final EdgeInsets? padding;
  final double? borderRadius;
  final EdgeInsets? margin;
  final List<BoxShadow>? boxShadow;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(left: 16, right: 16, bottom: 14),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: boxShadow ?? defaultBoxShadow(),
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageView(
              height: 70,
              width: 70,
              borderRadiusValue: 12,
              fit: BoxFit.contain,
              backgroundColor: Colors.white,
              networkImage: "${data?.image}",
              onTap: null,
              boxShadow: primaryBoxShadow(),
              margin: const EdgeInsets.only(right: 16),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${data?.name}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontStyle: GoogleFonts.mulish().fontStyle,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${data?.description}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                      fontStyle: GoogleFonts.mulish().fontStyle,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
