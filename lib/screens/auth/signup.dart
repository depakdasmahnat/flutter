import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../core/config/app_config.dart';
import '../../core/constant/colors.dart';
import '../../core/constant/formatters.dart';
import '../../core/constant/gradients.dart';
import '../../utils/validators.dart';
import '../../utils/widgets/custom_button.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../utils/widgets/gradient_icon.dart';
import '../../utils/widgets/widgets.dart';

class SignUp extends StatefulWidget {
  const SignUp(
      {Key? key,
      required this.mobile,
      required this.countryCode,
      required this.email,
      this.name,
      this.profilePic,
      this.isVerified})
      : super(key: key);

  final String? profilePic;
  final String? name;
  final bool? isVerified;
  final String? email;
  final String? mobile;
  final String? countryCode;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String? profilePic = widget.profilePic;
  late bool? isVerified = widget.isVerified;
  late String? name = widget.name;
  late String? mobile = widget.mobile;
  late String? countryCode = widget.countryCode ?? AppConfig.countryCode;
  late String? email = widget.email;

  late TextEditingController nameCtrl = TextEditingController(text: name ?? "");
  late TextEditingController emailCtrl = TextEditingController(text: email ?? "");
  late TextEditingController mobileCtrl = TextEditingController(text: mobile ?? "");
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController referralCtrl = TextEditingController();

  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool acceptedTerms = true;

  @override
  void dispose() {
    super.dispose();
    nameCtrl.dispose();
    emailCtrl.dispose();
    mobileCtrl.dispose();
    passwordCtrl.dispose();
    referralCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.55,
              width: size.width,
              child: Image.asset(AppImages.signUpScreen),
            ),
          ],
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
          key: signUpFormKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                CustomTextField(
                  controller: nameCtrl,
                  autofocus: true,
                  prefixIcon: const Icon(Icons.person),
                  validator: (val) {
                    return Validator.nameValidator(val);
                  },
                  labelText: "Name",
                  hintText: "Name",
                  margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                ),
                CustomTextField(
                  controller: emailCtrl,
                  autofocus: true,
                  enabled: email == null,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (val) {
                    return Validator.emailValidator(val);
                  },
                  labelText: "Email",
                  hintText: "Email",
                  margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                ),
                CustomTextField(
                  controller: mobileCtrl,
                  autofocus: true,
                  enabled: mobile == null,
                  labelText: "Mobile Number",
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.call),
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
                  hintText: "Enter Mobile Number",
                  margin: const EdgeInsets.only(left: 24, right: 24, top: 14),
                ),
                // CustomTextField(
                //   controller: passwordCtrl,
                //   autofocus: true,
                //   prefixIcon: const Icon(Icons.lock_outline),
                //   validator: (val) {
                //     return Validator.validateRegexPassword(val);
                //   },
                //   labelText: "Password",
                //   hintText: "Password",
                //   autofillHints: const [AutofillHints.password],
                //   obscureText: hidePassword,
                //   obscuringCharacter: "*",
                //   suffixIcon: IconButton(
                //     iconSize: 22,
                //     onPressed: () {
                //       hidePassword = !hidePassword;
                //       setState(() {});
                //     },
                //     icon: Icon(
                //       hidePassword ? Icons.visibility : Icons.visibility_off,
                //     ),
                //   ),
                //   margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                // ),
                CustomTextField(
                  controller: referralCtrl,
                  autofocus: true,
                  prefixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: primaryColor.withOpacity(0.3),
                        child: const Icon(
                          CupertinoIcons.gift_fill,
                          size: 16,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  labelText: "Referral Code ",
                  hintText: "Referral Code ",
                  margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            acceptedTerms = !acceptedTerms;
                            setState(() {});
                          },
                          child: GradientIcon(
                            icon: acceptedTerms
                                ? CupertinoIcons.checkmark_alt_circle_fill
                                : Icons.circle_outlined,
                            gradient: primaryGradient,
                            size: 18,
                            margin: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      termsAndConditions(context),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 8),
                  child: CustomButton(
                    height: 50,
                    onPressed: () {
                      if (acceptedTerms) {
                        register();
                      } else {
                        disagreeTermsIssue(context);
                      }
                    },
                    splashEffect: true,
                    text: "Sign Up",
                    fontSize: 15,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  register() {
    if (signUpFormKey.currentState?.validate() == true) {
      FocusScope.of(context).unfocus();
      context.read<AuthControllers>().register(
            context: context,
            name: nameCtrl.text,
            email: emailCtrl.text,
            countryCode: countryCode,
            mobile: mobileCtrl.text,
            password: passwordCtrl.text,
            profilePic: profilePic,
            isVerified: isVerified,
            referralCode: referralCtrl.text,
          );
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> disagreeTermsIssue(BuildContext context) {
    return showSnackBar(
        context: context,
        text: "Accept Terms & Conditions to Continue...",
        color: Colors.red,
        icon: Icons.error);
  }
}
