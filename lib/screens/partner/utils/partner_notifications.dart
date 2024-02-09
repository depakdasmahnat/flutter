import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/utils/widgets/image_view.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';

class PartnerNotification extends StatelessWidget {
  const PartnerNotification({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
  });

  final String? title;
  final num? value;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    double borderRadius = 6;

    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: defaultBoxShadow(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: primaryColor,
                    child: ImageView(
                      assetImage: AppImages.package,
                      height: 18,
                      width: 18,
                      color: Colors.white,
                      margin: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "$title",
                    style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                color: primaryColor,
                size: 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}
