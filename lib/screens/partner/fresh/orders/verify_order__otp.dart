import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaas/controllers/partner/partner_controller.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/database/local_database.dart';
import '../../../../utils/widgets/custom_button.dart';

class VerifyOrderOTP extends StatefulWidget {
  const VerifyOrderOTP({
    Key? key,
    required this.orderId,
    this.onSuccess,
    this.name,
  }) : super(key: key);

  final String? orderId;
  final String? name;

  final GestureTapCallback? onSuccess;

  @override
  State<VerifyOrderOTP> createState() => _VerifyOrderOTPState();
}

class _VerifyOrderOTPState extends State<VerifyOrderOTP> {
  late String? orderId = widget.orderId;
  late String? name = widget.name;
  late VoidCallback? onSuccess = widget.onSuccess;
  LocalDatabase localDatabase = LocalDatabase();

  late String? mobile = LocalDatabase().mobile;
  late Timer timer;
  int resetCountDown = 60;
  late int countDown = 60;

  final verifyOtpFormKey = GlobalKey<FormState>();
  TextEditingController pin1 = TextEditingController();
  TextEditingController pin2 = TextEditingController();
  TextEditingController pin3 = TextEditingController();
  TextEditingController pin4 = TextEditingController();
  bool checkedOnce = false;
  FocusNode focusNode = FocusNode();

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      sendOTP();
      startCountDown();
    });
    super.initState();
  }

  sendOTP() {
    context.read<PartnerController>().sendOrderOtp(context: context, orderId: orderId);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 18, 0),
                  child: Text(
                    "Confirm Order",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                  child: Text(
                    "We have sent the verification code to $name .verify it to complete Order",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(24, 12, 18, 36),
                //   child: Text(
                //     "${AppConfig.countryCode} $mobile",
                //     style: const TextStyle(
                //       fontSize: 20,
                //       color: Colors.black,
                //       fontWeight: FontWeight.w500,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  child: RawKeyboardListener(
                    focusNode: focusNode,
                    onKey: (key) {
                      String otp = "${pin1.text}${pin2.text}${pin3.text}${pin4.text}";
                      debugPrint("OTP Is $otp");
                      if (otp.isNotEmpty && key is RawKeyDownEvent && key.logicalKey == LogicalKeyboardKey.backspace) {
                        FocusScope.of(context).previousFocus();
                        debugPrint('BackSpace clicked');
                      }
                    },
                    child: Form(
                      key: verifyOtpFormKey,
                      child: SizedBox(
                        height: 64,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          children: [
                            otpTextField(
                              controller: pin1,
                            ),
                            otpTextField(
                              controller: pin2,
                            ),
                            otpTextField(
                              controller: pin3,
                            ),
                            otpTextField(
                              controller: pin4,
                              lastPin: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "0.$countDown Sec",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                    height: 45,
                    width: size.width * 0.7,
                    mainAxisAlignment: MainAxisAlignment.center,
                    text: "Verify",
                    fontSize: 16,
                    margin: const EdgeInsets.only(bottom: 16),
                    onPressed: () {
                      verifyOtp(onSuccess: onSuccess);
                    }),
                if (countDown == 0)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Column(
                      children: [
                        Text(
                          "Din’t you received any code? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (countDown == 0)
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              reSentOtp();
                            },
                            child: const Text(
                              "Resent new code",
                              style: TextStyle(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w600),
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

  otpTextField({
    required TextEditingController controller,
    TextInputType? inputType,
    FormFieldValidator<String>? validator,
    bool lastPin = false,
    String? hintText,
    String? labelText,
    int? limit,
    EdgeInsets? padding,
  }) {
    return Container(
      height: 64,
      width: 64,
      margin: const EdgeInsets.only(left: 6, right: 6),
      decoration: controller.text.isEmpty ? errorCircularInput() : circularInput(),
      child: Center(
        child: TextFormField(
          controller: controller,
          keyboardType: inputType ?? TextInputType.phone,
          validator: (val) {
            if (val!.isEmpty) {
              return "";
            }
            return null;
          },
          autofocus: true,
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.next,
          cursorColor: primaryColor,
          inputFormatters: [LengthLimitingTextInputFormatter(1)],
          onChanged: lastPin
              ? (val) {
                  if (val.length == 1) {
                    if (checkedOnce) {
                      setState(() {
                        verifyOtpFormKey.currentState!.validate();
                      });
                    }
                    FocusScope.of(context).unfocus();
                  }
                }
              : (val) {
                  if (val.length == 1) {
                    if (checkedOnce) {
                      setState(() {
                        verifyOtpFormKey.currentState!.validate();
                      });
                    }
                    FocusScope.of(context).nextFocus();
                  }
                },
          style: verifyOTPTextStyle(),
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: 36,
              fontWeight: FontWeight.w600,
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            border: InputBorder.none,
            isCollapsed: false,
            isDense: true,
            contentPadding: const EdgeInsets.only(left: 16, right: 16),
          ),
        ),
      ),
    );
  }

  Future verifyOtp({required GestureTapCallback? onSuccess}) async {
    setState(() {
      checkedOnce = true;
    });

    if (verifyOtpFormKey.currentState!.validate()) {
      String otp = "${pin1.text}${pin2.text}${pin3.text}${pin4.text}";
      debugPrint(otp);

      context.read<PartnerController>().verifyOrderOtp(
            context: context,
            orderId: orderId,
            otp: otp,
            onSuccess: onSuccess,
          );
    } else {}
  }

  TextStyle verifyOTPTextStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 28,
      fontWeight: FontWeight.w500,
    );
  }

  InputBorder inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade800),
      borderRadius: BorderRadius.circular(100.0),
    );
  }

  BoxDecoration circularInput() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: Colors.grey.shade300),
    );
  }

  BoxDecoration errorCircularInput() {
    BoxDecoration box = BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: primaryColor.withOpacity(0.3)),
    );
    if (checkedOnce) {
      box = BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.red.shade300),
      );
    }
    return box;
  }

  Future reSentOtp() async {
    setState(() {
      countDown = resetCountDown;
      sendOTP();
      startCountDown();
    });
  }
}
