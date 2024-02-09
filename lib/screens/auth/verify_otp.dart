import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../core/constant/colors.dart';
import '../../utils/validators.dart';
import '../../utils/widgets/custom_button.dart';
import '../../utils/widgets/custom_text_field.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({Key? key, this.mobile, this.countryCode, this.joinAsPartner, this.forgetPasswordMode})
      : super(key: key);

  final String? mobile;
  final String? countryCode;
  final String? joinAsPartner;
  final bool? forgetPasswordMode;

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  late bool? forgetPasswordMode = widget.forgetPasswordMode;
  late String? mobile = widget.mobile;
  late String? countryCode = widget.countryCode;
  late String? joinAsPartner = widget.joinAsPartner;

  TextEditingController otpCtrl = TextEditingController();
  GlobalKey<FormState> verifyOTPFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    otpCtrl.dispose();
  }

  int limit = 6;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
          key: verifyOTPFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Text(
                      "Enter OTP",
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
                        Expanded(
                          child: Text(
                            "We have sent an OTP on your Phone number \n$countryCode $mobile",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomTextField(
                    controller: otpCtrl,
                    autofocus: true,
                    limit: limit,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.security, color: primaryColor),
                    validator: (val) {
                      return Validator.otpValidator(val);
                    },
                    labelText: "OTP",
                    hintText: "Enter $limit digit OTP",
                    onChanged: (val) {
                      setState(() {});

                      if (val.length >= limit) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                    margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                  ),
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
                        verifyOTP();
                      },
                      splashEffect: true,
                      text: "VERIFY OTP",
                      fontSize: 15,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            reSendOtp();
                          },
                          child: Text(
                            "Resend OTP",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: Text(
                            "Change Phone Number",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
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

  verifyOTP() {
    if (verifyOTPFormKey.currentState?.validate() == true) {
      FocusScope.of(context).unfocus();
      context.read<AuthControllers>().verifyOtp(
            context: context,
            phoneNo: mobile,
            otp: otpCtrl.text,
            countryCode: countryCode,
            joinAsPartner: joinAsPartner,
            forgetPasswordMode: forgetPasswordMode,
          );
    }
  }

  reSendOtp() {
    FocusScope.of(context).unfocus();
    context.read<AuthControllers>().reSendOtp(
          context: context,
          mobile: mobile,
          countryCode: countryCode,
          joinAsPartner: joinAsPartner,
          forgetPasswordMode: forgetPasswordMode,
        );
  }
}
