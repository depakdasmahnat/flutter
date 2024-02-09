import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/utils/widgets/custom_button.dart';
import 'package:gaas/utils/widgets/data_widget_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/orders/cart_controller.dart';
import '../../core/constant/colors.dart';
import '../../models/orders/applie_coupon_model.dart';
import '../../models/orders/valid_coupons_model.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../utils/widgets/widgets.dart';

class ApplyCoupon extends StatefulWidget {
  const ApplyCoupon({Key? key, this.id}) : super(key: key);
  final num? id;

  @override
  State<ApplyCoupon> createState() => _ApplyCouponState();
}

class _ApplyCouponState extends State<ApplyCoupon> {
  TextEditingController couponCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      CartController cartController = Provider.of<CartController>(context, listen: false);
      cartController.fetchValidCoupons(
        context: context,
        partnerId: widget.id,
      );

      couponCodeController.text = cartController.lastCouponCode ?? "";
    });
  }

  List<ValidCouponsData>? validCoupons;
  AppliedCouponData? couponData;

  @override
  Widget build(BuildContext context) {
    ///Cart Controllers...

    CartController cartController = Provider.of<CartController>(context);
    ValidCouponsModel? validCouponsModel = cartController.validCouponsModel;
    validCoupons = validCouponsModel?.data;
    couponData = cartController.appliedCouponData;
    return Scaffold(
      appBar: AppBar(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            backButton(context: context),
          ],
        ),
        leadingWidth: 50,
        title: const Text("Apply Coupon"),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          CustomTextField(
            hintText: "Type Coupon code here",
            controller: couponCodeController,
            fillColor: Colors.grey.shade50,
            borderColor: Colors.grey.shade200,
            onChanged: (val) {
              setState(() {});
            },
            style: textStyle(),
            hintStyle: textStyle(),
            textAlignVertical: TextAlignVertical.center,
            suffixIcon: CupertinoButton(
              child: const Text(
                "APPLY",
                style: TextStyle(color: primaryColor, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                setState(() {});
                context
                    .read<CartController>()
                    .applyCoupon(context: context, couponCode: couponCodeController.text);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: primaryColor, size: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Best Offers For You".toUpperCase(),
                  style: const TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const Icon(Icons.star, color: primaryColor, size: 18),
            ],
          ),
          DataWidgetBuilder(
            isLoading: cartController.loadingValidCoupons,
            haveData: validCoupons.haveData,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: validCoupons?.length ?? 0,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var data = validCoupons?.elementAt(index);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      couponCodeController.text = "${data?.code}";
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
                    margin: EdgeInsets.only(left: 16, right: 16, top: index == 0 ? 16 : 0, bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: defaultBoxShadow(),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data?.name}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 4),
                          child: Text(
                            "${data?.code}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              height: 24,
                              text: "${data?.code}",
                              textColor: primaryColor,
                              fontSize: 14,
                              letterSpacing: 1.5,
                              backgroundColor: primaryColor.withOpacity(0.1),
                              borderColor: primaryColor.withOpacity(0.3),
                              borderRadius: 6,
                              fontWeight: FontWeight.w600,
                              margin: EdgeInsets.zero,
                              onPressed: () {},
                            ),
                            CustomButton(
                              height: 24,
                              text: "APPLY",
                              fontSize: 12,
                              letterSpacing: 1.2,
                              borderRadius: 6,
                              fontWeight: FontWeight.w600,
                              margin: EdgeInsets.zero,
                              onPressed: () {
                                couponCodeController.text = "${data?.code}";
                                setState(() {});
                                context.read<CartController>().applyCoupon(
                                      context: context,
                                      couponId: data?.id,
                                      couponCode: data?.code,
                                      creatorId: data?.creatorId,
                                      creatorType: data?.creatorType,
                                    );
                              },
                            )
                          ],
                        ),
                        Text(
                          "You can get Upto \$${data?.discountUpto ?? 0}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  TextStyle textStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.black,
      fontSize: 16,
    );
  }
}
