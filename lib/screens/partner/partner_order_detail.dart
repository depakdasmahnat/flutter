import 'package:flutter/material.dart';
import 'package:gaas/controllers/partner/product_controller.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/models/partner/orders/send_order_timeslots.dart';
import 'package:gaas/utils/widgets/custom_button.dart';
import 'package:gaas/utils/widgets/data_widget_builder.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/partner/partner_controller.dart';
import '../../core/constant/colors.dart';
import '../../core/constant/constant.dart';
import '../../core/enums/enums.dart';
import '../../models/dashboard/producer_details_model.dart';
import '../../models/partner/orders/partner_order_detail_model.dart';
import '../../utils/widgets/custom_bottom_sheet.dart';
import '../home/product/utils/order_detail_card.dart';
import '../home/utils/nearby_product.dart';
import 'fresh/orders/verify_order__otp.dart';

class PartnerOrderDetail extends StatefulWidget {
  const PartnerOrderDetail({Key? key, required this.orderId, required this.partnerId}) : super(key: key);
  final num? orderId;
  final num? partnerId;

  @override
  State<PartnerOrderDetail> createState() => _PartnerOrderDetailState();
}

class _PartnerOrderDetailState extends State<PartnerOrderDetail> {
  late num? orderId = widget.orderId;
  late num? partnerId = widget.partnerId;

