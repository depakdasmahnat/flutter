import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/utils/widgets/data_widget_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/constant/colors.dart';
import '../../../models/partner/product/my_products_model.dart';
import '../../controllers/dashboard_controller.dart';
import '../../core/config/app_images.dart';
import '../../core/enums/enums.dart';
import '../../models/dashboard/global_search_model.dart';
import '../../route/route_paths.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../utils/widgets/image_view.dart';
import '../home/all_producers.dart';
import '../home/utils/fresh_produce_card.dart';
import '../home/utils/nearby_product.dart';
import '../home/view_producer.dart';
import '../services/all_services.dart';

class GlobalSearch extends StatefulWidget {
  const GlobalSearch({Key? key}) : super(key: key);

  @override
  State<GlobalSearch> createState() => _GlobalSearchState();
}

class _GlobalSearchState extends State<GlobalSearch> {
  TextEditingController searchCtrl = TextEditingController();
  List<GlobalSearchData>? globalSearchData;

  Future fetchGlobalSearch({bool? loadingNext}) async {
    DashboardController dashboardController = Provider.of<DashboardController>(context, listen: false);

    return dashboardController.fetchGlobalSearch(
      context: context,
      searchKey: searchCtrl.text,
      isRefresh: loadingNext == true ? null : true,
      loadingNext: loadingNext,
    );
  }

  List<MyProductsData>? myProductsData;

  Timer? _debounce;

  void onSearchFieldChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchGlobalSearch();
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchGlobalSearch();
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DashboardController controller = Provider.of<DashboardController>(context);
    globalSearchData = controller.globalSearchData;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 30,
          title: CustomTextField(
            height: 50,
            controller: searchCtrl,
            autofocus: true,
            prefixIcon: ImageView(
              height: 24,
              width: 24,
              onTap: () {
                FocusScope.of(context).unfocus();
                fetchGlobalSearch();
              },
              assetImage: AppImages.search,
            ),
            fillColor: primaryGrey,
            hintText: "Search",
            onChanged: (val) {
              onSearchFieldChanged(val);
            },
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (val) {
              FocusScope.of(context).unfocus();
              fetchGlobalSearch();
            },
            borderColor: primaryGrey,
            margin: const EdgeInsets.only(right: 8),
          ),
        ),
        body: SmartRefresher(
          key: widget.key,
          controller: controller.globalSearchController,
          enablePullUp: true,
          enablePullDown: true,
          onRefresh: () async {
            if (mounted) {
              await fetchGlobalSearch();
            }
          },
          onLoading: () async {
            if (mounted) {
              await fetchGlobalSearch(loadingNext: true);
            }
          },
          child: DataWidgetBuilder(
            isLoading: controller.loadingGlobalSearch,
            haveData: globalSearchData.haveData,
            heightFactor: 0.8,
            child: ListView.builder(
              itemCount: globalSearchData?.length,
              shrinkWrap: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const ScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                var data = globalSearchData?.elementAt(index);
                return data?.groupType == "Partner"
                    ? partnerCard(index, data, controller)
                    : globalSearchWidgets(data: data);
              },
            ),
          ),
        ),
      ),
    );
  }

  Column partnerCard(
    int index,
    GlobalSearchData? data,
    DashboardController? controller,
  ) {
    return Column(
      children: [
        NearbyProductCard(
          id: data?.id,
          title: data?.name,
          image: "${data?.profilePhoto}",
          address: data?.address,
          rating: data?.rating,
          reviews: data?.reviews,
          distance: data?.distanceLabel,
          totalProducts: data?.productCounts,
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
        ),
        if (data?.products.haveData == true)
          Container(
            height: 85,
            margin: const EdgeInsets.only(bottom: 14),
            child: ListView.builder(
              itemCount: data?.products?.length ?? 0,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 24),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var product = data?.products?.elementAt(index);
                return FreshProduceCard(
                  name: product?.name,
                  image: "${product?.image}",
                  radius: 60,
                  selected: false,
                  onTap: () {
                    context.pushNamed(Routs.viewProducer,
                        extra: ViewProducer(
                          partnerId: "${data?.id ?? ""}",
                          orderType: data?.orderTypes,
                        ));
                  },
                );
              },
            ),
          ),
        const Divider(color: primaryGrey, thickness: 2, height: 1),
      ],
    );
  }

  Widget globalSearchWidgets({
    required GlobalSearchData? data,
  }) {
    Widget? widget;

    List<ServiceType?>? types = ServiceType.values.where((element) => element.value == data?.type).toList();

    ServiceType? type;
    if (types.haveData) {
      type = types.first;
    }
    String? groupType = data?.groupType;

    if (groupType == "Product") {
      onTap() {
        context.pushNamed(Routs.viewProducer,
            extra: ViewProducer(
              partnerId: "${data?.userId}",
              orderType: data?.orderTypes,
            ));
      }

      widget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        child: GestureDetector(
          onTap: () {
            onTap();
          },
          child: Row(
            children: [
              FreshProduceCard(
                name: data?.groupType,
                image: data?.profilePhoto,
                selected: false,
                radius: 50,
                onTap: () {
                  onTap();
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${data?.name}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  if (data?.address != null)
                    Text(
                      "${data?.address}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  // const SizedBox(height: 4),
                  // if (data?.price != null)
                  //   Text(
                  //     "\$${data?.price}",
                  //     style: const TextStyle(color: Colors.grey),
                  //   ),
                ],
              )
            ],
          ),
        ),
      );
    } else if (groupType == "Category" || groupType == "Subcategory") {
      onTap() {
        if (groupType == "Category") {
          if (type == ServiceType.serviceProvider) {
            context.pushNamed(Routs.allServices, extra: AllServices(categoryId: data?.id));
          } else {
            debugPrint("Going to AllProducersScreen");

            context.pushNamed(Routs.allProducers,
                extra: AllProducersScreen(
                    categoryId: data?.categoryId, subCategoryId: data?.id, orderType: null, type: type));
          }
        } else {
          if (type == ServiceType.serviceProvider) {
            context.pushNamed(Routs.allServices,
                extra: AllServices(categoryId: data?.categoryId, subCategoryId: data?.id));
          } else {
            debugPrint("Going to AllProducersScreen Subcategory ${data?.id}");
            context.pushNamed(Routs.allProducers,
                extra: AllProducersScreen(
                    categoryId: data?.categoryId, subCategoryId: data?.id, orderType: null, type: type));
          }
        }
      }

      widget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        child: GestureDetector(
          onTap: () {
            onTap();
          },
          child: Row(
            children: [
              FreshProduceCard(
                name: data?.groupType,
                image: data?.icon,
                selected: false,
                radius: 50,
                onTap: () {
                  onTap();
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${data?.name}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${data?.type}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        if (widget != null) widget,
        if (widget != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Divider(color: Colors.grey.shade300, height: 1),
          ),
      ],
    );
  }
}
