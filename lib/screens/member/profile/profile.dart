import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';

import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../guest/guestProfile/guest_faq.dart';

class MemberProfile extends StatefulWidget {
  const MemberProfile({super.key});

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.04,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white.withOpacity(0.6000000238418579)),
                    child: Padding(
                      padding: const EdgeInsets.all(9),
                      child: Icon(
                        AntDesign.left,
                        color: Colors.black,
                        size: size.height * 0.034,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            CircleAvatar(
              backgroundImage: const AssetImage(AppAssets.memberprofile),
              maxRadius: size.height * 0.08,
            ),
            CustomeText(
              text: 'Ayaan Sha',
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            CustomeText(
              text: '+91 62656 84212',
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            CustomeText(
              text: 'Civil lines, Raipur, C.G.',
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: CustomeText(
                text: 'Watched Demo Video',
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(kPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomeText(
                        text: '03',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomeText(
                        text: 'Watch Videos',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.09,
                    child: const VerticalDivider(
                      thickness: 0.5,
                      color: Color(0xFF4D4D4D),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomeText(
                        text: '06',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomeText(
                        text: 'Pending Videos',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.09,
                    child: const VerticalDivider(
                      thickness: 0.5,
                      color: Color(0xFF4D4D4D),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomeText(
                        text: '09',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomeText(
                        text: 'Watch Count',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: CustomeText(
                text: 'Watched Video',
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: size.height * 0.44,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                padding: EdgeInsets.only(bottom: size.height * 0.1),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * 0.08,
                              width: size.height * 0.08,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  AppAssets.product1,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            Expanded(
                              child: CustomeText(
                                text:
                                    'New nontoxic powder uses sunlight to quickly disinfect contaminated dr...',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            CircleAvatar(
                              maxRadius: size.height * 0.03,
                              backgroundColor: Colors.transparent,
                              backgroundImage: AssetImage(AppAssets.playIcon),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 8),
            child: GradientButton(
              height: 70,
              borderRadius: 18,
              backgroundGradient: primaryGradient,
              backgroundColor: Colors.transparent,
              boxShadow: const [],
              margin: const EdgeInsets.only(left: 16, right: 24),
              onTap: () {
                context.pushNamed(Routs.callender);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Call for Demo',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: GoogleFonts.urbanist().fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1B1B1B), Color(0xFF282828)],
                        ),
                        shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        AppAssets.call,
                        height: size.height * 0.02,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
