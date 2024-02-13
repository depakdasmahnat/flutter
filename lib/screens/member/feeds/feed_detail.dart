import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/enums.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/services/database/local_database.dart';
import 'package:mrwebbeast/screens/member/feeds/feeds_card.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../controllers/feeds/feeds_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../models/feeds/comments_model.dart';
import '../../../models/feeds/feeds_data.dart';
import '../../../utils/widgets/image_view.dart';

class FeedDetail extends StatefulWidget {
  const FeedDetail({super.key, this.id});

  final num? id;

  @override
  State<FeedDetail> createState() => _FeedDetailState();
}

class _FeedDetailState extends State<FeedDetail> {
  late num? id = widget.id;
  FeedsData? feedDetails;

  Future fetchFeedDetails({bool? loadingNext}) async {
    return await context.read<FeedsController>().fetchFeedDetails(feedId: id);
  }

  List<CommentsData>? comments;
  TextEditingController commentCtrl = TextEditingController();

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
        title: const Text('Details'),
      ),
      body: Consumer<FeedsController>(
        builder: (context, controller, child) {
          feedDetails = controller.feedDetails;
          comments = controller.comments;

          return SmartRefresher(
            controller: controller.commentsController,
            enablePullUp: true,
            enablePullDown: true,
            onRefresh: () async {
              if (mounted) {
                await fetchComments();
              }
            },
            onLoading: () async {
              if (mounted) {
                await fetchComments(loadingNext: true);
              }
            },
            child: ListView(
              shrinkWrap: true,
              children: [
                if (feedDetails != null)
                  FeedCard(data: feedDetails)
                else
                  Container(
                    height: 180,
                    margin: const EdgeInsets.only(bottom: kPadding),
                    child: const CupertinoActivityIndicator(),
                  ),
                if (comments.haveData == true)
                  ListView.builder(
                    itemCount: comments?.length ?? 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 50),
                    itemBuilder: (context, index) {
                      var data = comments?.elementAt(index);

                      return Padding(
                        padding: const EdgeInsets.all(kPadding),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ImageView(
                              height: 33,
                              width: 33,
                              networkImage: '${data?.profilePicture}',
                              isAvatar: true,
                              margin: const EdgeInsets.only(right: kPadding),
                            ),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${data?.guestFirstName} ${data?.guestLastName}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  '${data?.comment}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  )
              ],
            ),
          );
        },
      ),
      bottomSheet: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageView(
                height: 40,
                width: 40,
                borderRadiusValue: 50,
                fit: BoxFit.cover,
                isAvatar: true,
                networkImage: localDatabase.userRole == UserRoles.guest.value
                    ? '${localDatabase.guest?.profilePhoto}'
                    : '${localDatabase.member?.profilePhoto}',
                margin: const EdgeInsets.only(right: 4),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Color(0xFF383838)),
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: TextFormField(
                      controller: commentCtrl,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: kPadding),
                          hintText: '',
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  fetchFeedDetails();
                  await context
                      .read<FeedsController>()
                      .addComment(
                        context: context,
                        feedId: feedDetails?.id,
                        comment: commentCtrl.text,
                      )
                      .then((value) {
                    commentCtrl.clear();
                    setState(() {});
                  });
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF1B1B1B), Color(0xFF282828)],
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Image.asset(
                      AppAssets.sendIcon,
                      height: size.height * 0.02,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
