import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_string_extension.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller/auth_controller.dart';
import '../../core/config/app_assets.dart';
import '../../core/constant/gradients.dart';
import '../../core/services/database/local_database.dart';
import '../../models/auth_model/guest_data.dart';
import '../../utils/widgets/gradient_button.dart';
import '../../utils/widgets/gradient_text.dart';
import '../guest/guest_check_demo/guest_check_demo_step2.dart';

class ConnectWithUs extends StatefulWidget {
  const ConnectWithUs({super.key});

  @override
  State<ConnectWithUs> createState() => _ConnectWithUsState();
}

class _ConnectWithUsState extends State<ConnectWithUs> {

  AudioPlayer player =  AudioPlayer();
 playLocal() async {

   AudioCache.instance = AudioCache(prefix: 'assets/');
   await player?.play(AssetSource('gifSound/sound.mp3'));
   player?.setReleaseMode(ReleaseMode.loop);

 }
  @override
  void initState() {
    playLocal();
    super.initState();
  }

  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  navigateToDashboard() {
    return context.pushReplacementNamed(Routs.gtpVideo);
  }
 @override
 void dispose() {
   player?.dispose();
   player?.stop();
   super.dispose();
 }

  @override
  Widget build(BuildContext context) {
    GuestData? guest = context.read<LocalDatabase>().guest;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     // GradientButton(
      //     //   height: 30,
      //     //   width: 75,
      //     //   blur: 10,
      //     //   borderRadius: 20,
      //     //   backgroundGradient: inActiveGradient,
      //     //   backgroundColor: Colors.transparent,
      //     //   boxShadow: const [],
      //     //   margin: const EdgeInsets.only(right: 16),
      //     //   onTap: () {
      //     //     navigateToDashboard();
      //     //   },
      //     //   child: const Center(
      //     //     child: Text(
      //     //       'Skip',
      //     //       style: TextStyle(
      //     //         color: Colors.white,
      //     //         fontWeight: FontWeight.w400,
      //     //         fontSize: 14,
      //     //       ),
      //     //     ),
      //     //   ),
      //     // ),
      //   ],
      // ),
      body: Stack(
        children: [
          const Positioned.fill(  //
            child: Image(
              image: AssetImage(AppAssets.welcomeGif),
              fit : BoxFit.fill,
            ),
          ),



          Form(
            key: signInFormKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.05, bottom: 8),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height*0.05,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            'Hello, ${guest?.firstName?.toCapitalizeFirst} !',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            'Welcome to the world of',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText1(
                              text: 'true',
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GradientText(
                              'Health, Wealth &',
                              gradient: primaryGradient,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontFamily: GoogleFonts.urbanist().fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        GradientText(
                          'Happiness',
                          gradient: primaryGradient,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontFamily: GoogleFonts.urbanist().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GradientButton(
                        height: 60,
                        borderRadius: 18,
                        blur: 10,
                        backgroundGradient: primaryGradient,
                        backgroundColor: Colors.transparent,
                        boxShadow: const [],
                        margin:  const EdgeInsets.only(bottom: 16, top: 6),
                        onTap: () async {
                          // playLocal();
                          await player.pause();
                          await context.read<AuthControllers>().connectWithUs(context: context, guestId:guest?.id.toString() );
                          // setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'I am excited',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: GoogleFonts.urbanist().fontFamily,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding prefixIcon({required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          const SizedBox(
            height: 20,
            child: VerticalDivider(
              width: 1,
              thickness: 1.1,
            ),
          )
        ],
      ),
    );
  }
}
