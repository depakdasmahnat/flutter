import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gaas/screens/home/view_producer.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../models/dashboard/service/service_provider_detail.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/image_view.dart';

class MapServiceProviderCard extends StatelessWidget {
  const MapServiceProviderCard({
    super.key,
    required this.serviceProvider,
    this.width,
    this.padding,
    this.onTap,
    this.margin,
    this.borderRadius,
    this.boxShadow,
  });

  final ServiceProviderData? serviceProvider;
  final EdgeInsets? padding;
  final double? width;
  final double? borderRadius;
  final EdgeInsets? margin;
  final List<BoxShadow>? boxShadow;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin ?? const EdgeInsets.only(bottom: 3),
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: boxShadow,
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap ??
            () {
              context.pushNamed(Routs.viewProducer, extra: ViewProducer(partnerId: "${serviceProvider?.id}"));
            },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageView(
                    height: 50,
                    width: 50,
                    borderRadiusValue: 12,
                    fit: BoxFit.cover,
                    backgroundColor: Colors.white,
                    networkImage: "${serviceProvider?.profilePhoto}",
                    onTap: null,
                    boxShadow: primaryBoxShadow(),
                    margin: const EdgeInsets.only(right: 12),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                serviceProvider?.name ?? "",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: GoogleFonts.mulish().fontStyle,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                        if ((serviceProvider?.rating ?? 0) > 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    "${serviceProvider?.ratingLabel ?? ""} ${serviceProvider?.rating}",
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
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
            ),
          ],
        ),
      ),
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
