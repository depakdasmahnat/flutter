import 'package:flutter/material.dart';
import 'package:gaas/core/constant/shadows.dart';

import '../../../../../core/config/app_images.dart';
import '../../../../../core/constant/colors.dart';
import '../../../../../models/partner/offers/partner_offers_model.dart';
import '../../../../../utils/widgets/image_view.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({
    Key? key,
    required this.index,
    required this.offerData,
  }) : super(key: key);

  final int index;
  final PartnerOffersData? offerData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: index == 0 ? 16 : 0, bottom: 12),
      padding: const EdgeInsets.only(top: 8, bottom: 16, left: 12, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: defaultBoxShadow(),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${offerData?.name}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                              children: [
                                RichText(
                                  maxLines: 1,
                                  text: TextSpan(
                                    style: defaultStyle(),
                                    children: <TextSpan>[
                                      TextSpan(text: "Coupon Code", style: defaultStyle()),
                                      TextSpan(text: "  :-  ", style: defaultStyle()),
                                      TextSpan(text: "${offerData?.code}", style: defaultBoldStyle()),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              children: [
                                RichText(
                                  maxLines: 1,
                                  text: TextSpan(
                                    style: defaultStyle(),
                                    children: <TextSpan>[
                                      TextSpan(text: "Amount", style: defaultStyle()),
                                      TextSpan(text: "  :-  ", style: defaultStyle()),
                                      TextSpan(
                                          text: "\$ ${offerData?.amount ?? 0.0}",
                                          style: defaultBoldStyle(color: Colors.green)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              children: [
                                RichText(
                                  maxLines: 1,
                                  text: TextSpan(
                                    style: defaultStyle(),
                                    children: <TextSpan>[
                                      TextSpan(text: "Discount", style: defaultStyle()),
                                      TextSpan(text: "  :-  ", style: defaultStyle()),
                                      TextSpan(
                                          text: "\$${offerData?.discountUpto ?? 0.0} (${offerData?.percent ?? "0"}%)",
                                          style: defaultBoldStyle()),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (offerData?.categoryName != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    "Category :- ${offerData?.categoryName}",
                                    style: defaultStyle(),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: ImageView(
                          height: 40,
                          width: 105,
                          fit: BoxFit.contain,
                          assetImage: AppImages.appIcon,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const ImageView(
                          height: 16,
                          width: 16,
                          color: primaryColor,
                          assetImage: AppImages.clock,
                          margin: EdgeInsets.only(right: 4),
                        ),
                        Text(
                          "Start Date :- ${offerData?.startDate}",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const ImageView(
                          height: 16,
                          width: 16,
                          color: primaryColor,
                          assetImage: AppImages.clock,
                          margin: EdgeInsets.only(right: 4),
                        ),
                        Text(
                          "End Date :- ${offerData?.endDate}",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.group, color: Colors.white, size: 15),
                      const SizedBox(width: 4),
                      Text(
                        "${offerData?.maxUser} Users",
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.edit, color: primaryColor, size: 15),
                      SizedBox(width: 4),
                      Text(
                        "Edit",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: primaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle defaultStyle() => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      );

  TextStyle defaultBoldStyle({Color? color}) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.black,
      );
}
