import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../controllers/check_demo_controller/check_demo_controller.dart';
import '../../../core/constant/colors.dart';

class ChewieVideoPlayerCard extends StatefulWidget {
  const ChewieVideoPlayerCard(
      {super.key, this.url, this.borderRadius, this.aspectRatio, this.type, this.demoId,this.onCompleted});

  final double? aspectRatio;
  final String? url;
  final bool? type;
  final String? demoId;
  final VoidCallback? onCompleted;
  final double? borderRadius;

  @override
  State<ChewieVideoPlayerCard> createState() => _ChewieVideoPlayerCardState();
}

class _ChewieVideoPlayerCardState extends State<ChewieVideoPlayerCard> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  late String? url = widget.url;
  late double? borderRadius = widget.borderRadius;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  @override
  void dispose() {
    super.dispose();
    disposeVideo();
    videoPlayerController = null;
  }

  Future initVideo() async {
    disposeVideo();
    if (url != null) {
      debugPrint('url$url');
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse('$url'));
    }
    await videoPlayerController?.initialize();
    if (videoPlayerController != null) {
      chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
          autoPlay: true,
          // looping: true,
          zoomAndPan: true,
          showOptions: false,
          materialProgressColors: ChewieProgressColors(
              handleColor: Colors.green,
              bufferedColor: Colors.green.withOpacity(0.3),
              playedColor: Colors.white));
      chewieController?.videoPlayerController.addListener(() {

        videoPlayerController?.value = videoPlayerController!.value;
        if (videoPlayerController!.value.position >= videoPlayerController!.value.duration) {
         widget.onCompleted?.call();
        }
      });

      setState(() {

      });
      // playVideo();
      // videoPlayerController?.addListener(() {
      //   if (videoPlayerController!.value.position >=
      //       videoPlayerController!.value.duration) {
      //     widget.onCompleted!();
      //   }
      //   if (context.mounted) {
      //     setState(() {});
      //   }
      // });
      // playVideo();
    }
  }

  Future<bool> playVideo() async {
    if (videoPlayerController?.value.isPlaying == true) {
      await videoPlayerController?.pause();
      await  chewieController?.pause();
    } else {
      if (videoPlayerController!.value.position >= videoPlayerController!.value.duration) {
        // If the video is complete, seek to the beginning before playing
        await videoPlayerController?.seekTo(Duration.zero);
      }
      await videoPlayerController?.play();
    }
    return true;
  }

  Future disposeVideo() async {
    if (videoPlayerController?.value.isInitialized == true) {
      videoPlayerController?.removeListener(() {});
      await videoPlayerController?.dispose();
    }
  }
  @override
  Widget build(BuildContext context) {

    return VisibilityDetector(
      key: const ObjectKey('videoManager'),
      onVisibilityChanged: (visibility) {
        var visiblePercentage = visibility.visibleFraction * 100;
        if (visibility.visibleFraction == 0 && mounted) {
          videoPlayerController?.pause();
        } else if (visibility.visibleFraction < 0.95 && mounted) {
          videoPlayerController?.pause();
        } else if (visibility.visibleFraction == 1 && mounted) {
          videoPlayerController?.play();
        }
        debugPrint('Video Player visibility  ${visibility.key} is $visiblePercentage% visible & ${visibility.visibleFraction}');
      },
      child: Container(
        color: Colors.black,
        child: (videoPlayerController?.value.isInitialized == true)
            ? GestureDetector(
                onTap: () {
                  if (widget.type == true) {
                    context.read<CheckDemoController>().videoCount(
                          context: context,
                          demoId: '${widget.demoId}',
                        );
                  }
                  playVideo();
                },
                child: AspectRatio(
                  aspectRatio: widget.aspectRatio ?? 16 / 9,
                  child: Chewie(
                    controller: chewieController!,

                  ),
                ),
              )
            : const AspectRatio(
                aspectRatio: 16 / 9,
                child: CupertinoActivityIndicator(radius: 18, color: primaryColor),
              ),
      ),
    );
  }
}
