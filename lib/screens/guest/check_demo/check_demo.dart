import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:mrwebbeast/utils/widgets/appbar.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../../controllers/check_demo_controller/check_demo_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/gradient_text.dart';

class GuestNewCheckDemo extends StatefulWidget {
  const GuestNewCheckDemo({super.key});

  @override
  State<GuestNewCheckDemo> createState() => _GuestNewCheckDemoState();
}

class _GuestNewCheckDemoState extends State<GuestNewCheckDemo> {
  final PageController _pageController = PageController();
  Color? inactiveColor =const Color(0xFF3D3D3D);
  @override
  void initState() {
    super.initState();
    // context.read<CheckDemoController>().addIndex(3);

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.06),
          child: CustomAppBar(
            showLeadICon: true,
            title: 'Demo Journey',
          )),
      body: Consumer<CheckDemoController>(
        builder: (context, controller, child) {
          return  Column(

            // shrinkWrap: true,
            children: [


              EasyStepper(
                activeStep:controller.stepIndex,
                internalPadding: 1,
                showLoadingAnimation: false,
                stepRadius: 12,
                onStepReached: (index) {

                  controller.addIndex(index);

                },

                showStepBorder: false,
                finishedStepBackgroundColor: inactiveColor,

                steps: [
                  EasyStep(
                    customTitle: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // CustomeText(
                        //   text: 'Video',
                        //   fontSize: 10,
                        // ),
                        GradientText(
                          'Video',
                          gradient: controller.stepIndex>=0? primaryGradient:inActiveGradient,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: GoogleFonts.urbanist().fontFamily,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    customStep: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: controller.stepIndex>=0? primaryGradient:inActiveGradient
                      ),
                    ),
                    topTitle: false,

                  ),
                  EasyStep(
                      customTitle: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          GradientText(
                            'Q&A',
                            gradient: controller.stepIndex>=1? primaryGradient:inActiveGradient,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: GoogleFonts.urbanist().fontFamily,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      customStep: Container(
                        decoration: BoxDecoration(
                      shape: BoxShape.circle, gradient: controller.stepIndex>=1? primaryGradient:inActiveGradient),
                      ),
                      topTitle: false),
                  EasyStep(
                      customTitle: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          GradientText(
                            'Demo Video',
                            gradient: controller.stepIndex>=2? primaryGradient:inActiveGradient,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: GoogleFonts.urbanist().fontFamily,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      customStep: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, gradient:controller.stepIndex>=2? primaryGradient:inActiveGradient),
                      ),
                      topTitle: false),
                  EasyStep(
                      customTitle: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          GradientText(
                            'Answers',
                            gradient: controller.stepIndex>=3? primaryGradient:inActiveGradient,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: GoogleFonts.urbanist().fontFamily,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      customStep: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, gradient: controller.stepIndex>=3? primaryGradient:inActiveGradient),
                      ),
                      topTitle: false),
                  EasyStep(
                      customTitle: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          GradientText(
                            'Business video',
                            gradient: controller.stepIndex>=4? primaryGradient:inActiveGradient,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: GoogleFonts.urbanist().fontFamily,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      customStep: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, gradient: controller.stepIndex>=4? primaryGradient:inActiveGradient),
                      ),
                      topTitle: false),
                  EasyStep(
                      customTitle: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          GradientText(
                            'Connect',
                            gradient: controller.stepIndex>=5? primaryGradient:inActiveGradient,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: GoogleFonts.urbanist().fontFamily,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      customStep: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Image.asset(AppAssets.star1,color: controller.stepIndex>=5?null:inactiveColor,),
                      ),
                      topTitle: false),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                 onPageChanged: (value) {
                   context.read<CheckDemoController>().addIndex(value);
                 },
                  children: [
                    Center(child: CustomeText(text: 'ok',)),
                    Center(child: CustomeText(text: 'not ok',)),
                    Center(child: CustomeText(text: 'ok ok ok')),
                  ],
                ),
              ),


            ],
          );
        },


      ),
    );
  }
}
