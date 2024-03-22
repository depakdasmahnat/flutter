import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/services/database/local_database.dart';
import '../../../models/auth_model/guest_data.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/image_view.dart';


class GuestCheckDemoStep4 extends StatefulWidget {
 final String? mobile;
  const GuestCheckDemoStep4({super.key,this.mobile});

  @override
  State<GuestCheckDemoStep4> createState() => _GuestCheckDemoStep4State();
}

class _GuestCheckDemoStep4State extends State<GuestCheckDemoStep4>  with WidgetsBindingObserver {
  AudioPlayer player =  AudioPlayer();
  playLocal() async {
    WidgetsBinding.instance!.addObserver(this);
    AudioCache.instance = AudioCache(prefix: 'assets/');
    await player?.play(AssetSource('gifSound/think_bigLast.mp3'));
    player?.setReleaseMode(ReleaseMode.loop);
    // player?.setVolume(0.2);


  }
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      playLocal();

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
    return Scaffold(
       body: Stack(
         children: [
           // const ImageView(
           //   // height: 100,
           //   assetImage: AppAssets.confeti2,
           // ),
           Positioned(
             // bottom: size.height*0.14,
             child: Container(

               width: size.width,
               decoration: const BoxDecoration(
                 image: DecorationImage(
                   image: AssetImage(
                     AppAssets.thinkBigLastScreen,
                   ),
                   fit: BoxFit.cover,
                 ),
               ),
             ),
           ),



         ],
       ),
      bottomSheet:   Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GradientButton(
            height: 60,
            borderRadius: 18,
            blur: 10,
            backgroundGradient: whiteGradient,
            backgroundColor: Colors.transparent,
            boxShadow: const [],
            margin: const EdgeInsets.only(left: 16, right: 24),
            onTap: () async{
              // context.read<CheckDemoController>().addIndex(4);
              // context.read<CheckDemoController>().nextPage(4);
              await   player.pause();
              context.pop();

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
          const SizedBox(
            height: 10,
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
              await   player.pause();
              await context.read<MembersController>().callUser(
                mobileNo: widget.mobile,
              );

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Call to connect now',
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
    );
  }
}
