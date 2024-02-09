import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/models/dashboard/producer_details_model.dart';

import '../../../utils/widgets/image_view.dart';

class ProducerOffersCard extends StatelessWidget {
  const ProducerOffersCard({Key? key, required this.offer}) : super(key: key);
  final List<ProducerOffers?>? offer;

  @override
  Widget build(BuildContext context) {
    return offer.haveData
        ? CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 16 / 4,
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: defaultBoxShadow(),
                    ),
                    child: ListTile(
                      isThreeLine: true,
                      title: Text(
                        "${data?.title}",
                        style: const TextStyle(color: primaryColor),
                      ),
                      subtitle: Text(
                        "${data?.description}",
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageView(
                            height: 36,
                            width: 36,
                            assetImage: AppImages.offerIcon,
                            color: primaryColor,
                            borderRadiusValue: 18,
                            onTap: () {
                              // context.pushNamed(Routs.partnerProducts, extra: PartnerProducts(bannerId: data?.id));
                            },
                            fit: BoxFit.cover,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          )
        : const SizedBox();
  }
}
