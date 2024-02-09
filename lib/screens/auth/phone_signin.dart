import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../core/constant/colors.dart';
import '../../core/constant/formatters.dart';
import '../../utils/validators.dart';
import '../../utils/widgets/custom_button.dart';
import '../../utils/widgets/custom_text_field.dart';

class PhoneSignIn extends StatefulWidget {
  const PhoneSignIn({Key? key, this.joinAsPartner, this.forgetPasswordMode}) : super(key: key);
  final String? joinAsPartner;
  final bool? forgetPasswordMode;

  @override
  State<PhoneSignIn> createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> {
  late bool? forgetPasswordMode = widget.forgetPasswordMode;
  late String? joinAsPartner = widget.joinAsPartner;
  String countryCode = "+1";
  TextEditingController phoneCtrl = TextEditingController();

  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    phoneCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Continue with Phone"),
      ),
      body: SafeArea(
        child: SizedBox(
          height: size.height * 0.54,
          width: size.width,
          child: Image.asset(AppImages.emailScreen),
        ),
      ),
      bottomSheet: Container(
        constraints: BoxConstraints(minWidth: size.width),
        padding: const EdgeInsets.only(top: 36, bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryColor, width: 0.7),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Form(
          key: signInFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Text(
                      forgetPasswordMode == true
                          ? "Continue to Reset Password"
                          : "Continue with Phone Number",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  CustomTextField(
                    controller: phoneCtrl,
                    autofocus: true,
                    labelText: "Phone Number",
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.call),
                    // prefixIcon: Padding(
                    //   padding: const EdgeInsets.only(left: 12, right: 4),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       const Icon(Icons.call),
                    //       const SizedBox(width: 5),
                    //       Text(
                    //         countryCode,
                    //         style: TextStyle(
                    //           fontSize: 18,
                    //           color: Colors.grey.shade700,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    inputFormatters: [
                      PhoneNumberFormatter(),
                      LengthLimitingTextInputFormatter(14),
                    ],
                    validator: (val) {
                      return Validator.validateUSAPhoneNumber(val);
                    },
                    onChanged: (val) {
                      if (val.length == 14) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                    hintText: "Enter Phone Number",
                    margin: const EdgeInsets.only(left: 24, right: 24, bottom: 14),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 8),
                    child: CustomButton(
                      height: 50,
                      onPressed: () {
                        signIn();
                      },
                      splashEffect: true,
                      text: "Sign In",
                      fontSize: 15,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                ],
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       "By continuing, you agree to ",
              //       style: TextStyle(
              //         color: Colors.grey.shade500,
              //         fontSize: 13,
              //         fontWeight: FontWeight.w400,
              //       ),
              //       textAlign: TextAlign.center,
              //     ),
              //     const SizedBox(width: 4),
              //     Text(
              //       "Terms & Conditions",
              //       style: TextStyle(
              //         color: Colors.grey.shade500,
              //         fontSize: 13,
              //         decoration: TextDecoration.underline,
              //         fontWeight: FontWeight.w600,
              //       ),
              //       textAlign: TextAlign.center,
              //     )
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  signIn() {
    if (signInFormKey.currentState!.validate()) {
      context.read<AuthControllers>().sendOtp(
            context: context,
            mobile: phoneCtrl.text,
            countryCode: countryCode,
            joinAsPartner: joinAsPartner,
            forgetPasswordMode: forgetPasswordMode,
          );
    }
  }
}
