import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/utils/widgets/image_view.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../core/enums/enums.dart';
import '../../../models/dashboard/banners_model.dart';
import '../../../route/route_paths.dart';
import '../../services/service_provider_detail.dart';

class ServicesOfferBanners extends StatelessWidget {
  const ServicesOfferBanners({Key? key, required this.banners, this.schemeMode, this.serviceType})
      : super(key: key);
  final List<BannersData?>? banners;
  final bool? schemeMode;
  final ServiceType? serviceType;

  @override
  Widget build(BuildContext context) {
    return banners.haveData
        ? CarouselSlider(
            options: CarouselOptions(
              height: 250,
              viewportFraction: 0.55,
              initialPage: 0,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 1200),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              pageSnapping: false,
              scrollDirection: Axis.horizontal,
            ),
            items: banners?.map((data) {
              return Builder(
                builder: (BuildContext context) {
                  return ServiceCard(banner: data);
                },
              );
            }).toList(),
          )
        : const SizedBox();
  }
}

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    this.title,
    this.subTitle,
    required this.banner,
  });

  final BannersData? banner;
  final String? title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double width = size.width * 0.5;
    double borderRadius = 20;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (banner?.partners != null) {
          context.pushNamed(Routs.serviceProviderDetail,
              extra: ServiceProviderDetailScreen(
                id: num.parse("${banner?.partners}"),
              ));
        }
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: defaultBoxShadow(),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomLeft,
          children: [
            ImageView(
              height: 250,
              width: width,
              networkImage: "${banner?.image}",
              borderRadiusValue: borderRadius,
              onTap: null,
              fit: BoxFit.cover,
              margin: EdgeInsets.zero,
            ),
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        "$title",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              shadows: defaultTextShadow(color: Colors.black),
                            ),
                      ),
                    if (subTitle != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          "$subTitle",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                                shadows: defaultTextShadow(color: Colors.black),
                              ),
                        ),
                      ),
                    const DottedLine(
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
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
