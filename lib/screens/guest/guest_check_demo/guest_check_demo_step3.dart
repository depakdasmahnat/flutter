import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';

import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:provider/provider.dart';



import '../../../controllers/check_demo_controller/check_demo_controller.dart';
import '../../../utils/widgets/gradient_button.dart';
import 'guest_check_demo_step2.dart';
class GuestCheckDemoStep3 extends StatefulWidget {
  const GuestCheckDemoStep3({super.key});

  @override
  State<GuestCheckDemoStep3> createState() => _GuestCheckDemoStep3State();
}

class _GuestCheckDemoStep3State extends State<GuestCheckDemoStep3> {
  Color? inactiveColor =const Color(0xFF1C1C1C);
  final bool _site = true;
  AudioPlayer player =  AudioPlayer();
  playLocal() async {

    AudioCache.instance = AudioCache(prefix: 'assets/');
    await player?.play(AssetSource('gifSound/think_big_answer.mp3'));
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
  void dispose() {
    player?.stop();
    player?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:Consumer<CheckDemoController>(
        builder: (context, controller, child) {
          return  Center(
            child: Container(
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
                      height: size.height*0.32,
                    ),
                    CustomText1(
                      text: 'Your answers',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    CustomText1(
                      text: 'Reference site about Lorem Ipsum, giving information on its origins, a random generator.',
                      fontSize: 16,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    controller.demoAnsLoader==false?const LoadingScreen():
                    SizedBox(
                      height: size.height*0.28,
                      child: ListView.builder(
                        itemCount:controller.fetchGuestDemoAns?.data?.length??0,
                        shrinkWrap: true,

                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration:  BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)

                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: size.width*0.04,
                                          height: size.height*0.02,
                                          child: Radio(
                                            value: true,
                                            groupValue: _site,
                                            activeColor: Colors.black,
                                            onChanged: (value) {
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 7,
                                        ),

                                        SizedBox(
                                          width: size.width*0.6,
                                          height: size.width*0.1,
                                          child: CustomText1(
                                            text: controller.fetchGuestDemoAns?.data?[index],
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const Icon(Icons.check,color: Colors.black,size: 17,)
                                  ],
                                ),
                              ),
                            ),
                          );
                        },),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    GradientButton(
                      height: 60,
                      borderRadius: 18,
                      blur: 10,
                      backgroundGradient: primaryGradient,
                      backgroundColor: Colors.transparent,
                      boxShadow: const [],
                      margin: const EdgeInsets.only(left: 16, right: 24),
                      onTap: () async{
                        // playLocal();
                    await    player?.pause();
                        // player?.dispose();
                        context.read<CheckDemoController>().addIndex(4,'');
                        context.read<CheckDemoController>().nextPage(4);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
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
