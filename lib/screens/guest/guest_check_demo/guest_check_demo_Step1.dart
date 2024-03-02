import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:mrwebbeast/screens/guest/guest_check_demo/textMotion.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../controllers/check_demo_controller/check_demo_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/route/route_paths.dart';
import '../../auth/gtp_video.dart';

class GuestCheckDemoStep1 extends StatefulWidget {
  final String? video;
 final PageController? pageController;
  final String? jumpType;
  const GuestCheckDemoStep1({super.key,this.video,this.pageController,this.jumpType});

  @override
  State<GuestCheckDemoStep1> createState() => _GuestCheckDemoStep1State();
}

class _GuestCheckDemoStep1State extends State<GuestCheckDemoStep1> {
  // late FlickManager flickManager;
  ValueNotifier<VideoPlayerValue?> currentPosition = ValueNotifier(null);
  VideoPlayerController? controller;
  bool?  loading =false;
  // late Future<void> futureController;

  ChewieController? chewieController;
  var playerWidget;
  // initVideo() {
  //   controller = VideoPlayerController.networkUrl(Uri.parse(widget.video??''));
  //   futureController = controller!.initialize();
  //
  //   controller?.play();
  //   setState(() {});
  // }

  @override
  void initState() {

    fullScreenVideo();
    controller!.addListener(() {
      if (controller!.value.isInitialized) {
        currentPosition.value = controller?.value;
        if (controller!.value.position >= controller!.value.duration) {
          if(widget.jumpType=='3'){
            context.read<CheckDemoController>()?.nextPage(3);
          }else if(widget.jumpType=='4'){
            context.read<CheckDemoController>()?.nextPage(5);
            context.read<CheckDemoController>()?.addIndex(5,'');
          }
          else{
            context.read<CheckDemoController>()?.nextPage(1);
          }
          // controller?.pause();
          // context.pop();
        }

      }
      setState(() {

      });
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    controller!.addListener(() {


      setState(() {
      });
    });
    super.initState();
  }
  @override
  void dispose() {
    controller?.dispose();
    chewieController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }


  double _aspectRatio = 16 / 9;
   fullScreenVideo(){
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.video??''));
     chewieController = ChewieController(
       allowedScreenSleep: true,
       allowFullScreen: true,
       deviceOrientationsAfterFullScreen: [
         DeviceOrientation.landscapeRight,
         DeviceOrientation.landscapeLeft,
         DeviceOrientation.portraitUp,
         DeviceOrientation.portraitDown,
       ],
       videoPlayerController: controller!,
       aspectRatio: _aspectRatio,
       autoInitialize: true,
       autoPlay: true,
       showControls: true,
     );
     chewieController?.addListener(() {
       if (chewieController!.isFullScreen) {
         SystemChrome.setPreferredOrientations([
           DeviceOrientation.landscapeRight,
           DeviceOrientation.landscapeLeft,
         ]);
       } else {
         SystemChrome.setPreferredOrientations([
           DeviceOrientation.portraitUp,
           DeviceOrientation.portraitDown,
         ]);
       }
     });

   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Chewie(
        controller: chewieController!,
      ),
    );
  }
}
