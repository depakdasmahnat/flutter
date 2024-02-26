import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';

import 'package:video_player/video_player.dart';

import '../../core/config/app_assets.dart';
import '../../core/route/route_paths.dart';


class GtpVideo extends StatefulWidget {
 final String? videoLink;
  const GtpVideo({super.key,this.videoLink});

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
     setState(() {});
  }
  @override
  void initState() {
    initVideo();
    controller!.addListener(() {
      if (controller!.value.isInitialized) {
        currentPosition.value = controller?.value;
        if (controller!.value.position >= controller!.value.duration) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp, // Change to desired orientation
          ]);
          controller?.pause();
          context.pop();
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
  String formatDuration(Duration duration) {
    return "${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}";
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
                  aspectRatio:2/1,
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
      bottomSheet: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: VideoProgressIndicator(
              controller!,
              allowScrubbing: true,
              padding: EdgeInsets.zero,
              colors: const VideoProgressColors(
                backgroundColor: Color(0xFF243771),
                playedColor: Colors.white,
                bufferedColor: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDuration(controller!.value.position),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  formatDuration(controller!.value.duration),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),

    );
  }
}
