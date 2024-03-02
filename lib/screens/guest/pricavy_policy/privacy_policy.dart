import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/constant/constant.dart';

import '../../../core/constant/gradients.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../guestProfile/guest_faq.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color textColo =const Color(0xffB5B5B5);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.06),
          child: CustomAppBar(
            showLeadICon: true,
            title: 'Privacy policy',
          )),
      body: Padding(
        padding:  const EdgeInsets.all(kPadding),
        child: ListView(

          children: [
            CustomeText(
              text: 'Last updated: February 06, 2024',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color:textColo,
            ),
            const SizedBox(
              height: 15,
            ),
             Text(
              textAlign: TextAlign.justify,
              'This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.',
            style: TextStyle(
              color: textColo,

              height: 2,

            ),

            ),
            const SizedBox(
              height: 15,
            ),
             Text(
              textAlign: TextAlign.justify,
              'We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy. This Privacy Policy has been created with the help of the Privacy Policy Generator.',
              style: TextStyle(
                color: textColo,

                height: 2,

              ),

            ),
            const SizedBox(
              height: 30,
            ),
            CustomeText(
              text: 'Interpretation and Definitions',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color:Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomeText(
              text: 'Interpretation',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color:Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
             Text(
              textAlign: TextAlign.justify,
              'The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.',
              style: TextStyle(
                color: textColo,

                height: 2,

              ),

            ),
            const SizedBox(
              height: 30,
            ),
            CustomeText(
              text: 'Definitions',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color:Colors.white,
            ),
            Text(
              textAlign: TextAlign.justify,
              'The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.',
              style: TextStyle(
                color: textColo,

                height: 2,

              ),

            ),
            const SizedBox(
              height: 100,
            ),


          ],
        ),
      ),
    bottomNavigationBar: Column(
      mainAxisAlignment:  MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        GradientButton(
          height: 70,
          borderRadius: 18,
          blur: 10,
          backgroundGradient: primaryGradient,
          backgroundColor: Colors.transparent,
          boxShadow: const [],
          margin: const EdgeInsets.only(left: 16, right: 24),
          onTap: () {
            context.pop();
            // if (signInFormKey.currentState?.validate() == true) {
            //   sendOtp();
            // }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Accept & Continue',
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
        const SizedBox(
          height: 10,
        )
      ],
    ),
    );
  }
}
