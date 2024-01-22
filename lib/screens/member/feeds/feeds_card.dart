import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/constant.dart';
import '../../../core/constant/gradients.dart';
import '../../../models/feeds/feeds_model.dart';

class FeedCard extends StatefulWidget {
  const FeedCard({
    super.key,
    required this.index,
    required this.data,
  });

  final int index;
  final FeedsData data;

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  VideoPlayerController? videoPlayerController;
  late FeedsData? data = widget.data;

  Future initVideo() async {
    disposeVideo();
    if (data?.videoUrl != null) {
      debugPrint('data?.videoUrl ${data?.videoUrl}');

      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse('${data?.videoUrl}'));
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
      decoration: BoxDecoration(
        gradient: feedsCardGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data?.images.haveData == true)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data?.images?.length ?? 0,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  physics: const PageScrollPhysics(),
                  itemBuilder: (context, index) {
                    var image = data?.images?.elementAt(index);

                    return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ImageView(
                        borderRadiusValue: 16,
                        margin: EdgeInsets.zero,
                        fit: BoxFit.contain,
                        assetImage: '${image}',
                      ),
                    );
                  },
                ),
              ),
            )
          else if (data?.videoUrl != null)
            videoPlayerWidget(),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data?.title}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    '12 hr',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          FeedMenu(
                            icon: AppAssets.heartIcon,
                            value: '3',
                          ),
                          FeedMenu(
                            icon: AppAssets.chatIcon,
                            value: '12K',
                          ),
                          FeedMenu(
                            icon: AppAssets.shareIcon,
                          ),
                        ],
                      ),
                      FeedMenu(
                        lastMenu: true,
                        icon: AppAssets.bookmarkIcon,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget videoPlayerWidget() {
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
                borderRadius: BorderRadius.circular(8),
                child: GestureDetector(
                  onTap: () {
                    playVideo();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
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

class FeedMenu extends StatelessWidget {
  const FeedMenu({
    super.key,
    required this.icon,
    this.value,
    this.onTap,
    this.lastMenu,
  });

  final String icon;
  final String? value;
  final bool? lastMenu;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: lastMenu != true ? kPadding : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageView(
            height: 20,
            width: 20,
            borderRadiusValue: 0,
            color: Colors.white,
            margin: const EdgeInsets.only(right: 4),
            fit: BoxFit.contain,
            onTap: onTap,
            assetImage: icon,
          ),
          if (value != null)
            Text(
              '$value',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
        ],
      ),
    );
  }
}
