import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';

import '../../../core/config/app_assets.dart';
import '../../../utils/widgets/custom_back_button.dart';

class GusetProductDetails extends StatefulWidget {
  const GusetProductDetails({super.key});

  @override
  State<GusetProductDetails> createState() => _GusetProductDetailsState();
}

class _GusetProductDetailsState extends State<GusetProductDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: size.height * 0.39,
            width: size.width,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppAssets.geustProductDteila),
                    fit: BoxFit.contain),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(17),
                    bottomRight: Radius.circular(17))),
            child: Padding(
              padding: EdgeInsets.only(left: kPadding, top: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomBackButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(left: kPadding, right: kPadding),
              child: Text(
                'Reverse Osmosis PVC Kangen Water Machine Price, Water Storage Capacity: 4000 L',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: EdgeInsets.only(left: kPadding, right: kPadding),
            child: DetailList(
              leftTitle: 'Brand Kangen',
              rightTitle: 'Water Machine Price',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: kPadding, right: kPadding),
            child: DetailList(
              leftTitle: 'Usage/Application',
              rightTitle: 'Kangen Water Machine Price ',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: kPadding, right: kPadding),
            child: DetailList(
              leftTitle: 'Water Storage Capacity',
              rightTitle: '4000 L',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: kPadding, right: kPadding),
            child: DetailList(
              leftTitle: 'Purification Capacity',
              rightTitle: 'Kangen Water Machine Price',
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          const Padding(
            padding: EdgeInsets.only(left: kPadding),
            child: Text(
              'Product Description',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: kPadding, top: 10),
            child: Text(
              'CERTIFICATIONS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: kPadding, top: 5, right: kPadding),
            child: Text(
              'Enagic International is certified to ISO 9001, ISO 14001, and ISO 13485 for quality control and environmental management, the Water Quality Association Gold Seal for product certification, and a member in good standing of the prestigious Direct Selling Association.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailList extends StatelessWidget {
  String? leftTitle;
  String? rightTitle;

  DetailList({
    this.leftTitle,
    this.rightTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leftTitle ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              rightTitle ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const Divider(
          thickness: 1,
          color: Color(0xFF1C1C1C),
        ),
      ],
    );
  }
}
