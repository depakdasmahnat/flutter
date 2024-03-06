import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart' show parse;
import 'package:mrwebbeast/core/constant/enums.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/screens/member/feeds/video_player.dart';
import 'package:mrwebbeast/screens/member/feeds/youtube_video_player.dart';
import 'package:mrwebbeast/utils/widgets/image_opener.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:mrwebbeast/utils/widgets/pdf_viewer.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/feeds/feeds_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../core/constant/gradients.dart';
import '../../../models/feeds/feeds_data.dart';
import '../../../models/guest_Model/guestDemoModel.dart';
import 'chewie_video_player.dart';
import 'feed_detail.dart';

class FeedCard extends StatefulWidget {
  const FeedCard({
    super.key,
    this.index,
    this.resourceTitle,
    required this.data,
    this.isFeeds = true,
  });
  final int? index;
  final FeedsData? data;
  final bool? isFeeds;
  final String? resourceTitle;

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  late FeedsData? data = widget.data;
  late bool? isFeeds = widget.isFeeds;

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
    Size size = MediaQuery.sizeOf(context);
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
              if (data?.fileType == FeedsFileType.image.value && data?.file != null)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ImageView(
                    width: size.width,
                    borderRadiusValue: 18,
                    margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                    backgroundColor: Colors.transparent,
                    fit: BoxFit.cover,
                    networkImage: '${data?.file}',
                    onTap: () {
                      context.pushNamed(Routs.feedDetail, extra: FeedDetail(id: data?.id));
                      // context.pushNamed(Routs.imageOpener, extra: ImageOpener(networkImage: '${data?.file}'));
                    },
                  ),
                )
              else if (data?.fileType == FeedsFileType.image.value && data?.files.haveData == true)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: PageView.builder(
                    itemCount: data?.files?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    physics: const PageScrollPhysics(),
                    itemBuilder: (context, index) {
                      var image = data?.files?.elementAt(index);
                      return ImageView(
                        width: size.width,
                        borderRadiusValue: 18,
                        margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                        backgroundColor: Colors.transparent,
                        fit: BoxFit.cover,
                        networkImage: '$image',
                      );
                    },
                  ),
                )
              else if (data?.fileType == FeedsFileType.video.value && data?.file != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                  child: ChewieVideoPlayerCard(
                    url: '${data?.file}',
                    borderRadius: 18,
                  ),
                )
              else if (data?.fileType == FeedsFileType.youtubeVideo.value && data?.file != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                  child: YoutubeVideoPlayerCard(
                    url: '${data?.file}',
                    borderRadius: 18,
                  ),
                )
              else if (data?.fileType == FeedsFileType.pdf.value && data?.file != null)
                ImageView(
                  height: 150,
                  borderRadiusValue: 18,
                  margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                  backgroundColor: Colors.transparent,
                  fit: BoxFit.cover,
                  assetImage: AppAssets.pdfIcon,
                  onTap: () {
                    context.pushNamed(Routs.feedDetail, extra: FeedDetail(id: data?.id));
                    // context.pushNamed(Routs.viewPdf, extra: PDFViewer(pdfUrl: '${data?.file}',
                    //     ));
                  },
                )
              else if (data?.file != null)
                ImageView(
                  height: 150,
                  borderRadiusValue: 18,
                  margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                  backgroundColor: Colors.transparent,
                  fit: BoxFit.cover,
                  assetImage: AppAssets.fileIcon,
                  onTap: () {
                    launchUrl(Uri.parse('${data?.file}'));
                  },
                )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                if (data?.title != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${data?.title}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),

                if (data?.description != null && data?.fileType == FeedsFileType.article.value)
                  showMoreDescription(
                    context: context,
                    description: parseHtmlToText(htmlString: '${data?.description}'),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 3,
                    overFlow: TextOverflow.ellipsis,
                  )
                else if (data?.description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Text(
                      '${data?.description}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                if (isFeeds == true)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12, top: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (data?.isLiked == null)
                              Container(
                                height: 18,
                                width: 24,
                                margin: const EdgeInsets.only(
                                  right: kPadding,
                                ),
                                child: const CupertinoActivityIndicator(),
                              )
                            else
                              FeedMenu(
                                icon: data?.isLiked == true ? AppAssets.heartFilledIcon : AppAssets.heartIcon,
                                value: data?.likes,
                                onTap: () async {
                                  await context.read<FeedsController>().manageWishList(
                                        feedId: data?.id,
                                        inWishList: data?.isLiked == true,
                                      );
                                },
                              ),
                            // const SizedBox(
                            //   width: 10,
                            // ),
                            // FeedMenu(
                            //   icon: AppAssets.chatIcon,
                            //   value: data?.comments,
                            // ),
                            const SizedBox(
                              width: 10,
                            ),

                            FeedMenu(
                              icon: AppAssets.shareIcon,
                              onTap: () {
                                Share.share('${data?.title ?? ''}\n${data?.file ?? ''}');
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            if(data?.downloadAndSharePermission==true)
                             FeedMenu(
                              onTap: () {
                                launchUrl(Uri.parse('${data?.file}'));
                              },
                              icon: AppAssets.fileDownload,
                            ),
                          ],
                        ),
                        // const FeedMenu(
                        //   lastMenu: true,
                        //   icon: AppAssets.bookmarkIcon,
                        // ),
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

  Widget showMoreDescription({
    required BuildContext context,
    required String? description,
    TextStyle? style,
    int? maxLines,
    TextOverflow? overFlow,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        maxLines: maxLines,
        overflow: overFlow ?? TextOverflow.clip,
        text: TextSpan(
          children: [
            TextSpan(
              text: '$description',
              style: style ??
                  TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade200,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            // const TextSpan(
            //   text: "Show More",
            //   style: TextStyle(
            //     fontSize: 12,
            //     color: primaryColor,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ],
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
  final num? value;
  final bool? lastMenu;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: lastMenu != true ? kPadding : 0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageView(
              height: 25,
              width: 27,
              borderRadiusValue: 0,
              color: Colors.white,
              margin: const EdgeInsets.only(right: 6),
              fit: BoxFit.contain,
              onTap: null,
              assetImage: icon,
            ),
            if (value != null)
              Text(
                '$value',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
          ],
        ),
      ),
    );
  }
}

String parseHtmlToText({required String htmlString}) {
  final document = parse(htmlString);
  final String parsedText = parse(document.body!.text).documentElement!.text;
  return parsedText;
}

class FeedCardForDemo extends StatefulWidget {
  const FeedCardForDemo({
    super.key,
    this.index,
    required this.data,
    this.isFeeds = true,
  });

  final int? index;
  final DataForDemo? data;
  final bool? isFeeds;

  @override
  State<FeedCardForDemo> createState() => _FeedCardForDemoState();
}

class _FeedCardForDemoState extends State<FeedCardForDemo> {
  late DataForDemo? data = widget.data;
  late bool? isFeeds = widget.isFeeds;

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
    Size size = MediaQuery.sizeOf(context);

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
              if (data?.fileType == 'Image')
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ImageView(
                    width: size.width,
                    borderRadiusValue: 18,
                    margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                    backgroundColor: Colors.transparent,
                    fit: BoxFit.cover,
                    networkImage: '${data?.file}',
                    onTap: () {
                      context.pushNamed(Routs.imageOpener, extra: ImageOpener(networkImage: '${data?.file}'));
                    },
                  ),
                )
              // else if (data?.fileType == FeedsFileType.image.value  )
              //   AspectRatio(
              //     aspectRatio: 16 / 9,
              //     child: PageView.builder(
              //       itemCount: data?.files?.length ?? 0,
              //       scrollDirection: Axis.horizontal,
              //       physics: const PageScrollPhysics(),
              //       itemBuilder: (context, index) {
              //         var image = data?.files?.elementAt(index);
              //
              //         return ImageView(
              //           width: size.width,
              //           borderRadiusValue: 18,
              //           margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
              //           backgroundColor: Colors.transparent,
              //           fit: BoxFit.cover,
              //           networkImage: '$image',
              //         );
              //       },
              //     ),
              //   )
              else if (data?.fileType == 'Video')
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                  child: ChewieVideoPlayerCard(
                    url: '${data?.file}',
                    borderRadius: 18,
                  ),
                )
              else if (data?.fileType == FeedsFileType.youtubeVideo.value && data?.file != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                  child: YoutubeVideoPlayerCard(
                    url: '${data?.file}',
                    borderRadius: 18,
                  ),
                )
              else if (data?.fileType == 'PDF' && data?.file != null)
                ImageView(
                  height: 150,
                  borderRadiusValue: 18,
                  margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                  backgroundColor: Colors.transparent,
                  fit: BoxFit.cover,
                  assetImage: AppAssets.pdfIcon,
                  onTap: () {
                    context.pushNamed(Routs.viewPdf,
                        extra: PDFViewer(
                          pdfUrl: '${data?.file}',
                        ));
                  },
                )
              else if (data?.file != null)
                ImageView(
                  height: 150,
                  borderRadiusValue: 18,
                  margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                  backgroundColor: Colors.transparent,
                  fit: BoxFit.cover,
                  assetImage: AppAssets.fileIcon,
                  onTap: () {
                    launchUrl(Uri.parse('${data?.file}'));
                  },
                )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data?.title != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${data?.title}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                // if (data?.description != null && data?.fileType == FeedsFileType.article.value)
                //   showMoreDescription(
                //     context: context,
                //     description: parseHtmlToText(htmlString: '${data?.description}'),
                //
                //     style: const TextStyle(
                //       // height: ,
                //       fontWeight: FontWeight.w400,
                //     ),
                //     maxLines: 2,
                //
                //     overFlow: TextOverflow.ellipsis,
                //   )
                // else if (data?.description != null)
                //   Padding(
                //     padding: const EdgeInsets.only(top: 10,bottom: 5),
                //     child: Text(
                //       '${data?.description}',
                //       style: const TextStyle(
                //         color: Colors.grey,
                //         fontSize: 13,
                //
                //         fontWeight: FontWeight.w400,
                //       ),
                //       textAlign: TextAlign.start,
                //     ),
                //   ),
                // if (isFeeds == true)
                //   Padding(
                //     padding: const EdgeInsets.only(bottom: 12,top: 3),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Row(
                //           children: [
                //             if (data?.isLiked == null)
                //               Container(
                //                 height: 18,
                //                 width: 24,
                //                 margin: const EdgeInsets.only(right: kPadding,),
                //                 child: const CupertinoActivityIndicator(),
                //               )
                //             else
                //               FeedMenu(
                //                 icon: data?.isLiked == true ? AppAssets.heartFilledIcon : AppAssets.heartIcon,
                //                 value: data?.likes,
                //                 onTap: () async {
                //                   await context.read<FeedsController>().manageWishList(
                //                     feedId: data?.id,
                //                     inWishList: data?.isLiked == true,
                //                   );
                //                 },
                //               ),
                //             const SizedBox(
                //               width: 10,
                //             ),
                //             FeedMenu(
                //               icon: AppAssets.chatIcon,
                //               value: data?.comments,
                //             ),
                //             const SizedBox(
                //               width: 10,
                //             ),
                //             FeedMenu(
                //               icon: AppAssets.shareIcon,
                //               onTap: () {
                //                 Share.share('${data?.title ?? ''}\n${data?.file ?? ''}');
                //               },
                //             ),
                //           ],
                //         ),
                //         // const FeedMenu(
                //         //   lastMenu: true,
                //         //   icon: AppAssets.bookmarkIcon,
                //         // ),
                //       ],
                //     ),
                //   ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget showMoreDescription({
    required BuildContext context,
    required String? description,
    TextStyle? style,
    int? maxLines,
    TextOverflow? overFlow,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        maxLines: maxLines,
        overflow: overFlow ?? TextOverflow.clip,
        text: TextSpan(
          children: [
            TextSpan(
              text: '$description',
              style: style ??
                  TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade200,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            // const TextSpan(
            //   text: "Show More",
            //   style: TextStyle(
            //     fontSize: 12,
            //     color: primaryColor,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
