import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

import '../../core/config/app_assets.dart';


class GtpVideo extends StatefulWidget {
  const GtpVideo({super.key});

  @override
  State<GtpVideo> createState() => _GtpVideoState();
}


class _GtpVideoState extends State<GtpVideo> {
  ValueNotifier<VideoPlayerValue?> currentPosition = ValueNotifier(null);
  VideoPlayerController? controller;
  late Future<void> futureController;

  initVideo() {
    controller = VideoPlayerController.asset(AppAssets.introVideo);
    futureController = controller!.initialize();
     controller?.play();

     setState(() {

     });
  }

  @override
  void initState() {
    initVideo();
    controller!.addListener(() {
      if (controller!.value.isInitialized) {
        currentPosition.value = controller?.value;
      }
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

      body: FutureBuilder(
        future: futureController,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator.adaptive());
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
                  aspectRatio: 16 / 9,
                  child: Stack(children: [
                    Positioned.fill(
                        child: Container(
                            foregroundDecoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(.7),
                                    Colors.transparent
                                  ],
                                  stops: [0,
                                    .3
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter),
                            ),
                            child: VideoPlayer(controller!))),

                  ])),
            );
          }
        },
      ),

    );
  }
}
