import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import '../../../core/config/app_assets.dart';
class SocialLinks extends StatefulWidget {
  const SocialLinks({super.key});

  @override
  State<SocialLinks> createState() => _SocialLinksState();
}

class _SocialLinksState extends State<SocialLinks> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        ImageView(
          height: size.height * 0.026,
          assetImage: AppAssets.fb,

        ),
        ImageView(
          height: size.height * 0.026,
          assetImage: AppAssets.tw,

        ),
        ImageView(
          height: size.height * 0.026,
          assetImage: AppAssets.insta,

        ),
        ImageView(
          height: size.height * 0.026,
          assetImage: AppAssets.link,

        ),
      ],
    );
  }
}
