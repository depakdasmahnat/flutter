import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constant/shadows.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/image_view.dart';
import '../../services/service_provider_detail.dart';
import '../view_producer.dart';

class RecentlyViewedServicesCard extends StatelessWidget {
  const RecentlyViewedServicesCard({
    super.key,
    required this.image,
    this.title,
    this.boxFit,
    this.radius,
    this.padding,
    this.isService,
    required this.id,
  });

  final num? id;
  final String? title;
  final String? image;
  final BoxFit? boxFit;
  final double? radius;
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
            ImageView(
              height: radius ?? 85,
              width: radius ?? 85,
              fit: boxFit ?? BoxFit.cover,
              borderRadiusValue: 60,
              backgroundColor: Colors.white,
              boxShadow: defaultBoxShadow(),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              networkImage: "$image",
              isAvatar: true,
              onTap: null,
              margin: const EdgeInsets.only(bottom: 8),
              padding: padding,
            ),
            if (title != null)
              SizedBox(
                width: 85,
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
