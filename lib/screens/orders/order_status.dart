import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/extensions/normal/build_context_extension.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../controllers/dashboard_controller.dart';
import '../../core/config/app_images.dart';
import '../../core/constant/colors.dart';
import '../../models/orders/place_order_model.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({Key? key, this.placeOrderData}) : super(key: key);
  final PlaceOrderData? placeOrderData;

  @override
  OrderStatusState createState() => OrderStatusState();
}

class OrderStatusState extends State<OrderStatus> {
  late PlaceOrderData? placeOrderData = widget.placeOrderData;

  navigateToOrdersList() {
    context.firstRoute();
    context.read<DashboardController>().setDashBoardIndex(index: 4, context: context);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        navigateToOrdersList();
        return true;
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size.width,
              color: Colors.white,
              child: Column(
                children: [
                  Lottie.asset(
                    height: 150,
                    width: 150,
                    AppImages.successJson,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Thanks For Order',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                    child: Text(
                      'Your order was placed successfully for more, check order detail',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                color: primaryColor,
                borderRadius: BorderRadius.circular(40),
                child: const Text(
                  "Check Orders",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  navigateToOrdersList();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
