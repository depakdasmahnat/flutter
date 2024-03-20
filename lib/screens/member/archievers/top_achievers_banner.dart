import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/screens/guest/guest_check_demo/guest_check_demo_step2.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../models/member/dashboard/achievers_model.dart';
import '../../../utils/widgets/gradient_text.dart';
import '../../../utils/widgets/image_view.dart';

class TopAchieversBanners extends StatefulWidget {
  const TopAchieversBanners({super.key, required this.data});

  final List<AchieversData?>? data;

  @override
  State<TopAchieversBanners> createState() => _TopAchieversBannersState();
}

class _TopAchieversBannersState extends State<TopAchieversBanners> {
  int bannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return widget.data.haveData
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: kPadding, bottom: 4),
                child: CarouselSlider(
                    options: CarouselOptions(

                      aspectRatio: 16 /16,
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
                    items: List.generate(widget.data?.length ?? 0, (bannerIndex) {
                      var data = widget.data?.elementAt(bannerIndex);
                      return Builder(
                        builder: (BuildContext context) {
                          return TopAchieverCard(
                            data: data,
                            bannerIndex: bannerIndex,
                          );
                        },
                      );
                    })),
              ),
              if ((widget.data?.length ?? 0) > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: kPadding),
                  child: SizedBox(
                    height: 6,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        bool current = index == bannerIndex;
                        return GradientButton(
                          height: 6,
                          width: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          backgroundGradient: current ? whiteGradient : primaryGradient,
                        );
                      },
                    ),
                  ),
                ),
            ],
          )
        : const SizedBox();
  }
}

class TopAchieverCard extends StatelessWidget {
  const TopAchieverCard({
    super.key,
    required this.data,
    required this.bannerIndex,
    this.bannersLength,
    this.margin,
  });

  final int bannerIndex;
  final int? bannersLength;
  final AchieversData? data;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ImageView(
                  height: 40,
                  width: 40,
                  assetImage: AppAssets.trophyIcon,
                  margin: EdgeInsets.only(right: 8),
                ),
                Text(
                  'RANK ${bannerIndex + 1}',
                  style: const TextStyle(
                    fontSize: 30,

                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),

           Stack(
          children: [
             ImageView(
              height: 170,
              width: 170,
              networkImage: data?.profilePhoto,
              borderRadiusValue: 100,
              fit: BoxFit.cover,
              isAvatar: true,
              margin: const EdgeInsets.only(top: 4, bottom: 2),
            ),
            Positioned(
              left: -7,
              child: Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        AppAssets.batch
                    )
                  )
                ),
                child: Center(

                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GradientText(
                      '${data?.rank}',
                      gradient: primaryGradient,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: GoogleFonts.urbanist().fontFamily,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            )

          ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4,top: kPadding),
            child: Text(
              '${data?.firstName ?? ''} ${data?.lastName ?? ''}',
              style: const TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Turnover',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '₹${data?.turnover ?? ''}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
