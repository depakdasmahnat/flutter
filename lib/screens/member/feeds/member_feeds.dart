import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/controllers/feeds/feeds_controller.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/screens/member/feeds/feeds_card.dart';
import 'package:mrwebbeast/utils/widgets/custom_text_field.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';
import '../../../models/feeds/feeds_data.dart';
import '../../../models/guest_Model/fetchfeedcategoriesmodel.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import 'feed_detail.dart';

class MemberFeeds extends StatefulWidget {
  const MemberFeeds({
    super.key,
  });

  @override
  State<MemberFeeds> createState() => _MemberFeedsState();
}

class _MemberFeedsState extends State<MemberFeeds> {
  TextEditingController searchController = TextEditingController();
  List<FeedsData>? feeds;

  Future fetchFeeds({bool? loadingNext}) async {
    return await context.read<FeedsController>().fetchFeeds(
          context: context,
          isRefresh: loadingNext == true ? false : true,
          loadingNext: loadingNext ?? false,
          categoryId: selectedFilter?.id,
          searchKey: searchController.text,
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<GuestControllers>().fetchFeedCategories(context: context);
      fetchFeeds();
    });
  }

  FeedCategory? selectedFilter;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Feeds'),
      ),
      body: Consumer<FeedsController>(
        builder: (context, controller, child) {
          feeds = controller.feeds;

          return SmartRefresher(
            controller: controller.feedsController,
            enablePullUp: true,
            enablePullDown: true,
            onRefresh: () async {
              if (mounted) {
                await fetchFeeds();
              }
            },
            onLoading: () async {
              if (mounted) {
                await fetchFeeds(loadingNext: true);
              }
            },
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: bottomNavbarSize),
              children: [
                CustomTextField(
                  hintText: 'Search',
                  controller: searchController,
                  hintStyle: const TextStyle(color: Colors.white),
                  prefixIcon: ImageView(
                    height: 20,
                    width: 20,
                    borderRadiusValue: 0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(left: kPadding, right: kPadding),
                    fit: BoxFit.contain,
                    assetImage: AppAssets.searchIcon,
                    onTap: () {
                      fetchFeeds();
                    },
                  ),
                  onEditingComplete: () {
                    fetchFeeds();
                  },
                  margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                ),
                Consumer<GuestControllers>(
                  builder: (context, value, child) {
                    return SizedBox(
                      height: 40,
                      child: Center(
                        child: ListView.builder(
                          itemCount: value.fetchFeedCategoriesModel?.data?.length ?? 0,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: kPadding),
                          itemBuilder: (context, index) {
                            var data = value.fetchFeedCategoriesModel?.data?.elementAt(index);
                            // bool isSelected = selectedFilter == data;
                            return GradientButton(
                              backgroundGradient:
                                  selectedFilter?.id == data?.id ? primaryGradient : inActiveGradient,
                              borderWidth: 2,
                              borderRadius: 30,
                              onTap: () {
                                selectedFilter = data;
                                setState(() {});
                                fetchFeeds();
                              },
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 8),
                              child: Text(
                                '${data?.name}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: selectedFilter?.id == data?.id ? Colors.black : Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                if (controller.loadingFeeds)
                  const LoadingScreen(
                    heightFactor: 0.7,
                    message: 'Loading Feeds...',
                  )
                else if (feeds.haveData)
                  ListView.builder(
                    itemCount: feeds?.length ?? 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var data = feeds?.elementAt(index);
                      return InkWell(
                        onTap: () {
                          context.pushNamed(Routs.feedDetail, extra: FeedDetail(id: data?.id));
                        },
                        child: FeedCard(
                          index: index,
                          data: data,
                        ),
                      );
                    },
                  )
                else
                  NoDataFound(
                    heightFactor: 0.7,
                    message: controller.feedsModel?.message ?? 'No Feeds Found',
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
