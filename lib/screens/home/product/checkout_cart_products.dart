import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/orders/cart_controller.dart';
import '../../../core/config/app_images.dart';
import '../../../core/constant/colors.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/image_view.dart';

class CheckoutCartProducts extends StatefulWidget {
  const CheckoutCartProducts({super.key});

  @override
  State<CheckoutCartProducts> createState() => _CheckoutCartProductsState();
}

class _CheckoutCartProductsState extends State<CheckoutCartProducts> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(builder: (context, controller, widget) {
      Size size = MediaQuery.sizeOf(context);

      if (controller.getProductsCount() > 0) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ImageView(
                    height: 24,
                    width: 24,
                    color: Colors.black,
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
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_up,
                            color: primaryColor,
                          )
                        ],
                      ),
                      Text(
                        "\$${controller.getSubTotal()}",
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              CustomButton(
                height: 50,
                text: "Next",
                trailingImage: AppImages.arrow,
                fontSize: 18,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
