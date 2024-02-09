import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/models/dashboard/producer_details_model.dart';
import 'package:gaas/utils/widgets/data_widget_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/constant/colors.dart';
import '../../../models/partner/product/my_products_model.dart';
import '../../controllers/wishlist_controller.dart';
import '../../core/config/app_images.dart';
import '../../core/enums/enums.dart';
import '../../core/functions.dart';
import '../../models/dashboard/favorites_model.dart';
import '../../route/route_paths.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../utils/widgets/image_view.dart';
import '../../utils/widgets/widgets.dart';
import '../home/product/utils/product_card.dart';
import '../home/utils/nearby_product.dart';
import '../home/view_producer.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> with TickerProviderStateMixin {
  TextEditingController searchCtrl = TextEditingController();

  late WishlistServiceType? wishlistServiceType = wishlistServiceTypes()?.first;

  List<WishlistServiceType>? wishlistServiceTypes() => [
        WishlistServiceType.freshProduce,
        WishlistServiceType.nursery,
        if (wishListType == WishListType.partner) WishlistServiceType.serviceProvider,
        if (wishListType == WishListType.partner) WishlistServiceType.knowledge,
      ];
  int tabIndex = 0;

  late WishListType? wishListType = wishListTypesTab?.first;
  List<WishListType>? wishListTypesTab = WishListType.values;

  TabController? tabController;

  List<FavoritesData>? favoritesData;

  Future fetchFavorites({bool? loadingNext}) async {
    WishListController controller = Provider.of<WishListController>(context, listen: false);

    return controller.fetchFavorites(
      context: context,
      searchKey: searchCtrl.text,
      type: wishListType?.value,
      serviceType: wishlistServiceType?.value,
      isRefresh: loadingNext == true ? null : true,
      loadingNext: loadingNext,
    );
  }

  List<MyProductsData>? myProductsData;
  Timer? _debounce;

  void onSearchFieldChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchFavorites();
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchFavorites();

      setState(() {});
      tabController =
          TabController(initialIndex: tabIndex, length: wishListTypesTab?.length ?? 0, vsync: this);
      tabController?.animateTo(tabIndex);
      tabController?.addListener(() {});
    });
  }

  Future onTabChange(int index) async {
    setState(() {
      if (!context.read<WishListController>().loadingFavorites) {
        tabIndex = index;
        wishListType = wishListTypesTab?[tabIndex];
        wishlistServiceType = wishlistServiceTypes()?.first;

        fetchFavorites();
        debugPrint("onTabChange tabIndex $tabIndex  ");
      }
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    tabController?.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    WishListController controller = Provider.of<WishListController>(context);
    favoritesData = controller.favoritesData;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              backButton(context: context),
            ],
          ),
          leadingWidth: 50,
          title: const Text("Favorites"),
        ),
        body: DefaultTabController(
          initialIndex: tabIndex,
          length: wishListTypesTab?.length ?? 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width,
                height: 55,
                child: TabBar(
                  controller: tabController,
                  onTap: (val) {
                    onTabChange(val);
                  },
                  labelColor: primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: primaryColor,
                  indicatorWeight: 1,
                  automaticIndicatorColorAdjustment: true,
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  unselectedLabelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  tabs: List.generate(
                    wishListTypesTab?.length ?? 0,
                    (index) {
                      var data = wishListTypesTab?.elementAt(index);
                      return Text("${data?.value}s");
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: Container(
                  height: 28,
                  margin: const EdgeInsets.only(top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                    // boxShadow: defaultBoxShadow(),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: wishlistServiceTypes()?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      WishlistServiceType? data = wishlistServiceTypes()?.elementAt(index);
                      bool selectedItem = wishlistServiceType?.value == data?.value;

                      return card(index, data, selectedItem);
                    },
                  ),
                ),
              ),
              CustomTextField(
                height: 50,
                controller: searchCtrl,
                autofocus: true,
                prefixIcon: ImageView(
                  height: 24,
                  width: 24,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    fetchFavorites();
                  },
                  assetImage: AppImages.search,
                ),
                fillColor: primaryGrey,
                hintText: "Search",
                onChanged: (val) {
                  onSearchFieldChanged(val);
                },
                onFieldSubmitted: (val) {
                  FocusScope.of(context).unfocus();
                  fetchFavorites();
                },
                borderColor: primaryGrey,
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
              ),
              Expanded(
                child: SmartRefresher(
                  key: widget.key,
                  controller: controller.favoritesController,
                  enablePullUp: true,
                  enablePullDown: true,
                  onRefresh: () async {
                    if (mounted) {
                      await fetchFavorites();
                    }
                  },
                  onLoading: () async {
                    if (mounted) {
                      await fetchFavorites(loadingNext: true);
                    }
                  },
                  child: DataWidgetBuilder(
                    isLoading: controller.loadingFavorites,
                    haveData: favoritesData.haveData,
                    heightFactor: 0.7,
                    child: ListView.builder(
                      itemCount: favoritesData?.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        var data = favoritesData?.elementAt(index);
                        return globalSearchWidgets(data: data, index: index);
                      },
                    ),

                    // child: (wishListType == WishListType.partner)
                    //     ? ListView.builder(
                    //         itemCount: favoritesData?.length,
                    //         shrinkWrap: true,
                    //         physics: const ScrollPhysics(),
                    //         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    //         padding: const EdgeInsets.symmetric(horizontal: 16),
                    //         itemBuilder: (context, index) {
                    //           var data = favoritesData?.elementAt(index);
                    //           return globalSearchWidgets(data: data, index: index);
                    //         },
                    //       )
                    //     : GridView.builder(
                    //         shrinkWrap: true,
                    //         physics: const NeverScrollableScrollPhysics(),
                    //         itemCount: favoritesData?.length ?? 0,
                    //         padding: const EdgeInsets.only(left: 16, right: 16),
                    //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //           crossAxisCount: productsInRow,
                    //           childAspectRatio: 0.7,
                    //           crossAxisSpacing: 12,
                    //           mainAxisSpacing: 12,
                    //         ),
                    //         itemBuilder: (context, index) {
                    //           var data = favoritesData?.elementAt(index);
                    //           return ProductCard(
                    //             product: ProducerProducts(
                    //               id: data?.id,
                    //               name: data?.name,
                    //               description: data?.deletedAt,
                    //             ),
                    //           );
                    //         },
                    //       ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget globalSearchWidgets({
    required int index,
    required FavoritesData? data,
  }) {
    return Stack(
      children: [
        Column(
          children: [
            NearbyProductCard(
              id: data?.id,
              title: data?.name,
              image: "${data?.profilePhoto ?? data?.image}",
              address: data?.address,
              rating: data?.rating,
              reviews: data?.reviews,
              distance: data?.distanceLabel,
              onTap: () {
                context.pushNamed(Routs.viewProducer, extra: ViewProducer(partnerId: "${data?.id}"));
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Divider(color: Colors.grey.shade300, height: 1),
            ),
          ],
        ),
        Positioned(
          top: 16,
          right: 8,
          child: GestureDetector(
            onTap: () {
              if (data?.inWishlist == true) {
                context.read<WishListController>().removeFavorite(
                    context: context, wishlistId: "${data?.wishlistId}", index: index, wishlistScreen: true);
              }
            },
            child: data?.inWishlist == null
                ? const CupertinoActivityIndicator()
                : const Icon(
                    CupertinoIcons.heart_solid,
                    color: Colors.red,
                  ),
          ),
        ),
      ],
    );
  }

  Widget card(int index, WishlistServiceType? data, bool selectedItem) {
    bool lastIndex = index == ((wishlistServiceTypes()?.length ?? 0) - 1);
    debugPrint("index == list?.length $index ${wishlistServiceTypes()?.length}");
    return GestureDetector(
      onTap: () {
        wishlistServiceType = data;

        setState(() {});
        fetchFavorites();
      },
      child: Container(
        margin: EdgeInsets.only(right: lastIndex ? 0 : 1.2),
        decoration: BoxDecoration(
          color: selectedItem ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: selectedItem ? Colors.transparent : Colors.grey.shade300,
              offset: const Offset(1, 0),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${data?.value}",
                  style: TextStyle(
                    fontSize: 13,
                    color: (selectedItem ? Colors.white : Colors.grey.shade700),
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
