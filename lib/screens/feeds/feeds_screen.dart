import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaas/controllers/dashboard_controller.dart';
import 'package:gaas/controllers/feeds_controller.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/utils/widgets/data_widget_builder.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/config/app_images.dart';
import '../../core/constant/colors.dart';
import '../../models/feeds/feeds_model.dart';
import '../../models/partner/category_model.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../utils/widgets/image_view.dart';
import '../dashboard/utils/user_app_bar.dart';
import '../home/utils/fresh_produce_card.dart';
import 'utils/feed_card.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> with TickerProviderStateMixin {
  late int tabIndex = 0;
  TabController? tabController;

  CategoryData? selectedCategory;
  List<CategoryData>? categoryData;
  RefreshController refreshController = RefreshController();
  List<FeedsData>? feedsData;

  Future fetchFeeds({bool? loadingNext}) async {
    FeedsController controller = Provider.of<FeedsController>(context, listen: false);

    return controller.fetchFeeds(
      controller: refreshController,
      context: context,
      searchKey: searchCtrl.text,
      categoryId: selectedCategory?.id,
      isRefresh: loadingNext == true ? false : true,
      loadingNext: loadingNext ?? false,
    );
  }

  Timer? debounce;
  TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      FeedsController controller = Provider.of<FeedsController>(context, listen: false);

      categoryData = await controller.fetchCategories(context: context);
      tabController = TabController(initialIndex: tabIndex, length: categoryData?.length ?? 0, vsync: this);
      tabController?.animateTo(tabIndex);
      tabController?.addListener(() {
        setState(() {
          tabIndex = tabController?.index ?? 0;
          debugPrint("addListener TabIndex $tabIndex");
        });
      });
      fetchFeeds();
    });
  }

  Future onTabChange(int index) async {
    FeedsController controller = Provider.of<FeedsController>(context, listen: false);
    if (controller.loadingFeeds == false) {
      tabIndex = index;
      selectedCategory = categoryData?[index];
      tabController?.animateTo(tabIndex);
      setState(() {});
      await fetchFeeds();
      debugPrint("onTabChange tabIndex $tabIndex");
    }
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  void dispose() {
    tabController?.removeListener(_handleTabIndex);
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FeedsController controller = Provider.of<FeedsController>(context);
    feedsData = controller.feedsData;
    categoryData = controller.categoryData;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: userAppBar(context: context, showCart: false),
      body: DefaultTabController(
        initialIndex: tabIndex,
        length: categoryData?.length ?? 0,
        child: SmartRefresher(
          controller: refreshController,
          enablePullUp: true,
          enablePullDown: true,
          onRefresh: () async {
            if (mounted) {
              await fetchFeeds();
            }
          },
          onLoading: () async {
            await fetchFeeds(loadingNext: true);
          },
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              CustomTextField(
                controller: searchCtrl,
                height: 50,
                prefixIcon: ImageView(
                  height: 24,
                  width: 24,
                  assetImage: AppImages.search,
                  onTap: () async {
                    await fetchFeeds();
                  },
                ),
                fillColor: primaryGrey,
                hintText: "Search",
                onChanged: (val) async {
                  debounceApiCall();
                },
                borderColor: primaryGrey,
                margin: const EdgeInsets.only(left: 24, right: 12),
              ),
              Container(
                color: Colors.white.withOpacity(0.95),
                width: size.width,
                child: TabBar(
                  controller: tabController,
                  onTap: (val) {},
                  isScrollable: true,
                  labelColor: primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: primaryColor,
                  automaticIndicatorColorAdjustment: true,
                  indicatorSize: TabBarIndicatorSize.tab,
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  tabs: List.generate(
                    categoryData?.length ?? 0,
                    (index) {
                      var data = categoryData?.elementAt(index);
                      return FreshProduceCard(
                        name: data?.name,
                        image: data?.icon,
                        radius: 60,
                        textSize: 13,
                        selected: index == tabIndex,
                        onTap: () {
                          onTabChange(index);
                        },
                        padding: const EdgeInsets.only(bottom: 10),
                      );
                    },
                  ),
                ),
              ),
              DataWidgetBuilder(
                isLoading: controller.loadingFeeds,
                haveData: feedsData.haveData,
                heightFactor: 0.6,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: feedsData?.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    var feed = feedsData?.elementAt(index);
                    return FeedCard(feed: feed);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void debounceApiCall() {
    if (debounce != null) {
      debounce?.cancel();
    }
    debounce = Timer(const Duration(milliseconds: 300), () async {
      await fetchFeeds();
    });
  }
}
