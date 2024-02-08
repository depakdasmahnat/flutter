import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/constant/constant.dart';

import '../../../core/constant/gradients.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/gradient_text.dart';
import '../guestProfile/guest_edit_profile.dart';
import '../guestProfile/guest_faq.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({super.key});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  @override
  Widget build(BuildContext context) {
    Color textColor =Color(0xff1C1C1C);
    Color textColor1 =Color(0xffB5B5B5);
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.06),
          child: CustomAppBar(
            showLeadICon: true,
            title: 'Help & Support',
          )),
      body:Padding(
        padding: const EdgeInsets.all(kPadding),
        child: ListView(
          children: [
            // const SizedBox(
            //   height: 15,
            // ),
            Align(
              alignment:  Alignment.center,
              child: CustomeText(
                text: "Any questions? we're here to help you!",
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,

              ),
            ),
             SizedBox(
              height: size.height*0.05,
            ),
            Container(
              // height: size.height*0.4,
              decoration:  BoxDecoration(
                color: textColor,
                borderRadius: BorderRadius.circular(24)
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: GradientText(
                        'Any Query',
                        gradient: primaryGradient,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: GoogleFonts.urbanist().fontFamily,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: size.height*0.16,
                      decoration:  BoxDecoration(
                          color: Color(0xff3B3B3B),
                          borderRadius: BorderRadius.circular(16)
                      ),
                      child: TextFormField(
                        decoration:  InputDecoration(
                          contentPadding:EdgeInsets.only(left: size.width*0.05) ,
                          border: InputBorder.none,
                          hintText: 'Please type your message here...',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14
                          ),
                        ),



                        // margin: const EdgeInsets.only(bottom: 18),
                      ),

                    ),
                    GradientButton(
                      height: 70,
                      borderRadius: 18,
                      blur: 10,
                      backgroundGradient: primaryGradient,
                      backgroundColor: Colors.transparent,
                      boxShadow: const [],
                      margin:  EdgeInsets.only(left: 16, right: 24,top: size.height*0.05),
                      onTap: () {
                        // if (signInFormKey.currentState?.validate() == true) {
                        //   sendOtp();
                        // }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Query message',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: GoogleFonts.urbanist().fontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.height*0.06,
            ),
            CustomeText(
              text: 'Contact details',
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white,

            ),
            SizedBox(
              height: size.height*0.04,
            ),
            CustomeText(
              text: 'Call us',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: textColor1,
            ),
            SizedBox(
              height: size.height*0.01,
            ),
            CustomeText(
              text: '+91 68245 65789',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor1,
            ),
            SizedBox(
              height: size.height*0.02,
            ),
            CustomeText(
              text: 'Email us',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: textColor1,
            ),
            SizedBox(
              height: size.height*0.01,
            ),
            CustomeText(
              text: 'contact@company.com',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: textColor1,
            ),
          ],
        ),
      ),

    );
  }
}
