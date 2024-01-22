import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:provider/provider.dart';
import '../../../utils/validators.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../controllers/auth_controller/auth_controller.dart';
import '../../core/constant/gradients.dart';
import '../../utils/widgets/gradient_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController referralCodeCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(),
      body: Stack(
        children: [
          Image.asset(AppAssets.authbackgroundimage,fit: BoxFit.fitWidth,width: double.infinity),
          Form(
            key: signInFormKey,
            child: ListView(
              padding: const EdgeInsets.only(left: 24, right: 24),
              children: [
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.19, bottom: 8),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome!',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Login now to continue your journey',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomTextField(
                  controller: phoneCtrl,
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  limit: 10,
                  validator: (val) {
                    return Validator.numberValidator(val);
                  },
                  onChanged: (value) {
                    print("check 1");
                    if(value.length==10){
                      context.read<AuthControllers>().validateMobile(
                        context: context,
                        mobile: phoneCtrl.text,
                      );
                      print("check 2");
                    }

                  },
                  hintText: 'Enter Mobile No.',
                  autofillHints: const [AutofillHints.telephoneNumberNational],
                  margin: const EdgeInsets.only(bottom: 24),
                ),
                CustomTextField(
                  controller: nameCtrl,
                  autofocus: true,
                  validator: (val) {
                    return Validator.fullNameValidator(val);
                  },
                  onChanged: (value) {


                  },
                  hintText: 'Enter Full Name',
                  autofillHints: const [AutofillHints.name],
                  margin: const EdgeInsets.only(top: 1, bottom: 1),
                ),
                CustomTextField(
                  controller: nameCtrl,
                  autofocus: true,
                  validator: (val) {
                    return Validator.fullNameValidator(val);
                  },
                  onChanged: (value) {

                  },
                  hintText: 'Enter Last Name',
                  autofillHints: const [AutofillHints.name],
                  margin: const EdgeInsets.only(top: 18, bottom: 18),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Enter Referral Code',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                CustomTextField(
                  controller: referralCodeCtrl,
                  autofocus: true,
                  hintText: 'Referral code',
                  validator: (value) {
                    return Validator.numberValidator(value);
                  },
                  margin: const EdgeInsets.only(bottom: 18),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Text(
                    'Don’t have an account?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          GradientButton(
            height: 70,
            borderRadius: 18,
            backgroundGradient: primaryGradientBlur,
            backgroundColor: Colors.transparent,
            boxShadow: const [],
            margin: const EdgeInsets.only(left: 16, right: 24),
            onTap: () {
              if (signInFormKey.currentState?.validate() == true) {
                context.firstRoute();
                context.pushNamed(Routs.verifyOTP);
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
          SizedBox(
            height: size.height*0.05,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 153.80,
                height: 5.74,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(114.78),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height*0.01,
          ),
        ],
      ),
      // bottomNavigationBar:
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
// void login() {
//   if (signInFormKey.currentState!.validate()) {
//
//   }
// }