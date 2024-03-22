import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_string_extension.dart';

import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:provider/provider.dart';



import '../../../controllers/check_demo_controller/check_demo_controller.dart';
import '../../../core/services/database/local_database.dart';
import '../../../models/auth_model/guest_data.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/gradient_text.dart';
import 'guest_check_demo_step2.dart';
class GuestCheckDemoStep3 extends StatefulWidget {
  const GuestCheckDemoStep3({super.key});

  @override
  State<GuestCheckDemoStep3> createState() => _GuestCheckDemoStep3State();
}

class _GuestCheckDemoStep3State extends State<GuestCheckDemoStep3>  with WidgetsBindingObserver {
  Color? inactiveColor =const Color(0xFF1C1C1C);
  final bool _site = true;
  AudioPlayer player =  AudioPlayer();
  playLocal() async {
    WidgetsBinding.instance!.addObserver(this);
    AudioCache.instance = AudioCache(prefix: 'assets/');
    await player?.play(AssetSource('gifSound/thinkbig3Sound.mp3'));
    player?.setReleaseMode(ReleaseMode.loop);
    // player?.setVolume(0.2);
  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      playLocal();
      await context.read<CheckDemoController>().fetchDemoAns(context: context);
    });
    super.initState();
    // context.read<CheckDemoController>().addIndex(3);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('check statue ${AppLifecycleState.paused}');
    if (state == AppLifecycleState.paused) {
      player.pause();
    } else if (state == AppLifecycleState.resumed) {
      playLocal();

    }
  }
  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    player?.dispose();
    player?.stop();
    player.pause();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    GuestData? guest = context.read<LocalDatabase>().guest;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:Consumer<CheckDemoController>(
        builder: (context, controller, child) {
          return  Center(
            child: Container(
              height:675 ,
              decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage(AppAssets.thinkBigLastAnswer),
                      fit: BoxFit.cover
                  ),
                  gradient: inActiveGradientTransparent,
                  borderRadius: BorderRadius.circular(22)
              ),
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    SizedBox(
                      height: size.height*0.37,
                    ),

                    CustomText1(
                      text: 'Hey, ${guest?.firstName.toCapitalizeFirst} i know you loved our\nmagical Kangen water',
                      fontSize: 16,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    controller.demoAnsLoader==false?const LoadingScreen():
                    SizedBox(
                      height: size.height*0.2,
                      child: ListView.builder(
                        itemCount:controller.fetchGuestDemoAns?.data?.length??0,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return     Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 8),
                            child: CustomText1(
                              text:controller.fetchGuestDemoAns?.data?[index] ,
                              fontSize: 16,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          );
                          //   Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     decoration:  BoxDecoration(
                          //         color: Colors.white,
                          //         borderRadius: BorderRadius.circular(10)
                          //
                          //     ),
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8),
                          //       child:
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Row(
                          //             children: [
                          //               SizedBox(
                          //                 width: size.width*0.04,
                          //                 height: size.height*0.02,
                          //                 child: Radio(
                          //                   value: true,
                          //                   groupValue: _site,
                          //                   activeColor: Colors.black,
                          //                   onChanged: (value) {
                          //                   },
                          //                 ),
                          //               ),
                          //               const SizedBox(
                          //                 width: 7,
                          //               ),
                          //
                          //               SizedBox(
                          //                 width: size.width*0.6,
                          //                 height: size.width*0.1,
                          //                 child: CustomText1(
                          //                   text: controller.fetchGuestDemoAns?.data?[index],
                          //                   fontWeight: FontWeight.w400,
                          //                   fontSize: 14,
                          //                   color: Colors.black,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //
                          //           const Icon(Icons.check,color: Colors.black,size: 17,)
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // );
                        },),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomText1(
                      text: 'Lets work together to make a big change!!!!\nAll the best..!!!',
                      fontSize: 16,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                     SizedBox(
                      height: size.height*0.02,
                    ),
                    GradientButton(
                      height: 60,
                      borderRadius: 18,
                      blur: 10,
                      backgroundGradient: inActiveGradient,
                      backgroundColor: Colors.transparent,
                      boxShadow: const [],
                      margin: const EdgeInsets.only(left: 16, right: 24),
                      onTap: () async{

                    await    player?.pause();

                        context.read<CheckDemoController>().addIndex(4,'');
                        context.read<CheckDemoController>().nextPage(4);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          // Text(
                          //   'Continue',
                          //   style: TextStyle(
                          //     color: Colors.black,
                          //     fontFamily: GoogleFonts.urbanist().fontFamily,
                          //     fontWeight: FontWeight.w600,
                          //     fontSize: 18,
                          //   ),
                          // ),
                          GradientText(
                            'Continue',
                            gradient: primaryGradient,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: GoogleFonts.urbanist().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },


      ),
    );
  }
}
