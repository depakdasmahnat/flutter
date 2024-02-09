import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:provider/provider.dart';

import '../../../controllers/partner/membership_controller.dart';
import '../../../controllers/partner/partner_controller.dart';
import '../../../core/constant/colors.dart';
import '../../../core/enums/enums.dart';
import '../../../utils/widgets/image_view.dart';

class PartnerServiceCard extends StatelessWidget {
  const PartnerServiceCard({
    super.key,
    required this.type,
    required this.name,
    required this.image,
    required this.route,
    this.boxFit,
    this.radius,
    this.padding,
    this.onTap,
    this.itemCounts,
  });

  final ServiceType type;
  final String? name;
  final String? image;
  final String? route;

  final BoxFit? boxFit;
  final double? radius;
  final EdgeInsets? padding;
  final num? itemCounts;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap ??
          () {
            PartnerController controllers = Provider.of(context, listen: false);
            controllers.setServiceType(serviceType: type);
            context.read<PartnerController>().resetIndex();
            MembershipController membershipController =
                Provider.of<MembershipController>(context, listen: false);
            membershipController.checkMembershipAPI(context: context, route: "$route", type: type);
          },
      child: Padding(
        padding: const EdgeInsets.only(right: 12, top: 12),
        child: Badge(
          offset: const Offset(0, -6),
          label: Text("${itemCounts ?? 0}"),
          backgroundColor: primaryColor,
          isLabelVisible: ((itemCounts ?? 0) > 0),
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Column(
            children: [
              ImageView(
                height: radius ?? 65,
                width: radius ?? 65,
                fit: boxFit ?? BoxFit.cover,
                borderRadiusValue: 8,
                border: Border.all(color: Colors.grey.shade300),
                assetImage: "$image",
                onTap: null,
                backgroundColor: Colors.white,
                boxShadow: defaultBoxShadow(),
                margin: const EdgeInsets.only(bottom: 8),
                padding: padding,
              ),
              if (name != null)
                SizedBox(
                  width: 75,
                  child: Text(
                    "$name",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
