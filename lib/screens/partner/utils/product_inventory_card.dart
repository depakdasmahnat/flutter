import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/constant/constant.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/image_view.dart';

class ProductInventoryCard extends StatelessWidget {
  const ProductInventoryCard({
    super.key,
    required this.id,
    required this.title,
    this.image,
    this.status,
    required this.price,
    required this.mrpPrice,
    this.padding,
    this.onTap,
    this.margin,
    this.borderRadius,
    this.boxShadow,
    this.weight,
  });

  final num? id;
  final String? title;
  final String? status;
  final String? image;
  final String? price;
  final String? mrpPrice;
  final String? weight;
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
        onPressed: () {},
        child: Row(
          children: [
            if (image != null)
              ImageView(
                height: 80,
                width: 80,
                borderRadiusValue: 12,
                fit: BoxFit.cover,
                backgroundColor: Colors.white,
                networkImage: "$image",
                onTap: null,
                boxShadow: primaryBoxShadow(),
                margin: const EdgeInsets.only(right: 16),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "$title",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontStyle: GoogleFonts.mulish().fontStyle,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      Row(
                        children: [
                          if (status == "Pending" || status == "Requested") statusTag(status: status),
                          CustomButton(
                            height: 22,
                            text: "Edit",
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            onPressed: () {
                              if (onTap != null) {
                                onTap!();
                              }
                            },
                            borderRadius: 6,
                            mainAxisAlignment: MainAxisAlignment.center,
                            boxShadow: defaultBoxShadow(),
                            margin: EdgeInsets.zero,
                          ),
                        ],
                      ),

                      // else
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "\$${mrpPrice ?? 0}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: FittedBox(
                          child: Text(
                            "$weight",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontStyle: GoogleFonts.mulish().fontStyle,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        "\$$price",
                        style: const TextStyle(
                          fontSize: 18,
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statusTag({
    required String? status,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: statusColor(status: status)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        "$status",
        style: TextStyle(
          fontSize: 12,
          color: statusColor(status: status),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget storeDetail({
    required String? title,
    IconData? icon,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
      margin: const EdgeInsets.only(top: 6, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                (icon),
                size: 12,
                color: iconColor ?? Colors.grey.shade800,
              ),
            ),
          Text(
            "$title",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
