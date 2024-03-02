import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart' show parse;
import 'package:mrwebbeast/core/constant/enums.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/screens/member/feeds/youtube_video_player.dart';
import 'package:mrwebbeast/utils/widgets/image_opener.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:mrwebbeast/utils/widgets/pdf_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../core/constant/gradients.dart';
import '../../../models/member/training/chapter_details_model.dart';
import '../feeds/chewie_video_player.dart';

class ChapterDetailsCard extends StatefulWidget {
  const ChapterDetailsCard({
    super.key,
    this.index,
    required this.data,
  });

  final int? index;
  final ChapterExercise? data;

  @override
  State<ChapterDetailsCard> createState() => _ChapterDetailsCardState();
}

class _ChapterDetailsCardState extends State<ChapterDetailsCard> {
  late ChapterExercise? data = widget.data;

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
      margin: const EdgeInsets.only(left: kPadding, right: kPadding, top: 8, bottom: 8),
      decoration: BoxDecoration(
        gradient: feedsCardGradient,
        border: Border.all(color: Colors.grey.shade900),
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
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
                        context.pushNamed(Routs.imageOpener,
                            extra: ImageOpener(networkImage: '${data?.file}'));
                      },
                    ),
                  )

                // else if (data?.fileType == FeedsFileType.image.value && data?.files.haveData == true)
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
                else if (data?.fileType == FeedsFileType.video.value && data?.file != null)
                  ChewieVideoPlayerCard(
                    url: '${data?.file}',
                    borderRadius: 18,
                  )
                else if (data?.fileType == FeedsFileType.youtubeVideo.value && data?.file != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                    child: YoutubeVideoPlayerCard(
                      url: '${data?.file}',
                      borderRadius: 18,
                    ),
                  )
                else if (data?.fileType == FeedsFileType.video.value && data?.files.haveData == true)
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: PageView.builder(
                      itemCount: data?.files?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      physics: const PageScrollPhysics(),
                      itemBuilder: (context, index) {
                        var file = data?.files?.elementAt(index);
                        return ChewieVideoPlayerCard(
                          url: '$file',
                          borderRadius: 18,
                        );
                      },
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
            if (data?.title != null || data?.description != null)
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
                    if (data?.description != null && data?.fileType == FeedsFileType.article.value)
                      showMoreDescription(
                        context: context,
                        description: parseHtmlToText(htmlString: '${data?.description}'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overFlow: TextOverflow.ellipsis,
                      )
                    else if (data?.description != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
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
                  ],
                ),
              )
          ],
        ),
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
              height: 18,
              width: 20,
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
