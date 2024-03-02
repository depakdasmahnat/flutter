import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../controllers/check_demo_controller/check_demo_controller.dart';
import '../../../core/constant/colors.dart';

class VideoPlayerCard extends StatefulWidget {
  const VideoPlayerCard({super.key, this.url, this.borderRadius,this.aspectRatio,this.type,this.demoId});
  final double? aspectRatio;
  final String? url;
  final bool? type;
  final String? demoId;

  final double? borderRadius;

  @override
  State<VideoPlayerCard> createState() => _VideoPlayerCardState();
}

class _VideoPlayerCardState extends State<VideoPlayerCard> {
  VideoPlayerController? videoPlayerController;
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
    videoPlayerController?.addListener(() {
      if (context.mounted) {
        setState(() {});
      }
    });
    playVideo();
  }

  Future<bool> playVideo() async {
    if (videoPlayerController?.value.isPlaying == true) {
      await videoPlayerController?.pause();
    } else {
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
        debugPrint(
            'Video Player visibility  ${visibility.key} is $visiblePercentage% visible & ${visibility.visibleFraction}');
      },
      child: Container(
        child: (videoPlayerController?.value.isInitialized == true)
            ? ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
                child: GestureDetector(
                  onTap:() {
                    if(widget.type==true){
                      context.read<CheckDemoController>().videoCount(context: context, demoId: '${widget.demoId}', );
                    }

                    playVideo();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: widget.aspectRatio??16 / 9,
                        child: VideoPlayer(videoPlayerController!),
                      ),
                      if (videoPlayerController?.value.isPlaying == false)
                        Icon(Icons.play_circle_filled_outlined, size: 56, color: Colors.grey.shade100)
                      else if (videoPlayerController?.value.isBuffering == true)
                        const CupertinoActivityIndicator(color: primaryColor),
                    ],
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
