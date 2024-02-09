import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/constant/constant.dart';
import 'package:gaas/core/functions.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../controllers/partner/partner_controller.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../core/enums/enums.dart';
import '../../../models/partner/orders/partner_order_model.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/custom_bottom_sheet.dart';
import '../../../utils/widgets/image_view.dart';
import '../fresh/orders/verify_order__otp.dart';
import '../partner_order_detail.dart';

class PartnerOrdersCard extends StatelessWidget {
  const PartnerOrdersCard({
    super.key,
    required this.order,
    this.padding,
    this.onTap,
    this.margin,
    this.borderRadius,
    this.boxShadow,
    this.refreshOrders,
  });

  final PartnerOrderData? order;
  final EdgeInsets? padding;
  final double? borderRadius;
  final EdgeInsets? margin;
  final List<BoxShadow>? boxShadow;
  final GestureTapCallback? onTap;
  final GestureTapCallback? refreshOrders;

  @override
  Widget build(BuildContext context) {
    double imageSize = deviceSpecificValue(context: context, device: 60, tablet: 100).toDouble();
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
              context.pushNamed(Routs.partnerOrderDetail,
                  extra: PartnerOrderDetail(orderId: order?.orderId, partnerId: order?.partnerId));
            },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageView(
              height: imageSize,
              width: imageSize,
              borderRadiusValue: 12,
              fit: BoxFit.cover,
              backgroundColor: Colors.white,
              networkImage: "${order?.profilePhoto}",
              onTap: null,
              boxShadow: primaryBoxShadow(),
              margin: const EdgeInsets.only(right: 16, bottom: 12),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          "${order?.userName}",
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
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                    child: Text(
                      "Order Id :- #${order?.orderNumber}",
                      style: TextStyle(
                        fontSize: 10,
                        color: primaryColor,
                        fontWeight: FontWeight.w400,
                        fontStyle: GoogleFonts.mulish().fontStyle,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 4),
                    child: Row(
                      children: [
                        Text(
                          "${order?.products} items",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                            fontStyle: GoogleFonts.mulish().fontStyle,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 6, right: 6),
                          child: Icon(
                            Icons.circle,
                            size: 4,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          order?.distanceLabel ?? "",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                            fontStyle: GoogleFonts.mulish().fontStyle,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 4),
                    child: Row(
                      children: [
                        Text(
                          order?.datetime ?? "",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                            fontStyle: GoogleFonts.mulish().fontStyle,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      if (order?.orderStatus == OrderStatuses.processing.value)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: SizedBox(
                            height: 24,
                            child: CupertinoButton(
                              borderRadius: BorderRadius.circular(5),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              color: primaryColor,
                              child: const Text(
                                "Ready To Pick",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              onPressed: () {
                                context.read<PartnerController>().readyToPickupPopup(
                                      context: context,
                                      orderId: "${order?.orderId}",
                                      onSuccess: () {
                                        context.pop();
                                      },
                                    );
                              },
                            ),
                          ),
                        ),
                      if (order?.orderStatus == OrderStatuses.readyToPickup.value)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: SizedBox(
                            height: 24,
                            child: CupertinoButton(
                              borderRadius: BorderRadius.circular(5),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              color: primaryColor,
                              child: const Text(
                                "Complete",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              onPressed: () {
                                CustomBottomSheet.show(
                                  context: context,
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  physics: const BouncingScrollPhysics(),
                                  showTitleDivider: false,
                                  body: VerifyOrderOTP(
                                    orderId: "${order?.orderId}",
                                    name: order?.userName,
                                    onSuccess: () {
                                      context.pop();
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 8),
              child: Column(
                children: [
                  Container(
                    height: 20,
                    margin: const EdgeInsets.only(top: 6),
                    child: CupertinoButton(
                      borderRadius: BorderRadius.circular(16),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: statusColor(status: "${order?.orderStatus}"),
                      disabledColor: statusColor(status: "${order?.orderStatus}"),
                      onPressed: null,
                      child: Text(
                        "${order?.orderStatus}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      "\$${order?.totalAmount}",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
