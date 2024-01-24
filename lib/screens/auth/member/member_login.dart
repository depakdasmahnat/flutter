import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/screens/dashboard/dashboard.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import '../../../../utils/validators.dart';
import '../../../../utils/widgets/custom_text_field.dart';
import '../../../core/constant/gradients.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/gradient_text.dart';

class MemberLogin extends StatefulWidget {
  const MemberLogin({super.key});

  @override
  State<MemberLogin> createState() => _MemberLoginState();
}

class _MemberLoginState extends State<MemberLogin> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController idCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Image.asset(AppAssets.authbackgroundimage, fit: BoxFit.fitWidth, width: double.infinity),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(backgroundColor: Colors.transparent),
          body: Form(
            key: signInFormKey,
            child: ListView(
              padding: EdgeInsets.only(left: 24, right: 24, top: size.height * 0.05),
              children: [
                const Text(
                  'Welcome to',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
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
                CustomTextField(
                  controller: idCtrl,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    return Validator.numericValidator(val, 'Id No');
                  },
                  hintText: 'ID No.',
                  margin: const EdgeInsets.only(top: 18, bottom: 18),
                ),
                CustomTextField(
                  controller: passwordCtrl,
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  limit: 10,
                  validator: (val) {
                    return Validator.strongPasswordValidator(val);
                  },
                  hintText: 'Password.',
                  autofillHints: const [AutofillHints.password],
                  suffixIcon: const ImageView(
                    height: 24,
                    width: 24,
                    assetImage: AppAssets.lockIcon,
                    margin: EdgeInsets.only(right: 8),
                  ),
                  margin: const EdgeInsets.only(bottom: 24),
                ),
                TextButton(onPressed: (){}, child: Text(''))
              ],
            ),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientButton(
                height: 60,
                borderRadius: 18,
                backgroundGradient: primaryGradientBlur,
                blur: 20,
                backgroundColor: Colors.transparent,
                boxShadow: const [],
                margin: const EdgeInsets.only(left: 16, right: 24, bottom: 24),
                onTap: () {
                  if (signInFormKey.currentState?.validate() == true) {
                    context.firstRoute();
                    context.pushReplacementNamed(Routs.dashboard);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
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
            ],
          ),
        ),
      ],
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
