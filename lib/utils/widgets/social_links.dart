import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';
import '../../../core/config/app_assets.dart';
import '../../controllers/member/member_controller/member_controller.dart';

class SocialLinks extends StatefulWidget {
  final void Function()? fbOnTab;
  final void Function()? instaOnTab;
  const SocialLinks({super.key, this.fbOnTab, this.instaOnTab});

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
          onTap: widget.fbOnTab,
          height: size.height * 0.03,
          assetImage: AppAssets.fb,
        ),
        // ImageView(
        //   height: size.height * 0.026,
        //   assetImage: AppAssets.tw,
        //
        //     await context.read<MembersController>().socialLink(
        // link: 'https://www.facebook.com/teampinnacleaquaofficial?mibextid=kFxxJD'
        // );
        // ),
        ImageView(
          onTap: widget.fbOnTab,
          height: size.height * 0.03,
          assetImage: AppAssets.insta,
        ),
        // ImageView(
        //   height: size.height * 0.026,
        //   assetImage: AppAssets.link,
        //
        // ),
      ],
    );
  }
}
