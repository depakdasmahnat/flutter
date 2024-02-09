import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/screens/home/product/utils/product_detail.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/dashboard_controller.dart';
import '../../../../controllers/orders/cart_controller.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/services/database/local_database.dart';
import '../../../../models/dashboard/producer_details_model.dart';
import '../../../../utils/widgets/custom_bottom_sheet.dart';
import '../../../orders/utils/counter_buttons.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.product, this.producer, this.type, this.orderType})
      : super(key: key);
  final ProducerDetailsData? producer;
  final ProducerProducts? product;
  final ServiceType? type;
  final String? orderType;

  @override
  Widget build(BuildContext context) {
    CartController cartController = Provider.of<CartController>(context);
    bool productExist = cartController.productExist(productId: product?.id);
    late bool isAuthenticated = LocalDatabase().accessToken != null;
    debugPrint("productExist $productExist");

    return InkWell(
      onTap: () {
        CustomBottomSheet.show(
          context: context,
          body: ProductDetail(
            producer: producer,
            product: product,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(16),
          // borderRadius: const BorderRadius.only(
          //   topRight: Radius.circular(22),
          //   bottomLeft: Radius.circular(22),
          // ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ClipRRect(
                    child: Stack(
                      children: [
                        Hero(
                          tag: "${product?.image}",
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(16), topLeft: Radius.circular(16)),
                              image: DecorationImage(
                                image: NetworkImage("${product?.image}"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        // if ((product?.discount ?? 0) > 0)
                        //   Banner(
                        //     message: "${product?.discount}% OFF",
                        //     color: Colors.red,
                        //     location: BannerLocation.topStart,
                        //   ),

                        Positioned(
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                            ),
                            child: const Text(
                              "Organic",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),

                        if (isAuthenticated)
                          Positioned(
                            top: 4,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                if (product?.inWishlist == true) {
                                  context.read<DashboardController>().removeProducerWishList(
                                      context: context,
                                      id: product?.id,
                                      type: WishListType.product,
                                      wishlistId: "${product?.wishlistId}");
                                } else {
                                  context.read<DashboardController>().addToWishList(
                                        context: context,
                                        id: product?.id,
                                        type: WishListType.product,
                                        targetId: product?.id,
                                      );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: primaryBoxShadow(),
                                ),
                                child: Center(
                                  child: product?.inWishlist == null
                                      ? const CupertinoActivityIndicator(radius: 10, color: primaryColor)
                                      : Icon(
                                          product?.inWishlist == true
                                              ? CupertinoIcons.heart_solid
                                              : CupertinoIcons.heart,
                                          color: Colors.red,
                                          size: 22,
                                        ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (product?.discount != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "\$${product?.mrpPrice ?? 0}",
                        style: const TextStyle(color: Colors.red, decoration: TextDecoration.lineThrough),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${product?.discount} % OFF",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                Text(
                  "\$${product?.price}/${product?.unitName}",
                  style: const TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 6, right: 6),
                      child: Text(
                        "${product?.name}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 6),
                    //   child: Text(
                    //     "${product?.initialInventory} ${product?.unitName}",
                    //     style: TextStyle(
                    //       color: Colors.grey.shade500,
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ),
                    if (productExist)
                      const Text(
                        "Added to Cart",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const Padding(
                      padding: EdgeInsets.only(left: 12, right: 12, top: 6),
                      child: DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.5,
                        dashLength: 2.0,
                        dashColor: primaryColor,
                        dashRadius: 0.0,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
                        dashGapRadius: 0.0,
                      ),
                    ),
                    if (productExist)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CounterButtons(
                          hideCounter: false,
                          showTotal: false,
                          producer: producer,
                          product: product,
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () {},
                          child: const Text(
                            "Add to Cart",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 12,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
            if (productExist == false)
              Positioned(
                bottom: 12,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    cartController.addProduct(context: context, producer: producer, product: product);
                  },
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: primaryColor,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
