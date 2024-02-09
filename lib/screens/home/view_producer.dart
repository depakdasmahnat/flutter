import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/orders/cart_controller.dart';
import 'package:gaas/core/config/app_config.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/screens/home/product/checkout_cart_products.dart';
import 'package:gaas/screens/home/product/utils/product_detail.dart';
import 'package:gaas/screens/home/utils/filter_button.dart';
import 'package:gaas/screens/home/utils/fresh_produce_card.dart';
import 'package:gaas/screens/home/utils/multi_filter_button.dart';
import 'package:gaas/screens/home/utils/producer_offer_card2.dart';
import 'package:gaas/screens/home/utils/producer_offers_card.dart';
import 'package:gaas/utils/widgets/custom_button.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';

import '../../controllers/dashboard_controller.dart';
import '../../core/config/app_images.dart';
import '../../core/constant/colors.dart';
import '../../core/constant/constant.dart';
import '../../core/enums/enums.dart';
import '../../core/functions.dart';
import '../../core/services/database/local_database.dart';
import '../../models/dashboard/all_producers.dart';
import '../../models/dashboard/filters_model.dart';
import '../../models/dashboard/producer_details_model.dart';
import '../../utils/skeleton.dart';
import '../../utils/widgets/custom_bottom_sheet.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../utils/widgets/data_widget_builder.dart';
import '../../utils/widgets/image_view.dart';
import 'product/utils/product_card.dart';
import 'utils/filter_pickup.dart';
import 'utils/nearby_product.dart';

class ViewProducer extends StatefulWidget {
  const ViewProducer({Key? key, required this.partnerId, this.bannerId, this.orderType, this.product})
      : super(key: key);

  final String? partnerId;
  final AllProducersProducts? product;
  final num? bannerId;
  final String? orderType;

  @override
  State<ViewProducer> createState() => _ViewProducerState();
}

class _ViewProducerState extends State<ViewProducer> with TickerProviderStateMixin {
  late String? partnerId = widget.partnerId;
  ServiceType type = ServiceType.freshProduce;
  TextEditingController searchCtrl = TextEditingController();
  late AllProducersProducts? product = widget.product;
  late int tabIndex = 0;
  TabController? tabController;
  late String? orderType = widget.orderType;
  List<String>? orderTypes;
  ProducerDetailsData? producerDetailsData;
  List<ProducerProducts>? producerProducts;
  List<ProducerOffers>? producerOffers;
  RefreshController producerDetailsController = RefreshController(initialRefresh: false);

  Future fetchProducerDetails({
    bool? loadingNext,
    bool? isFullRefresh,
  }) async {
    DashboardController dashboardController = Provider.of<DashboardController>(context, listen: false);

    return dashboardController.fetchProducerDetails(
      context: context,
      type: type,
      partnerId: partnerId,
      productId: product?.id,
      searchKey: searchCtrl.text,
      sortBy: selectedSorting,
      orderType: orderType,
      selectedFilterIds: selectedFilterIds?.toList(),
      filterOptions: selectedFilterOptions,
      otherFilterBy: selectedOtherFilters,
      isFullRefresh: isFullRefresh ?? false,
      isRefresh: loadingNext == true ? null : true,
      loadingNext: loadingNext,
      controller: producerDetailsController,
    );
  }

  List<FiltersData?>? filtersData;
  Set<num?>? selectedFilterIds = {};

  List<FilterOptions?>? selectedFilterOptions = [];

  Future fetchFilters() async {
    DashboardController dashboardController = Provider.of<DashboardController>(context, listen: false);
    return dashboardController.fetchFilters(context: context, type: type, searchKey: searchCtrl.text);
  }

  num? subCategoryId;

