import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/services_controller.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/screens/home/utils/filter_button.dart';
import 'package:gaas/screens/home/utils/filter_pickup.dart';
import 'package:gaas/screens/map/service_map_view.dart';
import 'package:gaas/screens/services/service_provider_detail.dart';
import 'package:gaas/utils/widgets/custom_bottom_sheet.dart';
import 'package:gaas/utils/widgets/data_widget_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controllers/dashboard_controller.dart';
import '../../controllers/location/location_controller.dart';
import '../../core/config/app_images.dart';
import '../../core/constant/colors.dart';
import '../../core/constant/constant.dart';
import '../../core/enums/enums.dart';
import '../../models/dashboard/filters_model.dart';
import '../../models/dashboard/service/service_provider_detail.dart';
import '../../models/order_type_data.dart';
import '../../models/partner/category_model.dart';
import '../../route/route_paths.dart';
import '../../utils/skeleton.dart';
import '../../utils/widgets/custom_button.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../utils/widgets/image_view.dart';
import '../../utils/widgets/widgets.dart';
import '../dashboard/utils/user_service_card.dart';
import '../home/utils/fresh_produce_card.dart';

class AllServices extends StatefulWidget {
  const AllServices({
    Key? key,
    this.categoryId,
    this.subCategoryId,
    this.bannerId,
    this.partnerIds,
  }) : super(key: key);

  final num? categoryId;
  final num? subCategoryId;

  final num? bannerId;
  final String? partnerIds;

  @override
  State<AllServices> createState() => _AllServicesState();
}

class _AllServicesState extends State<AllServices> with TickerProviderStateMixin {
  late ServiceType type = ServiceType.serviceProvider;

  late num? categoryId = widget.categoryId;

  TextEditingController searchCtrl = TextEditingController();
  List<CategoryData>? subCategoryData;
  List<ServiceProviderData>? allServiceProviders;

  List<FiltersData?>? filtersData;
  Set<num?>? selectedFilterIds = {};

  List<FilterOptions?>? selectedFilterOptions = [];

  Future fetchFilters() async {
    DashboardController dashboardController = Provider.of<DashboardController>(context, listen: false);
    return dashboardController.fetchFilters(context: context, type: type, searchKey: searchCtrl.text);
  }

  Future fetchSubCategories() async {
    DashboardController dashboardController = Provider.of<DashboardController>(context, listen: false);
    return dashboardController.fetchSubCategories(
      context: context,
      type: type,
      categoryId: "${categoryId ?? ""}",
      isAll: true,
    );
  }

  Future fetchAllServiceProviders({bool? loadingNext}) async {
    ServicesController servicesController = Provider.of<ServicesController>(context, listen: false);

    return servicesController.fetchAllServiceProviders(
      context: context,
      type: type,
      categoryId: categoryId,
      subcategoryId: subCategoryId,
      bannerId: widget.bannerId,
      partnerIds: widget.partnerIds,
      sortBy: selectedSorting,
      selectedFilterIds: selectedFilterIds?.toList(),
      filterOptions: selectedFilterOptions,
      otherFilterBy: selectedOtherFilters,
      searchKey: searchCtrl.text,
      isRefresh: loadingNext == true ? null : true,
      loadingNext: loadingNext,
      allOrderTypes: selectedOrderTypes?.type,
    );
  }

  late OrderTypeData? selectedOrderTypes = OrderTypeData(type: AllOrderTypes.all);

  late int tabIndex = 0;

  num? subCategoryId;

  TabController? tabController;

  String? selectedSorting;

