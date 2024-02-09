import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/screens/auth/phone_signin.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../core/constant/colors.dart';
import '../../route/route_paths.dart';
import '../../utils/validators.dart';
import '../../utils/widgets/custom_button.dart';
import '../../utils/widgets/custom_text_field.dart';

class EmailSignIn extends StatefulWidget {
  const EmailSignIn({Key? key}) : super(key: key);

  @override
  State<EmailSignIn> createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  GlobalKey<FormState> emailLoginFormKey = GlobalKey<FormState>();

  bool hidePassword = true;

  @override
  void dispose() {
    super.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Continue with Email"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.55,
              width: size.width,
              child: Image.asset(AppImages.emailScreen),
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
          key: emailLoginFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Text(
                      "Continue with Email",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  CustomTextField(
                    controller: emailCtrl,
                    autofocus: true,
                    prefixIcon: const Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      return Validator.emailValidator(val);
                    },
                    labelText: "Email",
                    hintText: "Email",
                    margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
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
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Text(
                            "Forget Password",
                            style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          onPressed: () {
                            context.pushNamed(Routs.phoneSignIn,
                                extra: PhoneSignIn(forgetPasswordMode: true));
                          },
                        ),
                      ],
                    ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account ?",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      context.push(Routs.register);
                    },
                    child: const Text(
                      "SIGN UP",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  signIn() {
    if (emailLoginFormKey.currentState?.validate() == true) {
      FocusScope.of(context).unfocus();

      context.read<AuthControllers>().emailLogin(
            context: context,
            email: emailCtrl.text,
            password: passwordCtrl.text,
          );
    }
  }
}
