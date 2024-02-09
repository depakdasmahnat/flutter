import 'package:flutter/material.dart';
import 'package:gaas/controllers/auth/auth_controller.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/extensions/normal/build_context_extension.dart';
import 'package:gaas/core/services/database/local_database.dart';
import 'package:gaas/route/route_paths.dart';
import 'package:gaas/screens/auth/phone_signin.dart';
import 'package:gaas/screens/dashboard/dashboard.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_config.dart';
import '../../core/constant/colors.dart';
import '../../intro_screen.dart';
import '../../utils/widgets/custom_button.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  TextEditingController mobileNumber = TextEditingController();
  int mobileNumberLength = 10;
  final signInFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppConfig.generateDeviceToken();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntroScreen(),
        ],
      ),
      bottomSheet: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.56,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryColor, width: 0.7),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Form(
          key: signInFormKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Text(
                      "Get Started with ${AppConfig.apkName}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  CustomButton(
                    height: 50,
                    onPressed: () {
                      context.push(Routs.emailSignIn);
                    },
                    text: "Continue with Email",
                    fontSize: 15,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  CustomButton(
                    height: 48,
                    splashEffect: true,
                    onPressed: () {
                      context.read<AuthControllers>().signInWithGoogle(context: context);
                    },
                    imagePath: AppImages.google,
                    text: "Continue with Google",
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    fontSize: 15,
                    margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                  ),
                  CustomButton(
                    height: 48,
                    splashEffect: true,
                    onPressed: () {
                      context.read<AuthControllers>().signInWithApple(context: context);
                    },
                    imagePath: AppImages.apple,
                    imageColor: Colors.grey.shade900,
                    text: "Continue with Apple",
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    fontSize: 15,
                    margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                  ),
                  CustomButton(
                    height: 48,
                    splashEffect: true,
                    onPressed: () {
                      context.pushNamed(Routs.phoneSignIn);
                    },
                    imagePath: AppImages.phoneIcon,
                    imageColor: Colors.grey.shade900,
                    text: "Continue with Phone",
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    fontSize: 15,
                    margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                  ),
                  CustomButton(
                    height: 48,
                    splashEffect: true,
                    onPressed: () {
                      context.pushNamed(Routs.phoneSignIn, extra: const PhoneSignIn(joinAsPartner: "Yes"));
                    },
                    imageColor: Colors.grey.shade900,
                    text: "Continue as Partner",
                    backgroundColor: Colors.white,
                    borderColor: Colors.white,
                    textColor: Colors.black,
                    fontSize: 15,
                    mainAxisAlignment: MainAxisAlignment.center,
                    margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 8),
                    child: CustomButton(
                      height: 50,
                      onPressed: () {
                        context.firstRoute();
                        context.pushReplacement(Routs.dashboard, extra: const DashBoard(dashBoardIndex: 0));
                        LocalDatabase().setIsSkipped(true);
                      },
                      text: "Continue as Guest",
                      fontSize: 15,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
