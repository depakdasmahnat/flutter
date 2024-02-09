import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/services_controller.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/constant/constant.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constant/shadows.dart';
import '../../../models/orders/orders_model.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/image_view.dart';
import '../../controllers/orders/cart_controller.dart';
import '../../core/functions.dart';
import 'order_detail.dart';

class UnreviewedOrdersCard extends StatelessWidget {
  const UnreviewedOrdersCard({
    super.key,
    required this.order,
    this.padding,
    this.onTap,
    this.margin,
    this.borderRadius,
    this.boxShadow,
    this.refreshOrders,
    required this.index,
    required this.serviceType,
  });

  final int index;
  final ServiceType serviceType;
  final OrdersData? order;
  final EdgeInsets? padding;
  final double? borderRadius;
  final EdgeInsets? margin;
  final List<BoxShadow>? boxShadow;
  final GestureTapCallback? onTap;
  final GestureTapCallback? refreshOrders;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    removeOrderCard() {
      if (serviceType == ServiceType.freshProduce) {
        context.read<CartController>().clearFreshProduceUnReviewedOrders(index: index);
      } else if (serviceType == ServiceType.nursery) {
        context.read<CartController>().clearNurseryUnReviewedOrders(index: index);
      } else if (serviceType == ServiceType.serviceProvider) {
        context.read<ServicesController>().clearServicesUnReviewedOrders(index: index);
      }
    }

    double imageSize = deviceSpecificValue(context: context, device: 40, tablet: 50).toDouble();
    return Container(
      width: size.width * 0.95,
      margin: margin ?? const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        // boxShadow: boxShadow ?? defaultBoxShadow(),
        border: Border.all(color: Colors.grey.shade100),
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap ??
            () {
              removeOrderCard();

              context.pushNamed(Routs.orderDetail,
                  extra: OrderDetail(
                    orderId: order?.orderId,
                    partnerId: order?.partnerId,
                    refreshOrders: refreshOrders,
                  ));
            },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageView(
              height: imageSize,
              width: imageSize,
              borderRadiusValue: imageSize,
              fit: BoxFit.cover,
              backgroundColor: Colors.white,
              networkImage: "${order?.profilePhoto}",
              onTap: null,
              boxShadow: primaryBoxShadow(),
              margin: const EdgeInsets.only(right: 16),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "${order?.partnerName}",
                    minFontSize: 12,
                    maxFontSize: 14,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontStyle: GoogleFonts.mulish().fontStyle,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "Your ${order?.type} Order is ${order?.orderStatus}",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        fontStyle: GoogleFonts.mulish().fontStyle,
                      ),
                      textScaleFactor: TextScaleFactor.autoScale(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  height: 28,
                  margin: const EdgeInsets.only(right: 8, left: 4),
                  child: const CupertinoButton(
                    color: primaryColor,
                    disabledColor: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    onPressed: null,
                    child: AutoSizeText(
                      'View',
                      minFontSize: 12,
                      maxFontSize: 13,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    removeOrderCard();
                  },
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                )
              ],
            )
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
