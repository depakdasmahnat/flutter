import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/screens/member/feeds/video_player.dart';
import 'package:mrwebbeast/screens/member/feeds/youtube_video_player.dart';
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
  late FeedsData? data = widget.data;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          Column(
            children: [
              if (data?.images.haveData == true)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: AspectRatio(
                    aspectRatio: 16 / 8,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data?.images?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      physics: const PageScrollPhysics(),
                      itemBuilder: (context, index) {
                        var image = data?.images?.elementAt(index);

                        return AspectRatio(
                          aspectRatio: 16 / 8,
                          child: ImageView(
                            borderRadiusValue: 18,
                            margin: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            fit: BoxFit.cover,
                            assetImage: '$image',
                          ),
                        );
                      },
                    ),
                  ),
                )
              else if (data?.videoUrl != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: VideoPlayerCard(
                    url: '${data?.videoUrl}',
                    borderRadius: 18,
                  ),
                )
              else if (data?.youtubeUrl != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: YoutubeVideoPlayerCard(
                    url: '${data?.youtubeUrl}',
                    borderRadius: 18,
                  ),
                ),
            ],
          ),
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
