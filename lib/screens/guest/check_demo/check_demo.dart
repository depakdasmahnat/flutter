import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:mrwebbeast/utils/widgets/appbar.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:provider/provider.dart';

import '../../../controllers/check_demo_controller/check_demo_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/gradient_text.dart';
import '../../auth/gtp_video.dart';
import '../../auth/login.dart';
import '../guest_check_demo/guest_check_demo_Step1.dart';
import '../guest_check_demo/guest_check_demo_step2.dart';
import '../guest_check_demo/guest_check_demo_step3.dart';
import '../guest_check_demo/guest_check_demo_step4.dart';
import '../guest_check_demo/textMotion.dart';

class GuestNewCheckDemo extends StatefulWidget {
  const GuestNewCheckDemo({super.key});

  @override
  State<GuestNewCheckDemo> createState() => _GuestNewCheckDemoState();
}

class _GuestNewCheckDemoState extends State<GuestNewCheckDemo> {

  Color? inactiveColor =const Color(0xFF3D3D3D);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
     await context.read<CheckDemoController>().getStepCheckDemo(context: context);
     await context.read<CheckDemoController>().guestCheckDemoStep1(context: context);
     if(context.read<CheckDemoController>().getStep?.demoStep==1){
       context.read<CheckDemoController>().pageController.jumpToPage(1);
       context.read<CheckDemoController>().addIndex(1,'');
     }
     else if(context.read<CheckDemoController>().getStep?.demoStep==2){
       context.read<CheckDemoController>().pageController.jumpToPage(2);
       context.read<CheckDemoController>().addIndex(2,'');
     } else if(context.read<CheckDemoController>().getStep?.demoStep==3){
       context.read<CheckDemoController>().pageController.jumpToPage(3);
       context.read<CheckDemoController>().addIndex(3,'');
     }else if(context.read<CheckDemoController>().getStep?.demoStep==4){
       context.read<CheckDemoController>().pageController.jumpToPage(4);
       context.read<CheckDemoController>().addIndex(4,'');

     }else if(context.read<CheckDemoController>().getStep?.demoStep==5){
       context.read<CheckDemoController>().pageController.jumpToPage(5);
       context.read<CheckDemoController>().addIndex(5,'');
     }else if(context.read<CheckDemoController>().getStep?.demoStep==6){
       context.read<CheckDemoController>().pageController.jumpToPage(5);
       context.read<CheckDemoController>().addIndex(5,'');
     }else {
       context.read<CheckDemoController>().addIndex(0,'');
     }
    });
    super.initState();
    // context.read<CheckDemoController>().addIndex(3);
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.08),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomAppBar(
              showLeadICon: true,
              title: 'Demo Journey',
            ),
          )),
      body: Consumer<CheckDemoController>(
        builder: (context, controller, child) {
          return
            Column(

            children: [
              EasyStepper(
                activeStep:controller.stepIndex,
                internalPadding: 1,
                // enableStepTapping: false,
                showLoadingAnimation: false,
                stepRadius: 12,
                onStepReached: (index) {
                  controller.addIndex(index,'');
                  controller.nextPage(index);
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 0,right: 8),
                  child: PageView(
                    controller: controller.pageController,
                    scrollDirection: Axis.horizontal,
                   physics: const NeverScrollableScrollPhysics(),
                   onPageChanged: (value) async{
                     context.read<CheckDemoController>().addIndex(value,'');

                     if(value==2){
                       await context.read<CheckDemoController>().guestCheckDemoStep1(context: context);
                     }
                   },
                    children: [
                      Consumer<CheckDemoController>(
                        builder: (context, controller, child) {
                          return controller.guestCheckDemoLoader==false?
                          const LoadingScreen() :
                          // GtpVideo( videoLink: controller.guestCheckDemoVideoAndStep?.data?[0].link,);
                          GuestCheckDemoStep1(video: controller.guestCheckDemoVideoAndStep?.data?[0].link??'');
                        },
                           ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0,right: 8),
                        child: GuestCheckDemoStep2(),
                      ),
                      Consumer<CheckDemoController>(
                        builder: (context, controller, child) {
                          return controller.guestCheckDemoLoader==false?
                          const LoadingScreen() :
                          GuestCheckDemoStep1(video: controller.guestCheckDemoVideoAndStep?.data?[0].link??'',jumpType: '3',);
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0,right: 8),
                        child: GuestCheckDemoStep3(),
                      ),
                      Consumer<CheckDemoController>(
                        builder: (context, controller, child) {
                          return controller.guestCheckDemoLoader==false?
                          const LoadingScreen() :
                          GuestCheckDemoStep1(video: controller.guestCheckDemoVideoAndStep?.data?[0].link??'',jumpType: '4',);
                        },
                      ),
                       GuestCheckDemoStep4(mobile: controller.guestCheckDemoVideoAndStep?.mobile??'',)

                    ],
                  ),
                ),
              ),
              if(controller.stepIndex==0)
              Padding(
                padding: const EdgeInsets.only(bottom: kPadding),
                child: SizedBox(
                  height: size.height*0.03,
                  child: ScrollingText(text: 'Remember, each body is different. Kangen does not claim that it cures any ailment.', textStyle: const TextStyle(
                    color: Colors.white,
                  ),),
                ),
              ),

            ],
          );
        },
      ),
    );
  }
}
