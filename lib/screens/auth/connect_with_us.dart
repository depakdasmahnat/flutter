import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_string_extension.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller/auth_controller.dart';
import '../../core/config/app_assets.dart';
import '../../core/constant/gradients.dart';
import '../../core/services/database/local_database.dart';
import '../../models/auth_model/guest_data.dart';
import '../../utils/widgets/gradient_button.dart';
import '../../utils/widgets/gradient_text.dart';

class ConnectWithUs extends StatefulWidget {
  const ConnectWithUs({super.key});

  @override
  State<ConnectWithUs> createState() => _ConnectWithUsState();
}

class _ConnectWithUsState extends State<ConnectWithUs> {
  @override
  void initState() {
    super.initState();
  }

  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  navigateToDashboard() {
    return context.pushReplacementNamed(Routs.gtpVideo);
  }

  @override
  Widget build(BuildContext context) {
    GuestData? guest = context.read<LocalDatabase>().guest;
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
              navigateToDashboard();
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
              bottom: size.height*0.14,

              child: Container(
                height: size.height * 0.48,
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
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            'Hello, ${guest?.firstName?.toCapitalizeFirst} !',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            "Let's dive in and explore together!",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GradientText(
                          '#ConnectWithUs',
                          gradient: primaryGradient,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontFamily: GoogleFonts.urbanist().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
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
                        backgroundGradient: primaryGradient,
                        backgroundColor: Colors.transparent,
                        boxShadow: const [],
                        margin: const EdgeInsets.only(bottom: 6, top: 6),
                        onTap: () async {
                          await context.read<AuthControllers>().connectWithUs(context: context, guestId:guest?.id.toString() );

                          setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'I am excited',
                              style: TextStyle(
                                color: Colors.black,
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
