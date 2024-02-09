import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/screens/feeds/utils/feed_images.dart';
import 'package:gaas/screens/feeds/view_feed.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../controllers/feeds_controller.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../core/functions.dart';
import '../../../models/feeds/feeds_model.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/description_text.dart';
import '../../../utils/widgets/image_view.dart';
import '../youtube_player.dart';
import 'qna_card.dart';

class FeedCard extends StatelessWidget {
  const FeedCard({
    super.key,
    this.padding,
    this.onTap,
    this.margin,
    this.borderRadius,
    this.boxShadow,
    this.feed,
  });

  final FeedsData? feed;

  final EdgeInsets? padding;
  final double? borderRadius;
  final EdgeInsets? margin;
  final List<BoxShadow>? boxShadow;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int faqShowLimit = 2;
    int faqLength = (feed?.faq?.length ?? 0);

    FeedsController controller = Provider.of<FeedsController>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: boxShadow,
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap ??
            () {
              context.pushNamed(Routs.viewFeed,
                  extra: ViewFeed(
                    id: feed?.id,
                  ));
            },
        child: Column(
          children: [
            Padding(
              padding: padding ?? const EdgeInsets.symmetric(vertical: 18),
              child: Column(
                children: [
                  Padding(
                    padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageView(
                          height: 35,
                          width: 35,
                          borderRadiusValue: 30,
                          fit: BoxFit.cover,
                          backgroundColor: Colors.white,
                          networkImage: "${feed?.creatorDetail?.profilePic}",
                          isAvatar: true,
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
                                    child:      AutoSizeText(

                                      "${feed?.creatorDetail?.name}",

                                      style: TextStyle(

                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: GoogleFonts.mulish().fontStyle,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (feed?.creatorDetail?.isVerified == true)
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
                                    child: AutoSizeText(
                                      minFontSize: 12,
                                      maxFontSize: 14,
                                      "${feed?.creatorDetail?.address}",
                                      style: const TextStyle(

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
                  if (feed?.files.haveData == true) FeedImages(images: feed?.files),
                  if (feed?.description != null && feed?.fileType == FeedTypes.video.value)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: YoutubeVideoCard(feed: feed),
                    ),
                  Padding(
                    padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (feed?.title != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Text(
                              "${feed?.title}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontStyle: GoogleFonts.mulish().fontStyle,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor: TextScaleFactor.autoScale(context),
                            ),
                          ),
                        if (feed?.fileType == FeedTypes.faq.value)
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: faqLength >= faqShowLimit ? faqShowLimit : faqLength,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var faq = feed?.faq?[index];

                              return QNACard(
                                question: faq?.question,
                                answer: faq?.answer,
                              );
                            },
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (feed?.description != null && feed?.fileType == FeedTypes.article.value)
                                Flexible(
                                  child: showMoreDescription(
                                    context: context,
                                    description: parseHtmlToText(htmlString: "${feed?.description}"),
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: GoogleFonts.mulish().fontStyle,
                                    ),
                                    maxLines: 2,
                                    overFlow: TextOverflow.ellipsis,
                                  ),
                                )
                              else if (feed?.description != null && feed?.fileType != FeedTypes.video.value)
                                Flexible(
                                  child: showMoreDescription(
                                    context: context,
                                    description: "${feed?.description}",
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: GoogleFonts.mulish().fontStyle,
                                    ),
                                    maxLines: 2,
                                    overFlow: TextOverflow.ellipsis,
                                  ),
                                )
                              else if (faqLength >= faqShowLimit && feed?.fileType == FeedTypes.faq.value)
                                const Flexible(
                                  child: Text(
                                    "Show More",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              else
                                const SizedBox(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ImageView(
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.contain,
                                    assetImage: AppImages.send,
                                    onTap: () {
                                      context.read<FeedsController>().shareFeed(feed: feed);
                                    },
                                    margin: const EdgeInsets.only(right: 6),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: feed?.isLiked == null
                                        ? const CupertinoActivityIndicator(
                                            color: primaryColor,
                                          )
                                        : InkWell(
                                            onTap: () {
                                              FeedsController controller =
                                                  Provider.of<FeedsController>(context, listen: false);
                                              if (feed?.isLiked == true) {
                                                controller.removerWishList(
                                                    context: context, postId: feed?.id);
                                              } else {
                                                controller.addToWishList(context: context, postId: feed?.id);
                                              }
                                            },
                                            child: Column(
                                              children: [
                                                Icon(
                                                  feed?.isLiked == true
                                                      ? CupertinoIcons.heart_fill
                                                      : CupertinoIcons.heart,
                                                  size: 24,
                                                  color: primaryColor,
                                                ),
                                                if ((feed?.likes ?? 0) > 0)
                                                  Text(
                                                    "${feed?.likes}",
                                                    style: const TextStyle(color: Colors.black, fontSize: 10),
                                                  )
                                              ],
                                            ),
                                          ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 3, color: Colors.grey.shade200)
          ],
        ),
      ),
    );
  }

  Widget iconTag({
    required IconData? icon,
    required String? title,
    required Color? background,
    required Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 8,
            color: color,
          ),
          const SizedBox(width: 2),
          Text(
            "$title",
            style: TextStyle(
              fontSize: 8,
              color: color,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget storeDetail({
    required String? title,
    IconData? icon,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
      margin: const EdgeInsets.only(top: 6, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                (icon),
                size: 12,
                color: iconColor ?? Colors.grey.shade800,
              ),
            ),
          Text(
            "$title",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
