import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/orders/cart_controller.dart';
import '../../../core/config/app_images.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/image_view.dart';

class HomeCartProducts extends StatefulWidget {
  const HomeCartProducts({super.key});

  @override
  State<HomeCartProducts> createState() => _CheckoutCartProductsState();
}

class _CheckoutCartProductsState extends State<HomeCartProducts> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(builder: (context, controller, widget) {
      Size size = MediaQuery.sizeOf(context);

      if (controller.getProductsCount() > 0) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ImageView(
                    height: 24,
                    width: 26,
                    color: Colors.white,
                    assetImage: AppImages.bag,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${controller.getProductsCount()} Item Added",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "\$${controller.getSubTotal()}",
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              CustomButton(
                height: 35,
                text: "Next",
                textColor: Colors.black,
                borderRadius: 40,
                borderColor: Colors.white,
                backgroundColor: Colors.white,
                imageColor: Colors.black,
                trailingImage: AppImages.arrow,
                fontSize: 16,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                onPressed: () {
                  context.push(Routs.checkout);
                },
                margin: const EdgeInsets.only(top: 6, bottom: 6, right: 8),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
