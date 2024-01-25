import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/screens/member/archievers/archievers_table.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:mrwebbeast/utils/widgets/custom_text_field.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../utils/widgets/image_view.dart';

class Achievers extends StatefulWidget {
  const Achievers({super.key});

  @override
  State<Achievers> createState() => _AchieversState();
}

class _AchieversState extends State<Achievers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: primaryGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                )),
            child: Column(
              children: [
                AppBar(
                  leading:  CustomBackButton(),
                  title: const Text(
                    'Achievers',
                    style: TextStyle(color: Colors.black),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                const ImageView(
                  assetImage: AppAssets.congratulationsBanner,
                  margin: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
                )
              ],
            ),
          ),
          Row(
            children: [
              const Flexible(
                child: CustomTextField(
                  hintText: 'Search',
                  readOnly: true,
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: ImageView(
                    height: 20,
                    width: 20,
                    borderRadiusValue: 0,
                    color: Colors.white,
                    margin: EdgeInsets.only(left: kPadding, right: kPadding),
                    fit: BoxFit.contain,
                    assetImage: AppAssets.searchIcon,
                  ),
                  margin: EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding, bottom: kPadding),
                ),
              ),
              GradientButton(
                height: 60,
                width: 60,
                margin: const EdgeInsets.only(left: 8, right: kPadding),
                backgroundGradient: blackGradient,
                child: const ImageView(
                  height: 28,
                  width: 28,
                  assetImage: AppAssets.filterIcons,
                  margin: EdgeInsets.zero,
                ),
              )
            ],
          ),
          const Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            child: AchieversTable(),
          )),
        ],
      ),
    );
  }
}
