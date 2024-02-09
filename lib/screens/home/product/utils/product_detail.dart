import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/utils/widgets/image_view.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/dashboard_controller.dart';
import '../../../../controllers/orders/cart_controller.dart';
import '../../../../core/constant/colors.dart';
import '../../../../core/constant/shadows.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/services/database/local_database.dart';
import '../../../../models/dashboard/producer_details_model.dart';
import '../../../orders/utils/counter_buttons.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, required this.producer, required this.product});

  final ProducerDetailsData? producer;
  final ProducerProducts? product;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late ProducerDetailsData? producer = widget.producer;
  late ProducerProducts? product = widget.product;

  @override
  Widget build(BuildContext context) {
    late bool isAuthenticated = LocalDatabase().accessToken != null;
    CartController cartController = Provider.of<CartController>(context);
    bool productExist = cartController.productExist(productId: product?.id);
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        // border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (size.width  < 600)
                ClipRRect(
                  child: Stack(
                    children: [
                      Hero(
                        tag: "${product?.image}",
                        child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                            image: DecorationImage(
                              image: NetworkImage("${product?.image}"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (size.width  >= 600)
                  ImageView(
                    fit: BoxFit.cover,
                    networkImage: "${product?.image}",
                    margin: EdgeInsets.zero,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                          child: Row(
                            children: [
                              Text(
                                "${product?.name}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        if (product?.description != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                            child: Text(
                              "${product?.description}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        customRow(
                          title1: "Inventory",
                          title2: "${product?.initialInventory} ${product?.unitName}",
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Price",
                                style: TextStyle(color: Colors.black, fontSize: 14),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "\$${product?.price}",
                                    style: const TextStyle(
                                        color: primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "\$${product?.mrpPrice ?? 0}",
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16),
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
                              onTap: () {
                                cartController.addProduct(
                                    context: context, producer: producer, product: product);
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Add to Cart",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 16,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: primaryColor,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          if ((product?.discount ?? 0) > 0)
            Banner(
              message: "${product?.discount}% OFF",
              color: Colors.red,
              location: BannerLocation.topStart,
            ),
          if (isAuthenticated)
            Positioned(
              top: 12,
              right: 56,
              child: GestureDetector(
                onTap: () async {
                  bool? inWishlist;
                  int? newWishlistId;

                  if (product?.inWishlist == true) {
                    product?.inWishlist = null;
                    setState(() {});
                    inWishlist = await context.read<DashboardController>().removeProducerWishList(
                        context: context,
                        id: product?.id,
                        type: WishListType.product,
                        wishlistId: "${product?.wishlistId}");
                  } else {
                    product?.inWishlist = null;
                    setState(() {});
                    newWishlistId = await context.read<DashboardController>().addToWishList(
                          context: context,
                          id: product?.id,
                          type: WishListType.product,
                          targetId: product?.id,
                        );
                    inWishlist = true;

                    ;
                  }
                  if (newWishlistId != null) {
                    product?.wishlistId = newWishlistId;
                  }

                  product?.inWishlist = inWishlist;
                  setState(() {});
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
                            product?.inWishlist == true ? CupertinoIcons.heart_solid : CupertinoIcons.heart,
                            color: Colors.red,
                            size: 22,
                          ),
                  ),
                ),
              ),
            ),
          Positioned(
            right: 12,
            top: 12,
            child: InkWell(
              onTap: () {
                context.pop();
              },
              child: const CircleAvatar(
                backgroundColor: primaryColor,
                radius: 14,
                child: Center(
                  child: Icon(
                    CupertinoIcons.multiply,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
