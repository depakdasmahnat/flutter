import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/controllers/guest_controller/guest_controller.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:provider/provider.dart';

import '../../../core/constant/gradients.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/gradient_text.dart';
import '../guestProfile/guest_faq.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({super.key});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  TextEditingController questionController =TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color textColor =Color(0xff1C1C1C);

    Color? textColor2 =const Color(0xFF909090);
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
                text: "Any questions ? we're here to help you!",
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
                        'Any Query ?',
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
                        controller: questionController,
                        decoration:  InputDecoration(
                          contentPadding:EdgeInsets.only(left: size.width*0.07) ,
                          border: InputBorder.none,
                          hintText: 'Please Drop Your Questions Here.',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14
                          ),
                        ),

                        // margin: const EdgeInsets.only(bottom: 18),
                      ),

                    ),
                    GradientButton(
                      height: 60,
                      borderRadius: 18,
                      blur: 10,
                      backgroundGradient: primaryGradient,
                      backgroundColor: Colors.transparent,
                      boxShadow: const [],
                      margin:  EdgeInsets.only(left: 16, right: 24,top: size.height*0.05),
                      onTap: () async{
                       await context.read<GuestControllers>().helpAndSupport(context: context, question: questionController.text);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Send Request',
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
              text: 'Social admin',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: textColor2,
            ),
            SizedBox(
              height: size.height*0.01,
            ),
            CustomeText(
              text: 'Tanvesh',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor2,
            ),
            SizedBox(
              height: size.height*0.02,
            ),
            CustomeText(
              text: 'Email',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: textColor2,
            ),
            SizedBox(
              height: size.height*0.01,
            ),
            CustomeText(
              text: 'er.tanveshrupani@gmail.com',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: textColor2,
            ),
          ],
        ),
      ),

    );
  }
}
