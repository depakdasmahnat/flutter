import 'package:flutter/material.dart';
import 'package:gaas/controllers/services_controller.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/constant/constant.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/utils/widgets/custom_text_field.dart';
import 'package:gaas/utils/widgets/image_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controllers/dashboard_controller.dart';
import '../../controllers/location/location_controller.dart';
import '../../core/constant/colors.dart';
import '../../core/enums/enums.dart';
import '../../core/functions.dart';
import '../../core/services/database/local_database.dart';
import '../../models/dashboard/banners_model.dart';
import '../../models/dashboard/fresh_produce_recent.dart';
import '../../models/dashboard/service/service_provider_detail.dart';
import '../../models/partner/category_model.dart';
import '../../route/route_paths.dart';
import '../../utils/skeleton.dart';
import '../../utils/widgets/data_widget_builder.dart';
import '../dashboard/utils/user_app_bar.dart';
import '../dashboard/utils/user_service_card.dart';
import '../home/all_producers.dart';
import '../home/utils/fresh_produce_card.dart';
import '../home/utils/recently_viewed_services.dart';
import '../home/utils/services_offer_banners.dart';
import 'all_services.dart';
import 'service_provider_detail.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({
    super.key,
  });

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  bool isAuthenticated = LocalDatabase().accessToken != null;
  late ServiceType type = ServiceType.serviceProvider;
  RefreshController nearbyServiceProvidersController = RefreshController(initialRefresh: false);
  List<ServiceProviderData>? nearbyServiceProvidersData;

  fetchFreshProduce() {
    DashboardController dashboardController = Provider.of<DashboardController>(context, listen: false);
    ServicesController servicesController = Provider.of<ServicesController>(context, listen: false);
    servicesController.fetchNearbyServiceProviders(
        context: context, isRefresh: true, controller: nearbyServiceProvidersController);
    dashboardController.fetchBanners(context: context, type: type);
    dashboardController.fetchCategories(context: context, type: type).then((value) async {
      categoryData = value;
      setState(() {});
      await divideIntoTwoCategories();
    });
    if (isAuthenticated) {
      dashboardController.fetchFreshProduceRecent(context: context, type: type);
    }
  }

  List<BannersData>? banners;
  List<CategoryData>? categoryData;

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchFreshProduce();
      context.read<LocationController>().checkLocationAccess(context: context);
    });
  }

  List<FreshProduceRecentData>? freshProduceData;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    DashboardController controller = Provider.of<DashboardController>(context);
    ServicesController servicesController = Provider.of<ServicesController>(context);

    banners = controller.bannersData;
    freshProduceData = controller.freshProduceData;
    categoryData = controller.categoryData;
    nearbyServiceProvidersData = servicesController.nearbyServiceProvidersData;
    return Scaffold(
      appBar: userAppBar(
        context: context,
        actions: [],
        onSuccess: () {
          fetchFreshProduce();
        },
      ),
      body: SmartRefresher(
        controller: nearbyServiceProvidersController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () async {
          if (mounted) {
            await fetchFreshProduce();
          }
        },
        onLoading: () async {
          await controller.fetchNearbyProducers(
              type: type, loadingNext: true, context: context, controller: nearbyServiceProvidersController);
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
                      context.push(Routs.serviceMapViewHome);
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
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
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
                        return RecentlyViewedServicesCard(
                          id: data?.partnerId,
                          isService: true,
                          title: data?.partnerName,
                          image: "${data?.profilePhoto}",
                        );
                      },
                    ),
                  ),
                ],
              ),
            if (controller.loadingBanners)
              Skeletons().skeletonBannerCard(context: context)
            else if (banners.haveData)
              SizedBox(
                height: 250,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: banners?.length ?? 0,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 16),
                  itemBuilder: (BuildContext context, int index) {
                    var data = banners?.elementAt(index);
                    return ServiceCard(banner: data);
                  },
                ),
              ),
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
                      maxLines: 2,
                      borderRadius: 12,
                      onTap: () {
                        context.pushNamed(Routs.allServices, extra: AllServices(categoryId: data?.id));
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
                      borderRadius: 12,
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
              isLoading: servicesController.loadingNearbyServiceProviders,
              haveData: nearbyServiceProvidersData.haveData,
              loadingWidget: Skeletons().skeletonCategoriesCard(context: context, itemCount: 8),
              heightFactor: 0.4,
              child: Container(
                color: primaryGrey,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: nearbyServiceProvidersData?.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var data = nearbyServiceProvidersData?.elementAt(index);

                    return ServiceProviderCard(
                      onTap: () {
                        context.push(Routs.serviceProviderDetail,
                            extra: ServiceProviderDetailScreen(id: data?.id));
                      },
                      serviceProvider: data,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
