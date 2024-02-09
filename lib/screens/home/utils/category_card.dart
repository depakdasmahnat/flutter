import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_images.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../core/enums/enums.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/image_view.dart';
import '../all_producers.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.title,
    required this.image,
    required this.orderType,
    this.type,
  });

  final String? title;
  final String? image;
  final AllOrderTypes? orderType;
  final ServiceType? type;

  @override
  Widget build(BuildContext context) {
    double width = 165;
    double borderRadius = 20;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        context.pushNamed(Routs.allProducers,
            extra: AllProducersScreen(
              orderType: orderType,
              type: type,
            ));
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 22, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: defaultBoxShadow(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: Text(
                "$title",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                ImageView(
                  height: 160,
                  width: width,
                  assetImage: "$image",
                  borderRadiusValue: borderRadius,
                  onTap: null,
                  fit: BoxFit.cover,
                  margin: EdgeInsets.zero,
                ),
                const Positioned(
                  top: 0,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: 20,
                    child: ImageView(
                      height: 18,
                      width: 18,
                      assetImage: AppImages.arrow,
                      onTap: null,
                      fit: BoxFit.contain,
                      margin: EdgeInsets.zero,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