  String? selectedSorting;
  List<String>? selectedOtherFilters = [];
  late bool isAuthenticated = LocalDatabase().accessToken != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchFilters();
      fetchProducerDetails(isFullRefresh: true).then((value) {
        producerDetailsData = value;
        orderTypes = producerDetailsData?.orderTypes;
        if (orderType == null && orderTypes.haveData) {
          orderType = orderTypes?.first;
        }

        setState(() {});
        int newTabIndex = 0;
        debugPrint("orderType $orderType");

        if (orderTypes.haveData && orderType != null) {
          newTabIndex = producerDetailsData!.orderTypes!.indexWhere((element) => element == orderType);
          if (!newTabIndex.isNegative) {
            tabIndex = newTabIndex;
            debugPrint("orderType tabIndex $tabIndex");
            setState(() {});
          }
        }

        setState(() {});

        tabController = TabController(initialIndex: tabIndex, length: orderTypes?.length ?? 0, vsync: this);
        tabController?.animateTo(tabIndex);
        tabController?.addListener(() {
          setState(() {
            tabIndex = tabController?.index ?? 0;
            debugPrint("addListener TabIndex $tabIndex");
          });
        });

        List<ProducerProducts?>? selectedProducts =
            producerDetailsData?.products?.where((element) => element?.id == product?.id).toList();

        if (selectedProducts.haveData) {
          CustomBottomSheet.show(
            context: context,
            body: ProductDetail(
              producer: producerDetailsData,
              product: selectedProducts?.first,
            ),
          );
        }
      });
    });
  }

  Future onTabChange(int index) async {
    setState(() {
      if (!context.read<DashboardController>().loadingProducerDetails) {
        tabIndex = index;

        orderType = orderTypes?[index];
        final cartController = Provider.of<CartController>(context, listen: false);
        cartController.setOrderType(
            context: context, producerId: producerDetailsData?.id, orderType: orderType);

        fetchProducerDetails();
        debugPrint("onTabChange tabIndex $tabIndex  ");
      }
    });
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
    Size size = MediaQuery.of(context).size;
    debugPrint("id $partnerId");
    CartController cartController = Provider.of<CartController>(context);
    DashboardController controller = Provider.of<DashboardController>(context);
    debugPrint("orderType $orderType");
    producerDetailsData = controller.producerDetailsData;
    orderTypes = producerDetailsData?.orderTypes;
    producerProducts = controller.producerProducts;
    producerOffers = producerDetailsData?.offers;
    filtersData = controller.filtersData;
    int productsInRow = deviceSpecificValue(context: context, device: 2, tablet: 4, desktop: 6).toInt();
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
          title: const Text("Producer Detail"),
          actions: [
            Row(
              children: [
                if (isAuthenticated)
                  GestureDetector(
                    onTap: () {
                      if (producerDetailsData?.inWishlist == true) {
                        context.read<DashboardController>().removeProducerWishList(
                            context: context,
                            type: WishListType.partner,
                            id: producerDetailsData?.id,
                            wishlistId: "${producerDetailsData?.wishlistId}");
                      } else {
                        context.read<DashboardController>().addToWishList(
                              context: context,
                              id: producerDetailsData?.id,
                              type: WishListType.partner,
                              targetId: producerDetailsData?.id,
                            );
                      }
                    },
                    child: producerDetailsData?.inWishlist == null
                        ? const CupertinoActivityIndicator()
                        : Icon(
                            producerDetailsData?.inWishlist == true
                                ? CupertinoIcons.heart_solid
                                : CupertinoIcons.heart,
                            color: Colors.red,
                          ),
                  ),
                IconButton(
                  onPressed: () {
                    Share.share(
                        "${producerDetailsData?.name}\n\n${producerDetailsData?.address}\n\nCheckout ${AppConfig.apkName}\n${AppConfig.apkLink()}");
                  },
                  icon: const Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          ],
        ),
        body: DefaultTabController(
          initialIndex: tabIndex,
          length: orderTypes?.length ?? 0,
          child: Column(
            children: [
              Column(
                children: [
                  if (producerDetailsData == null)
                    Skeletons().skeletonBannerCard(context: context)
                  else
                    Container(
                      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: primaryBoxShadow(),
                      ),
                      child: NearbyProductCard(
                        id: producerDetailsData?.id,
                        title: producerDetailsData?.name ?? "",
                        address: producerDetailsData?.address ?? "",
                        rating: producerDetailsData?.rating,
                        reviews: producerDetailsData?.reviews,
                        image: producerDetailsData?.profilePhoto,
                        distance: producerDetailsData?.distanceLabel,
                        onTap: () {},
                        detailsCard: true,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: searchCtrl,
                          height: 50,
                          prefixIcon: ImageView(
                            height: 24,
                            width: 24,
                            assetImage: AppImages.search,
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              await fetchProducerDetails();
                            },
                          ),
                          fillColor: Colors.grey.shade50,
                          hintText: "Search",
                          onChanged: (val) async {
                            if (!controller.loadingProducerDetails) {
                              await fetchProducerDetails();
                            }
                          },
                          onEditingComplete: () async {
                            await fetchProducerDetails();
                          },
                          borderColor: primaryGrey,
                          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
                        ),
                      ),
                      // if (product != null)
                      //   Stack(
                      //     clipBehavior: Clip.none,
                      //     children: [
                      //       FreshProduceCard(
                      //         name: product?.name,
                      //         image: "${product?.image}",
                      //         radius: 50,
                      //         selected: false,
                      //         onTap: null,
                      //       ),
                      //       Positioned(
                      //         top: -14,
                      //         right: 0,
                      //         child: IconButton(
                      //             onPressed: () {
                      //               product = null;
                      //               setState(() {});
                      //               fetchProducerDetails();
                      //             },
                      //             icon: const Icon(
                      //               Icons.cancel,
                      //               color: Colors.red,
                      //             )),
                      //       )
                      //     ],
                      //   )
                    ],
                  ),
                ],
              ),
              Expanded(
                child: SmartRefresher(
                  key: widget.key,
                  controller: producerDetailsController,
                  enablePullUp: true,
                  enablePullDown: true,
                  onRefresh: () async {
                    if (mounted) {
                      await fetchProducerDetails();
                    }
                  },
                  onLoading: () async {
                    if (mounted) {
                      await fetchProducerDetails(loadingNext: true);
                    }
                  },
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      if (producerOffers.haveData) ProducerOffersCard(offer: producerOffers),
                      SizedBox(
                        height: 45,
                        child: ListView(
                          padding: const EdgeInsets.only(left: 18, right: 18, bottom: 6),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            FilterButton(
                              title: "Sort",
                              image: AppImages.filter,
                              showArrow: true,
                              selected: selectedSorting != null,
                              onTap: () {
                                CustomBottomSheet.show(
                                  context: context,
                                  showTitleDivider: false,
                                  title: "Sort By",
                                  centerTitle: true,
                                  body: sortingBody(),
                                );
                              },
                            ),
                            if (filtersData.haveData == true)
                              SizedBox(
                                height: 45,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: filtersData?.length,
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var filter = filtersData?.elementAt(index);

                                    return FilterButton(
                                      title: "${filter?.name}",
                                      image: AppImages.filter,
                                      showArrow: true,
                                      selected: selectedFilter(options: filter?.options),
                                      onTap: () {
                                        CustomBottomSheet.show(
                                            context: context,
                                            showTitleDivider: false,
                                            title: "Select ${filter?.name}",
                                            centerTitle: true,
                                            body: FilterPicker(
                                              filterId: filter?.id,
                                              selectedFilterIds: selectedFilterIds,
                                              selectedFilterOptions: selectedFilterOptions,
                                              filterOptions: filter?.options,
                                              onChange: (ids, filterOptions) {
                                                selectedFilterIds = ids;
                                                selectedFilterOptions = filterOptions;
                                                setState(() {});
                                              },
                                            ),
                                            bottomNavBarHeight: 60,
                                            bottomNavBar: CustomButton(
                                              text: "Select",
                                              fontSize: 18,
                                              height: 45,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              onPressed: () {
                                                context.pop();
                                                fetchProducerDetails();
                                              },
                                              margin: const EdgeInsets.all(16),
                                            ));
                                      },
                                    );
                                  },
                                ),
                              ),
                            MultiFilterButton(
                              selectedList: selectedOtherFilters,
                              list: otherFilters,
                              onChange: (val) {
                                if (controller.loadingProducerDetails == false) {
                                  selectedOtherFilters = val;
                                  fetchProducerDetails();
                                }
                                setState(() {});
                              },
                            )
                          ],
                        ),
                      ),
                      if (orderTypes?.haveData == true)
                        SizedBox(
                          width: size.width,
                          height: 50,
                          child: TabBar(
                            controller: tabController,
                            onTap: (val) {
                              onTabChange(val);
                            },
                            isScrollable: true,
                            labelColor: primaryColor,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: primaryColor,
                            indicatorWeight: 3,
                            automaticIndicatorColorAdjustment: true,
                            indicatorSize: TabBarIndicatorSize.tab,
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                            tabs: List.generate(
                              orderTypes?.length ?? 0,
                              (index) {
                                var data = orderTypes?.elementAt(index);
                                return Text(
                                  "$data",
                                  style: const TextStyle(),
                                );
                              },
                            ),
                          ),
                        ),
                      DataWidgetBuilder(
                        isLoading: controller.loadingProducerDetails,
                        haveData: producerProducts?.haveData == true,
                        heightFactor: 0.5,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: producerProducts?.length ?? 0,
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: productsInRow,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (context, index) {
                            return ProductCard(
                              producer: producerDetailsData,
                              product: producerProducts?.elementAt(index),
                              type: type,
                              orderType: orderType,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CheckoutCartProducts(),
      ),
    );
  }

  bool selectedFilter({List<FilterOptions?>? options}) {
    bool? result = options?.any((data) =>
        selectedFilterOptions?.where((selectedOptions) => selectedOptions?.id == data?.id).isNotEmpty ==
        true);
    return result ?? false;
  }

  Widget sortingBody() {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: shortingFilter.length,
            itemBuilder: (context, index) {
              String id = shortingFilter.elementAt(index)["id"];
              String title = shortingFilter.elementAt(index)["title"];
              return InkWell(
                onTap: () {
                  if (selectedSorting == id) {
                    selectedSorting = null;
                  } else {
                    selectedSorting = id;
                  }
                  setState(() {});
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        headingText(
                          context: context,
                          text: title,
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        if (selectedSorting != null && id == selectedSorting)
                          const Padding(
                            padding: EdgeInsets.only(right: 24),
                            child: Icon(
                              CupertinoIcons.checkmark_alt_circle_fill,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                      ],
                    ),
                    const Divider(height: 0),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    side: MaterialStateProperty.all(
                      const BorderSide(color: primaryColor, width: 0.8, style: BorderStyle.solid),
                    ),
                  ),
                  onPressed: () {
                    onReset(filterMode: false);
                  },
                  child: Container(
                    height: 45,
                    constraints: const BoxConstraints(minWidth: 130),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Reset",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 45,
                  constraints: const BoxConstraints(minWidth: 150),
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(12),
                    padding: EdgeInsets.zero,
                    color: primaryColor,
                    child: const Text(
                      "Apply",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      onApply();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      );
    });
  }

  Future onReset({required bool filterMode}) async {
    if (filterMode) {
      selectedFilterOptions?.clear();
    } else {
      selectedSorting = null;
    }

    setState(() {});
    Navigator.pop(context);
    return await fetchProducerDetails();
  }

  Future onApply() async {
    Navigator.pop(context);
    return await fetchProducerDetails();
  }
}
