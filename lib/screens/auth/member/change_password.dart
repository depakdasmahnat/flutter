import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:provider/provider.dart';

import '../../../../utils/validators.dart';
import '../../../../utils/widgets/custom_text_field.dart';
import '../../../controllers/member/member_auth_controller.dart';
import '../../../core/constant/gradients.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/gradient_text.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key, this.enagicId});

  final String? enagicId;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  void initState() {
    super.initState();
  }

  late TextEditingController enagicIdCtrl = TextEditingController(text: widget.enagicId);
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController confirmPasswordCtrl = TextEditingController();
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  bool obscurePassword = true;

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
                  'Set new password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GradientText(
                    'Thank you for your verification! Please\nset a new password.',
                    gradient: primaryGradient,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                CustomTextField(
                  controller: passwordCtrl,
                  keyboardType: TextInputType.text,
                  hintText: 'New Password',
                  autofillHints: const [AutofillHints.password],
                  validator: (val) {
                    return Validator.strongPasswordValidator(val, 'New Password');
                  },
                  margin: const EdgeInsets.only(top: 18,bottom: 18,),
                ),
                CustomTextField(
                  controller: confirmPasswordCtrl,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  hintText: 'Confirm Password',
                  autofillHints: const [AutofillHints.password],
                  validator: (val) {
                    return Validator.confirmPasswordValidator(passwordCtrl.text, val, 'Confirm Password');
                  },
                  margin: const EdgeInsets.only(bottom: 18),
                ),
                GradientButton(
                  height: 60,
                  borderRadius: 18,
                  backgroundGradient: primaryGradient,
                  blur: 20,
                  backgroundColor: Colors.transparent,
                  boxShadow: const [],
                  margin: const EdgeInsets.only(bottom: 24, top: 36),
                  onTap: () {
                    if (signInFormKey.currentState?.validate() == true) {
                      context.read<MemberAuthControllers>().changePassword(
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
