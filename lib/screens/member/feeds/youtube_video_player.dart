import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mrwebbeast/core/services/api/exception_handler.dart';

import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../core/constant/colors.dart';

class YoutubeVideoPlayerCard extends StatefulWidget {
  const YoutubeVideoPlayerCard({super.key, this.url, this.borderRadius, this.showControls, this.onCompleted,this.aspectRatio,this.backGroundColor});

  final String? url;
  final double? borderRadius;
  final bool? showControls;
  final bool? backGroundColor;
  final double? aspectRatio;
  final GestureTapCallback? onCompleted;

  @override
  State<YoutubeVideoPlayerCard> createState() => _YoutubeVideoPlayerCardState();
}

class _YoutubeVideoPlayerCardState extends State<YoutubeVideoPlayerCard> {
  YoutubePlayerController? controller;
  late String? url = widget.url;
  late double? borderRadius = widget.borderRadius;
  late bool showControls = widget.showControls ?? true;
  late GestureTapCallback? onCompleted = widget.onCompleted;

  @override
  void initState() {
    super.initState();
    try {
      controller = YoutubePlayerController(
        params:  YoutubePlayerParams(
          mute: false,
          showControls: showControls,
          showFullscreenButton: false,
        ),
      );

      controller?.loadVideo('$url');

      controller?.pauseVideo();
    } catch (e, s) {
      ErrorHandler.catchError(e, s, false);
    }

    debugPrint('Loading ytVideoPlayer...');
    // controller.setFullScreenListener((value) {
    //   debugPrint("YoutubePlayer FullScreen :- $value");
    //   if (value == true) {
    //   } else {}
    // });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            YoutubePlayer(
              controller: controller!,
              aspectRatio:widget.aspectRatio?? 16 / 9,
              backgroundColor:widget.backGroundColor==false? Colors.grey.shade200:null,
              enableFullScreenOnVerticalDrag: false,
            ),
            if (controller != null && onCompleted != null)
              VideoPositionIndicator(
                controller: controller,
                onCompleted: onCompleted ,
              ),
          ],
        ),
      )
          : const AspectRatio(
        aspectRatio: 16 / 9,
        child: CupertinoActivityIndicator(radius: 18, color: primaryColor),
      ),
    );
  }
}

class VideoPositionIndicator extends StatefulWidget {
  const VideoPositionIndicator({
    super.key,
    required this.controller,
    this.onCompleted,
  });

  final YoutubePlayerController? controller;
  final GestureTapCallback? onCompleted;

  @override
  State<VideoPositionIndicator> createState() => _VideoPositionIndicatorState();
}

class _VideoPositionIndicatorState extends State<VideoPositionIndicator> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<YoutubeVideoState>(
      stream: widget.controller?.videoStateStream,
      initialData: const YoutubeVideoState(),
      builder: (context, snapshot) {
        Duration? position = snapshot.data?.position;
        final currentPosition = position?.inSeconds ?? 0;

        return StreamBuilder(
          stream: widget.controller?.duration.asStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              int? totalDuration = snapshot.data?.toInt();
              Duration duration = Duration(seconds: (totalDuration ?? 0).toInt());
              bool isCompleted = ((currentPosition == totalDuration) && currentPosition > 0);

              if (isCompleted ) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  widget.onCompleted?.call();
                  widget.controller?.nextVideo();
                });
              }
              return Container(
                decoration: BoxDecoration(color: isCompleted ? Colors.green : null),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: totalDuration == 0 ? 0 : currentPosition / (totalDuration ?? 0),
                      minHeight: 1,
                      color: isCompleted ? Colors.white : Colors.green,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$currentPosition sec',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                          ),
                          if (isCompleted) const Text('Completed'),
                          Text(
                            '$totalDuration sec',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Loading... ',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                  CupertinoActivityIndicator(),
                ],
              );
            }
          },
        );
      },
    );
  }
}
