import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/constant/constant.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../models/partner/earnings_model.dart';
import '../../../utils/widgets/image_view.dart';

class EarningsCard extends StatelessWidget {
  const EarningsCard({
    super.key,
    this.padding,
    this.onTap,
    this.margin,
    this.borderRadius,
    this.boxShadow,
    this.data,
  });

  final EarningsData? data;

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
        onPressed: onTap ??
            () {
              // context.pushNamed(Routs.partnerOrderDetail,
              //     extra: PartnerOrderDetail(orderId: orderId, partnerId: partnerId));
            },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageView(
              height: 70,
              width: 70,
              borderRadiusValue: 12,
              fit: BoxFit.cover,
              backgroundColor: Colors.white,
              networkImage: "${data?.profilePhoto}",
              onTap: null,
              boxShadow: primaryBoxShadow(),
              margin: const EdgeInsets.only(right: 16),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          data?.userName ?? "",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontStyle: GoogleFonts.mulish().fontStyle,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (data?.isVerified == true)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(
                            Icons.verified_outlined,
                            size: 14,
                            color: primaryColor,
                          ),
                        )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 6),
                    child: Text(
                      "Order Id :- #${data?.orderNumber ?? ""}",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                        fontStyle: GoogleFonts.mulish().fontStyle,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            "${data?.productCounts ?? ""} Products",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        statusTag(
                          status: data?.orderStatus ?? "",
                        ),
                      ],
                    ),
                  ),
                  if(data?.settledAt !=null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 4),
                    child: Text(
                      "Placed on :- ${data?.settledAt ?? ""}",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                        fontStyle: GoogleFonts.mulish().fontStyle,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  "\$${data?.actualAmount ?? 0}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
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
          fontSize: 8,
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
