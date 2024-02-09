import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/screens/feeds/view_feed.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../controllers/dashboard_controller.dart';
import '../../models/feeds/feeds_model.dart';
import '../../route/route_paths.dart';

class YoutubeVideoCard extends StatefulWidget {
  const YoutubeVideoCard({Key? key, this.feed}) : super(key: key);
  final FeedsData? feed;

  @override
  State<YoutubeVideoCard> createState() => _YoutubeVideoCardState();
}

class _YoutubeVideoCardState extends State<YoutubeVideoCard> {
  late YoutubePlayerController controller;
  late FeedsData? feed = widget.feed;

  @override
  void initState() {
    DashboardController dashboardController = Provider.of<DashboardController>(context, listen: false);
    super.initState();
    controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: false,
      ),
    );
    controller.loadVideo("${feed?.description}");
    controller.pauseVideo();

    debugPrint("Loading knowledgeVideoPlayer...");
    // controller.setFullScreenListener((value) {
    //   context.pushNamed(Routs.viewFeed,
    //       extra: ViewFeed(
    //         id: feed?.id,
    //         youtubePlayerController: controller,
    //       ));
    //   debugPrint("YoutubePlayer FullScreen :- $value");
    //   if (value == true) {
    //   } else {}
    // });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const ObjectKey("knowledgeVideoPlayer"),
      onVisibilityChanged: (visibility) async {
        var visiblePercentage = visibility.visibleFraction * 100;
        if (visiblePercentage >= 80 && mounted) {
          controller.playVideo();
        } else {
          controller.pauseVideo();
        }
      },
      child: YoutubePlayer(
        controller: controller,
        aspectRatio: 16 / 9,
        backgroundColor: Colors.grey.shade200,
        enableFullScreenOnVerticalDrag: false,
      ),
    );
  }
}
