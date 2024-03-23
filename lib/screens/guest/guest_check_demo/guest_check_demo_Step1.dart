//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import '../../../controllers/check_demo_controller/check_demo_controller.dart';
// import '../../member/feeds/chewie_video_player.dart';
// import '../../member/feeds/youtube_video_player.dart';
//
// class GuestCheckDemoStep1 extends StatefulWidget {
//   final String? video;
//   final bool? videoType;
//  final PageController? pageController;
//   final String? jumpType;
//
//   const GuestCheckDemoStep1({super.key,this.video,this.pageController,this.jumpType,this.videoType});
//
//   @override
//   State<GuestCheckDemoStep1> createState() => _GuestCheckDemoStep1State();
// }
//
// class _GuestCheckDemoStep1State extends State<GuestCheckDemoStep1> {
//   //
//   ValueNotifier<VideoPlayerValue?> currentPosition = ValueNotifier(null);
//   VideoPlayerController? controller;
//   // bool?  loading =false;
//   //
//   // YoutubePlayerController? controller;
//   // ChewieController? chewieController;
//   // var playerWidget;
//   // // initVideo() {
//   // //   controller = VideoPlayerController.networkUrl(Uri.parse(widget.video??''));
//   // //   futureController = controller!.initialize();
//   // //
//   // //   controller?.play();
//   // //   setState(() {});
//   // // }
//   //
//   // // @override
//   // // void initState() {
//   // //   fullScreenVideo();
//   // //   controller!.addListener(() {
//   // //     if (controller!.value.isInitialized) {
//   // //       currentPosition.value = controller?.value;
//   // //       if (controller!.value.position >= controller!.value.duration) {
//   // //         if(widget.jumpType=='3'){
//   // //           context.read<CheckDemoController>()?.nextPage(3);
//   // //         }else if(widget.jumpType=='4'){
//   // //           context.read<CheckDemoController>()?.nextPage(5);
//   // //           context.read<CheckDemoController>()?.addIndex(5,'');
//   // //         }
//   // //         else{
//   // //           context.read<CheckDemoController>()?.nextPage(1);
//   // //         }
//   // //         // controller?.pause();
//   // //         // context.pop();
//   // //       }
//   // //
//   // //     }
//   // //     setState(() {
//   // //     });
//   // //   });
//   // //   // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//   // //   // controller!.addListener(() {
//   // //   //   setState(() {
//   // //   //   });
//   // //   // });
//   // //   super.initState();
//   // // }
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   try {
//   //     controller = YoutubePlayerController(
//   //       params: const YoutubePlayerParams(
//   //         mute: false,
//   //         showControls: false,
//   //         showFullscreenButton: false,
//   //       ),
//   //     );
//   //
//   //
//   //
//   //
//   //     controller?.loadVideo('https://www.youtube.com/watch?v=IlZbHDSalww');
//   //     controller?.pauseVideo();
//   //
//   //     // controller?.valueStream.listen((state) {
//   //     //   if (state == PlayerState.ended) {
//   //     //     print('Video has ended');
//   //     //     // Add your logic to print the desired data or perform any other actions
//   //     //   }
//   //     // });
//   //   } catch (e, s) {
//   //     ErrorHandler.catchError(e, s, false);
//   //   }
//   //
//   //   // controller.setFullScreenListener((value) {
//   //   //   debugPrint("YoutubePlayer FullScreen :- $value");
//   //   //   if (value == true) {
//   //   //   } else {}
//   //   // });
//   // }
//   // @override
//   // void dispose() {
//   //   // controller?.dispose();
//   //   chewieController?.dispose();
//   //   SystemChrome.setPreferredOrientations([
//   //     DeviceOrientation.landscapeRight,
//   //     DeviceOrientation.landscapeLeft,
//   //     DeviceOrientation.portraitUp,
//   //     DeviceOrientation.portraitDown,
//   //   ]);
//   //   super.dispose();
//   // }
//   //
//   //
//   // double _aspectRatio = 16 / 9;
//    // fullScreenVideo(){
//    //  controller = VideoPlayerController.networkUrl(Uri.parse(widget.video??''));
//    //   chewieController = ChewieController(
//    //     allowedScreenSleep: true,
//    //     allowFullScreen: true,
//    //     deviceOrientationsAfterFullScreen: [
//    //       DeviceOrientation.landscapeRight,
//    //       DeviceOrientation.landscapeLeft,
//    //       DeviceOrientation.portraitUp,
//    //       DeviceOrientation.portraitDown,
//    //     ],
//    //     videoPlayerController: controller!,
//    //     aspectRatio: _aspectRatio,
//    //     autoInitialize: true,
//    //     autoPlay: true,
//    //     showControls: true,
//    //   );
//    //   chewieController?.addListener(() {
//    //     if (chewieController!.isFullScreen) {
//    //       SystemChrome.setPreferredOrientations([
//    //         DeviceOrientation.landscapeRight,
//    //         DeviceOrientation.landscapeLeft,
//    //       ]);
//    //     } else {
//    //       SystemChrome.setPreferredOrientations([
//    //         DeviceOrientation.portraitUp,
//    //         DeviceOrientation.portraitDown,
//    //       ]);
//    //     }
//    //   });
//    //
//    // }
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       body: ChewieVideoPlayerCard(
//         url: widget.video,
//         borderRadius: 18,
//         onCompleted: () {
//           print('check complete video');
//           // if(widget.jumpType=='3'){
//           //   context.read<CheckDemoController>().nextPage(3);
//           // }else if(widget.jumpType=='4'){
//           //   context.read<CheckDemoController>().nextPage(5);
//           //   context.read<CheckDemoController>().addIndex(5,'');
//           // }
//           // else{
//           //   context.read<CheckDemoController>().nextPage(1);
//           // }
//
//         },
//       ),
//       // Center(
//       //   child: VisibilityDetector(
//       //     key: const ObjectKey('ytVideoPlayer'),
//       //
//       //     onVisibilityChanged: (visibility) async {
//       //       var visiblePercentage = visibility.visibleFraction * 100;
//       //       if (visiblePercentage >= 80 && mounted) {
//       //         controller?.playVideo();
//       //       } else {
//       //         controller?.pauseVideo();
//       //       }
//       //     },
//       //     child: controller != null
//       //         ? ClipRRect(
//       //         // borderRadius: BorderRadius.circular(borderRadius ?? 8),
//       //         child:YoutubePlayer(
//       //           controller: controller!,
//       //           aspectRatio: 16 / 9,
//       //           // backgroundColor: widget.backGroundColor==true?null:Colors.grey.shade200,
//       //           enableFullScreenOnVerticalDrag: false,
//       //         )
//       //       // YoutubePlayer(
//       //       //   controller: controller!,
//       //       //   aspectRatio: 16 / 9,
//       //       //   backgroundColor: Colors.grey.shade200,
//       //       //   enableFullScreenOnVerticalDrag: false,
//       //       // ),
//       //     )
//       //         : const AspectRatio(
//       //       aspectRatio: 16 / 9,
//       //       child: CupertinoActivityIndicator(radius: 18, color: primaryColor),
//       //     ),
//       //   ),
//       // )
//       // widget.videoType==true?
// //       Center(
// //         child: ChewieVideoPlayerCard(
// //           url: widget.video,
// //           borderRadius: 18,
// //           onCompleted: () {
// //             // if(widget.jumpType=='3'){
// //             //   context.read<CheckDemoController>().nextPage(3);
// //             // }else if(widget.jumpType=='4'){
// //             //   context.read<CheckDemoController>().nextPage(5);
// //             //   context.read<CheckDemoController>().addIndex(5,'');
// //             // }
// //             // else{
// //             //   context.read<CheckDemoController>().nextPage(1);
// //             // }
// //
// //           },
// //         ),
// //       );
// //           :
// //       Center(
// //         child: IgnorePointer(
// //           ignoring: true,
// //           child: YoutubeVideoPlayerCard(
// //             // showControls: true,
// //             url: widget.video,
// //             // url: 'https://www.youtube.com/watch?v=AGKk7CvQRd8',
// //
// //           borderRadius: 0,
// //             onCompleted: () {
// //               if(widget.jumpType=='3'){
// //                 context.read<CheckDemoController>().nextPage(3);
// //               }else if(widget.jumpType=='4'){
// //                 context.read<CheckDemoController>().nextPage(5);
// //                 context.read<CheckDemoController>().addIndex(5,'');
// //               }
// //               else{
// //                 context.read<CheckDemoController>().nextPage(1);
// //               }
// //
// //             },
// //           ),
// //         ),
// //       )
//       // Chewie(
//       //   controller: chewieController!,
//       // ),
//     );
//   }
// }

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../controllers/check_demo_controller/check_demo_controller.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/gradients.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../guestProfile/guest_faq.dart';

class GuestCheckDemoStep1 extends StatefulWidget {
  final String? video;
  final bool? videoType;
  final int? index;

  final PageController? pageController;
  final String? jumpType;
  const GuestCheckDemoStep1(
      {super.key,
      this.video,
      this.videoType,
      this.pageController,
      this.index,
      this.jumpType});

  @override
  State<GuestCheckDemoStep1> createState() => _GuestCheckDemoStep1State();
}

class _GuestCheckDemoStep1State extends State<GuestCheckDemoStep1> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  bool? previousVideo = false;
  int? tabIndex = 0;
  String? previousVideoLink = '';
  Future initVideo() async {
    // disposeVideo();
    if (widget.video != null) {
      if (previousVideo == false) {
        videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse('${widget.video}'));
      } else {
        videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse('$previousVideoLink'));
      }
    }
    await videoPlayerController?.initialize();
    if (videoPlayerController != null) {
      chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
          autoPlay: true,
          // looping: true,
          zoomAndPan: true,
          showOptions: false,
          allowPlaybackSpeedChanging: false,
          allowMuting: false,
          draggableProgressBar: false,
          materialProgressColors: ChewieProgressColors(
              handleColor: Colors.green,
              bufferedColor: Colors.green.withOpacity(0.3),
              playedColor: Colors.white));
      chewieController?.videoPlayerController.addListener(() {
        if (chewieController!.videoPlayerController.value.position >=
            chewieController!.videoPlayerController.value.duration) {
          print(
              'complete video ${chewieController!.videoPlayerController!.value.position}');
          if (widget.jumpType == '3') {
            context.read<CheckDemoController>().nextPage(3);
          } else if (widget.jumpType == '4') {
            context.read<CheckDemoController>().nextPage(5);
            context.read<CheckDemoController>().addIndex(5, '');
          } else {
            context.read<CheckDemoController>().nextPage(1);
          }
        }
      });
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.index != 0) {
        await context
            .read<CheckDemoController>()
            .fetchDemoVideos(context: context);
      }
    });

    initVideo();
  }

  Future disposeVideo() async {
    if (videoPlayerController?.value.isInitialized == true) {
      videoPlayerController?.removeListener(() {});
      await videoPlayerController?.dispose();
      chewieController?.dispose();
    }
  }

  @override
  void dispose() {
    super.dispose();
    disposeVideo();
    videoPlayerController = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (videoPlayerController?.value.isInitialized == true)
            ? GestureDetector(
                onTap: () {},
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Chewie(
                    controller: chewieController!,
                  ),
                ),
              )
            : const AspectRatio(
                aspectRatio: 16 / 9,
                child:
                    CupertinoActivityIndicator(radius: 18, color: primaryColor),
              ),
      ),
      bottomSheet: Consumer<CheckDemoController>(
        builder: (context, controller, child) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.index != 0 || tabIndex == 2)
                Padding(
                  padding:
                      const EdgeInsets.only(left: kPadding, bottom: kPadding),
                  child: GradientButton(
                    height: 30,
                    width: 100,
                    borderRadius: 18,
                    onTap: () {
                      if (widget.index == 1 || tabIndex==1||tabIndex==0) {
                        disposeVideo();
                        previousVideo = true;
                        previousVideoLink = controller.fetchDemoVideosAfter?.data?[0].videoLink;
                        initVideo();
                        setState(() {});
                      } else if (widget.index == 2 && tabIndex==0 ) {
                        disposeVideo();
                        previousVideo = true;
                        tabIndex = 1;
                        previousVideoLink = controller.fetchDemoVideosAfter?.data?[1].videoLink;
                        initVideo();
                        setState(() {});
                      }
                    },
                    backgroundGradient: primaryGradient,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomeText(
                          text: 'Previous Video',
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              // if(widget.index!=0 && tabIndex==1)
              // Padding(
              //   padding: const EdgeInsets.only(left: kPadding,bottom: kPadding),
              //   child: GradientButton(
              //     height: 30,
              //     width: 100,
              //     borderRadius: 18,
              //     onTap: () {
              //       if(widget.index==1){
              //         disposeVideo();
              //         previousVideo =true;
              //         previousVideoLink =controller.fetchDemoVideosAfter?.data?[0].videoLink;
              //         initVideo();
              //         setState(() {});
              //       }else if(widget.index==2){
              //         disposeVideo();
              //         previousVideo =true;
              //         previousVideoLink =controller.fetchDemoVideosAfter?.data?[1].videoLink;
              //         initVideo();
              //         setState(() {});
              //       }
              //     },
              //     backgroundGradient: primaryGradient,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         CustomeText(
              //           text: 'Previous Video',
              //           color: Colors.black,
              //           fontSize: 14,
              //         ),
              //
              //       ],
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}
