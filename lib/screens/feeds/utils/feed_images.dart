import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';

import '../../../core/enums/enums.dart';
import '../../../utils/widgets/image_view.dart';

class FeedImages extends StatelessWidget {
  const FeedImages({Key? key, required this.images, this.schemeMode, this.serviceType}) : super(key: key);
  final List<String?>? images;
  final bool? schemeMode;
  final ServiceType? serviceType;

  @override
  Widget build(BuildContext context) {
    return images.haveData
        ? CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
            ),
            items: images?.map((data) {
              return Builder(
                builder: (BuildContext context) {
                  return ImageView(
                    width: MediaQuery.of(context).size.width,
                    networkImage: "$data",
                    backgroundColor: Colors.grey.shade50,
                    borderRadiusValue: 0,
                    boxShadow: defaultBoxShadow(),
                    onTap: null,
                    fit: BoxFit.cover,
                    margin: const EdgeInsets.only(top: 6, bottom: 8),
                  );
                },
              );
            }).toList(),
          )
        : const SizedBox();
  }
}
