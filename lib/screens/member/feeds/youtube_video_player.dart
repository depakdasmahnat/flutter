import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/services/api/exception_handler.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../core/constant/colors.dart';

class YoutubeVideoPlayerCard extends StatefulWidget {
  const YoutubeVideoPlayerCard({super.key, this.url, this.borderRadius,this.backGroundColor,this.aspectRatio});

  final String? url;
  final double? borderRadius;
  final bool? backGroundColor;
  final double? aspectRatio ;

  @override
  State<YoutubeVideoPlayerCard> createState() => _YoutubeVideoPlayerCardState();
}

class _YoutubeVideoPlayerCardState extends State<YoutubeVideoPlayerCard> {
  YoutubePlayerController? controller;
  late String? url = widget.url;
  late double? borderRadius = widget.borderRadius;

  @override
  void initState() {
    super.initState();
    try {
      controller = YoutubePlayerController(

        params: const YoutubePlayerParams(
          mute: false,

          showControls: false,
          showFullscreenButton: true,
        ),




      );

      controller?.loadVideo('$url');

      controller?.pauseVideo();


    } catch (e, s) {
      ErrorHandler.catchError(e, s, false);
    }


    // controller.setFullScreenListener((value) {
    //   debugPrint("YoutubePlayer FullScreen :- $value");
    //   if (value == true) {
    //   } else {}
    // });
  }

  @override
  Widget build(BuildContext context) {
    return
      VisibilityDetector(
      key: const ObjectKey('ytVideoPlayer'),

      onVisibilityChanged: (visibility) async {
        var visiblePercentage = visibility.visibleFraction * 100;
        if (visiblePercentage >= 80 && mounted) {
          controller?.playVideo();
        } else {
          controller?.pauseVideo();
        }
      },

      child: controller != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              child:YoutubePlayer(
                controller: controller!,
                aspectRatio:widget.aspectRatio?? 16 / 9,
                backgroundColor: widget.backGroundColor==true?null:Colors.grey.shade200,
                enableFullScreenOnVerticalDrag: false,
              )
              // YoutubePlayer(
              //   controller: controller!,
              //   aspectRatio: 16 / 9,
              //   backgroundColor: Colors.grey.shade200,
              //   enableFullScreenOnVerticalDrag: false,
              // ),
            )
          : const AspectRatio(
              aspectRatio: 16 / 9,
              child: CupertinoActivityIndicator(radius: 18, color: primaryColor),
            ),
    );
  }
}
