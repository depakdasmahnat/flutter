import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../core/constant/colors.dart';
import '../../core/constant/gradients.dart';
import '../../core/constant/shadows.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../utils/widgets/gradient_text.dart';
import '../../utils/widgets/widgets.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({super.key, required this.mobileNo, required this.goBack});

  final String? mobileNo;
  final bool? goBack;

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  late bool? goBack = widget.goBack;

  late Timer timer;
  int resetCountDown = 60;
  late int countDown = 60;
  int totalOtpFields = 6;

  late String? mobileNo = widget.mobileNo;
  late String countryCode = '+91';
  final verifyOtpFormKey = GlobalKey<FormState>();

  startCountDown() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (countDown == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            countDown--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startCountDown();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String currentText = '';
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          width: size.width,
          padding: EdgeInsets.only(top: size.height * 0.05, bottom: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Text(
                      'OTP verification',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'we have sent a verification code to $countryCode ${mobileNo ?? 0}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: PinCodeTextField(
                      length: totalOtpFields,
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      boxShadows: primaryBoxShadow(context),
                      cursorColor: Colors.white,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(12),
                        fieldHeight: 65,
                        fieldWidth: 50,
                        activeBorderWidth: 1,
                        activeFillColor: customTextFieldFilledColor,
                        activeColor: customTextFieldFilledColor,
                        selectedColor: primaryColor,
                        selectedFillColor: customTextFieldFilledColor,
                        disabledColor: customTextFieldFilledColor,
                        inactiveColor: customTextFieldFilledColor,
                        inactiveFillColor: customTextFieldFilledColor,
                        // activeBoxShadow: primaryBoxShadow(context),
                        // inActiveBoxShadow: primaryBoxShadow(context),
                      ),

                      animationDuration: const Duration(milliseconds: 200),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      // errorAnimationController: errorController,
                      controller: textEditingController,
                      autoFocus: true,
                      autoDismissKeyboard: true,
                      onCompleted: (value) {
                        debugPrint('Completed OTP $value');
                        verifyOtp(otp: value);
                      },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print('Allowing to paste $text');
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                      appContext: context,
                    ),
                  ),

                  // PinCodeInputField(
                  //   length: totalOtpFields,
                  //   onCompleted: (val) {},
                  // ),

                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 16, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          countDown == 0 ? 'Did’t get the OTP?' : '$countDown  sec',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        if (countDown == 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: GestureDetector(
                              onTap: () {
                                reSentOtp();
                              },
                              child: GradientText(
                                'Resend SMS',
                                gradient: primaryGradient,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     CustomButton(
                  //       width: size.width * 0.7,
                  //       color: ((otp?.length ?? 0) < 4) ? Colors.grey.shade300 : null,
                  //       title: "CONFIRM",
                  //       margin: const EdgeInsets.only(top: 36),
                  //       onTap: () {
                  //         if ((otp?.length ?? 0) == 4) {
                  //           verifyOtp();
                  //         }
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future reSentOtp() async {
    // await context.read<AuthControllers>().reSendOTP(context: context, phoneNumber: mobileNo, goBack: goBack);
    countDown = resetCountDown;
    startCountDown();
    setState(() {});
  }

  Future verifyOtp({required String otp}) async {
    if (otp.length == totalOtpFields) {
      if (otp == '123456') {
        context.pushNamed(Routs.interests);
      }
      setState(() {});
      // await context
      //     .read<AuthControllers>()
      //     .verifyOTP(context: context, otp: otp, phoneNumber: mobileNo, goBack: goBack);
    } else {
      showSnackBar(context: context, text: 'Wrong Password', color: Colors.red);
    }
  }
}
