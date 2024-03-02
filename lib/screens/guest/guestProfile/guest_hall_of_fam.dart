import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';

import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/social_links.dart';
import '../guest_check_demo/guest_check_demo_step2.dart';

class HallOfFam extends StatefulWidget {
  const HallOfFam({super.key});

  @override
  State<HallOfFam> createState() => _HallOfFamState();
}

class _HallOfFamState extends State<HallOfFam> {
  Color? inactiveColor =const Color(0xFF1C1C1C);
  Color? inactiveTextColor =const Color(0xFF8C8C8C);
  Color? inactiveVideoColor =const Color(0xFFCBCBCB);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.06),
          child: CustomAppBar(
            showLeadICon: true,
            title: 'Hall of fame',
          )),
      body: Padding(
        padding: const EdgeInsets.only(left: kPadding,right: kPadding,top: kPadding),
        child: ListView(
          shrinkWrap: true,
          children:  [
            CustomeText(
              text: 'Meet our leader',
              fontWeight: FontWeight.w600,
              fontSize: 22,

            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: kPadding,bottom: kPadding),
              itemBuilder: (context, index) {
              return      Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: inactiveColor,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const ImageView(
                              assetImage: AppAssets.userImage,
                              borderRadiusValue: 60,
                              // height: 70,
                              // width: 70,
                              isAvatar: true,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomeText(
                                    text: 'Macauley Herring',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  CustomText1(
                                    text: '“Dance is the hidden language of the soul. Reference  hidden the soul.”',
                                    fontSize: 14,
                                    color: inactiveTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0,right: 8),
                          child: CustomText1(
                            text: 'Dance is the hidden language of the soul. Reference site about Lorem Ipsum, giving information on its origins, a random generator. Dance is the hidden language of the soul.',
                            fontSize: 14,
                            color: inactiveTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0,right: 8,top: 8),
                          child: CustomText1(
                            text: 'Video link',
                            fontSize: 14,
                            color: inactiveVideoColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 8),
                          child: CustomeText(
                            text: 'https://www.youtube.com/watch?v=M9MSjQjYM',
                            fontSize: 16,
                            color: inactiveTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SocialLinks()
                      ],
                    ),
                  ),
                ),
              );
            },)

          ],
        ),
      ),
    );
  }
}
