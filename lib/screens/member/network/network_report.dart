import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/screens/member/archievers/archievers_table.dart';
import 'package:mrwebbeast/screens/member/network/pinnacle_list_table.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:mrwebbeast/utils/widgets/custom_text_field.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../utils/widgets/image_view.dart';

class NetworkReport extends StatefulWidget {
  const NetworkReport({super.key});

  @override
  State<NetworkReport> createState() => _NetworkReportState();
}

class _NetworkReportState extends State<NetworkReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: const Text(
          'Report',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
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
            child: NetworkPinnacleTable(),
          )),
        ],
      ),
    );
  }
}
