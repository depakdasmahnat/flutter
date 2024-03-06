import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mrwebbeast/core/constant/enums.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/services/database/local_database.dart';
import 'package:mrwebbeast/screens/member/feeds/feeds_card.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../controllers/feeds/feeds_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../models/feeds/comments_model.dart';
import '../../../models/feeds/feeds_data.dart';
import '../../../utils/widgets/image_view.dart';
import 'feed_details_card.dart';

class FeedDetail extends StatefulWidget {
  const FeedDetail({super.key, this.id});

  final num? id;

  @override
  State<FeedDetail> createState() => _FeedDetailState();
}

class _FeedDetailState extends State<FeedDetail> {
  late num? id = widget.id;
  List<FeedsData>? feedDetails;

  Future fetchFeedDetails({bool? loadingNext}) async {
    return await context.read<FeedsController>().fetchFeedsDetails(
          context: context,
          isRefresh: loadingNext == true ? false : true,
          loadingNext: loadingNext ?? false,
          feedId: id,
        );
  }

  List<CommentsData>? comments;
  TextEditingController commentCtrl = TextEditingController();
  PageController pageController = PageController();

  Future fetchComments({bool? loadingNext}) async {
    return await context.read<FeedsController>().fetchComments(
          context: context,
          feedId: id,
          isRefresh: loadingNext == true ? false : true,
          loadingNext: loadingNext ?? false,
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchFeedDetails();
      fetchComments();
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LocalDatabase localDatabase = Provider.of<LocalDatabase>(context);
    return Scaffold(
      appBar: AppBar(
        leading: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomBackButton(),
          ],
        ),
        title: const Text('Social'),
      ),
      body: Consumer<FeedsController>(
        builder: (context, controller, child) {
          feedDetails = controller.feedsDetails;
          comments = controller.comments;
          return PageView.builder(
            controller: pageController,
            itemCount: feedDetails?.length ?? 0,
            scrollDirection: Axis.vertical,
            physics: const PageScrollPhysics(),
            onPageChanged: (int page) async {
              if (mounted) {
                await fetchComments(loadingNext: true);
              }
            },
            itemBuilder: (context, index) {
              var feedDetail = feedDetails?.elementAt(index);
              return (controller.loadingFeedsDetails)
                  ? const LoadingScreen()
                  : (feedDetails != null)
                      ? FeedDetailsCard(data: feedDetail)
                      : const NoDataFound();
            },
          );
        },
      ),
    );
  }
}

// if (comments.haveData == true)
//   ListView.builder(
//     itemCount: comments?.length ?? 0,
//     shrinkWrap: true,
//     physics: const NeverScrollableScrollPhysics(),
//     padding: const EdgeInsets.only(top: 8, bottom: 50),
//     itemBuilder: (context, index) {
//       var data = comments?.elementAt(index);
//
//       return Padding(
//         padding: const EdgeInsets.all(kPadding),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             ImageView(
//               height: 33,
//               width: 33,
//               networkImage: '${data?.profilePicture}',
//               isAvatar: true,
//               margin: const EdgeInsets.only(right: kPadding),
//             ),
//             SizedBox(
//               width: size.width * 0.02,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   '${data?.guestFirstName} ${data?.guestLastName}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   textAlign: TextAlign.start,
//                 ),
//                 Text(
//                   '${data?.comment}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                   ),
//                   textAlign: TextAlign.start,
//                 ),
//               ],
//             )
//           ],
//         ),
//       );
//     },
//   )
