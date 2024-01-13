import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/config/app_assets.dart';
import '../../core/constant/gradients.dart';
import '../../core/route/route_paths.dart';
import '../../utils/widgets/gradient_button.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  @override
  void initState() {
    super.initState();
  }

  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  navigateToConnectWithUs() {
    return context.pushNamed(Routs.connectWithUs);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          GradientButton(
            height: 30,
            width: 75,
            blur: 10,
            borderRadius: 20,
            backgroundGradient: inActiveGradient,
            backgroundColor: Colors.transparent,
            boxShadow: const [],
            margin: const EdgeInsets.only(right: 16),
            onTap: () {
              navigateToConnectWithUs();

            },
            child: const Center(
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              height: size.height * 0.6,
              width: size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    AppAssets.moneyBg,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Form(
            key: signInFormKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.05, bottom: 8),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            'Do you want to make money?',
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          'Select your answers',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GradientButton(
                        height: 60,
                        borderRadius: 18,
                        blur: 10,
                        backgroundGradient: inActiveGradientTransparent,
                        backgroundColor: Colors.transparent,
                        boxShadow: const [],
                        margin: const EdgeInsets.only(bottom: 6, top: 6),
                        onTap: () {
                          navigateToConnectWithUs();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Yes',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: GoogleFonts.urbanist().fontFamily,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GradientButton(
                        height: 60,
                        borderRadius: 18,
                        blur: 10,
                        backgroundGradient: inActiveGradientTransparent,
                        backgroundColor: Colors.transparent,
                        boxShadow: const [],
                        margin: const EdgeInsets.only(bottom: 6, top: 6),
                        onTap: () {
                          navigateToConnectWithUs();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: GoogleFonts.urbanist().fontFamily,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding prefixIcon({required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          const SizedBox(
            height: 20,
            child: VerticalDivider(
              width: 1,
              thickness: 1.1,
            ),
          )
        ],
      ),
    );
  }
}
