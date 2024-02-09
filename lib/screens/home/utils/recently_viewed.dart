import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/image_view.dart';
import '../../services/service_provider_detail.dart';
import '../view_producer.dart';

class RecentlyViewedCard extends StatelessWidget {
  const RecentlyViewedCard({
    super.key,
    required this.image,
    this.title,
    this.boxFit,
    this.radius,
    this.padding,
    this.isService,
    this.itemCounts,
    required this.id,
  });

  final num? id;
  final String? title;
  final String? image;
  final BoxFit? boxFit;
  final double? radius;
  final int? itemCounts;
  final EdgeInsets? padding;
  final bool? isService;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (isService == true) {
          context.push(Routs.serviceProviderDetail, extra: ServiceProviderDetailScreen(id: id));
        } else {
          context.pushNamed(Routs.viewProducer, extra: ViewProducer(partnerId: "$id"));
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Badge(
              offset: const Offset(0, 2),
              label: Text("${itemCounts ?? 0}"),
              backgroundColor: primaryColor,
              isLabelVisible: ((itemCounts ?? 0) > 0),
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8, top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: defaultBoxShadow(),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ImageView(
                  height: radius ?? 60,
                  width: radius ?? 60,
                  fit: boxFit ?? BoxFit.cover,
                  borderRadiusValue: 60,
                  networkImage: "$image",
                  onTap: null,
                  margin: EdgeInsets.zero,
                  padding: padding,
                ),
              ),
            ),
            if (title != null)
              SizedBox(
                width: 80,
                child: Text(
                  "$title",
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              )
          ],
        ),
      ),
    );
  }
}
