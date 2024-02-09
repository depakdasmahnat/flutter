import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../utils/widgets/image_view.dart';

class EarningCard extends StatelessWidget {
  const EarningCard({
    super.key,
    required this.title,
    required this.value,
    required this.image,
    this.onTap,
  });

  final String? title;
  final String? value;

  final String? image;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    double borderRadius = 18;
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          width: size.width * 0.35,
          margin: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: defaultBoxShadow(),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: primaryColor,
                    child: ImageView(
                      height: 24,
                      width: 24,
                      fit: BoxFit.contain,
                      assetImage: "$image",
                      color: Colors.white,
                      onTap: () {},
                      margin: EdgeInsets.zero,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: FittedBox(
                      child: Text(
                        "\$$value",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "$title",
                style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
