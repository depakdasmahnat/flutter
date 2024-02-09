import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';

class DashboardOrderCard extends StatelessWidget {
  const DashboardOrderCard({
    super.key,
    required this.title,
    this.value,
    this.hike,
    this.onTap,
  });

  final String? title;
  final String? value;

  final String? hike;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    double borderRadius = 12;

    Size size = MediaQuery.sizeOf(context);

    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          width: size.width / 3,
          margin: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
          padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: primaryColor, width: 1.8),
            boxShadow: defaultBoxShadow(),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$title",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                  ),
                  if (value != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "$value",
                        style:
                            const TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ),
                  const SizedBox(height: 2),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hike != null)
                      const Icon(
                        Icons.arrow_drop_up_outlined,
                        size: 24,
                        color: primaryColor,
                      ),
                    Text(
                      hike ?? "",
                      style: const TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
