import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/models/dashboard/producer_details_model.dart';

import '../../../utils/widgets/image_view.dart';

class ProducerOffersCard2 extends StatelessWidget {
  const ProducerOffersCard2({Key? key, required this.offer}) : super(key: key);
  final List<ProducerOffers?>? offer;

  @override
  Widget build(BuildContext context) {
    return offer.haveData
        ? CarouselSlider(
            options: CarouselOptions(
           height: 60,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 1200),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
            ),
            items: offer?.map((data) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: offerColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: defaultBoxShadow(),
                    ),
                    child: Row(
                      children: [
                        ImageView(
                          height: 24,
                          width: 24,
                          assetImage: AppImages.offerIcon,
                          color: Colors.white,
                          borderRadiusValue: 18,
                          onTap: () {
                            // context.pushNamed(Routs.partnerProducts, extra: PartnerProducts(bannerId: data?.id));
                          },
                          fit: BoxFit.cover,
                          margin: const EdgeInsets.only(right: 12),
                        ),
                        Text(
                          "${data?.description}",
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          )
        : const SizedBox();
  }
}
