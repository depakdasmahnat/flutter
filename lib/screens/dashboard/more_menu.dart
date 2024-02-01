import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';

import '../../core/route/route_paths.dart';
import '../member/lead/model_dailog_box.dart';

class DashboardMoreMenu extends StatefulWidget {
  bool? showLeadItem;
   DashboardMoreMenu({super.key,this.showLeadItem});

  @override
  State<DashboardMoreMenu> createState() => _DashboardMoreMenuState();
}

class _DashboardMoreMenuState extends State<DashboardMoreMenu> {
  Future<void> _showDialog(
      BuildContext context,) async {
    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return  const ModelDialogBox1(
        ) ;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Padding(
        padding: const EdgeInsets.only(bottom: kPadding),
        child:widget.showLeadItem==true?
        Column(
          children: [
            MenuButton(
              width: 270,
              title: 'Add List',
              image: AppAssets.addPersonIcon,
              onTap: () {
                context.pushNamed(Routs.memberaddList);
              },
            ),
            MenuButton(
              width: 270,
                title: 'Contact',
                image: AppAssets.leadContact,
                onTap: () {
                  context.pushNamed(Routs.createGoal);
                },
              ),
              MenuButton(
                width: 270,
                title: 'Share referral',
                image: AppAssets.leadShare,
                onTap: () async{
                await  _showDialog(
                  context
                );

                  // context.pushNamed(Routs.createGoal);
                },
              ),
          ],
        )  :
        Column(
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
              onTap: () {
                context.pushNamed(Routs.createEvent);
              },
            ),
            MenuButton(
              title: 'Create Demo',
              image: AppAssets.videoIcons,
              onTap: () {
                context.pushNamed(Routs.createDemo);
              },
            ),
            MenuButton(
              title: 'Create Target',
              image: AppAssets.targetIcon,
              onTap: () {
                context.pushNamed(Routs.createTarget);
              },
            ),

          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton(
      {super.key, this.title, this.image, this.gradient, this.onTap,this.width});

  final String? title;
  final double? width;
  final String? image;
  final Gradient? gradient;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      height: 60,
      width: width ,
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
