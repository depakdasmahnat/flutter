import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../core/constant/constant.dart';
import '../../../models/auth_model/fetchinterestcategory.dart';
import '../../../models/feeds/feeds_data.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';
import '../../member/feeds/feeds_card.dart';

class ResourceAndDemo extends StatefulWidget {
  final ResourceCategoryData? category;

  const ResourceAndDemo({super.key, this.category});

  @override
  State<ResourceAndDemo> createState() => _ResourceAndDemoState();
}

class _ResourceAndDemoState extends State<ResourceAndDemo> {
  late ResourceCategoryData? category = widget.category;

  List<FeedsData>? resources;

  Future fetchResourcesDetail({bool? loadingNext}) async {
    return await context.read<GuestControllers>().fetchResourcesDetail(
          context: context,
          categoryId: category?.id,
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
        title: Text(category?.name ?? 'Resources'),
      ),
      body: Consumer<GuestControllers>(
        builder: (context, controller, child) {
          resources = controller.resources;
          return SmartRefresher(
            controller: controller.resourcesController,
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
                  onFieldSubmitted: (value) {

                  },

                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: ImageView(
                    height: 20,
                    width: 20,
                    borderRadiusValue: 0,
                    color: Colors.white,
                    margin: EdgeInsets.only(left: kPadding, right: kPadding),
                    fit: BoxFit.contain,
                    assetImage: AppAssets.searchIcon,
                  ),
                  margin: EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
                ),
                controller.loadingResources == true
                    ? const LoadingScreen(heightFactor: 0.7)
                    : (resources.haveData)
                        ? ListView.builder(
                            itemCount: resources?.length ?? 0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: kPadding),
                            // physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var data = resources?.elementAt(index);

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
