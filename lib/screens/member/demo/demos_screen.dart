import 'package:flutter/material.dart';
import 'package:mrwebbeast/controllers/member/member_controller/member_controller.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/constant/constant.dart';
import '../../../models/feeds/feeds_data.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';
import '../../member/feeds/feeds_card.dart';

class DemosScreen extends StatefulWidget {
  const DemosScreen({super.key});

  @override
  State<DemosScreen> createState() => _DemosScreenState();
}

class _DemosScreenState extends State<DemosScreen> {
  List<FeedsData>? demos;

  Future fetchResourcesDetail({bool? loadingNext}) async {
    return await context.read<MembersController>().fetchDemoDetail(
          context: context,
          isRefresh: loadingNext == true ? false : true,
          loadingNext: loadingNext ?? false,
        );
  }

  TextEditingController searchController = TextEditingController();
  List<FeedsData>? feeds;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchResourcesDetail();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
      ),
      body: Consumer<MembersController>(
        builder: (context, controller, child) {
          demos = controller.demo;
          return SmartRefresher(
            controller: controller.demoController,
            enablePullUp: true,
            enablePullDown: true,
            onRefresh: () async {
              if (mounted) {
                await fetchResourcesDetail();
              }
            },
            onLoading: () async {
              if (mounted) {
                await fetchResourcesDetail(loadingNext: true);
              }
            },
            child: ListView(
              shrinkWrap: true,
              children: [
                CustomTextField(
                  hintText: 'Search',
                  controller: searchController,
                  hintStyle: const TextStyle(color: Colors.white),
                  onFieldSubmitted: (val) {
                    fetchResourcesDetail();
                  },
                  prefixIcon: ImageView(
                    height: 20,
                    width: 20,
                    borderRadiusValue: 0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(left: kPadding, right: kPadding),
                    fit: BoxFit.contain,
                    assetImage: AppAssets.searchIcon,
                    onTap: () {
                      fetchResourcesDetail();
                    },
                  ),
                  margin: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
                ),
                controller.loadingDemo == true
                    ? const LoadingScreen(heightFactor: 0.7)
                    : (demos.haveData)
                        ? ListView.builder(
                            itemCount: demos?.length ?? 0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: kPadding),
                            // physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var data = demos?.elementAt(index);

                              return InkWell(
                                  onTap: () {
                                    // if(widget.type!='true'){
                                    //   context.pushNamed(Routs.resourceAndDemo,extra:true );
                                    // }
                                  },
                                  child: FeedCard(
                                    index: index,
                                    data: data,
                                    isFeeds: false,
                                  ));
                            },
                          )
                        : const NoDataFound(heightFactor: 0.7),
              ],
            ),
          );
        },
      ),
    );
  }
}
