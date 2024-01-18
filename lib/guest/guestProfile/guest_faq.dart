import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../core/route/route_paths.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';

class GuestFaq extends StatefulWidget {
  const GuestFaq({super.key});

  @override
  State<GuestFaq> createState() => _GuestFaqState();
}

class _GuestFaqState extends State<GuestFaq> {
  List item = [
    {
      'image': AppAssets.rocket,
      'first': 'Questions about',
      'second': 'Getting Started',
      'gradiant': primaryGradient,
      'color': const Color(0xFFE1FF41),
    },
    {
      'image': AppAssets.aboutQ,
      'first': 'Questions about',
      'second': 'How to Invest',
      'gradiant': null,
      'color': const Color(0xFFE1FF41),
    },
    {
      'image': AppAssets.rupees,
      'first': 'Questions about',
      'second': 'Payment Meth…',
      'gradiant': null,
      'color': Colors.white,
    }
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.24),
          child: CustomAppBar(
            showLeadICon: true,
            title: 'FAQ',
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(size.height * 0.06),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'How can we help you?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  CustomTextField(
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
                ],
              ),
            ),
          )),
      body: ListView(
        children: [
          SizedBox(
            height: size.height * 0.16,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: item.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Container(
                    decoration: ShapeDecoration(
                      gradient: index == 0
                          ? primaryGradient
                          : index == 1
                              ? const LinearGradient(colors: [Color(0xFFE1FF41), Color(0xFFE1FF41)])
                              : const LinearGradient(colors: [
                                  Colors.white,
                                  Colors.white,
                                ]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: kPadding, top: kPadding, bottom: kPadding, right: kPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            item[index]['image'],
                            height: size.height * 0.04,
                          ),
                          Text(
                            item[index]['first'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              height: 3,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            item[index]['second'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(kPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomeText(
                  text: 'Top Questions',
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                CustomeText(
                  text: 'View All',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Container(
              decoration: BoxDecoration(gradient: primaryGradient, borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(kPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomeText(
                          text: 'How to create a account?',
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        CustomeText(
                          text: '-',
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: kPadding, bottom: kPadding),
                      child: CustomeText(
                        text:
                            'Open the Tradebase app to get started and follow the steps. Tradebase doesn’t charge a fee to create or maintain your Tradebase account.',
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                child: Container(
                  decoration: ShapeDecoration(
                    color: const Color(0xFF1B1B1B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(kPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomeText(
                            text: 'How to add a payment method by this app?',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              context.push(Routs.selectLead);
                            },
                            child: const Icon(Icons.add))
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class CustomeText extends StatelessWidget {
  String? text;
  Color? color;
  double? fontSize;
  double? textHeight;
  TextAlign? textAlign;
  FontWeight? fontWeight;

  CustomeText({
    this.color,
    this.text,
    this.fontWeight,
    this.fontSize,
    this.textHeight,
    this.textAlign,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Text(
      text ?? '',
      style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight, height: textHeight),
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}
