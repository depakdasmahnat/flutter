import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gaas/core/constant/constant.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../models/orders/orders_model.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/custom_bottom_sheet.dart';
import '../../../utils/widgets/image_view.dart';
import '../order_detail.dart';
import 'rate_this_order.dart';

class OrdersCard extends StatelessWidget {
  const OrdersCard({
    super.key,
    required this.order,
    this.padding,
    this.onTap,
    this.margin,
    this.borderRadius,
    this.boxShadow,
    this.refreshOrders,
  });

  final OrdersData? order;
  final EdgeInsets? padding;
  final double? borderRadius;
  final EdgeInsets? margin;
  final List<BoxShadow>? boxShadow;
  final GestureTapCallback? onTap;
  final GestureTapCallback? refreshOrders;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(left: 16, right: 16, bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: boxShadow ?? defaultBoxShadow(),
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      child: CupertinoButton(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        onPressed: onTap ??
            () {
              context.pushNamed(Routs.orderDetail,
                  extra: OrderDetail(
                    orderId: order?.orderId,
                    partnerId: order?.partnerId,
                    refreshOrders: refreshOrders,
                  ));
            },
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    ImageView(
                      height: 50,
                      width: 50,
                      borderRadiusValue: 12,
                      fit: BoxFit.cover,
                      backgroundColor: Colors.white,
                      networkImage: "${order?.profilePhoto}",
                      isAvatar: true,
                      onTap: null,
                      boxShadow: primaryBoxShadow(),
                      margin: const EdgeInsets.only(right: 16, bottom: 12),
                    ),
                    if (order?.type != null)
                      statusTag(
                        color: primaryColor,
                        status: "${order?.type}",
                      ),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${order?.partnerName}",
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
                            fontSize: 16,
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
            if (order?.orderStatus == "Completed") const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (order?.orderStatus == "Completed")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: RatingBar.builder(
                      initialRating: (order?.reviewDetail?.rating ?? 0).toDouble(),
                      minRating: 1,
                      ignoreGestures: true,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 24,
                      unratedColor: Colors.grey.shade400,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        debugPrint("$rating");
                      },
                    ),
                  ),
                if (order?.orderStatus == "Completed")
                  Container(
                    height: 24,
                    margin: const EdgeInsets.only(top: 6),
                    child: CupertinoButton(
                      borderRadius: BorderRadius.circular(4),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      color: primaryColor,
                      child: Text(
                        order?.reviewAdded == true ? "Update Feedback" : "Rate Us",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        CustomBottomSheet.show(
                          context: context,
                          isScrollControlled: true,
                          enableDrag: true,
                          physics: const BouncingScrollPhysics(),
                          showTitleDivider: false,
                          body: RateThisOrder(
                            onSuccess: () {
                              context.pop();
                              refreshOrders?.call();
                            },
                            id: order?.orderId,
                            partnerId: order?.partnerId,
                            reviewAdded: order?.reviewAdded,
                            reviewDetail: order?.reviewDetail,
                          ),
                        );
                      },
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
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color ?? statusColor(status: status)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        "$status",
        style: TextStyle(
          fontSize: 8,
          color: color ?? statusColor(status: status),
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
