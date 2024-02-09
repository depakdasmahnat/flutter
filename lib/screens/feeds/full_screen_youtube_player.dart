import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../controllers/dashboard_controller.dart';

class FullScreenYoutubeVideoCard extends StatefulWidget {
  const FullScreenYoutubeVideoCard({Key? key, this.url, this.controller}) : super(key: key);
  final String? url;
  final YoutubePlayerController? controller;

  @override
  State<FullScreenYoutubeVideoCard> createState() => _FullScreenYoutubeVideoCardState();
}

class _FullScreenYoutubeVideoCardState extends State<FullScreenYoutubeVideoCard> {
  YoutubePlayerController? controller;
  bool? hideFullScreenVideo;

  @override
  void initState() {
    DashboardController dashboardController = Provider.of<DashboardController>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.controller == null) {
        controller = YoutubePlayerController(
          params: const YoutubePlayerParams(
            mute: false,
            showControls: true,
            showFullscreenButton: true,
          ),
        );
        controller?.loadVideo("${widget.url}");
        controller?.setFullScreenListener((value) {
          dashboardController.changFullScreenVideo();
          debugPrint("YoutubePlayer FullScreen :- $value");
          if (value == true) {
          } else {}
        });
      } else {
        controller = widget.controller!;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    DashboardController dashboardController = Provider.of<DashboardController>(context);
    Size size = MediaQuery.of(context).size;
    hideFullScreenVideo = dashboardController.fullScreenVideo;
    return (controller != null)
        ? SizedBox(
            height: hideFullScreenVideo == false ? null : size.height,
            width: hideFullScreenVideo == false ? null : size.width,
            child: YoutubePlayerScaffold(
              controller: controller!,
              aspectRatio: 16 / 9,
              backgroundColor: Colors.grey.shade200,
              enableFullScreenOnVerticalDrag: false,
              builder: (context, player) {
                return VisibilityDetector(
                  key: const ObjectKey("feedsPlayer"),
                  onVisibilityChanged: (visibility) {
                    var visiblePercentage = visibility.visibleFraction * 100;
                    if (visiblePercentage >= 80 && mounted) {
                      controller?.playVideo();
                    } else {
                      controller?.stopVideo();
                    }
                  },
                  child: player,
                );
              },
            ),
          )
        : const SizedBox();
  }
}
