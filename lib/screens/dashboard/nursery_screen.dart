import 'package:flutter/material.dart';
import 'package:gaas/controllers/dashboard_controller.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/screens/dashboard/utils/user_app_bar.dart';
import 'package:gaas/screens/home/utils/nearby_product.dart';
import 'package:gaas/utils/widgets/custom_text_field.dart';
import 'package:gaas/utils/widgets/data_widget_builder.dart';
import 'package:gaas/utils/widgets/image_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../controllers/location/location_controller.dart';
import '../../controllers/orders/cart_controller.dart';
import '../../core/constant/colors.dart';
import '../../core/constant/constant.dart';
import '../../core/enums/enums.dart';
import '../../core/functions.dart';
import '../../core/services/database/local_database.dart';
import '../../models/dashboard/banners_model.dart';
import '../../models/dashboard/fresh_produce_recent.dart';
import '../../models/dashboard/nearby_producers_model.dart';
import '../../models/orders/orders_model.dart';
import '../../models/partner/category_model.dart';
import '../../route/route_paths.dart';
import '../../utils/skeleton.dart';
import '../home/all_producers.dart';
import '../home/product/cart_products_home.dart';
import '../home/utils/fresh_produce_card.dart';
import '../home/utils/offer_banners.dart';
import '../home/utils/recently_viewed.dart';
import '../orders/unreviewed_orders_card.dart';

class NurseryScreen extends StatefulWidget {
  const NurseryScreen({
    super.key,
  });

  @override
  State<NurseryScreen> createState() => _NurseryScreenState();
}

class _NurseryScreenState extends State<NurseryScreen> {
  LocalDatabase localDatabase = LocalDatabase();
  late bool? isPartner = localDatabase.role == Roles.partner.value;
  late bool? isFreshProducer = localDatabase.isFreshProducer;
  late bool? isNursery = localDatabase.isNursery;
  late bool? isServiceProvider = localDatabase.isServiceProvider;
  bool isAuthenticated = LocalDatabase().accessToken != null;
  late ServiceType type = ServiceType.nursery;
  RefreshController nearbyProducersController = RefreshController(initialRefresh: false);

  fetchFreshProduce() {
    DashboardController dashboardController = Provider.of<DashboardController>(context, listen: false);
    dashboardController.fetchNearbyProducers(
        context: context, isRefresh: true, type: type, controller: nearbyProducersController);
    dashboardController.fetchBanners(context: context, type: type);
    dashboardController.fetchCategories(context: context, type: type).then((value) async {
      categoryData = value;
      if (context.mounted) {
        setState(() {});
      }

      await divideIntoTwoCategories();
    });

    if (isAuthenticated) {
      dashboardController.fetchFreshProduceRecent(context: context, type: type);
    }
  }

