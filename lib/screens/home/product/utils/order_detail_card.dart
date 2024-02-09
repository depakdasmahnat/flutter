import 'package:flutter/material.dart';

import '../../../../core/constant/colors.dart';
import '../../../../core/constant/shadows.dart';
import '../../../../models/dashboard/producer_details_model.dart';
import '../../../../utils/widgets/image_view.dart';

class OrderDetailCard extends StatelessWidget {
  const OrderDetailCard({Key? key, required this.index, required this.product, this.hideCounter, this.producer})
      : super(key: key);
  final int index;
  final ProducerDetailsData? producer;
  final ProducerProducts? product;
  final bool? hideCounter;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          child: Row(
            children: [
              ImageView(
                height: 100,
                width: 100,
                networkImage: "${product?.image}",
                border: Border.all(color: Colors.grey.shade100),
                fit: BoxFit.contain,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${product?.quantity} ${product?.unitName}"),
                          Text(
                            "\$ ${(num.parse("${product?.quantity ?? 0}") * num.parse("${(product?.price ?? 0)}")).toStringAsFixed(2)}",
                            style: const TextStyle(color: primaryColor, fontSize: 16),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Row(
                          children: [
                            Text(
                              "\$${product?.price}",
                              style: const TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "\$${product?.mrpPrice ?? 0}",
                              style: const TextStyle(color: Colors.red, decoration: TextDecoration.lineThrough),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
