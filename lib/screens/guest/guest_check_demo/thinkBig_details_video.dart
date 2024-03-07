// import 'package:flutter/cupertino.dart';
//
// import '../../../models/guest_Model/fetchDemoVideosAfter.dart';
// import '../../member/feeds/chewie_video_player.dart';
//
// class DemoVideoCard extends StatefulWidget {
//   const DemoVideoCard({
//     super.key,
//     this.index,
//     required this.data,
//     this.isFeeds = true,
//   });
//
//   final int? index;
//   final FetchDemoVideosAfter? data;
//   final bool? isFeeds;
//
//   @override
//   State<DemoVideoCard> createState() => _DemoVideoCardState();
// }
//
// class _DemoVideoCardState extends State<DemoVideoCard> {
//   late FetchDemoVideosAfter? data = widget.data;
//   late bool? isFeeds = widget.isFeeds;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.sizeOf(context);
//     return
//       Stack(
//       children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//
//             // ChewieVideoPlayerCard(
//             //   url: '${controller.fetchDemoVideosAfter?.data?[index].videoLink}',
//             //   borderRadius: 18,
//             // )
//
//
//
//
//
//           ],
//         ),
//         if (isFeeds == true)
//           Positioned(
//             bottom: 10,
//             left: 8,
//             right: 8,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (data?.title != null)
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 10),
//                             child: Text(
//                               '${data?.title}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                               textAlign: TextAlign.start,
//                             ),
//                           ),
//                         if (data?.description != null && data?.fileType == FeedsFileType.article.value)
//                           showMoreDescription(
//                             context: context,
//                             description: parseHtmlToText(htmlString: '${data?.description}'),
//                             style: const TextStyle(
//                               color: Colors.grey,
//                               fontSize: 13,
//                               fontWeight: FontWeight.w400,
//                             ),
//                             maxLines: 3,
//                             overFlow: TextOverflow.ellipsis,
//                           )
//                         else if (data?.description != null)
//                           Padding(
//                             padding: const EdgeInsets.only(top: 10, bottom: 5),
//                             child: Text(
//                               '${data?.description}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               textAlign: TextAlign.start,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 12, top: 3),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         children: [
//                           if (data?.isLiked == null)
//                             Container(
//                               height: 18,
//                               width: 24,
//                               margin: const EdgeInsets.only(
//                                 bottom: kPadding,
//                               ),
//                               child: const CupertinoActivityIndicator(),
//                             )
//                           else
//                             FeedMenu(
//                               icon: data?.isLiked == true ? AppAssets.heartFilledIcon : AppAssets.heartIcon,
//                               value: data?.likes,
//                               onTap: () async {
//                                 await context.read<FeedsController>().manageWishList(
//                                   feedId: data?.id,
//                                   inWishList: data?.isLiked == true,
//                                 );
//                               },
//                             ),
//                           // const SizedBox(
//                           //   width: 10,
//                           // ),
//                           // FeedMenu(
//                           //   icon: AppAssets.chatIcon,
//                           //   value: data?.comments,
//                           // ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           FeedMenu(
//                             icon: AppAssets.shareIcon,
//                             onTap: () {
//                               Share.share('${data?.title ?? ''}\n${data?.file ?? ''}');
//                             },
//                           ),
//                         ],
//                       ),
//                       // const FeedMenu(
//                       //   lastMenu: true,
//                       //   icon: AppAssets.bookmarkIcon,
//                       // ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget showMoreDescription({
//     required BuildContext context,
//     required String? description,
//     TextStyle? style,
//     int? maxLines,
//     TextOverflow? overFlow,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: RichText(
//         maxLines: maxLines,
//         overflow: overFlow ?? TextOverflow.clip,
//         text: TextSpan(
//           children: [
//             TextSpan(
//               text: '$description',
//               style: style ??
//                   TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey.shade200,
//                     fontWeight: FontWeight.w400,
//                   ),
//             ),
//             // const TextSpan(
//             //   text: "Show More",
//             //   style: TextStyle(
//             //     fontSize: 12,
//             //     color: primaryColor,
//             //     fontWeight: FontWeight.bold,
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }