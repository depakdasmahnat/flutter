import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/screens/feeds/utils/feed_images.dart';
import 'package:gaas/screens/feeds/utils/qna_card.dart';
import 'package:gaas/screens/feeds/full_screen_youtube_player.dart';
import 'package:gaas/utils/widgets/data_widget_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../controllers/dashboard_controller.dart';
import '../../controllers/feeds_controller.dart';
import '../../core/config/app_images.dart';
import '../../core/constant/colors.dart';
import '../../core/constant/shadows.dart';
import '../../models/feeds/feeds_model.dart';
import '../../utils/widgets/image_view.dart';
import '../../utils/widgets/widgets.dart';

class ViewFeed extends StatefulWidget {
  const ViewFeed({Key? key, this.id, this.youtubePlayerController}) : super(key: key);
  final num? id;
  final YoutubePlayerController? youtubePlayerController;

  @override
  State<ViewFeed> createState() => _ViewFeedState();
}

class _ViewFeedState extends State<ViewFeed> {
  late num? id = widget.id;
  late YoutubePlayerController? youtubePlayerController = widget.youtubePlayerController;
  FeedsData? viewFeed;

  Future fetchFeeds() async {
    FeedsController controller = Provider.of<FeedsController>(context, listen: false);
    return controller.fetchViewFeed(postId: id, context: context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchFeeds();
    });
  }

  @override
  Widget build(BuildContext context) {
    DashboardController dashboardController = Provider.of<DashboardController>(context);
    Size size = MediaQuery.of(context).size;
    FeedsController controller = Provider.of<FeedsController>(context);
    viewFeed = controller.viewFeed;

    return WillPopScope(
      onWillPop: () async {
        dashboardController.changFullScreenVideo(value: false);
        return true;
      },
      child: Scaffold(
        backgroundColor: dashboardController.fullScreenVideo ? Colors.black : Colors.white,
        appBar: dashboardController.fullScreenVideo
            ? null
            : AppBar(
                title: Text(viewFeed?.title ?? "Details"),
                actions: [
                  Row(
                    children: [
                      ImageView(
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                        assetImage: AppImages.send,
                        onTap: () {
                          context.read<FeedsController>().shareFeed(feed: viewFeed);
                        },
                        margin: const EdgeInsets.only(right: 6),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, right: 16),
                        child: viewFeed?.isLiked == null
                            ? const CupertinoActivityIndicator(
                                color: primaryColor,
                              )
                            : InkWell(
                                onTap: () {
                                  FeedsController controller =
                                      Provider.of<FeedsController>(context, listen: false);
                                  if (viewFeed?.isLiked == true) {
                                    controller.removerWishList(context: context, postId: viewFeed?.id);
                                  } else {
                                    controller.addToWishList(context: context, postId: viewFeed?.id);
                                  }
                                },
                                child: Icon(
                                  viewFeed?.isLiked == true
                                      ? CupertinoIcons.heart_fill
                                      : CupertinoIcons.heart,
                                  size: 24,
                                  color: primaryColor,
                                ),
                              ),
                      )
                    ],
                  )
                ],
              ),
        body: DataWidgetBuilder(
          isLoading: controller.loadingViewFeed,
          haveData: viewFeed != null,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              if (dashboardController.fullScreenVideo == false)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageView(
                        height: 35,
                        width: 35,
                        borderRadiusValue: 30,
                        fit: BoxFit.cover,
                        backgroundColor: Colors.white,
                        networkImage: "${viewFeed?.creatorDetail?.profilePic}",
                        onTap: null,
                        boxShadow: primaryBoxShadow(),
                        margin: const EdgeInsets.only(right: 16),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    "${viewFeed?.creatorDetail?.name}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: GoogleFonts.mulish().fontStyle,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (viewFeed?.creatorDetail?.isVerified == true)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: Icon(
                                      Icons.verified_outlined,
                                      size: 18,
                                      color: primaryColor,
                                    ),
                                  )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    "${viewFeed?.creatorDetail?.address}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              if (viewFeed?.files?.haveData == true) FeedImages(images: viewFeed?.files),
              if (viewFeed?.description != null && viewFeed?.fileType == FeedTypes.video.value)
                if (dashboardController.fullScreenVideo == false)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: videoPlayer(),
                  )
                else
                  SizedBox(
                    height: size.height * 0.98,
                    width: size.width,
                    child: videoPlayer(),
                  ),
              if (dashboardController.fullScreenVideo == false)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      if (viewFeed?.description != null && viewFeed?.fileType == FeedTypes.article.value)
                        Text(
                          parseHtmlToText(htmlString: "${viewFeed?.description}"),
                          style: const TextStyle(fontSize: 12, color: Colors.black, height: 1.5),
                        )
                      else if (viewFeed?.description != null && viewFeed?.fileType != FeedTypes.video.value)
                        Text(
                          "${viewFeed?.description}",
                          style: const TextStyle(fontSize: 12, color: Colors.black, height: 1.5),
                        ),
                      if (viewFeed?.faq?.haveData == true)
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      "FAQs",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 3,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "Answers to the questions",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      if (viewFeed?.faq?.haveData == true)
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: viewFeed?.faq?.length ?? 0,
                          itemBuilder: (context, index) {
                            var faq = viewFeed?.faq?[index];

                            return QNACard(
                              question: faq?.question,
                              answer: faq?.answer,
                              showAnswer: index == 0 ? true : false,
                            );
                          },
                        ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget videoPlayer() {
    return FullScreenYoutubeVideoCard(
      url: "${viewFeed?.description}",
      controller: youtubePlayerController,
    );
  }
}