  List<String>? selectedOtherFilters = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchFilters();
      fetchSubCategories().then((value) {
        subCategoryData = value;
        setState(() {});

        tabController =
            TabController(initialIndex: tabIndex, length: subCategoryData?.length ?? 0, vsync: this);
        assignTabIndexFromSubCategory();

        tabController?.addListener(() {
          setState(() {
            assignTabIndexFromSubCategory();

            debugPrint("AddListener TabIndex $tabIndex & Sub Category Id $subCategoryId");
          });
        });

        fetchAllServiceProviders();
      });
    });
  }

  Future onTabChange(int index) async {
    setState(() {
      if (!context.read<ServicesController>().loadingAllServiceProviders) {
        tabIndex = index;
        if (subCategoryData.haveData) {
          subCategoryId = subCategoryData?[tabIndex].id;
        }
        fetchAllServiceProviders();
        debugPrint("onTabChange tabIndex $tabIndex & Sub Category Id $subCategoryId");
      }
    });
  }

  Timer? _debounce;

  void onSearchFieldChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchAllServiceProviders();
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController?.dispose();
    searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DashboardController controller = Provider.of<DashboardController>(context);
    ServicesController servicesController = Provider.of<ServicesController>(context);
    LocationController location = Provider.of<LocationController>(context);
    subCategoryData = controller.subCategoryData;
    allServiceProviders = servicesController.allServiceProvidersData;

    filtersData = controller.filtersData;

    debugPrint("selectedIndex $categoryId");
    return Scaffold(
      appBar: AppBar(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            backButton(context: context),
          ],
        ),
        leadingWidth: 50,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () async {
                  context.read<LocationController>().showLocationPopup(context: context).then((value) {
                    context.read<LocationController>().closeLocationPopupStatus();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_sharp,
                            color: Colors.black,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            width: size.width * 0.50,
                            child: Text(
                              location.address?.addressLine ?? "Select Location",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
      body: DefaultTabController(
        initialIndex: tabIndex,
        length: subCategoryData?.length ?? 0,
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: CustomTextField(
                    controller: searchCtrl,
                    height: 50,
                    prefixIcon: ImageView(
                      height: 24,
                      width: 24,
                      assetImage: AppImages.search,
                      onTap: () async {
                        await fetchAllServiceProviders();
                      },
                    ),
                    fillColor: primaryGrey,
                    hintText: "Search",
                    onChanged: (val) async {
                      onSearchFieldChanged(val);
                    },
                    borderColor: primaryGrey,
                    margin: const EdgeInsets.only(left: 16, right: 16),
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
                    onTap: () async {
                      context.push(Routs.serviceMapViewHome,
                          extra: ServiceMapViewHome(
                            type: type,
                            categoryId: categoryId,
                            subcategoryId: subCategoryId,
                            bannerId: widget.bannerId,
                            partnerIds: widget.partnerIds,
                            sortBy: selectedSorting,
                            selectedFilterIds: selectedFilterIds?.toList(),
                            filterOptions: selectedFilterOptions,
                            otherFilterBy: selectedOtherFilters,
                          ));
                    },
                    margin: EdgeInsets.zero,
                  ),
                )
              ],
            ),

            // Padding(
            //   padding: const EdgeInsets.only(left: 18, right: 18, top: 6),
            //   child: OrderTypeCard(
            //     selected: selectedOrderTypes,
            //     list: orderTypes,
            //     onChanged: (val) {
            //       setState(() {
            //         selectedOrderTypes = val;
            //       });
            //       if (!context.read<DashboardController>().loadingAllProducers) {
            //         fetchAllProducers();
            //       }
            //     },
            //   ),
            // ),

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
                                      fetchAllServiceProviders();
                                    },
                                    margin: const EdgeInsets.all(16),
                                  ));
                            },
                          );
                        },
                      ),
                    ),
                  // MultiFilterButton(
                  //   selectedList: selectedOtherFilters,
                  //   list: otherFilters,
                  //   onChange: (val) {
                  //     if (servicesController.loadingAllServiceProviders == false) {
                  //       selectedOtherFilters = val;
                  //       fetchAllServiceProviders();
                  //     }
                  //     setState(() {});
                  //   },
                  // )
                ],
              ),
            ),

            Expanded(
              child: SmartRefresher(
                controller: servicesController.allServiceProvidersController,
                enablePullUp: true,
                enablePullDown: true,
                onRefresh: () async {
                  if (mounted) {
                    await fetchAllServiceProviders();
                  }
                },
                onLoading: () async {
                  if (mounted) {
                    await fetchAllServiceProviders(loadingNext: true);
                  }
                },
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    if (subCategoryData?.haveData == true)
                      Container(
                        color: Colors.white.withOpacity(0.95),
                        width: size.width,
                        height: 120,
                        child: TabBar(
                          controller: tabController,
                          onTap: (val) {
                            onTabChange(val);
                          },
                          isScrollable: true,
                          labelColor: primaryColor,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: primaryColor,
                          automaticIndicatorColorAdjustment: true,
                          indicatorSize: TabBarIndicatorSize.tab,
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                          tabs: List.generate(
                            subCategoryData?.length ?? 0,
                            (index) {
                              var data = subCategoryData?.elementAt(index);
                              return FreshProduceCard(
                                name: data?.name,
                                image: data?.icon,
                                radius: 60,
                                textSize: 13,
                                selected: index == tabIndex,
                                padding: const EdgeInsets.only(bottom: 10),
                              );
                            },
                          ),
                        ),
                      ),
                    DataWidgetBuilder(
                      isLoading: servicesController.loadingAllServiceProviders,
                      haveData: allServiceProviders?.haveData == true,
                      heightFactor: 0.5,
                      loadingWidget: Skeletons().skeletonCategoriesCard(context: context, itemCount: 8),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: allServiceProviders?.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          var data = allServiceProviders?.elementAt(index);
                          return ServiceProviderCard(
                            serviceProvider: data,
                            onTap: () {
                              context.push(Routs.serviceProviderDetail,
                                  extra: ServiceProviderDetailScreen(id: data?.id));
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
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
            itemCount: serviceShortingFilter.length,
            itemBuilder: (context, index) {
              String id = serviceShortingFilter.elementAt(index)["id"];
              String title = serviceShortingFilter.elementAt(index)["title"];
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
    return await fetchAllServiceProviders();
  }

  Future onApply() async {
    Navigator.pop(context);
    return await fetchAllServiceProviders();
  }

  void assignTabIndexFromSubCategory() {
    if (widget.subCategoryId != null) {
      subCategoryId = widget.subCategoryId;
      if (subCategoryData.haveData) {
        tabIndex = subCategoryData?.indexWhere((element) => element.id == subCategoryId) ?? 0;
        debugPrint("TabIndex $tabIndex & Sub Category Id $subCategoryId");
      }
    } else if (subCategoryData.haveData) {
      subCategoryId = subCategoryData?[tabIndex].id;
    } else {
      tabIndex = tabController?.index ?? 0;
    }
    tabController?.animateTo(tabIndex);
    setState(() {});
  }
}
