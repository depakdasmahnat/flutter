import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant/colors.dart';
import '../../../utils/widgets/image_view.dart';

class OrdersInfoCard extends StatelessWidget {
  const OrdersInfoCard({
    super.key,
    required this.title,
    this.image,
    required this.description,
    required this.orders,
    this.padding,
    this.onTap,
  });

  final String? title;
  final String? image;
  final String? description;
  final num? orders;

  final EdgeInsets? padding;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CupertinoButton(
        padding: padding ?? const EdgeInsets.only(left: 12, right: 12, bottom: 12),
        onPressed: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerRight,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (image != null)
                  ImageView(
                    height: 30,
                    width: 30,
                    borderRadiusValue: 40,
                    fit: BoxFit.contain,
                    assetImage: "$image",
                    onTap: null,
                    color: primaryColor,
                    margin: EdgeInsets.zero,
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$title",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontStyle: GoogleFonts.mulish().fontStyle,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "$description",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Divider(color: Colors.grey.shade400, height: 1),
                      ),
                    ],
                  ),
                )
              ],
            ),
            if (orders != null)
              CircleAvatar(
                radius: 18,
                backgroundColor: primaryColor,
                child: Text(
                  "$orders",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
