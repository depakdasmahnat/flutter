import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/colors.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:mrwebbeast/utils/widgets/gradient_text.dart';

import '../core/route/route_paths.dart';
import '../utils/widgets/custom_button.dart';
import '../utils/widgets/image_view.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<WelcomeScreen> {
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  AppAssets.welcomeScreen,
                ),
                fit: BoxFit.cover,
              ),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.shade300,
              //     offset: const Offset(0, 10),
              //     blurRadius: 22,
              //     spreadRadius: 100,
              //   ),
              // ],
            ),
          ),
          Positioned(
            top: height * 0.1,
            child: const Padding(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageView(
                    height: 120,
                    // width: 280,
                    assetImage: AppAssets.logoTextIcon,
                    fit: BoxFit.fitHeight,
                    margin: EdgeInsets.only(top: 6),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 4, top: 4),
                  //   child: Text(
                  //     "Self drive the future",
                  //     style: TextStyle(
                  //       color: Colors.grey.shade500,
                  //       fontSize: 20,
                  //       fontFamily: GoogleFonts.raleway().fontFamily,
                  //     ),
                  //   ),
                  // ),
                  // const Padding(
                  //   padding: EdgeInsets.only(top: 6, right: 16),
                  //   child: Text(
                  //     "Your favourite Cars delivered fast \nat your home.",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w300,
                  //     ),
                  //     textAlign: TextAlign.start,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  GradientText(
                    'GLOBEL TEAM PINNACLE',
                    gradient: primaryGradient,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GradientButton(
                    height: 70,
                    borderRadius: 18,
                    backgroundGradient: primaryGradient,
                    backgroundColor: Colors.transparent,
                    boxShadow: const [],
                    margin: const EdgeInsets.only(bottom: 18, top: 24),
                    onTap: () {
                      // Navigator.pushNamed(context, Routs.signInRoute);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login as a Guest',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: GoogleFonts.urbanist().fontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    text: 'Login as a Member',
                    borderColor: primaryColor,
                    backgroundColor: Colors.transparent,
                    textColor: primaryColor,
                    boxShadow: const [],
                    mainAxisAlignment: MainAxisAlignment.center,
                    margin: const EdgeInsets.only(bottom: 16),
                    onPressed: () {
                      context.pushNamed(Routs.login);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
