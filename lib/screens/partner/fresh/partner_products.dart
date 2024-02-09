import 'package:flutter/material.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/screens/partner/fresh/products_list.dart';
import 'package:gaas/screens/partner/utils/product_schems_card.dart';
import 'package:gaas/utils/widgets/custom_bottom_sheet.dart';
import 'package:gaas/utils/widgets/custom_button.dart';
import 'package:gaas/utils/widgets/data_widget_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../controllers/partner/partner_controller.dart';
import '../../../controllers/partner/product_controller.dart';
import '../../../core/config/app_images.dart';
import '../../../core/constant/colors.dart';
import '../../../core/enums/enums.dart';
import '../../../models/partner/product/my_products_model.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';
import '../utils/partner_app_bar.dart';
import '../utils/product_inventory_card.dart';
import 'add_product.dart';

class PartnerProducts extends StatefulWidget {
  const PartnerProducts({Key? key, this.bannerId}) : super(key: key);
  final num? bannerId;

  @override
  State<PartnerProducts> createState() => _PartnerProductsState();
}

class _PartnerProductsState extends State<PartnerProducts> with TickerProviderStateMixin {
  ServiceType? type;
  late num? bannerId = widget.bannerId;
  late bool addSchemeMode = bannerId != null;

  late List<String>? tabCategories = ["All", "Requested"];

  late int tabIndex = 0;
  TabController? tabController;
  TextEditingController searchCtrl = TextEditingController();

  fetchCategories() {
    DashboardController dashboardController = Provider.of<DashboardController>(context, listen: false);
    dashboardController.fetchCategories(context: context, searchKey: searchCtrl.text, type: type);
  }

  Future fetchMyProducts({bool? loadingNext}) async {
    ProductController productController = Provider.of<ProductController>(context, listen: false);
    return productController.fetchMyProducts(
      context: context,
      searchKey: searchCtrl.text,
      bannerId: bannerId,
      showType: tabIndex == 0 ? "All" : tabCategories?[tabIndex],
      isRefresh: loadingNext == true ? null : true,
      loadingNext: loadingNext,
    );
  }

  List<MyProductsData>? myProductsData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      PartnerController partnerController = Provider.of<PartnerController>(context, listen: false);
      type = partnerController.serviceType;
      tabCategories?.insert(1, "${type?.value}");
      setState(() {});
      fetchCategories();
      fetchMyProducts();
      tabController = TabController(initialIndex: tabIndex, length: tabCategories?.length ?? 0, vsync: this);
      tabController?.animateTo(tabIndex);
      tabController?.addListener(() {
        tabIndex = tabController?.index ?? 0;
        debugPrint("addListener TabIndex $tabIndex");
        setState(() {});
      });
    });
  }

  Future onTabChange(int index) async {
    if (!context.read<ProductController>().loadingMyProducts) {
      tabIndex = index;
      setState(() {});
      fetchMyProducts();
      debugPrint("onTabChange tabIndex $tabIndex  ");
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
    Size size = MediaQuery.of(context).size;
    ProductController controller = Provider.of<ProductController>(context);
    myProductsData = controller.myProductsData;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: partnerAppBar(
            context: context, title: addSchemeMode ? "Manage Scheme" : "${type?.value} Products"),
        body: DefaultTabController(
          initialIndex: tabIndex,
          length: tabCategories?.length ?? 0,
          child: Column(
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
                  indicatorWeight: 1.5,
                  automaticIndicatorColorAdjustment: true,
                  indicatorSize: TabBarIndicatorSize.tab,
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  unselectedLabelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  tabs: List.generate(
                    tabCategories?.length ?? 0,
                    (index) {
                      var data = tabCategories?.elementAt(index);
                      return FittedBox(child: Text("$data"));
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: CustomTextField(
                      controller: searchCtrl,
                      height: 50,
                      prefixIcon: const ImageView(
                        height: 24,
                        width: 24,
                        assetImage: AppImages.search,
                      ),
                      fillColor: primaryGrey,
                      hintText: "Search ${tabCategories?[tabIndex]} Products",
                      onChanged: (val) async {
                        if (controller.loadingMyProducts == false) {
                          await fetchMyProducts();
                        }
                      },
                      onEditingComplete: () async {
                        // await fetchMyProducts();
                      },
                      borderColor: primaryGrey,
                      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 8),
                    ),
                  ),
                  // Container(
                  //   height: 50,
                  //   width: 58,
                  //   margin: const EdgeInsets.only(right: 24, bottom: 16, top: 8),
                  //   decoration: BoxDecoration(
                  //     color: primaryGrey,
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: ImageView(
                  //     height: 24,
                  //     width: 24,
                  //     fit: BoxFit.contain,
                  //     assetImage: AppImages.funnel,
                  //     color: primaryColor,
                  //     onTap: () async {
                  //       await fetchMyProducts();
                  //     },
                  //     margin: EdgeInsets.zero,
                  //   ),
                  // )
                ],
              ),
              Expanded(
                child: DataWidgetBuilder(
                  isLoading: controller.loadingMyProducts,
                  haveData: myProductsData.haveData,
                  child: SmartRefresher(
                    key: widget.key,
                    controller: controller.myProductsController,
                    enablePullUp: true,
                    enablePullDown: true,
                    onRefresh: () async {
                      if (mounted) {
                        await fetchMyProducts();
                      }
                    },
                    onLoading: () async {
                      if (mounted) {
                        await fetchMyProducts(loadingNext: true);
                      }
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: myProductsData?.length,
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      itemBuilder: (context, index) {
                        var data = myProductsData?.elementAt(index);

                        return addSchemeMode == true
                            ? ProductSchemesCard(product: data)
                            : ProductInventoryCard(
                                id: data?.id,
                                title: data?.name,
                                status: data?.status,
                                image: data?.image,
                                price: data?.price,
                                mrpPrice: data?.mrpPrice,
                                weight: "${data?.initialInventory} ${data?.unitName}",
                                onTap: () {
                                  context.pushNamed(Routs.addProduct, extra: AddProduct(productsData: data));
                                },
                              );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: addSchemeMode
            ? CustomButton(
                text: "Update",
                height: 45,
                width: size.width * 0.9,
                mainAxisAlignment: MainAxisAlignment.center,
                onPressed: () {
                  context
                      .read<ProductController>()
                      .manageSchemeProducts(context: context, banner_id: bannerId);
                },
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              )
            : null,
        floatingActionButton: addSchemeMode
            ? null
            : FloatingActionButton(
                onPressed: () {
                  CustomBottomSheet.show(
                    context: context,
                    enableDrag: true,
                    showBackButton: true,
                    isDismissible: true,
                    physics: const ScrollPhysics(),
                    margin: EdgeInsets.only(top: size.height * 0.2),
                    body: const ProductsList(),
                    bottomNavBarHeight: 50,
                    title: "Add Product",
                    centerTitle: true,
                    bottomNavBar: InkWell(
                      onTap: () {
                        context.pop();
                        context.pushNamed(Routs.addProduct, extra: const AddProduct());
                      },
                      child: const ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: primaryColor,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          "Add your own product",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
                      ),
                    ),
                  );
                },
                backgroundColor: primaryColor,
                child: const Icon(Icons.add, size: 32, color: Colors.white),
              ),
      ),
    );
  }
}
