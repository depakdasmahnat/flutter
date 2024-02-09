import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/orders/cart_controller.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/screens/orders/apply_coupon.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/payments/cart_payment_contrroller.dart';
import '../../core/config/app_config.dart';
import '../../core/config/app_images.dart';
import '../../core/constant/colors.dart';
import '../../core/enums/enums.dart';
import '../../models/orders/applie_coupon_model.dart';
import '../../models/orders/payment_summary_model.dart';
import '../../route/route_paths.dart';
import '../../utils/widgets/custom_bottom_sheet.dart';
import '../../utils/widgets/custom_button.dart';
import '../../utils/widgets/image_view.dart';
import 'cart_items.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  AppliedCouponData? appliedCouponData;
  PaymentSummaryData? paymentSummaryData;
  num? gaasCoin;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      CartController cartController = Provider.of(context, listen: false);
      cartController.getSelfPickingCharges();
      cartController.fetchOrderAddress(context: context);
      cartController.getPaymentSummary(context: context);
      Future.delayed(const Duration(milliseconds: 500))
          .then((value) => context.mounted ? cartController.getPaymentSummary(context: context) : null);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CartController cartController = Provider.of(context);
    appliedCouponData = cartController.appliedCouponData;
    paymentSummaryData = cartController.paymentSummaryModel?.data;
    gaasCoin = paymentSummaryData?.totalValidCoins;

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
          "Checkout",
          style: TextStyle(fontSize: 20, letterSpacing: 1.3, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            const CartItems(
              heightFactor: 0.3,
              checkOutMode: true,
              physics: NeverScrollableScrollPhysics(),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if (appliedCouponData?.code == null) {
                  context.push(Routs.applyCoupon, extra: const ApplyCoupon());
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: defaultBoxShadow(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  horizontalTitleGap: 0,
                  leading: const Icon(
                    Icons.discount,
                    color: primaryColor,
                  ),
                  title: Text(
                    appliedCouponData?.name ?? "Apply Coupon",
                    style: const TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: appliedCouponData?.code != null
                      ? Text(
                          "Applied Coupon (${appliedCouponData?.code})",
                        )
                      : null,
                  trailing: appliedCouponData != null
                      ? IconButton(
                          onPressed: () {
                            cartController.clearAppliedCoupon(context);
                            cartController.getPaymentSummary(context: context);
                          },
                          icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                        )
                      : null,
                ),
              ),
            ),
            if ((gaasCoin ?? 0) > 0)
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: defaultBoxShadow(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  dense: true,
                  leading: const ImageView(
                    height: 45,
                    width: 45,
                    borderRadiusValue: 40,
                    assetImage: AppImages.dollar,
                    fit: BoxFit.cover,
                    margin: EdgeInsets.zero,
                  ),
                  title: const Text(
                    "${AppConfig.apkName} Coin",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      cartController.appliedGaasCoin != null
                          ? "Applied ${cartController.appliedGaasCoin} ${AppConfig.apkName} Coins"
                          : "you can apply $gaasCoin ${AppConfig.apkName} Coins",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  trailing: cartController.appliedGaasCoin != null
                      ? IconButton(
                          onPressed: () {
                            cartController.clearGaasCoin(context);
                          },
                          icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                        )
                      : CustomButton(
                          height: 24,
                          width: 80,
                          text: "APPLY",
                          fontSize: 12,
                          letterSpacing: 1.2,
                          borderRadius: 6,
                          mainAxisAlignment: MainAxisAlignment.center,
                          fontWeight: FontWeight.w600,
                          margin: EdgeInsets.zero,
                          onPressed: () {
                            context.read<CartController>().applyGaasCoin(context, gaasCoin);
                          },
                        ),
                ),
              ),
            if ((paymentSummaryData?.wonCoins ?? 0) > 0)
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                decoration: BoxDecoration(
                  color: primaryColor,
                  boxShadow: defaultBoxShadow(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const ImageView(
                    height: 35,
                    width: 35,
                    borderRadiusValue: 40,
                    assetImage: AppImages.dollar,
                    fit: BoxFit.cover,
                    margin: EdgeInsets.zero,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "You will Earn ${paymentSummaryData?.wonCoins ?? 0.0}  ${AppConfig.apkName} Coin.",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
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
                    title2: "\$${cartController.getSubTotal()}",
                  ),
                  if (cartController.getSelfPickingCharges() > 0)
                    customRow(
                      title1: "Self Picking Charges",
                      title2: "\$${cartController.getSelfPickingCharges()}",
                    ),
                  if ((paymentSummaryData?.taxAmount ?? 0) > 0)
                    customRow(
                      title1:
                          "Taxes ${(paymentSummaryData?.taxPercent ?? 0) > 0 ? "(${paymentSummaryData?.taxPercent} %)" : ""} ",
                      title2: "\$${paymentSummaryData?.taxAmount ?? 0.0}",
                    ),
                  if ((paymentSummaryData?.couponPrice ?? 0) > 0)
                    customRow(
                      title1: "Coupon (${appliedCouponData?.code})",
                      title2: "-\$${paymentSummaryData?.couponPrice ?? 0.0}",
                      title2Style: const TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if ((paymentSummaryData?.coins ?? 0) > 0)
                    customRow(
                      title1: "Applied Coins",
                      title2: "-\$${paymentSummaryData?.coins ?? 0.0}",
                      title2Style: const TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
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
                    title2: "\$${(paymentSummaryData?.grandTotal ?? 0.0).toStringAsFixed(2)}",
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
      bottomNavigationBar: CustomButton(
        height: 75,
        width: size.width,
        borderRadius: 0,
        text: "Place Order",
        fontSize: 22,
        backgroundColor: cartController.calculatingPaymentSummary ? Colors.grey : primaryColor,
        borderColor: Colors.transparent,
        fontWeight: FontWeight.w700,
        mainAxisAlignment: MainAxisAlignment.center,
        onPressed: () {
          if (cartController.calculatingPaymentSummary == true) {
            showSnackBar(context: context, text: "Please wait Calculating Order details");
          } else {
            if (formKey.currentState?.validate() == true &&
                context.read<CartController>().validForm(context) == true) {
              CustomBottomSheet.show(
                context: context,
                title: "Select Payment Mode",
                centerTitle: true,
                body: StatefulBuilder(
                  builder: (context, setState) {
                    CartController cartController = Provider.of(context);
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 12),
                          itemCount: cartController.paymentModes()?.length ?? 0,
                          itemBuilder: (context, index) {
                            var paymentMode = cartController.paymentModes()?.elementAt(index);
                            bool selected = paymentMode?.id == cartController.paymentMode?.id;

                            return Container(
                              margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: primaryBoxShadow(),
                              ),
                              child: ListTile(
                                onTap: () {
                                  CartController cartController = Provider.of(context, listen: false);
                                  cartController.setPaymentMode(paymentMode: paymentMode);
                                },
                                title: Text(
                                  "${paymentMode?.value}",
                                  style: const TextStyle(color: Colors.black, fontSize: 14),
                                ),
                                trailing: Icon(
                                  selected ? Icons.radio_button_checked : Icons.circle_outlined,
                                  color: primaryColor,
                                ),
                              ),
                            );
                          },
                        ),
                        CustomButton(
                          height: 50,
                          width: size.width,
                          borderRadius: 12,
                          text: "Place Order",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          mainAxisAlignment: MainAxisAlignment.center,
                          onPressed: () async {
                            String? amount;

                            var paymentMode = cartController.paymentMode;
                            debugPrint("amount => $amount");
                            debugPrint("paymentMode => $paymentMode");
                            if (paymentMode == PaymentModes.payNow) {
                              amount = "${paymentSummaryData?.grandTotal ?? 0}";
                            } else if (paymentMode == PaymentModes.payReservation) {
                              amount = "${cartController.getSelfPickingCharges()}";
                            }

                            if (paymentMode == PaymentModes.payAtPickup) {
                              await context.read<CartController>().placeOrder(context: context);
                            } else {
                              context.pop();
                              context.read<CartPaymentController>().initPaymentSheet(
                                    amount: amount,
                                    currency: AppConfig.currency,
                                  );
                            }
                          },
                          margin: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 24),
                        )
                      ],
                    );
                  },
                ),
              );
            } else {}
          }
        },
        margin: EdgeInsets.zero,
      ),
    );
  }
}
