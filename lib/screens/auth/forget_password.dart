import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../core/constant/colors.dart';
import '../../utils/validators.dart';
import '../../utils/widgets/custom_button.dart';
import '../../utils/widgets/custom_text_field.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key, this.email}) : super(key: key);
  final String? email;

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late TextEditingController emailCtrl = TextEditingController(text: widget.email ?? "");
  TextEditingController passwordCtrl = TextEditingController();
  GlobalKey<FormState> forgetPasswordKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailCtrl.dispose();
  }

  int limit = 6;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.55,
              width: size.width,
              child: Image.asset(AppImages.otpScreen),
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
          key: forgetPasswordKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Text(
                      "Forget Password",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                    child: Row(
                      children: [
                        Text(
                          "Enter your new password to reset.",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  CustomTextField(
                    controller: passwordCtrl,
                    autofocus: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: (val) {
                      return Validator.validateRegexPassword(val);
                    },
                    labelText: "Password",
                    hintText: "Password",
                    autofillHints: const [AutofillHints.password],
                    obscureText: hidePassword,
                    obscuringCharacter: "*",
                    suffixIcon: IconButton(
                      iconSize: 22,
                      onPressed: () {
                        hidePassword = !hidePassword;
                        setState(() {});
                      },
                      icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                  ),
                  // CustomTextField(
                  //   controller: emailCtrl,
                  //   autofocus: true,
                  //   keyboardType: TextInputType.emailAddress,
                  //   prefixIcon: const Icon(Icons.email, color: primaryColor),
                  //   validator: (val) {
                  //     return Validator.emailValidator(val);
                  //   },
                  //   labelText: "Email",
                  //   hintText: "Enter Email",
                  //   onChanged: (val) {
                  //     setState(() {});
                  //   },
                  //   margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                  // ),
                  const Padding(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // CupertinoButton(
                        //   padding: EdgeInsets.zero,
                        //   child: const Text(
                        //     "Forget Password",
                        //     style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                        //   ),
                        //   onPressed: () {},
                        // ),
                        // CupertinoButton(
                        //   padding: EdgeInsets.zero,
                        //   child: const Text(
                        //     "Help ?",
                        //     style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w500),
                        //   ),
                        //   onPressed: () {},
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 8),
                    child: CustomButton(
                      height: 50,
                      onPressed: () {
                        forgetPassword();
                      },
                      splashEffect: true,
                      text: "Reset",
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

  forgetPassword() {
    if (forgetPasswordKey.currentState?.validate() == true) {
      FocusScope.of(context).unfocus();
      context.read<AuthControllers>().forgetPassword(
            context: context,
            password: passwordCtrl.text,
          );
    }
  }
}