  List<OrdersData>? unReviewedOrders;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchFreshProduce();
      context.read<LocationController>().checkLocationAccess(context: context);
      if (isAuthenticated) {
        AuthControllers authControllers = Provider.of<AuthControllers>(context, listen: false);
        authControllers.checkPartnerRequest(context: context);
        authControllers.fetchProfile(context: context);
      }
    });
  }

  List<BannersData>? banners;
  List<CategoryData>? categoryData;
  List<NearbyProducersData>? nearbyProducersData;
  List<FreshProduceRecentData>? freshProduceData;

  Future divideIntoTwoCategories() async {
    int maxItemsPerRow = deviceSpecificValue(context: context, device: 4, tablet: 7, desktop: 10).toInt();
    int itemsLength = categoryData?.length ?? 0;

    if (itemsLength > maxItemsPerRow) {
      categoryRow1 = categoryData?.sublist(0, maxItemsPerRow);
      categoryRow2 = categoryData?.sublist(maxItemsPerRow, itemsLength);
    } else {
      categoryRow1 = categoryData?.sublist(0, itemsLength);
    }

    setState(() {});
  }

  List<CategoryData>? categoryRow1;
  List<CategoryData>? categoryRow2;

  @override
  Widget build(BuildContext context) {
    AuthControllers authControllers = Provider.of<AuthControllers>(context);
    DashboardController controller = Provider.of<DashboardController>(context);
    banners = controller.bannersData;
    categoryData = controller.categoryData;
    Size size = MediaQuery.of(context).size;

    nearbyProducersData = controller.nearbyProducersData;
    freshProduceData = controller.freshProduceData;
    isFreshProducer = authControllers.isFreshProducer;
    isNursery = authControllers.isNursery;
    isServiceProvider = authControllers.isServiceProvider;
    CartController cartController = Provider.of<CartController>(context);
    unReviewedOrders = cartController.nurseryUnReviewedOrders;
    return Scaffold(
      appBar: userAppBar(
        context: context,
        onSuccess: () {
          fetchFreshProduce();
        },
      ),
      body: SmartRefresher(
        controller: nearbyProducersController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () async {
          if (mounted) {
            await fetchFreshProduce();
          }
        },
        onLoading: () async {
          await controller.fetchNearbyProducers(
              type: type, loadingNext: true, context: context, controller: nearbyProducersController);
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Row(
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      context.pushNamed(Routs.globalSearch);
                    },
                    child: CustomTextField(
                      height: 50,
                      enabled: false,
                      prefixIcon: const ImageView(
                        height: 24,
                        width: 24,
                        assetImage: AppImages.search,
                      ),
                      fillColor: primaryGrey,
                      hintText: "Search",
                      onChanged: (val) {},
                      borderColor: primaryGrey,
                      margin: const EdgeInsets.only(left: 24, right: 12),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 58,
                  margin: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    color: primaryGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ImageView(
                    height: 24,
                    width: 24,
                    fit: BoxFit.contain,
                    assetImage: AppImages.location,
                    onTap: () {
                      context.push(Routs.mapViewHome);
                    },
                    margin: EdgeInsets.zero,
                  ),
                )
              ],
            ),
            if (freshProduceData?.haveData == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
                    child: Text(
                      "Recently Viewed",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(
                    height: 115,
                    child: ListView.builder(
                      itemCount: freshProduceData?.length,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 24),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var data = freshProduceData?.elementAt(index);

                        return RecentlyViewedCard(
                          id: data?.partnerId,
                          title: data?.partnerName,
                          image: "${data?.profilePhoto}",
                          itemCounts: data?.itemCounts,
                          padding: const EdgeInsets.all(18),
                        );
                      },
                    ),
                  ),
                ],
              ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(color: primaryGrey, thickness: 8, height: 1),
            ),
            if (controller.loadingBanners)
              Skeletons().skeletonBannerCard(context: context)
            else if (banners.haveData)
              OfferBanners(banners: banners),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "EXPLORE",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
                  ),
                ],
              ),
            ),
            DataWidgetBuilder(
              isLoading: controller.loadingCategories,
              haveData: categoryRow1.haveData,
              heightFactor: 0.1,
              child: Container(
                height: defaultCategoriesSize(context),
                margin: const EdgeInsets.only(bottom: 16),
                child: ListView.builder(
                  itemCount: categoryRow1?.length ?? 0,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: 24),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var data = categoryRow1?.elementAt(index);
                    return FreshProduceCard(
                      name: data?.name,
                      image: data?.icon,
                      selected: false,
                      onTap: () {
                        context.pushNamed(Routs.allProducers,
                            extra: AllProducersScreen(
                              categoryId: data?.id,
                              orderType: null,
                              type: type,
                            ));
                      },
                    );
                  },
                ),
              ),
            ),
            if (categoryRow2.haveData)
              SizedBox(
                height: defaultCategoriesSize(context),
                child: ListView.builder(
                  itemCount: categoryRow2?.length ?? 0,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: 24),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var data = categoryRow2?.reversed.toList().elementAt(index);
                    return FreshProduceCard(
                      name: data?.name,
                      image: data?.icon,
                      selected: false,
                      onTap: () {
                        context.pushNamed(Routs.allProducers,
                            extra: AllProducersScreen(
                              categoryId: data?.id,
                              orderType: null,
                              type: type,
                            ));
                      },
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Text(
                "Nearby ${type.value}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            DataWidgetBuilder(
              isLoading: controller.loadingNearbyProducers,
              loadingWidget: Skeletons().skeletonCategoriesCard(context: context, itemCount: 8),
              haveData: nearbyProducersData.haveData,
              heightFactor: 0.4,
              child: Container(
                color: primaryGrey,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: nearbyProducersData?.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var data = nearbyProducersData?.elementAt(index);

                    return NearbyProductCard(
                      id: data?.id,
                      title: data?.name,
                      image: "${data?.profilePhoto}",
                      address: data?.address,
                      rating: data?.rating,
                      reviews: data?.reviews,
                      distance: data?.distanceLabel,
                      wishlistId: data?.wishlistId,
                      inWishlist: data?.inWishlist,
                      offers: data?.offers,
                      orderMode: data?.orderMode,
                      addToWishList: () {
                        context.read<DashboardController>().addToWishList(
                              context: context,
                              id: data?.id,
                              type: WishListType.partner,
                              targetId: data?.id,
                            );
                      },
                      removeWishList: () {
                        context.read<DashboardController>().removeProducerWishList(
                            context: context,
                            id: data?.id,
                            type: WishListType.partner,
                            wishlistId: "${data?.wishlistId}");
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      bottomSheet: (unReviewedOrders.haveData)
          ? ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: unReviewedOrders?.length ?? 0,
              itemBuilder: (context, index) {
                var order = unReviewedOrders?.elementAt(index);

                return UnreviewedOrdersCard(
                  index: index,
                  order: order,
                  serviceType: ServiceType.nursery,
                );
              },
            )
          : null,
      bottomNavigationBar: const HomeCartProducts(),
    );
  }
}
