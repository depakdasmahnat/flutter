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

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, this.enagicId});

  final String? enagicId;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  void initState() {
    super.initState();
  }

  late TextEditingController enagicIdCtrl = TextEditingController(text: widget.enagicId);
  TextEditingController contactCtrl = TextEditingController();
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
                  'Reset Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
                GradientText(
                  'Please enter your mobile no. or email to request a password reset',
                  gradient: primaryGradient,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                CustomTextField(
                  controller: enagicIdCtrl,
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    return Validator.alphanumericValidator(val, 'Enagic ID');
                  },
                  hintText: 'Enagic ID',
                  margin: const EdgeInsets.only(top: 18, bottom: 18),
                ),
                CustomTextField(
                  controller: contactCtrl,
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    if ((val?.length ?? 0) > 4) {
                      if (int.tryParse('$val') != null) {
                        return Validator.phoneNumberValidator(val, 10);
                      } else {
                        return Validator.emailValidator(val);
                      }
                    }
                    return null;
                  },
                  hintText: 'Enter mobile no. or email.',
                  autofillHints: const [AutofillHints.password],
                  margin: EdgeInsets.zero,
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
                      context.read<MemberAuthControllers>().forgotPassword(
                            context: context,
                            enagicId: enagicIdCtrl.text,
                            contact: contactCtrl.text,
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
