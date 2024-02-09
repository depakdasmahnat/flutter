import 'package:flutter/material.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerCard({
  Color? backgroundColor,
  Color? highlightColor,
  double? height,
  double? width,
  double? borderRadius,
  EdgeInsets? margin,
  Duration? duration,
  ShimmerDirection? direction,
  Gradient? gradient,
}) {
  return Row(
    children: [
      Shimmer.fromColors(
        baseColor: backgroundColor ?? Colors.grey.shade200,
        highlightColor: highlightColor ?? Colors.white,
        direction: direction ?? ShimmerDirection.ltr,
        period: duration ?? const Duration(milliseconds: 1800),
        child: Container(
            margin: margin ?? const EdgeInsets.only(left: 16, top: 6),
            height: height ?? 16,
            width: width ?? 200,
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.grey.shade200,
              borderRadius: BorderRadius.circular(borderRadius ?? 4),
            )),
      )
    ],
  );
}

class Skeletons {
  Widget skeletonProductCard({required BuildContext context, int? itemCount}) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: itemCount ?? 3,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
          child: Container(
            width: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: primaryBoxShadow(),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                      child: shimmerCard(
                        height: 125,
                        width: 125,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          shimmerCard(
                            height: 12,
                            width: size.width * 0.3,
                            margin: const EdgeInsets.only(left: 3, top: 2),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                          child: shimmerCard(
                            height: 12,
                            width: size.width * 0.2,
                            margin: const EdgeInsets.only(left: 3, top: 2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                shimmerCard(
                  height: 16,
                  width: size.width * 0.34,
                  margin: const EdgeInsets.only(left: 8, top: 2, right: 4, bottom: 12),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget skeletonBannerCard({required BuildContext context}) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: primaryBoxShadow(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [shimmerCard(height: 14, width: size.width * 0.75)],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: shimmerCard(height: 14, width: size.width * 0.25),
          ),
          shimmerCard(height: 14, width: size.width * 0.3),
        ],
      ),
    );
  }

  Widget skeletonCategoriesCard({
    required BuildContext context,
    int? itemCount,
    ScrollPhysics? physics,
  }) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: itemCount ?? 1,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Container(
            height: 150,
            width: size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: primaryBoxShadow(),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                shimmerCard(),
                shimmerCard(width: 120),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget skeletonEarningsCard({
    required BuildContext context,
    int? itemCount,
    ScrollPhysics? physics,
  }) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: itemCount ?? 1,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Container(
            height: 100,
            width: size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: primaryBoxShadow(),
            ),
            child: Row(
              children: [
                shimmerCard(height: 60, width: 60),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerCard(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: shimmerCard(width: size.width * 0.3, height: 8),
                    ),
                    shimmerCard(width: size.width * 0.4, height: 8),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
