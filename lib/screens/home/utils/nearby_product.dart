import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/core/functions.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../core/services/database/local_database.dart';
import '../../../models/dashboard/producer_details_model.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/image_view.dart';
import '../view_producer.dart';

class NearbyProductCard extends StatelessWidget {
  const NearbyProductCard({
    super.key,
    required this.id,
    required this.title,
    this.image,
    required this.address,
    required this.rating,
    required this.reviews,
    this.distance,
    this.totalProducts,
    this.padding,
    this.onTap,
    this.mobileNo,
    this.email,
    this.orderType,
    this.wishlistId,
    this.inWishlist,
    this.offers,
    this.orderMode,
    this.addToWishList,
    this.removeWishList,
    this.detailsCard,
  });

  final num? id;
  final String? title;
  final String? image;
  final String? address;
  final num? rating;
  final num? reviews;
  final String? distance;
  final String? email;
  final String? orderType;

  final num? totalProducts;

  final String? mobileNo;
  final num? wishlistId;

  final bool? inWishlist;
  final bool? detailsCard;
  final List<ProducerOffers>? offers;
  final String? orderMode;
  final EdgeInsets? padding;
  final Function? addToWishList;
  final Function? removeWishList;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    double imageSize = deviceSpecificValue(context: context, device: 40, tablet: 70).toDouble();
    late bool isAuthenticated = LocalDatabase().accessToken != null;
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 3),
      child: CupertinoButton(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        onPressed: onTap ??
            () {
              context.pushNamed(Routs.viewProducer,
                  extra: ViewProducer(partnerId: "$id", orderType: orderType));
            },
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageView(
                      height: imageSize,
                      width: imageSize,
                      borderRadiusValue: imageSize,
                      fit: BoxFit.cover,
                      backgroundColor: Colors.white,
                      networkImage: "$image",
                      isAvatar: true,
                      onTap: null,
                      boxShadow: primaryBoxShadow(),
                      margin: const EdgeInsets.only(right: 16),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$title",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: GoogleFonts.mulish().fontStyle,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textScaleFactor: TextScaleFactor.autoScale(context),
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      if (offers.haveData)
                                        ImageView(
                                          height: 28,
                                          width: 28,
                                          borderRadiusValue: 40,
                                          fit: BoxFit.cover,
                                          backgroundColor: Colors.white,
                                          assetImage: AppImages.offerIcon,
                                          color: offerColor,
                                          onTap: null,
                                          boxShadow: primaryBoxShadow(),
                                          padding: const EdgeInsets.all(4),
                                          margin: const EdgeInsets.only(left: 4, right: 4),
                                        ),
                                      if (isAuthenticated && addToWishList != null)
                                        GestureDetector(
                                          onTap: () {
                                            if (inWishlist == true) {
                                              removeWishList?.call();
                                            } else {
                                              addToWishList?.call();
                                            }
                                          },
                                          child: inWishlist == null
                                              ? const CupertinoActivityIndicator()
                                              : Icon(
                                                  inWishlist == true
                                                      ? CupertinoIcons.heart_solid
                                                      : CupertinoIcons.heart,
                                                  color: Colors.red,
                                                  size: 26,
                                                ),
                                        ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          if (email != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                "$email",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          if (address != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 2),
                                    child: Icon(
                                      Icons.location_on,
                                      size: 12,
                                      color: primaryColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "$address",
                                      maxLines: detailsCard == true ? null : 1,
                                      overflow: detailsCard == true ? null : TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textScaleFactor: TextScaleFactor.autoScale(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (orderMode != null)
                            Text(
                              "$orderMode",
                              style: const TextStyle(
                                fontSize: 13,
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  if ((reviews ?? 0) > 0)
                                    storeDetail(
                                      icon: Icons.star,
                                      iconColor: Colors.amber,
                                      title: "$rating ($reviews)",
                                    ),
                                  storeDetail(
                                    icon: Icons.navigation_outlined,
                                    iconColor: primaryColor,
                                    title: "${distance ?? "Far"} Away",
                                  ),
                                ],
                              ),
                              if (totalProducts != null)
                                Row(
                                  children: [
                                    Text(
                                      "View all $totalProducts+ Products",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 4, right: 4),
                                      child: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 12,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          // if (offers.haveData)
                          //   SizedBox(
                          //     height: 26,
                          //     child: ListView.builder(
                          //       shrinkWrap: true,
                          //       itemCount: offers?.length ?? 0,
                          //       scrollDirection: Axis.horizontal,
                          //       itemBuilder: (BuildContext context, int index) {
                          //         var data = offers?.elementAt(index);
                          //         return storeDetail(
                          //           icon: Icons.local_offer_outlined,
                          //           iconColor: primaryColor,
                          //           title: "${data?.name}",
                          //         );
                          //       },
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (mobileNo != null)
                        InkWell(
                          onTap: () {
                            launchUrl(
                              Uri.parse("tel:$mobileNo"),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: primaryColor,
                            child: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Positioned(
                //   bottom: 8,
                //   right: 0,
                //   child: Column(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       if (totalProducts != null)
                //         Row(
                //           children: [
                //             Text(
                //               "View all $totalProducts+ products",
                //               style: const TextStyle(
                //                 fontSize: 12,
                //                 color: primaryColor,
                //                 fontWeight: FontWeight.w400,
                //               ),
                //             ),
                //             const Padding(
                //               padding: EdgeInsets.only(left: 4, right: 4),
                //               child: Icon(
                //                 Icons.arrow_forward_ios_outlined,
                //                 size: 12,
                //                 color: primaryColor,
                //               ),
                //             ),
                //           ],
                //         ),
                //     ],
                //   ),
                // ),
              ],
            ),
            if (offers.haveData)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 4),
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

                  // CarouselSlider(
                  //   options: CarouselOptions(
                  //     height: 40,
                  //     viewportFraction: .95,
                  //     initialPage: 0,
                  //     enableInfiniteScroll: false,
                  //     reverse: false,
                  //     autoPlay: true,
                  //     autoPlayInterval: const Duration(seconds: 3),
                  //     autoPlayAnimationDuration:
                  //         const Duration(milliseconds: 1200),
                  //     autoPlayCurve: Curves.fastOutSlowIn,
                  //     enlargeCenterPage: false,
                  //     pageSnapping: false,
                  //     scrollDirection: Axis.horizontal,
                  //   ),
                  //   items: List.generate(
                  //     offers?.length ?? 0,
                  //     (index) {
                  //       var offer = offers?[index];
                  //       return MiniOfferCard(
                  //         index: index,
                  //         offer: offer,
                  //       );
                  //     },
                  //   ),
                  // ),

                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const PageScrollPhysics(),
                      itemCount: offers?.length ?? 0,
                      itemBuilder: (context, index) {
                        var offer = offers?[index];

                        return MiniOfferCard(
                          index: index,
                          offer: offer,
                          width: size.width * 0.78,
                        );
                      },
                    ),
                  ),
                ],
              )
          ],
        ),
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

class MiniOfferCard extends StatelessWidget {
  const MiniOfferCard({
    super.key,
    required this.index,
    required this.offer,
    this.width,
  });

  final int index;
  final ProducerOffers? offer;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.only(left: index == 0 ? 4 : 0, right: 16, top: 8, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          boxShadow: primaryBoxShadow(), color: Colors.white, borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          const ImageView(
            height: 26,
            width: 26,
            borderRadiusValue: 40,
            fit: BoxFit.cover,
            backgroundColor: Colors.white,
            assetImage: AppImages.offerIcon,
            color: primaryColor,
            onTap: null,
            padding: EdgeInsets.all(4),
            margin: EdgeInsets.only(right: 6),
          ),
          Flexible(
            child: Text(
              '${offer?.description}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          )
        ],
      ),
    );
  }
}
