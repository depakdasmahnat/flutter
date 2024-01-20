import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';

class DashboardMoreMenu extends StatefulWidget {
  const DashboardMoreMenu({super.key});

  @override
  State<DashboardMoreMenu> createState() => _DashboardMoreMenuState();
}

class _DashboardMoreMenuState extends State<DashboardMoreMenu> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Padding(
        padding: const EdgeInsets.only(bottom: kPadding),
        child: Column(
          children: [
            MenuButton(
              title: 'Add List',
              image: AppAssets.addPersonIcon,
              onTap: () {},
            ),
            MenuButton(
              title: 'Add Members',
              image: AppAssets.membersIcon,
              onTap: () {},
            ),
            MenuButton(
              title: 'Create Events',
              image: AppAssets.eventIcon,
              onTap: () {},
            ),
            MenuButton(
              title: 'Create Demo',
              image: AppAssets.videoIcons,
              onTap: () {},
            ),
            MenuButton(
              title: 'Create Target',
              image: AppAssets.targetIcon,
              onTap: () {},
            ),
            MenuButton(
              title: 'Create New Goal',
              image: AppAssets.goalIcon,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key, this.title, this.image, this.gradient, this.onTap});

  final String? title;
  final String? image;
  final Gradient? gradient;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      height: 60,
      backgroundGradient: gradient ?? whiteGradient,
      border: Border.all(color: Colors.grey.shade300),
      padding: const EdgeInsets.symmetric(horizontal: 36),
      margin: const EdgeInsets.symmetric(horizontal: 36, vertical: 4),
      onTap: onTap,
      child: Row(
        children: [
          ImageView(
            height: 30,
            width: 30,
            borderRadiusValue: 0,
            fit: BoxFit.contain,
            color: Colors.black,
            assetImage: image,
            margin: const EdgeInsets.only(right: 24),
          ),
          Text(
            '$title',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
