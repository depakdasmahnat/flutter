import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';

import '../../../core/constant/constant.dart';
import '../../../utils/widgets/image_view.dart';

class Banners extends StatefulWidget {
  const Banners({super.key, required this.banners});

  final List<String?>? banners;

  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  int bannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return widget.banners.haveData
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: kPadding, bottom: 4),
                child: CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 16 / 7,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      onPageChanged: (val, season) {
                        bannerIndex = val;
                        setState(() {});
                      },
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 1200),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: false,
                      enlargeFactor: 0.3,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: List.generate(widget.banners?.length ?? 0, (bannerIndex) {
                      var data = widget.banners?.elementAt(bannerIndex);
                      return Builder(
                        builder: (BuildContext context) {
                          return ImageView(
                            assetImage: '$data',
                            // backgroundColor: Colors.grey.shade300,
                            borderRadiusValue: 18,
                            onTap: () {},

                            fit: BoxFit.cover,
                            margin: const EdgeInsets.symmetric(horizontal: kPadding),
                          );
                        },
                      );
                    })),
              ),
              if ((widget.banners?.length ?? 0) > 0)
                SizedBox(
                  height: 8,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.banners?.length ?? 0,
                    itemBuilder: (context, index) {
                      bool current = index == bannerIndex;
                      return GradientButton(
                        height: 8,
                        width: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        backgroundGradient: current ? primaryGradient : inActiveGradient,
                      );
                    },
                  ),
                ),
            ],
          )
        : const SizedBox();
  }
}

class OfferBannerCard extends StatelessWidget {
  const OfferBannerCard({
    super.key,
    required this.data,
    required this.bannerIndex,
    this.bannersLength,
    this.margin,
  });

  final int bannerIndex;
  final int? bannersLength;
  final String? data;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: margin ?? const EdgeInsets.all(kPadding),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: kPadding),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(28),
      ),
      child: ImageView(
        networkImage: '$data',
        backgroundColor: Colors.grey.shade300,
        borderRadiusValue: 18,
        onTap: () {},
        fit: BoxFit.contain,
        margin: const EdgeInsets.only(left: kPadding),
      ),
    );
  }
}
