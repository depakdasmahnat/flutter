import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/core/functions.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums/enums.dart';
import '../../../models/dashboard/banners_model.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/image_view.dart';
import '../../partner/fresh/partner_products.dart';
import '../all_producers.dart';
import '../view_producer.dart';

class OfferBanners extends StatelessWidget {
  const OfferBanners({Key? key, required this.banners, this.schemeMode, this.serviceType}) : super(key: key);
  final List<BannersData?>? banners;
  final bool? schemeMode;
  final ServiceType? serviceType;

  @override
  Widget build(BuildContext context) {
    return banners.haveData
        ? CarouselSlider(
            options: CarouselOptions(
              height: deviceSpecificValue(
                context: context,
                device: 165,
                tablet: 280,
                desktop: 260,
              ).toDouble(),
              aspectRatio: 16 / 9,
              viewportFraction: deviceSpecificValue(
                context: context,
                device: 0.85,
                tablet: 0.5,
                desktop: 0.5,
              ).toDouble(),
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
            items: banners?.map((data) {
              return Builder(
                builder: (BuildContext context) {
                  return ImageView(
                    width: MediaQuery.of(context).size.width,
                    networkImage: "${data?.image}",
                    backgroundColor: Colors.grey.shade50,
                    borderRadiusValue: 18,
                    boxShadow: defaultBoxShadow(),
                    onTap: schemeMode == true
                        ? () {
                            context.pushNamed(Routs.partnerProducts,
                                extra: PartnerProducts(bannerId: data?.id));
                          }
                        : () {
                            String? type = data?.type;
                            if (type == BannerTypes.partner.value) {
                              context.pushNamed(Routs.viewProducer,
                                  extra: ViewProducer(partnerId: data?.partners));
                            } else if (type == BannerTypes.partners.value ||
                                type == BannerTypes.products.value) {
                              context.pushNamed(Routs.allProducers,
                                  extra: AllProducersScreen(
                                    type: serviceType,
                                    bannerId: data?.id,
                                    partnerIds: data?.partners,
                                  ));
                            }
                          },
                    fit: BoxFit.cover,
                    margin: const EdgeInsets.only(right: 16),
                  );
                },
              );
            }).toList(),
          )
        : const SizedBox();
  }
}
