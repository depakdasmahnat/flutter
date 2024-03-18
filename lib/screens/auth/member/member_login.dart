import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../../../utils/validators.dart';
import '../../../../utils/widgets/custom_text_field.dart';
import '../../../controllers/member/member_auth_controller.dart';
import '../../../core/constant/gradients.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/gradient_text.dart';

class MemberSignIn extends StatefulWidget {
  const MemberSignIn({super.key});

  @override
  State<MemberSignIn> createState() => _MemberSignInState();
}

class _MemberSignInState extends State<MemberSignIn> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController enagicIdCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.black,
      child: Stack(
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
                    'GLOBAL TEAM PINNACLE',
                    gradient: primaryGradient,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  CustomTextField(
                    controller: enagicIdCtrl,
                    textCapitalization: TextCapitalization.characters,
                    keyboardType: TextInputType.text,
                    // : TextCapitalization.sentences,
                    validator: (val) {
                      return Validator.alphanumericValidator(val, 'Id no');
                    },

                    hintText: 'ID No.',
                    margin: const EdgeInsets.only(top: 18, bottom: 18),
                  ),
                  CustomTextField(
                    controller: passwordCtrl,
                    obscureText: obscurePassword,
                    keyboardType: TextInputType.text,
                    hintText: 'Password',
                    autofillHints: const [AutofillHints.password],
                    validator: (val) {
                      return Validator.requiredValidator(val, 'Password');
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        obscurePassword = !obscurePassword;
                        setState(() {});
                      },
                      icon: Icon(
                        obscurePassword == true ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    margin: EdgeInsets.zero,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.pushNamed(Routs.resetPassword);
                        },
                        child: const Text('Forgot password?'),
                      ),
                    ],
                  )
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
                      context.read<MemberAuthControllers>().memberLogin(
                            context: context,
                            enagicId: enagicIdCtrl.text,
                            password: passwordCtrl.text,
                          );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login',
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
