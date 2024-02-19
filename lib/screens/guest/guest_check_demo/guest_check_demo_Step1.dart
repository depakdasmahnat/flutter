import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../controllers/check_demo_controller/check_demo_controller.dart';
import '../../../core/config/app_assets.dart';

class GuestCheckDemoStep1 extends StatefulWidget {
  final String? video;
 final PageController? pageController;
  final String? jumpType;
  const GuestCheckDemoStep1({super.key,this.video,this.pageController,this.jumpType});

  @override
  State<GuestCheckDemoStep1> createState() => _GuestCheckDemoStep1State();
}

class _GuestCheckDemoStep1State extends State<GuestCheckDemoStep1> {
  ValueNotifier<VideoPlayerValue?> currentPosition = ValueNotifier(null);
  VideoPlayerController? controller;
  late Future<void> futureController;

  initVideo() {
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.video??''));
    futureController = controller!.initialize();
    controller?.play();
    setState(() {});
  }
  @override
  void initState() {
    initVideo();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    controller!.addListener(() {
      if (controller!.value.isInitialized) {
        currentPosition.value = controller?.value;
        if (controller!.value.position >= controller!.value.duration) {
          controller?.pause();
          if(widget.jumpType=='3'){
            context.read<CheckDemoController>()?.nextPage(3);
          }else if(widget.jumpType=='4'){
            context.read<CheckDemoController>()?.nextPage(5);
            context.read<CheckDemoController>()?.addIndex(5);
          }
          else{
            context.read<CheckDemoController>()?.nextPage(1);
          }

        }
      }
      setState(() {
      });
    });
    super.initState();
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      FutureBuilder(
        future: futureController,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else {
            return InkWell(
              onTap: () {
                // Get.to(ShowVideoAndPhotos(
                //   image: null,
                //   video: widget.pathh,
                // ));
              },
              child:
              AspectRatio(
                // aspectRatio: controller!.value.aspectRatio,
                  aspectRatio:2/3.5,
                  child: Stack(children: [
                    Positioned.fill(
                        child: Container(
                            foregroundDecoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(.7),
                                    Colors.transparent
                                  ],
                                  stops: [0, .3],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter),
                            ),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                    width: controller!.value.size.width,
                                    height: controller!.value.size.height,
                                    child: VideoPlayer(controller!))))),


                  ])),
            );
          }
        },
      ),
    );
  }
}
