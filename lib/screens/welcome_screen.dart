import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/config/app_assets.dart';
import '../core/constant/gradients.dart';
import '../core/route/route_paths.dart';
import '../utils/widgets/custome_transparent_Button.dart';
import '../utils/widgets/gradient_button.dart';
import '../utils/widgets/gradient_text.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppAssets.welcomeSplash),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true),
            ),
          ),
          // Center(
          //   child: Padding(
          //     padding: EdgeInsets.only(top: size.height * 0.08),
          //     child: Column(
          //       children: [
          //         Image.asset(
          //           AppAssets.appLogo,
          //           height: size.height * 0.16,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(
              left: 28.0,
              right: 28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                GradientText(
                  'GLOBAL TEAM PINNACLE',
                  gradient: primaryGradient,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                GradientButton(
                  height: 70,
                  borderRadius: 18,
                  backgroundGradient: primaryGradient,
                  backgroundColor: Colors.transparent,
                  boxShadow: const [],
                  // margin:const EdgeInsets.only(left: 16, right: 24, bottom: 24),
                  onTap: () {
                    context.pushNamed(Routs.login);
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
                SizedBox(
                  height: size.height * 0.02,
                ),
                CustomTransparentButton(
                  onTap: () {
                    context.pushNamed(Routs.memberLogin);
                  },
                  title: 'Login as a Member',
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
