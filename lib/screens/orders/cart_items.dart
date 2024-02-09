import 'package:flutter/material.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/screens/orders/utils/select_order_timeSlots.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/orders/cart_controller.dart';
import '../../core/constant/colors.dart';
import '../../core/constant/shadows.dart';
import '../../models/dashboard/producer_details_model.dart';
import '../../utils/widgets/data_widget_builder.dart';
import '../../utils/widgets/image_view.dart';
import '../../utils/widgets/widgets.dart';
import '../home/utils/nearby_product.dart';
import 'utils/counter_buttons.dart';

class CartItems extends StatefulWidget {
  const CartItems({Key? key, this.physics, this.heightFactor, this.checkOutMode}) : super(key: key);

  final ScrollPhysics? physics;
  final double? heightFactor;
  final bool? checkOutMode;

  @override
  State<CartItems> createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  List<ProducerDetailsData?>? cartItems;

  late bool? checkOutMode = widget.checkOutMode;
  ProducerDetailsData? producer;
  List<ProducerProducts?>? products;

  @override
  Widget build(BuildContext context) {
    CartController cartController = Provider.of<CartController>(context);
    cartItems = cartController.cartItems;
    Size size = MediaQuery.of(context).size;

    return DataWidgetBuilder(
      isLoading: false,
      haveData: cartItems.haveData,
      heightFactor: widget.heightFactor,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: cartItems?.length ?? 0,
        physics: widget.physics ?? const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          producer = cartItems?.elementAt(index);
          products = producer?.products;
          List<ProducerServiceTypes>? serviceTypes = producer?.serviceTypes;

          return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              NearbyProductCard(
                id: producer?.id,
                title: producer?.name,
                image: producer?.profilePhoto,
                address: producer?.address,
                rating: producer?.rating,
                reviews: producer?.reviews,
                distance: producer?.distanceLabel,
                onTap: () {},
                padding: const EdgeInsets.symmetric(horizontal: 18),
              ),
              if (serviceTypes != null && checkOutMode == true)
                SelectOrderTypeTimeSlot(
                  producer: producer,
                  serviceTypes: serviceTypes,
                ),
              if (products.haveData)
                ListView.builder(
                  itemCount: products?.length ?? 0,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, productIndex) {
                    ProducerProducts? product = products?.elementAt(productIndex);
                    return Stack(
                      children: [
                        Container(
                          height: 100,
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: primaryBoxShadow(),
                          ),
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.only(right: 16),
                          child: ClipRRect(
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    ImageView(
                                      width: 80,
                                      networkImage: "${product?.image}",
                                      border: Border.all(color: Colors.grey.shade100),
                                      fit: BoxFit.contain,
                                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${product?.name}",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 6),
                                            child: Text(
                                              "${product?.initialInventory}  ${product?.unitName}.",
                                              style: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "\$${product?.mrpPrice ?? 0}",
                                            style: const TextStyle(
                                                color: Colors.red, decoration: TextDecoration.lineThrough),
                                          ),
                                          const SizedBox(width: 8),
                                          Row(
                                            children: [
                                              Text(
                                                "\$${product?.price}",
                                                style: const TextStyle(color: primaryColor, fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if ((product?.discount ?? 0) > 0)
                                  Banner(
                                    message: "${product?.discount}% OFF",
                                    color: Colors.red,
                                    location: BannerLocation.topStart,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 14,
                          bottom: 12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CounterButtons(
                                producer: producer,
                                product: product,
                                hideCounter: false,
                                refreshPaymentSummary: checkOutMode,
                                onCartEmpty: () {
                                  if (context.read<CartController>().getProductsCount() == 0) {
                                    context.pop();
                                    context.read<CartController>().clearCart(context);
                                    showSnackBar(context: context, text: "Oops Cart is Empty...");
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Divider(color: Colors.grey.shade200, height: 1, thickness: 4),
              )
            ],
          );
        },
      ),
    );
  }
}