  PartnerOrderDetailData? orderDetail;
  List<PartnerOrderDetailProducts>? products;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ProductController controller = Provider.of<ProductController>(context, listen: false);
      controller.fetchOrderDetail(context: context, orderId: orderId, partnerId: partnerId);
      controller.fetchSuggestedTimesSlots(context: context, partnerId: partnerId, orderId: orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    ProductController controller = Provider.of<ProductController>(context);
    orderDetail = controller.orderDetailData;
    products = orderDetail?.products;

    return Scaffold(
      appBar: AppBar(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            backButton(context: context),
          ],
        ),
        leadingWidth: 50,
        title: const Text(
          "Order Detail",
          style: TextStyle(fontSize: 20, letterSpacing: 1.3, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: DataWidgetBuilder(
        isLoading: controller.loadingOrderDetail,
        haveData: orderDetail != null,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(8),
                boxShadow: defaultBoxShadow(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        orderDetail?.orderType ?? "",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if ((orderDetail?.noOfPersons ?? 0) > 0)
                        Text(
                          "(${orderDetail?.noOfPersons ?? ""} ${((orderDetail?.noOfPersons ?? 0) > 1) ? 'Persons' : "Person"})",
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        orderDetail?.timeslotName ?? "",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        orderDetail?.datetime ?? "",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                statusTag(
                  width: size.width * 0.6,
                  status: "${orderDetail?.orderStatus}",
                ),
              ],
            ),
            if (orderDetail?.comment != null)
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: defaultBoxShadow(),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "User Comment",
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${orderDetail?.comment}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: defaultBoxShadow(),
              ),
              child: Column(
                children: [
                  customRow(
                    title1: "Order Id",
                    title1Style: title1Style(),
                    title2: "#${orderDetail?.orderNumber ?? ""}",
                    title2Style: title2Style(),
                  ),
                  customRow(
                    title1: "Date & Time",
                    title1Style: title1Style(),
                    title2: orderDetail?.datetime ?? "",
                    title2Style: title2Style(),
                  ),
                  if (orderDetail?.paymentMethod != null)
                    customRow(
                      title1: "Payment Method",
                      title1Style: title1Style(),
                      title2: orderDetail?.paymentMethod ?? "",
                      title2Style: title2Style(),
                    ),

                  customRow(
                    title1: "Order Total",
                    title1Style: title1Style(),
                    title2: "\$${orderDetail?.totalAmount ?? 0}",
                    title2Style: const TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if ((orderDetail?.paidAmount ?? 0) > 0)
                    customRow(
                      title1: "Paid Amount",
                      title1Style: title1Style(),
                      title2: "-\$${orderDetail?.paidAmount ?? 0}",
                      title2Style: const TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if ((orderDetail?.paidAmount ?? 0) > 0)
                    customRow(
                      title1: "Balance Amount",
                      title1Style: title1Style(),
                      title2: "\$${(orderDetail?.totalAmount ?? 0) - (orderDetail?.paidAmount ?? 0)}",
                      title2Style: const TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Download Invoice",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(color: primaryGrey, thickness: 3, height: 1),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: defaultBoxShadow(),
              ),
              child: NearbyProductCard(
                id: orderDetail?.id,
                title: orderDetail?.userName,
                image: orderDetail?.profilePhoto,
                address: orderDetail?.userAddress,
                rating: orderDetail?.ratings,
                email: orderDetail?.userEmail,
                reviews: orderDetail?.partnerReviews,
                distance: orderDetail?.distanceLabel,
                mobileNo: orderDetail?.userMobile,
                onTap: () {},
                padding: const EdgeInsets.symmetric(horizontal: 18),
              ),
            ),
            if (products.haveData)
              ListView.builder(
                itemCount: products?.length ?? 0,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var product = products?.elementAt(index);
                  return OrderDetailCard(
                    index: index,
                    product: ProducerProducts(
                      image: product?.image,
                      name: product?.productName,
                      price: "${product?.regularAmount ?? 0}",
                      mrpPrice: "${product?.mrpAmount ?? 0}",
                      unitName: "${product?.unitName}",
                      quantity: (product?.quantity ?? 0).toInt(),
                      initialInventory: (product?.totalRegularAmount ?? 0).toInt(),
                    ),
                    hideCounter: true,
                  );
                },
              ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(color: primaryGrey, thickness: 3, height: 1),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: defaultBoxShadow(),
              ),
              child: Column(
                children: [
                  customRow(
                    title1: "Subtotal",
                    title1Style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    title2: "\$${orderDetail?.subtotal ?? 0}",
                  ),
                  if ((orderDetail?.totalPersonAmount ?? 0) > 0)
                    customRow(
                      title1: "Self Picking Charges",
                      title2: "\$${orderDetail?.totalPersonAmount ?? "N/A"}",
                      title2Style: title2Style(),
                    ),
                  if ((orderDetail?.discount ?? 0) > 0)
                    customRow(
                      title1: "Discount",
                      title2: "\$${orderDetail?.discount ?? "N/A"}",
                      title2Style: title2Style(),
                    ),
                  if (orderDetail?.couponApplied == "Yes")
                    customRow(
                      title1: "Coupon",
                      title2: "-\$${orderDetail?.couponPrice ?? 0.0}",
                      title2Style: const TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (orderDetail?.coinsApplied == "Yes")
                    customRow(
                      title1: "Applied Coins",
                      title2: "-\$${orderDetail?.coinsAmount ?? 0.0}",
                      title2Style: const TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  customRow(
                    title1:
                        "Taxes ${(orderDetail?.taxPercent ?? 0) > 0 ? "(${orderDetail?.taxPercent} %)" : ""} ",
                    title2: "\$${orderDetail?.taxAmount ?? 0.0}",
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 14),
                    child: Divider(color: primaryGrey, thickness: 3, height: 1),
                  ),
                  customRow(
                    title1: "Grand Total",
                    title1Style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    title2: "\$${orderDetail?.totalAmount ?? 0}",
                    title2Style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (orderDetail?.orderStatus == OrderStatuses.processing.value)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomButton(
                      height: 45,
                      fontSize: 13,
                      text: "Reschedule",
                      textColor: primaryColor,
                      backgroundColor: Colors.white,
                      mainAxisAlignment: MainAxisAlignment.center,
                      margin: EdgeInsets.zero,
                      onPressed: () {
                        CustomBottomSheet.show(
                          context: context,
                          isScrollControlled: true,
                          enableDrag: true,
                          physics: const BouncingScrollPhysics(),
                          showTitleDivider: true,
                          title: "Reschedule",
                          body: SendOrderTimeSlots(
                            partnerId: partnerId,
                            orderId: orderId,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      height: 45,
                      fontSize: 13,
                      text: "Ready To Pick",
                      margin: EdgeInsets.zero,
                      mainAxisAlignment: MainAxisAlignment.center,
                      onPressed: () {
                        context.read<PartnerController>().readyToPickupPopup(
                              context: context,
                              orderId: "$orderId",
                              onSuccess: () {
                                context.pop();

                                controller.fetchOrderDetail(
                                    context: context, orderId: orderId, partnerId: partnerId);
                              },
                            );
                      },
                    ),
                  )
                ],
              ),
            ),
          (orderDetail?.orderStatus == OrderStatuses.readyToPickup.value)
              ? CustomButton(
                  height: 45,
                  text: "Complete",
                  mainAxisAlignment: MainAxisAlignment.center,
                  onPressed: () {
                    CustomBottomSheet.show(
                      context: context,
                      isScrollControlled: true,
                      enableDrag: true,
                      physics: const BouncingScrollPhysics(),
                      showTitleDivider: false,
                      body: VerifyOrderOTP(
                        orderId: "${orderDetail?.orderId}",
                        name: "${orderDetail?.userName}",
                        onSuccess: () {
                          context.pop();
                          context.pop();
                        },
                      ),
                    );
                  },
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  TextStyle title2Style() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle title1Style() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );
  }

  Widget statusTag({
    required String? status,
    Color? color,
    double? width,
  }) {
    return Container(
      height: 32,
      width: width,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color ?? statusColor(status: status),
        border: Border.all(color: color ?? statusColor(status: status)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          "$status",
          style: const TextStyle(
            fontSize: 14,
            letterSpacing: 1.3,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
