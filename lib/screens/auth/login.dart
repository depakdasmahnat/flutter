
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';

import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:provider/provider.dart';
import '../../../utils/validators.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../controllers/auth_controller/auth_controller.dart';
import '../../core/constant/gradients.dart';

import '../../core/route/route_paths.dart';
import '../../models/auth_model/validatemobile.dart';
import '../../utils/widgets/gradient_button.dart';
import '../../utils/widgets/web_view_screen.dart';
import '../../utils/widgets/widgets.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool checkValidate = false;
  bool forReferral = false;
  bool showReferral = false;
  bool checkBox = false;
  String countryCode ='';
  @override
  void initState() {
    super.initState();
  }

  // Validatemobile validate =Validatemobile();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController referralCodeCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color? textColor2 =const Color(0xFF909090);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(),
      body: Stack(
        children: [
          Image.asset(AppAssets.authbackgroundimage,
              fit: BoxFit.fitWidth, width: double.infinity),
          Form(
            key: signInFormKey,
            child: ListView(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 150),
              children: [
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.13, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        checkValidate==false?  'Welcome!' :'Register',
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 8, bottom: size.height * 0.06),
                        child:  Text(
                          checkValidate==false?  'Login now to continue your journey':'Fill your true information',
                          style: const TextStyle(
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(

                    decoration: ShapeDecoration(
                      color: const Color(0xFF1B1B1B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                      IntlPhoneField(
                        controller:phoneCtrl ,
                        decoration: const InputDecoration(
                          hintText: 'Enter Mobile No.',
                          border: InputBorder.none
                        ),
                         autovalidateMode: AutovalidateMode.disabled,
                        initialCountryCode: 'IN',
                        dropdownIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                        dropdownIconPosition: IconPosition.trailing,
                        disableLengthCheck: true,
                        // validator: (val) {
                        //   return Validator.numberValidator(val.toString());
                        // },
                        // pickerDialogStyle:PickerDialogStyle ,
                        onChanged: (phone) {

                          if (phone.number.length == 10) {
                            countryCode=phone.countryCode;
                            setState(() {});
                            validatePhone();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,bottom: 8),
                  child: CustomeText(
                    text: 'Use only WhatsApp no.',
                    color: textColor2,
                  ),
                ),
                // CustomTextField(
                //   controller: phoneCtrl,
                //   autofocus: true,
                //   prefix: SizedBox(
                //     width: size.width*0.24,
                //     child: Row(
                //       children: [
                //         CountryCodePicker(
                //           onChanged: (value) {
                //           },
                //           showCountryOnly: true,
                //           initialSelection: 'in',
                //           showDropDownButton: true,
                //           hideMainText: true,
                //           showFlagMain: true,
                //           flagWidth: size.width*0.04,
                //         ),
                //         SizedBox(
                //           height: 20,
                //           width: 10,
                //           child: VerticalDivider(
                //             width: 10,
                //             thickness: 2,
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                //   keyboardType: TextInputType.phone,
                //   limit: 10,
                //   validator: (val) {
                //     return Validator.numberValidator(val);
                //   },
                //   onChanged: (value) async {
                //     if (value.length == 10) {
                //       validatePhone();
                //     }
                //   },
                //   hintText: 'Enter Mobile No.',
                //   autofillHints: const [AutofillHints.telephoneNumberNational],
                //   margin: const EdgeInsets.only(bottom: 24),
                // ),

                if (checkValidate == true)
                  CustomTextField(
                    controller: nameCtrl,
                    autofocus: true,
                    validator: (val) {
                      return Validator.fullNameValidator(val);
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))

                    ],

                    onChanged: (value) {},
                    hintText: 'Enter First Name',
                    autofillHints: const [AutofillHints.name],
                    margin: const EdgeInsets.only(top: 1, bottom: 1),
                  ),
                if (checkValidate == true)
                  CustomTextField(
                    controller: lastNameCtrl,
                    autofocus: true,
                    // validator: (val) {
                    //   return Validator.fullNameValidator(val);
                    // },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))

                    ],
                    onChanged: (value) {},
                    hintText: 'Enter Last Name',
                    autofillHints: const [AutofillHints.name],
                    margin: const EdgeInsets.only(top: 18),
                  ),
                if (checkValidate == true)
                  CustomTextField(
                    controller: addressCtrl,
                    autofocus: true,
                    validator: (val) {
                      return Validator.flocationValidation(val);
                    },
                    onChanged: (value) {},
                    hintText: 'Enter City',
                    autofillHints: const [AutofillHints.name],
                    margin: const EdgeInsets.only(top: 18, bottom: 18),
                  ),
                // if(showReferral==true )
                // const Padding(
                //   padding: EdgeInsets.only(bottom: 12),
                //   child: Text(
                //     'Enter Referral Code',
                //     style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.w800),
                //   ),
                // ),
                if (showReferral == true)
                  CustomTextField(
                    controller: referralCodeCtrl,
                    autofocus: true,
                    textCapitalization: TextCapitalization.characters,
                    hintText: 'Referral Code',

                    validator: (value) {
                      return Validator.referralValidator(value);
                    },
                    // autofillHints: const [AutofillHints.name],
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
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

          if (checkValidate == true)
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                SizedBox(
                  width: 20,
                  child: Checkbox(
                    // fillColor: MaterialStateColor.resolveWith(
                    //   (states) {
                    //     return checkBox==false?Colors.black: Colors.black;
                    //   },
                    // ),
                    focusColor: MaterialStateColor.resolveWith((states) {
                      return Colors.black;
                    }),
                    // side: BorderSide.none,
                    activeColor: MaterialStateColor.resolveWith((states) {
                      return Colors.black;
                    }),

                    onChanged: (bool? value) {
                      checkBox =value!;
                      setState(() {});
                    }, value: checkBox,
                  ),
                ),
                SizedBox(
                  width: size.width*0.04,
                ),
                GestureDetector(
                  onTap: () {
                    context.pushNamed(Routs.webView,
                        extra: const WebViewScreen(
                          title: 'Terms & conditions',
                          url: 'https://api.gtp.proapp.in/api/v1/terms_and_condition',
                        ));
                  },
                  child: CustomeText(

                    text: 'I agree to the Terms and Conditions',
                    fontSize: 14,
                    // color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          GradientButton(
            height: 70,
            borderRadius: 18,
            blur: 10,
            backgroundGradient: primaryGradient,
            backgroundColor: Colors.transparent,
            boxShadow: const [],
            margin: const EdgeInsets.only(left: 16, right: 24),
            onTap: () {
              if (signInFormKey.currentState?.validate() == true) {
                sendOtp();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  checkValidate == true?'Register':'Login',
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
            height: size.height * 0.03,
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
            height: size.height * 0.01,
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

  Future validatePhone() async {
    Validatemobile? validate = await context.read<AuthControllers>().validateMobile(context: context, mobile: phoneCtrl.text,);
    if (validate?.status == true) {
      nameCtrl.text = validate?.data?.firstName ?? '';
      lastNameCtrl.text = validate?.data?.lastName ?? '';
      addressCtrl.text = validate?.data?.address ?? '';
      checkValidate = false;
      forReferral = true;
      showReferral = false;
      checkBox =true;
      setState(() {});

    } else {
      nameCtrl.clear();
      lastNameCtrl.clear();
      addressCtrl.clear();
      referralCodeCtrl.clear();
      checkValidate = true;
      forReferral = false;
      showReferral = true;
    }
    setState(() {});

  }

  Future sendOtp() async {
    if(checkBox==false){
      showSnackBar(context: context, color: Colors.green, text:'Please check the terms & condition');
    }else{
      await context.read<AuthControllers>().sendOtp(
          context: context,
          mobile: phoneCtrl.text,
          isMobileValidated: forReferral,
          firstName: nameCtrl.text,
          lastName: lastNameCtrl.text,
          referralCode: referralCodeCtrl.text,
          address: addressCtrl.text, countryCode: countryCode);
    }


    // setState(() {});
    // print('check status ${validate?.status}');
  }
}
