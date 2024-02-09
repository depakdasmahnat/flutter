import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gaas/controllers/services_controller.dart';
import 'package:gaas/screens/home/view_producer.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../core/enums/enums.dart';
import '../../../core/functions.dart';
import '../../../core/services/database/local_database.dart';
import '../../../models/dashboard/service/service_provider_detail.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/image_view.dart';

class ServiceProviderCard extends StatelessWidget {
  const ServiceProviderCard({
    super.key,
    required this.serviceProvider,
    this.width,
    this.padding,
    this.onTap,
    this.margin,
    this.borderRadius,
    this.boxShadow,
    this.detailsCard,
  });

  final ServiceProviderData? serviceProvider;
  final EdgeInsets? padding;
  final double? width;
  final double? borderRadius;
  final bool? detailsCard;
  final EdgeInsets? margin;
  final List<BoxShadow>? boxShadow;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    late bool isAuthenticated = LocalDatabase().accessToken != null;
    double imageSize = deviceSpecificValue(context: context, device: 60, tablet: 80).toDouble();
    return Stack(
      children: [
        Container(
          width: width,
          margin: margin ?? const EdgeInsets.only(bottom: 3),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: boxShadow,
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
          ),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onTap ??
                () {
                  context.pushNamed(Routs.viewProducer,
                      extra: ViewProducer(partnerId: "${serviceProvider?.id}"));
                },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageView(
                  height: imageSize,
                  width: imageSize,
                  borderRadiusValue: 12,
                  fit: BoxFit.cover,
                  backgroundColor: Colors.white,
                  networkImage: "${serviceProvider?.profilePhoto}",
                  isAvatar: true,
                  onTap: null,
                  boxShadow: primaryBoxShadow(),
                  margin: const EdgeInsets.only(right: 16),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 36,bottom: 6),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                serviceProvider?.name ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: GoogleFonts.mulish().fontStyle,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textScaleFactor: TextScaleFactor.autoScale(context),
                              ),
                            ),
                            if (serviceProvider?.isFeatured == "Yes")
                              const Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Icon(
                                  Icons.verified_outlined,
                                  size: 18,
                                  color: primaryColor,
                                ),
                              )
                          ],
                        ),
                      ),
                      if ((serviceProvider?.rating ?? 0) > 0)
                        Padding(
                          padding: const EdgeInsets.only(right: 36,bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(
                                  "${serviceProvider?.ratingLabel ?? ""} (${serviceProvider?.rating})",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              RatingBar.builder(
                                initialRating: (serviceProvider?.rating ?? 0).toDouble(),
                                minRating: 1,
                                ignoreGestures: true,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 14,
                                itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  debugPrint("$rating");
                                },
                              ),
                            ],
                          ),
                        ),

                      if (serviceProvider?.address != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2, bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_pin, size: 18),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "${serviceProvider?.address}",
                                  maxLines: detailsCard == true ? null : 1,
                                  overflow: detailsCard == true ? null : TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 6),
                      //   child: Row(
                      //     children: [
                      //       iconTag(
                      //         icon: Icons.lock_outline,
                      //         title: "Pay Securely",
                      //         background: Colors.green,
                      //         color: Colors.white,
                      //       ),
                      //       iconTag(
                      //         icon: Icons.attach_money_rounded,
                      //         title: "Great Value",
                      //         background: Colors.green.withOpacity(0.3),
                      //         color: Colors.green.shade700,
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // if ((serviceProvider?.perHourCharge ?? 0) > 0)
                      //   Text(
                      //     "\$${serviceProvider?.perHourCharge}/Hour",
                      //     style: const TextStyle(
                      //       fontSize: 14,
                      //       color: Colors.black,
                      //       fontWeight: FontWeight.w800,
                      //     ),
                      //   ),
                      // if (online == true)
                      //   Padding(
                      //     padding: const EdgeInsets.only(top: 2, bottom: 4),
                      //     child: Row(
                      //       children: [
                      //         const Padding(
                      //           padding: EdgeInsets.only(right: 6),
                      //           child: Icon(
                      //             Icons.circle,
                      //             size: 6,
                      //             color: Colors.green,
                      //           ),
                      //         ),
                      //         Flexible(
                      //           child: Text(
                      //             "Online",
                      //             style: TextStyle(
                      //               fontSize: 12,
                      //               color: Colors.green,
                      //               fontWeight: FontWeight.w400,
                      //               fontStyle: GoogleFonts
                      //                   .mulish()
                      //                   .fontStyle,
                      //             ),
                      //             maxLines: 1,
                      //             overflow: TextOverflow.ellipsis,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),

                      if (serviceProvider?.about != null && serviceProvider?.services == null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_pin, size: 18),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "${serviceProvider?.about}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        if (isAuthenticated)
          Positioned(
            top: 8,
            right: 30,
            child: InkWell(
              onTap: () {
                if (serviceProvider?.inWishlist == true) {
                  context.read<ServicesController>().removeProducerWishList(
                      context: context,
                      id: serviceProvider?.id,
                      type: WishListType.partner,
                      wishlistId: "${serviceProvider?.wishlistId}");
                } else {
                  context.read<ServicesController>().addToWishList(
                        context: context,
                        id: serviceProvider?.id,
                        type: WishListType.partner,
                        targetId: serviceProvider?.id,
                      );
                }
              },
              child: serviceProvider?.inWishlist == null
                  ? const CupertinoActivityIndicator()
                  : Icon(
                      serviceProvider?.inWishlist == true ? CupertinoIcons.heart_solid : CupertinoIcons.heart,
                      color: Colors.red,
                      size: 26,
                    ),
            ),
          ),
      ],
    );
  }

  Widget iconTag({
    required IconData? icon,
    required String? title,
    required Color? background,
    required Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 8,
            color: color,
          ),
          const SizedBox(width: 2),
          Text(
            "$title",
            style: TextStyle(
              fontSize: 8,
              color: color,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget storeDetail({
    required String? title,
    IconData? icon,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
      margin: const EdgeInsets.only(top: 6, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                (icon),
                size: 12,
                color: iconColor ?? Colors.grey.shade800,
              ),
            ),
          Text(
            "$title",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
